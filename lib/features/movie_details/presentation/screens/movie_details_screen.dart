import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/di/injection.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/features/movie_details/domain/entities/movie_details.dart';
import 'package:movies/features/movie_details/presentation/cubit/movie_details_cubit.dart';
import 'package:movies/features/movie_details/presentation/cubit/movie_details_state.dart';
import 'package:movies/features/movie_details/presentation/widgets/cast_tile.dart';
import 'package:movies/features/movie_details/presentation/widgets/details_header.dart';
import 'package:movies/features/movie_details/presentation/widgets/network_poster.dart';
import 'package:movies/features/movie_details/presentation/widgets/stat_chip.dart';
import 'package:movies/features/search_feature/features/search/domain/entities/movie.dart';
import 'package:movies/features/search_feature/features/search/presentation/widgets/movie_poster_card.dart';

/// Push with the movie id as the argument:
/// `Navigator.pushNamed(context, MovieDetailsScreen.routeName, arguments: id)`
class MovieDetailsScreen extends StatelessWidget {
  static const String routeName = 'movie_details';

  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MovieDetailsCubit>()..load(movieId),
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
          builder: (context, state) {
            if (state is MovieDetailsSuccess) {
              return _DetailsBody(
                movie: state.movie,
                similar: state.similar,
                isBookmarked: state.isBookmarked,
              );
            }
            if (state is MovieDetailsError) {
              return _ErrorView(
                message: state.message,
                onRetry: () => context.read<MovieDetailsCubit>().load(movieId),
              );
            }
            return const Center(
              child: CircularProgressIndicator(color: AppColors.yellow),
            );
          },
        ),
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  final MovieDetails movie;
  final List<Movie> similar;
  final bool isBookmarked;

  const _DetailsBody({
    required this.movie,
    required this.similar,
    required this.isBookmarked,
  });

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 16);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DetailsHeader(
            movie: movie,
            isBookmarked: isBookmarked,
            onBookmark: () =>
                context.read<MovieDetailsCubit>().toggleBookmark(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    // TODO: open the movie / trailer (needs url_launcher).
                    onPressed: () {},
                    child: const Text(
                      'Watch',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                gap,
                Row(
                  children: [
                    Expanded(
                      child: StatChip(
                        icon: Icons.favorite,
                        value: '${movie.likeCount}',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatChip(
                        icon: Icons.access_time_filled,
                        value: '${movie.runtime}',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatChip(
                        icon: Icons.star_rounded,
                        value: '${movie.rating}',
                      ),
                    ),
                  ],
                ),
                if (movie.screenshots.isNotEmpty) ...[
                  gap,
                  const _SectionTitle('Screen Shots'),
                  for (final url in movie.screenshots)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: NetworkPoster(url),
                        ),
                      ),
                    ),
                ],
                if (similar.isNotEmpty) ...[
                  gap,
                  const _SectionTitle('Similar'),
                  GridView.builder(
                    shrinkWrap: true,
                    // Without this the grid adds the status-bar inset on top.
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: similar.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.68,
                        ),
                    itemBuilder: (context, index) => MoviePosterCard(
                      movie: similar[index],
                      onTap: () => Navigator.pushReplacementNamed(
                        context,
                        MovieDetailsScreen.routeName,
                        arguments: similar[index].id,
                      ),
                    ),
                  ),
                ],
                if (movie.description.isNotEmpty) ...[
                  gap,
                  const _SectionTitle('Summary'),
                  Text(
                    movie.description,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                ],
                if (movie.cast.isNotEmpty) ...[
                  gap,
                  const _SectionTitle('Cast'),
                  for (final member in movie.cast)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: CastTile(member: member),
                    ),
                ],
                if (movie.genres.isNotEmpty) ...[
                  gap,
                  const _SectionTitle('Genres'),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final genre in movie.genres)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.darkGrey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            genre,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
            onPressed: () => Navigator.maybePop(context),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: onRetry,
                  child: const Text(
                    'Retry',
                    style: TextStyle(color: AppColors.yellow),
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
