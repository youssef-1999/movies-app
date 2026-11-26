import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/app_exception.dart';
import 'package:movies/features/browse/domain/entities/browse_sort.dart';
import 'package:movies/features/browse/domain/usecases/browse_movies_usecase.dart';
import 'package:movies/features/browse/presentation/cubit/browse_state.dart';
import 'package:movies/features/search_feature/features/search/domain/entities/movie.dart';

@injectable
class BrowseCubit extends Cubit<BrowseState> {
  final BrowseMoviesUseCase _browseMovies;

  /// Loaded results per genre + sort, so switching back is instant.
  final Map<String, BrowseState> _cache = {};

  /// Bumped on every first-page request so late answers from an old
  /// genre/sort are ignored.
  int _requestId = 0;

  BrowseCubit(this._browseMovies) : super(const BrowseState());

  static String _key(String? genre, BrowseSort sort) =>
      '${genre ?? 'all'}|${sort.name}';

  String get _currentKey => _key(state.genre, state.sort);

  /// Loads the first page. [genre] null means all genres.
  Future<void> init({String? genre}) => _loadFirstPage(genre, state.sort);

  Future<void> selectGenre(String? genre) async {
    if (genre == state.genre) return;
    await _switchTo(genre, state.sort);
  }

  Future<void> changeSort(BrowseSort sort) async {
    if (sort == state.sort) return;
    await _switchTo(state.genre, sort);
  }

  Future<void> retry() => _loadFirstPage(state.genre, state.sort);

  /// Pull to refresh: reloads page 1 but keeps the grid visible meanwhile.
  /// Returns an error message if it failed, so the UI can show it.
  Future<String?> refresh() {
    // Drop the cached copy so a fresh load replaces it.
    _cache.remove(_currentKey);
    return _loadFirstPage(state.genre, state.sort, keepMovies: true);
  }

  Future<void> _switchTo(String? genre, BrowseSort sort) async {
    final cached = _cache[_key(genre, sort)];
    if (cached != null) {
      _requestId++; // ignore any in-flight request for the old selection
      emit(cached.copyWith(isLoadingMore: false, loadMoreError: () => null));
      return;
    }
    await _loadFirstPage(genre, sort);
  }

  Future<String?> _loadFirstPage(
    String? genre,
    BrowseSort sort, {
    bool keepMovies = false,
  }) async {
    final requestId = ++_requestId;

    if (!keepMovies || state.movies.isEmpty) {
      emit(BrowseState(genre: genre, sort: sort));
    }

    try {
      final result = await _browseMovies(genre: genre, sort: sort, page: 1);
      if (isClosed || requestId != _requestId) return null;
      _emitAndCache(
        BrowseState(
          genre: genre,
          sort: sort,
          status: BrowseStatus.success,
          movies: result.movies,
          page: 1,
          hasMore: result.hasMore,
        ),
      );
      return null;
    } catch (e) {
      if (isClosed || requestId != _requestId) return null;
      // A failed refresh keeps the old grid; the UI shows the message.
      if (keepMovies && state.movies.isNotEmpty) {
        // A load-more cut short by this refresh must not stay "loading".
        emit(state.copyWith(isLoadingMore: false));
        return _message(e);
      }
      emit(
        BrowseState(
          genre: genre,
          sort: sort,
          status: BrowseStatus.failure,
          errorMessage: _message(e),
        ),
      );
      return null;
    }
  }

  Future<void> loadMore() async {
    final s = state;
    if (s.status != BrowseStatus.success || !s.hasMore || s.isLoadingMore) {
      return;
    }

    final key = _currentKey;
    final requestId = _requestId;
    emit(s.copyWith(isLoadingMore: true, loadMoreError: () => null));

    try {
      final result = await _browseMovies(
        genre: s.genre,
        sort: s.sort,
        page: s.page + 1,
      );
      if (isClosed || requestId != _requestId || key != _currentKey) return;

      // The API can shift items between pages; skip duplicates.
      final seen = state.movies.map((m) => m.id).toSet();
      final fresh = <Movie>[
        for (final m in result.movies)
          if (seen.add(m.id)) m,
      ];

      _emitAndCache(
        state.copyWith(
          movies: [...state.movies, ...fresh],
          page: s.page + 1,
          hasMore: result.hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      if (isClosed || requestId != _requestId || key != _currentKey) return;
      emit(
        state.copyWith(isLoadingMore: false, loadMoreError: () => _message(e)),
      );
    }
  }

  void _emitAndCache(BrowseState newState) {
    _cache[_key(newState.genre, newState.sort)] = newState;
    emit(newState);
  }

  String _message(Object e) => e is AppException
      ? e.message
      : 'Something went wrong. Please try again.';
}
