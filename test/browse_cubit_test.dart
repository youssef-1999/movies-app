import 'package:flutter_test/flutter_test.dart';
import 'package:movies/app_exception.dart';
import 'package:movies/features/browse/domain/entities/browse_sort.dart';
import 'package:movies/features/browse/domain/entities/movies_page.dart';
import 'package:movies/features/browse/domain/repositories/browse_repository.dart';
import 'package:movies/features/browse/domain/usecases/browse_movies_usecase.dart';
import 'package:movies/features/browse/presentation/cubit/browse_cubit.dart';
import 'package:movies/features/browse/presentation/cubit/browse_state.dart';
import 'package:movies/features/search_feature/features/search/domain/entities/movie.dart';

Movie _movie(int id) =>
    Movie(id: id, title: 'Movie $id', rating: 7, posterUrl: '');

/// Serves [total] movies in pages of [limit], and records every call.
class _FakeRepo implements BrowseRepository {
  final int total;
  final int limit;
  final calls = <String>[];
  bool fail = false;

  _FakeRepo({this.total = 45, this.limit = 20});

  @override
  Future<MoviesPage> browseMovies({
    required String? genre,
    required BrowseSort sort,
    required int page,
  }) async {
    calls.add('${genre ?? 'all'}|${sort.name}|$page');
    if (fail) throw const AppException('No internet connection.');
    final start = (page - 1) * limit;
    final end = (start + limit).clamp(0, total);
    return MoviesPage(
      movies: [for (var i = start; i < end; i++) _movie(i)],
      page: page,
      totalCount: total,
      limit: limit,
    );
  }
}

void main() {
  late _FakeRepo repo;
  late BrowseCubit cubit;

  setUp(() {
    repo = _FakeRepo();
    cubit = BrowseCubit(BrowseMoviesUseCase(repo));
  });

  tearDown(() => cubit.close());

  test('loads the first page', () async {
    await cubit.init();
    expect(cubit.state.status, BrowseStatus.success);
    expect(cubit.state.movies.length, 20);
    expect(cubit.state.hasMore, isTrue);
  });

  test('loads more pages until the end', () async {
    await cubit.init();
    await cubit.loadMore();
    await cubit.loadMore();
    expect(cubit.state.movies.length, 45);
    expect(cubit.state.hasMore, isFalse);

    await cubit.loadMore(); // nothing left: no request
    expect(repo.calls.length, 3);
  });

  test('switching back to a genre uses the cache', () async {
    await cubit.init();
    await cubit.selectGenre('action');
    await cubit.selectGenre(null);
    expect(cubit.state.genre, isNull);
    expect(repo.calls, ['all|latest|1', 'action|latest|1']);
  });

  test('changing sort reloads from page 1', () async {
    await cubit.init();
    await cubit.changeSort(BrowseSort.topRated);
    expect(cubit.state.sort, BrowseSort.topRated);
    expect(repo.calls.last, 'all|topRated|1');
  });

  test('first page error, then retry succeeds', () async {
    repo.fail = true;
    await cubit.init();
    expect(cubit.state.status, BrowseStatus.failure);
    expect(cubit.state.errorMessage, 'No internet connection.');

    repo.fail = false;
    await cubit.retry();
    expect(cubit.state.status, BrowseStatus.success);
  });

  test('load more error keeps the grid and can be retried', () async {
    await cubit.init();
    repo.fail = true;
    await cubit.loadMore();
    expect(cubit.state.movies.length, 20);
    expect(cubit.state.loadMoreError, isNotNull);

    repo.fail = false;
    await cubit.loadMore();
    expect(cubit.state.movies.length, 40);
    expect(cubit.state.loadMoreError, isNull);
  });

  test('failed refresh keeps the grid and returns the error', () async {
    await cubit.init();
    repo.fail = true;
    final error = await cubit.refresh();
    expect(error, 'No internet connection.');
    expect(cubit.state.status, BrowseStatus.success);
    expect(cubit.state.movies.length, 20);
  });

  test('a late answer for an old genre is ignored', () async {
    final first = cubit.init();
    final second = cubit.selectGenre('comedy');
    await Future.wait([first, second]);
    expect(cubit.state.genre, 'comedy');
  });
}
