
import 'package:injectable/injectable.dart';

import 'package:movies/features/search_feature/features/search/domain/entities/movie.dart';
import 'package:movies/features/search_feature/features/search/domain/repositories/search_repository.dart';

@lazySingleton
class SearchMoviesUseCase {
  final SearchRepository _repository;

  SearchMoviesUseCase(this._repository);

  Future<List<Movie>> call(String query) {
    return _repository.searchMovies(query);
  }
}