import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/features/movie_details/presentation/screens/movie_details_screen.dart';
import 'package:movies/features/search_feature/features/search/domain/entities/movie.dart';
import 'package:movies/features/search_feature/features/search/presentation/widgets/movie_poster_card.dart';

class ProfileTabs extends StatelessWidget {
  final List<Movie> watchlist;
  final List<Movie> history;
  const ProfileTabs({
    super.key,
    required this.watchlist,
    required this.history,
  });
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            indicatorColor: AppColors.yellow,
            labelColor: AppColors.yellow,
            unselectedLabelColor: Colors.white,
            dividerColor: Colors.white24,
            tabs: [
              Tab(icon: Icon(Icons.list_rounded, size: 28)),
              Tab(icon: Icon(Icons.folder_rounded, size: 28)),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _MoviesGrid(movies: watchlist),
               _MoviesGrid(movies: history),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MoviesGrid extends StatelessWidget {
  final List<Movie> movies;
  const _MoviesGrid({required this.movies});

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const _EmptyState();
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: movies.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, i) => MoviePosterCard(
        movie: movies[i],
        onTap: () => Navigator.pushNamed(
          context,
          MovieDetailsScreen.routeName,
          arguments: movies[i].id,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) =>
      Center(child: Image.asset('assets/images/Empty 1.png', width: 120));
}
