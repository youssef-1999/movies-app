import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/di/injection.dart';
import 'package:movies/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:movies/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:movies/features/auth/presentation/screens/login_screen.dart';
import 'package:movies/features/auth/presentation/screens/register_screen.dart';
import 'package:movies/features/browse/presentation/screens/browse_screen.dart';
import 'package:movies/features/home/presentation/screens/home_screen.dart';
import 'package:movies/features/movie_details/presentation/screens/movie_details_screen.dart';
import 'package:movies/features/profile_feature/profile/presentation/screens/profile_screen.dart';
import 'package:movies/features/search_feature/features/search/presentation/screens/search_screen.dart';
import 'package:movies/screens/onboarding_screens.dart';

abstract class AppRoutes {
  static const String initialRoute = OnboardingScreens.routeName;

  static Map<String, WidgetBuilder> routes = {
    OnboardingScreens.routeName: (context) => const OnboardingScreens(),
    LoginScreen.routeName: (context) => BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: const LoginScreen(),
    ), // BlocProvider(create: (context) => AuthCubit(), child: const LoginScreen()),
    RegisterScreen.routeName: (context) => BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: const RegisterScreen(),
    ),
    ForgetPassword.routeName: (context) => BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: const ForgetPassword(),
    ),
    HomeScreen.routeName: (context) => const HomeScreen(),
    SearchScreen.routeName: (context) => const SearchScreen(),
    BrowseScreen.routeName: (context) => BrowseScreen(
      initialGenre: ModalRoute.of(context)!.settings.arguments as String?,
    ),
    ProfileScreen.routeName: (context) => const ProfileScreen(),
    MovieDetailsScreen.routeName: (context) => MovieDetailsScreen(
      movieId: ModalRoute.of(context)!.settings.arguments as int,
    ),
    // UpdateProfileScreen is not a named route: it needs the ProfileCubit
    // from ProfileScreen, which pushes it with BlocProvider.value.
  };
}
