import 'package:injectable/injectable.dart';
import 'package:movies/features/search_feature/features/search/domain/entities/movie.dart';
import 'package:movies/features/watchlist/domain/repositories/watchlist_repository.dart';

@lazySingleton
class GetWatchlistUseCase {
  final WatchlistRepository _repo;
  GetWatchlistUseCase(this._repo);
  List<Movie> call() => _repo.getAll();
}

@lazySingleton
class IsBookmarkedUseCase {
  final WatchlistRepository _repo;
  IsBookmarkedUseCase(this._repo);
  bool call(int movieId) => _repo.isBookmarked(movieId);
}

@lazySingleton
class ToggleWatchlistUseCase {
  final WatchlistRepository _repo;
  ToggleWatchlistUseCase(this._repo);
  Future<bool> call(Movie movie) => _repo.toggle(movie);
}

@lazySingleton
class WatchWatchlistUseCase {
  final WatchlistRepository _repo;
  WatchWatchlistUseCase(this._repo);
  Stream<List<Movie>> call() => _repo.watch();
}
