import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';

/// Pulsing poster placeholders shown while the first page loads.
class BrowseSkeletonGrid extends StatefulWidget {
  final SliverGridDelegate gridDelegate;
  final EdgeInsets padding;

  const BrowseSkeletonGrid({
    super.key,
    required this.gridDelegate,
    required this.padding,
  });

  @override
  State<BrowseSkeletonGrid> createState() => _BrowseSkeletonGridState();
}

class _BrowseSkeletonGridState extends State<BrowseSkeletonGrid>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.35, end: 0.8).animate(_controller),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: widget.padding,
        gridDelegate: widget.gridDelegate,
        itemCount: 8,
        itemBuilder: (_, _) => DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.darkGrey,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
