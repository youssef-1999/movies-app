import 'package:flutter/material.dart';
import 'package:movies/apis/constants.dart';
import 'package:movies/core/theme/app_colors.dart';

/// "sci-fi" -> "Sci-Fi", "film-noir" -> "Film-Noir".
String genreLabel(String genre) => genre
    .split('-')
    .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
    .join('-');

/// Horizontal list of genre pills. `null` is the "All" pill.
class GenreTabs extends StatefulWidget {
  final String? selected;
  final ValueChanged<String?> onSelected;

  const GenreTabs({super.key, required this.selected, required this.onSelected});

  @override
  State<GenreTabs> createState() => _GenreTabsState();
}

class _GenreTabsState extends State<GenreTabs> {
  static const List<String?> _genres = [null, ...ApiConstants.genres];
  final Map<String?, GlobalKey> _keys = {for (final g in _genres) g: GlobalKey()};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _revealSelected(false));
  }

  @override
  void didUpdateWidget(covariant GenreTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _revealSelected(true));
    }
  }

  /// Keeps the selected pill visible, e.g. when it was picked off-screen.
  void _revealSelected(bool animate) {
    final ctx = _keys[widget.selected]?.currentContext;
    if (ctx == null || !mounted) return;
    Scrollable.ensureVisible(
      ctx,
      alignment: 0.5,
      duration: animate ? const Duration(milliseconds: 300) : Duration.zero,
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _genres.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final genre = _genres[i];
          return _GenrePill(
            key: _keys[genre],
            label: genre == null ? 'All' : genreLabel(genre),
            selected: genre == widget.selected,
            onTap: () => widget.onSelected(genre),
          );
        },
      ),
    );
  }
}

class _GenrePill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _GenrePill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: selected ? AppColors.yellow : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.yellow, width: 2),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.black : AppColors.yellow,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
