import 'package:injectable/injectable.dart';
import 'package:movies/features/history/domain/repositories/history_repository.dart';
import 'package:movies/features/search_feature/features/search/domain/entities/movie.dart';

@lazySingleton
class GetHistoryUseCase {
  final HistoryRepository _repo;
  GetHistoryUseCase(this._repo);
  List<Movie> call() => _repo.getAll();
}

@lazySingleton
class AddToHistoryUseCase {
  final HistoryRepository _repo;
  AddToHistoryUseCase(this._repo);
  Future<void> call(Movie movie) => _repo.add(movie);
}

@lazySingleton
class WatchHistoryUseCase {
  final HistoryRepository _repo;
  WatchHistoryUseCase(this._repo);
  Stream<List<Movie>> call() => _repo.watch();
}
