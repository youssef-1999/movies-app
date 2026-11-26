import '../../domain/entities/profile_entity.dart';
import 'package:movies/features/search_feature/features/search/domain/entities/movie.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;
  final List<Movie> watchlist;
  final List<Movie> history;
  ProfileLoaded(this.profile,
      [this.watchlist = const [], this.history = const []]);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
