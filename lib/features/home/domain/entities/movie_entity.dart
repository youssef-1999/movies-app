class MovieEntity {
  /// The movie's id in the API, used to open the details screen.
  final int id;
  final String name;

  /// Asset path of the poster image.
  final String image;
  final double rating;

  const MovieEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
  });
}
