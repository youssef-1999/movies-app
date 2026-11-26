import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies/core/di/injection.dart';
import 'package:movies/features/movie_details/presentation/screens/movie_details_screen.dart';

import 'package:movies/features/search_feature/features/search/presentation/cubit/search_cubit.dart';
import 'package:movies/features/search_feature/features/search/presentation/cubit/search_state.dart';
import 'package:movies/features/search_feature/features/search/presentation/widgets/movie_poster_card.dart';

const _background = AppColors.black;
const _fieldColor = AppColors.darkGrey;
const _yellow = AppColors.yellow;

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  static const String routeName = 'search'; 
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (_) => getIt<SearchCubit>(),
  child: const _SearchView(),
);
  }
}

class _SearchView extends StatelessWidget {
  const _SearchView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              TextField(
                onChanged: context.read<SearchCubit>().onQueryChanged,
                style: const TextStyle(color: Colors.white),
                cursorColor: _yellow,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const ImageIcon(
                   AssetImage(  'assets/icons/search2.png'),
                    color: Colors.white54,
                  ),
                  filled: true,
                  fillColor: _fieldColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Expanded(child: _SearchBody()),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBody extends StatelessWidget {
  const _SearchBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(
            child: CircularProgressIndicator(color: _yellow),
          );
        }

        if (state is SearchError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.white70),
            ),
          );
        }

        if (state is SearchSuccess && state.movies.isNotEmpty) {
          return GridView.builder(
            itemCount: state.movies.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.68,
            ),
            itemBuilder: (context, index) => MoviePosterCard(
              movie: state.movies[index],
              onTap: () => Navigator.pushNamed(
                context,
                MovieDetailsScreen.routeName,
                arguments: state.movies[index].id,
              ),
            ),
          );
        }
        return const _EmptyView();
      },
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
  
    return const Center(
      child: Image(
        image: AssetImage('assets/images/Empty 1.png'),
        width: 200,
        height: 200,
      ),
    );
  }
}
