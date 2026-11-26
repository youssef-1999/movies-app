import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/features/home/domain/entities/movie_entity.dart';
import 'package:movies/features/home/presentation/widgets/movie_card.dart';

class MoviesSection extends StatelessWidget {
  final String title;
  final List<MovieEntity> movies;

  const MoviesSection({super.key, required this.title, required this.movies});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: AppColors.white, fontSize: 20),
              ),
              const Text(
                'See More >',
                style: TextStyle(color: AppColors.yellow, fontSize: 14),
              ),
            ],
          ),
        ),
        SizedBox(
          height: size.height * 0.28,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movies.length,
            itemBuilder: (context, itemIndex) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: SizedBox(
                width: size.width * 0.38,
                child: MovieCard(movie: movies[itemIndex]),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
