import 'package:movies/features/search_feature/features/search/domain/entities/movie.dart';

abstract class WatchlistRepository {
  List<Movie> getAll();
  bool isBookmarked(int movieId);

  /// Adds or removes the movie. Returns true if it is now saved.
  Future<bool> toggle(Movie movie);

  /// Emits the new list every time it changes.
  Stream<List<Movie>> watch();
}
