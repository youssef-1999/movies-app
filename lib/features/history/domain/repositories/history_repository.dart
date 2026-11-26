import 'package:movies/features/search_feature/features/search/domain/entities/movie.dart';

abstract class HistoryRepository {
  List<Movie> getAll();

  /// Saves the movie at the top of the history (no duplicates).
  Future<void> add(Movie movie);

  /// Emits the new list every time it changes.
  Stream<List<Movie>> watch();
}
