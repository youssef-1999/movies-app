import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/features/search_feature/features/search/domain/entities/movie.dart';

/// Poster with the rating badge in the top-left corner.
class MoviePosterCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;

  const MoviePosterCard({super.key, required this.movie, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              movie.posterUrl,
              fit: BoxFit.cover,
              // The poster host (img.yts.pw) sends no CORS headers, so on web
              // Flutter can't fetch the bytes itself. Fall back to a plain
              // <img> element, which isn't subject to CORS. No effect on mobile.
              webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
              errorBuilder: (_, _, _) => const ColoredBox(
                color: Color(0xFF282A28),
                child: Icon(Icons.broken_image, color: Colors.white38),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      movie.rating.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.star, color: AppColors.yellow, size: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
