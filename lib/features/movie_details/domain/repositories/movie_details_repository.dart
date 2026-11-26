import 'package:movies/features/movie_details/domain/entities/movie_details.dart';
import 'package:movies/features/search_feature/features/search/domain/entities/movie.dart';

abstract class MovieDetailsRepository {
  Future<MovieDetails> getMovieDetails(int movieId);
  Future<List<Movie>> getSuggestions(int movieId);
}
