import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:movies/features/history/data/datasources/history_local_data_source.dart';
import 'package:movies/features/history/domain/repositories/history_repository.dart';
import 'package:movies/features/search_feature/features/search/domain/entities/movie.dart';

@LazySingleton(as: HistoryRepository)
class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryLocalDataSource _local;
  final _controller = StreamController<List<Movie>>.broadcast();

  HistoryRepositoryImpl(this._local);

  @override
  List<Movie> getAll() => _local.getAll();

  @override
  Future<void> add(Movie movie) async {
    final list = getAll();
    list.removeWhere((m) => m.id == movie.id); // re-opening moves it to the top
    list.insert(0, movie);
    await _local.saveAll(list);
    _controller.add(list);
  }

  @override
  Stream<List<Movie>> watch() => _controller.stream;
}
