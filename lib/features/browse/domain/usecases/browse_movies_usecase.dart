import 'package:injectable/injectable.dart';
import 'package:movies/features/browse/domain/entities/browse_sort.dart';
import 'package:movies/features/browse/domain/entities/movies_page.dart';
import 'package:movies/features/browse/domain/repositories/browse_repository.dart';

@lazySingleton
class BrowseMoviesUseCase {
  final BrowseRepository _repository;

  BrowseMoviesUseCase(this._repository);

  /// [genre] null means all genres.
  Future<MoviesPage> call({
    String? genre,
    BrowseSort sort = BrowseSort.latest,
    int page = 1,
  }) {
    return _repository.browseMovies(genre: genre, sort: sort, page: page);
  }
}
