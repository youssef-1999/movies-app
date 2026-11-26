import 'package:flutter/material.dart';
import 'package:movies/gen/assets.gen.dart';
import 'package:movies/features/auth/presentation/screens/login_screen.dart';
import 'package:movies/core/widgets/onboarding_item.dart';

class OnboardingData {
  const OnboardingData({
    required this.image,
    required this.title,
    this.description,
    required this.buttonText,
  });

  final AssetGenImage image;
  final String title;
  final String? description;
  final String buttonText;
}

class OnboardingScreens extends StatefulWidget {
  static const String routeName = '/boarding-screens';
  const OnboardingScreens({super.key});

  @override
  State<OnboardingScreens> createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  final _controller = PageController();
  int _currentPage = 0;

  static final List<OnboardingData> _pages = [
    OnboardingData(
      image: Assets.posters.moviesPosters,
      title: "Find Your Next \n Favorite Movie Here",
      description:
          "Get access to a huge library of movies \n to suit all tastes. You will surely like it.",
      buttonText: "Explore Now",
    ),
    OnboardingData(
      image: Assets.images.movie1,
      title: "Discover Movies",
      description:
          "Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.",
      buttonText: "Next",
    ),
    OnboardingData(
      image: Assets.images.movie2,
      title: "Explore All Genres",
      description:
          "Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.",
      buttonText: "Next",
    ),
    OnboardingData(
      image: Assets.images.movie3,
      title: "Create Watchlists",
      description:
          "Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.",
      buttonText: "Next",
    ),
    OnboardingData(
      image: Assets.images.movie4,
      title: "Rate, Review, and Learn",
      description:
          "Share your thoughts on the movies you've watched. Dive deep into film details and help others discover great movies with your reviews.",
      buttonText: "Next",
    ),
    OnboardingData(
      image: Assets.images.movie5,
      title: "Start Watching Now",
      buttonText: "Finish",
    ),
  ];

  bool get _isLastPage => _currentPage == _pages.length - 1;

  void _goTo(int page) {
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onNext() {
    if (_isLastPage) {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      return;
    }
    _goTo(_currentPage + 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: _pages.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (context, index) {
          final page = _pages[index];
          return OnboardingItem(
            image: page.image.provider(),
            title: page.title,
            description: page.description,
            buttonText: page.buttonText,
            onPressed: _onNext,
            // No "Back" on the first page or on the page right after it
            onBack: index > 1 ? () => _goTo(index - 1) : null,
          );
        },
      ),
    );
  }
}
