import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final double rating;
  final String posterUrl;

  const Movie({
    required this.id,
    required this.title,
    required this.rating,
    required this.posterUrl,
  });

  @override
  List<Object?> get props => [id, title, rating, posterUrl];
}
