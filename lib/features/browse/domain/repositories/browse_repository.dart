import 'package:movies/features/browse/domain/entities/browse_sort.dart';
import 'package:movies/features/browse/domain/entities/movies_page.dart';

abstract class BrowseRepository {
  Future<MoviesPage> browseMovies({
    required String? genre,
    required BrowseSort sort,
    required int page,
  });
}
