import 'package:equatable/equatable.dart';
import 'package:movies/features/search_feature/features/search/domain/entities/movie.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

/// Nothing typed yet.
class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

/// The list can be empty, which means "no results".
class SearchSuccess extends SearchState {
  final List<Movie> movies;

  const SearchSuccess(this.movies);

  @override
  List<Object?> get props => [movies];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
