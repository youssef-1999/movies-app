
import 'package:movies/features/search_feature/features/search/domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.rating,
    required super.posterUrl,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as int,
      title: (json['title'] as String?) ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      posterUrl: (json['medium_cover_image'] as String?) ?? '',
    );
  }
}
