import 'package:movies/features/movie_details/domain/entities/movie_details.dart';

class CastMemberModel extends CastMember {
  const CastMemberModel({
    required super.name,
    required super.character,
    required super.imageUrl,
  });

  factory CastMemberModel.fromJson(Map<String, dynamic> json) {
    return CastMemberModel(
      name: (json['name'] as String?) ?? '',
      character: (json['character_name'] as String?) ?? '',
      imageUrl: (json['url_small_image'] as String?) ?? '',
    );
  }
}

class MovieDetailsModel extends MovieDetails {
  const MovieDetailsModel({
    required super.id,
    required super.title,
    required super.year,
    required super.rating,
    required super.runtime,
    required super.likeCount,
    required super.description,
    required super.posterUrl,
    required super.trailerCode,
    required super.genres,
    required super.screenshots,
    required super.cast,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    final screenshots = [
      json['large_screenshot_image1'],
      json['large_screenshot_image2'],
      json['large_screenshot_image3'],
    ].whereType<String>().where((url) => url.isNotEmpty).toList();

    final description = (json['description_full'] as String?) ??
        (json['description_intro'] as String?) ??
        '';

    return MovieDetailsModel(
      id: json['id'] as int,
      title: (json['title'] as String?) ?? '',
      year: (json['year'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      runtime: (json['runtime'] as num?)?.toInt() ?? 0,
      likeCount: (json['like_count'] as num?)?.toInt() ?? 0,
      description: description,
      posterUrl: (json['large_cover_image'] as String?) ??
          (json['medium_cover_image'] as String?) ??
          '',
      trailerCode: (json['yt_trailer_code'] as String?) ?? '',
      genres: (json['genres'] as List?)?.whereType<String>().toList() ?? [],
      screenshots: screenshots,
      cast: (json['cast'] as List?)
              ?.map((c) => CastMemberModel.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
