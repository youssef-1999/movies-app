import 'package:equatable/equatable.dart';
import 'package:movies/features/search_feature/features/search/domain/entities/movie.dart';

/// One page of results from the movies API.
class MoviesPage extends Equatable {
  final List<Movie> movies;
  final int page;
  final int totalCount;
  final int limit;

  const MoviesPage({
    required this.movies,
    required this.page,
    required this.totalCount,
    required this.limit,
  });

  bool get hasMore => movies.isNotEmpty && page * limit < totalCount;

  @override
  List<Object?> get props => [movies, page, totalCount, limit];
}
