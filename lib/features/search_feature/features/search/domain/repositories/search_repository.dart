import 'package:movies/features/search_feature/features/search/domain/entities/movie.dart';

abstract class SearchRepository {
  Future<List<Movie>> searchMovies(String query);
}