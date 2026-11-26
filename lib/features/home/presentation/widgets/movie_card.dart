import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/features/home/domain/entities/movie_entity.dart';
import 'package:movies/features/movie_details/presentation/screens/movie_details_screen.dart';

class MovieCard extends StatelessWidget {
  final MovieEntity movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        MovieDetailsScreen.routeName,
        arguments: movie.id,
      ),
      child: _buildCard(),
    );
  }

  Widget _buildCard() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // poster
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(movie.image, fit: BoxFit.cover),
        ),
        // rating badge, top left
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.darkGrey.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${movie.rating}',
                  style: const TextStyle(color: AppColors.white, fontSize: 14),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.star, color: AppColors.yellow, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
