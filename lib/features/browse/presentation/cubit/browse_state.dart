import 'package:equatable/equatable.dart';
import 'package:movies/features/browse/domain/entities/browse_sort.dart';
import 'package:movies/features/search_feature/features/search/domain/entities/movie.dart';

enum BrowseStatus { loading, success, failure }

class BrowseState extends Equatable {
  /// null means "All".
  final String? genre;
  final BrowseSort sort;
  final BrowseStatus status;
  final List<Movie> movies;

  /// Last page that was loaded successfully.
  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  /// Error of the first page (full-screen error).
  final String? errorMessage;

  /// Error while loading the next page (shown under the grid).
  final String? loadMoreError;

  const BrowseState({
    this.genre,
    this.sort = BrowseSort.latest,
    this.status = BrowseStatus.loading,
    this.movies = const [],
    this.page = 0,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.loadMoreError,
  });

  BrowseState copyWith({
    String? Function()? genre,
    BrowseSort? sort,
    BrowseStatus? status,
    List<Movie>? movies,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    String? Function()? errorMessage,
    String? Function()? loadMoreError,
  }) {
    return BrowseState(
      genre: genre != null ? genre() : this.genre,
      sort: sort ?? this.sort,
      status: status ?? this.status,
      movies: movies ?? this.movies,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      loadMoreError:
          loadMoreError != null ? loadMoreError() : this.loadMoreError,
    );
  }

  @override
  List<Object?> get props => [
        genre,
        sort,
        status,
        movies,
        page,
        hasMore,
        isLoadingMore,
        errorMessage,
        loadMoreError,
      ];
}
