import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movies/features/home/domain/entities/movie_entity.dart';
import 'package:movies/features/home/presentation/widgets/movie_card.dart';

class MoviesCarousel extends StatelessWidget {
  final List<MovieEntity> movies;
  final ValueChanged<int> onPageChanged;

  const MoviesCarousel({
    super.key,
    required this.movies,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Center(
      child: CarouselSlider.builder(
        itemCount: movies.length,
        itemBuilder: (context, itemIndex, realIndex) =>
            MovieCard(movie: movies[itemIndex]),
        options: CarouselOptions(
          height: size.height * 0.45,
          viewportFraction: 0.6,
          enlargeCenterPage: true,
          onPageChanged: (newIndex, reason) => onPageChanged(newIndex),
        ),
      ),
    );
  }
}
