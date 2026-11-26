import 'package:equatable/equatable.dart';

class CastMember extends Equatable {
  final String name;
  final String character;
  final String imageUrl;

  const CastMember({
    required this.name,
    required this.character,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [name, character, imageUrl];
}

class MovieDetails extends Equatable {
  final int id;
  final String title;
  final int year;
  final double rating;

  /// Minutes.
  final int runtime;
  final int likeCount;
  final String description;
  final String posterUrl;
  final String trailerCode;
  final List<String> genres;
  final List<String> screenshots;
  final List<CastMember> cast;

  const MovieDetails({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.runtime,
    required this.likeCount,
    required this.description,
    required this.posterUrl,
    required this.trailerCode,
    required this.genres,
    required this.screenshots,
    required this.cast,
  });

  @override
  List<Object?> get props => [id];
}
