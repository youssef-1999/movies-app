import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:movies/features/search_feature/features/search/domain/entities/movie.dart';
import 'package:movies/features/watchlist/data/datasources/watchlist_local_data_source.dart';
import 'package:movies/features/watchlist/domain/repositories/watchlist_repository.dart';

@LazySingleton(as: WatchlistRepository)
class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistLocalDataSource _local;
  final _controller = StreamController<List<Movie>>.broadcast();

  WatchlistRepositoryImpl(this._local);

  @override
  List<Movie> getAll() => _local.getAll();

  @override
  bool isBookmarked(int movieId) => getAll().any((m) => m.id == movieId);

  @override
  Future<bool> toggle(Movie movie) async {
    final list = getAll();
    final exists = list.any((m) => m.id == movie.id);
    if (exists) {
      list.removeWhere((m) => m.id == movie.id);
    } else {
      list.insert(0, movie);
    }
    await _local.saveAll(list);
    _controller.add(list);
    return !exists;
  }

  @override
  Stream<List<Movie>> watch() => _controller.stream;
}
