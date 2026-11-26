import 'package:injectable/injectable.dart';
import 'package:movies/features/movie_details/domain/entities/movie_details.dart';
import 'package:movies/features/movie_details/domain/repositories/movie_details_repository.dart';
import 'package:movies/features/search_feature/features/search/domain/entities/movie.dart';

@lazySingleton
class GetMovieDetailsUseCase {
  final MovieDetailsRepository _repository;

  GetMovieDetailsUseCase(this._repository);

  Future<MovieDetails> call(int movieId) => _repository.getMovieDetails(movieId);
}

@lazySingleton
class GetMovieSuggestionsUseCase {
  final MovieDetailsRepository _repository;

  GetMovieSuggestionsUseCase(this._repository);

  Future<List<Movie>> call(int movieId) => _repository.getSuggestions(movieId);
}
