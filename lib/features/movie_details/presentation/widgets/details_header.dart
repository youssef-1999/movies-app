import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/features/movie_details/domain/entities/movie_details.dart';
import 'package:movies/features/movie_details/presentation/widgets/network_poster.dart';

/// Full-width poster that fades into the background, with back / bookmark
/// buttons, a play button, and the title + year at the bottom.
class DetailsHeader extends StatelessWidget {
  final MovieDetails movie;
  final VoidCallback? onPlay;
  final VoidCallback? onBookmark;

  final bool isBookmarked;

  const DetailsHeader({
    super.key,
    required this.movie,
    this.onPlay,
    this.onBookmark,
    this.isBookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.72;

    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          NetworkPoster(movie.posterUrl),
          // Fade to the screen background so the title stays readable.
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0, 0.45, 1],
                colors: [
                  AppColors.black.withValues(alpha: 0.2),
                  AppColors.black.withValues(alpha: 0.35),
                  AppColors.black,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.white,
                      size: 28,
                    ),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                                    IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookmarked ? AppColors.yellow : AppColors.white,
                      size: 32,
                    ),
                    onPressed: onBookmark,
                  ),
                ],
              ),
            ),
          ),
          Center(child: _PlayButton(onTap: onPlay)),
          Positioned(
            left: 16,
            right: 16,
            bottom: 8,
            child: Column(
              children: [
                Text(
                  movie.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${movie.year}',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _PlayButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white.withValues(alpha: 0.9),
        ),
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.yellow,
          ),
          child: const Icon(
            Icons.play_arrow_rounded,
            color: AppColors.white,
            size: 56,
          ),
        ),
      ),
    );
  }
}
