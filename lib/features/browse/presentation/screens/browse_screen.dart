import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/di/injection.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/features/browse/presentation/cubit/browse_cubit.dart';
import 'package:movies/features/browse/presentation/cubit/browse_state.dart';
import 'package:movies/features/browse/presentation/widgets/browse_skeleton.dart';
import 'package:movies/features/browse/presentation/widgets/genre_tabs.dart';
import 'package:movies/features/browse/presentation/widgets/sort_sheet.dart';
import 'package:movies/features/movie_details/presentation/screens/movie_details_screen.dart';
import 'package:movies/features/search_feature/features/search/presentation/widgets/movie_poster_card.dart';

const _gridPadding = EdgeInsets.fromLTRB(16, 8, 16, 16);

/// Grows from 2 columns on phones to more on tablets and web.
const _gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 220,
  crossAxisSpacing: 12,
  mainAxisSpacing: 12,
  childAspectRatio: 0.68,
);

class BrowseScreen extends StatelessWidget {
  static const String routeName = '/browse';

  /// Genre to open on; null shows all genres.
  final String? initialGenre;

  const BrowseScreen({super.key, this.initialGenre});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BrowseCubit>()..init(genre: initialGenre),
      child: const _BrowseView(),
    );
  }
}

class _BrowseView extends StatefulWidget {
  const _BrowseView();

  @override
  State<_BrowseView> createState() => _BrowseViewState();
}

class _BrowseViewState extends State<_BrowseView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Fetch the next page a little before the user hits the bottom.
  void _onScroll() {
    if (_scrollController.position.extentAfter < 600) {
      context.read<BrowseCubit>().loadMore();
    }
  }

  Future<void> _pickSort() async {
    final cubit = context.read<BrowseCubit>();
    final picked = await showSortSheet(context, cubit.state.sort);
    if (picked != null) cubit.changeSort(picked);
  }

  Future<void> _refresh() async {
    final error = await context.read<BrowseCubit>().refresh();
    if (error != null && mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: BlocListener<BrowseCubit, BrowseState>(
          // New genre or sort: start again from the top.
          listenWhen: (a, b) => a.genre != b.genre || a.sort != b.sort,
          listener: (_, _) {
            if (_scrollController.hasClients) _scrollController.jumpTo(0);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(onSortTap: _pickSort),
              BlocSelector<BrowseCubit, BrowseState, String?>(
                selector: (s) => s.genre,
                builder: (context, genre) => GenreTabs(
                  selected: genre,
                  onSelected: context.read<BrowseCubit>().selectGenre,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _BrowseBody(
                  scrollController: _scrollController,
                  onRefresh: _refresh,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onSortTap;

  const _Header({required this.onSortTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 12),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Browse',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          BlocSelector<BrowseCubit, BrowseState, String>(
            selector: (s) => s.sort.label,
            builder: (context, label) => TextButton.icon(
              onPressed: onSortTap,
              style: TextButton.styleFrom(foregroundColor: AppColors.yellow),
              icon: const Icon(Icons.sort_rounded),
              label: Text(label),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrowseBody extends StatelessWidget {
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;

  const _BrowseBody({required this.scrollController, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrowseCubit, BrowseState>(
      builder: (context, state) {
        final Widget child;
        switch (state.status) {
          case BrowseStatus.loading:
            child = const BrowseSkeletonGrid(
              key: ValueKey('loading'),
              gridDelegate: _gridDelegate,
              padding: _gridPadding,
            );
          case BrowseStatus.failure:
            child = _MessageView(
              key: const ValueKey('error'),
              icon: Icons.wifi_off_rounded,
              message: state.errorMessage ?? 'Something went wrong.',
              actionLabel: 'Try again',
              onAction: context.read<BrowseCubit>().retry,
            );
          case BrowseStatus.success when state.movies.isEmpty:
            child = const _MessageView(
              key: ValueKey('empty'),
              image: AssetImage('assets/images/Empty 1.png'),
              message: 'No movies found for this genre.',
            );
          case BrowseStatus.success:
            child = RefreshIndicator(
              key: const ValueKey('grid'),
              color: AppColors.yellow,
              backgroundColor: AppColors.darkGrey,
              onRefresh: onRefresh,
              child: _MoviesGrid(state: state, controller: scrollController),
            );
        }
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: child,
        );
      },
    );
  }
}

class _MoviesGrid extends StatelessWidget {
  final BrowseState state;
  final ScrollController controller;

  const _MoviesGrid({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    final movies = state.movies;
    return CustomScrollView(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: _gridPadding.copyWith(bottom: 0),
          sliver: SliverGrid.builder(
            gridDelegate: _gridDelegate,
            itemCount: movies.length,
            itemBuilder: (context, i) => MoviePosterCard(
              key: ValueKey(movies[i].id),
              movie: movies[i],
              onTap: () => Navigator.pushNamed(
                context,
                MovieDetailsScreen.routeName,
                arguments: movies[i].id,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(child: _GridFooter(state: state)),
      ],
    );
  }
}

/// Spinner while the next page loads, a retry on error, or an end marker.
class _GridFooter extends StatelessWidget {
  final BrowseState state;

  const _GridFooter({required this.state});

  @override
  Widget build(BuildContext context) {
    final Widget child;
    if (state.isLoadingMore) {
      child = const SizedBox.square(
        dimension: 28,
        child: CircularProgressIndicator(
          color: AppColors.yellow,
          strokeWidth: 3,
        ),
      );
    } else if (state.loadMoreError != null) {
      child = Column(
        children: [
          Text(
            state.loadMoreError!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
          TextButton(
            onPressed: context.read<BrowseCubit>().loadMore,
            style: TextButton.styleFrom(foregroundColor: AppColors.yellow),
            child: const Text('Retry'),
          ),
        ],
      );
    } else if (!state.hasMore) {
      child = Text(
        "You've reached the end · ${state.movies.length} movies",
        style: const TextStyle(color: Colors.white38, fontSize: 13),
      );
    } else {
      child = const SizedBox(height: 28);
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      child: Center(child: child),
    );
  }
}

class _MessageView extends StatelessWidget {
  final IconData? icon;
  final ImageProvider? image;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _MessageView({
    super.key,
    this.icon,
    this.image,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (image != null) Image(image: image!, width: 180, height: 180),
            if (icon != null) Icon(icon, color: Colors.white38, size: 64),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  foregroundColor: AppColors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
