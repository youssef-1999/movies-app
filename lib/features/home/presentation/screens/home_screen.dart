import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/features/home/data/datasources/dummy_movies.dart';
import 'package:movies/features/home/presentation/widgets/bottom_bar.dart';
import 'package:movies/features/home/presentation/widgets/home_background.dart';
import 'package:movies/features/home/presentation/widgets/movies_carousel.dart';
import 'package:movies/features/home/presentation/widgets/movies_section.dart';
import 'package:movies/features/browse/presentation/screens/browse_screen.dart';
import 'package:movies/features/profile_feature/profile/presentation/screens/profile_screen.dart';
import 'package:movies/features/search_feature/features/search/presentation/screens/search_screen.dart';
import 'package:movies/gen/assets.gen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _movies = dummyMovies;
  int _currentMovie = 0;
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: _selectedTab == 0
    ? AppBar(
        centerTitle: true,
        backgroundColor: AppColors.black,
        automaticallyImplyLeading: false,
        title: Assets.images.availableNow.image(),
      )
    : null,
      body: IndexedStack(
  index: _selectedTab,
  children: [
    SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.65,
              child: Stack(
                children: [
                  HomeBackground(image: _movies[_currentMovie].image),
                  MoviesCarousel(
                    movies: _movies,
                    onPageChanged: (i) => setState(() => _currentMovie = i),
                  ),
                ],
              ),
            ),
            Assets.images.watchNow.image(),
            MoviesSection(title: 'Action', movies: _movies),
          ],
        ),
      ),
    const SearchScreen(),
    const BrowseScreen(),
    const ProfileScreen(), // profile, later
  ],
),
      bottomNavigationBar: BottomBar(
        currentIndex: _selectedTab,
        onTap: (tab) => setState(() => _selectedTab = tab),
      ),
    );
  }
}
