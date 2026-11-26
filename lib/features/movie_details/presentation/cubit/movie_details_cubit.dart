import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/app_exception.dart';
import 'package:movies/features/movie_details/domain/usecases/movie_details_usecases.dart';
import 'package:movies/features/movie_details/presentation/cubit/movie_details_state.dart';
import 'package:movies/features/search_feature/features/search/domain/entities/movie.dart';
import 'package:movies/features/watchlist/domain/usecases/watchlist_usecases.dart';
import 'package:movies/features/history/domain/usecases/history_usecases.dart';

@injectable
class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  final GetMovieDetailsUseCase _getDetails;
  final GetMovieSuggestionsUseCase _getSuggestions;
  final ToggleWatchlistUseCase _toggleWatchlist;
  final IsBookmarkedUseCase _isBookmarked;
  final AddToHistoryUseCase _addToHistory;

  MovieDetailsCubit(
    this._getDetails,
    this._getSuggestions,
    this._toggleWatchlist,
    this._isBookmarked,
    this._addToHistory,
  ) : super(const MovieDetailsLoading());
  Future<void> load(int movieId) async {
    emit(const MovieDetailsLoading());
    try {
      final suggestions = _getSuggestions(movieId).catchError((_) => <Movie>[]);
      final details = await _getDetails(movieId);
      final similar = await suggestions;
      if (isClosed) return;

      try {
        await _addToHistory(
          Movie(
            id: details.id,
            title: details.title,
            rating: details.rating,
            posterUrl: details.posterUrl,
          ),
        );
      } catch (_) {}

      emit(
        MovieDetailsSuccess(
          details,
          similar,
          isBookmarked: _isBookmarked(details.id),
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(
        MovieDetailsError(
          e is AppException
              ? e.message
              : 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  Future<void> toggleBookmark() async {
    final s = state;
    if (s is! MovieDetailsSuccess) return;
    final m = s.movie;
    final saved = await _toggleWatchlist(
      Movie(id: m.id, title: m.title, rating: m.rating, posterUrl: m.posterUrl),
    );
    if (isClosed) return;
    emit(MovieDetailsSuccess(m, s.similar, isBookmarked: saved));
  }
}
