import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/features/browse/domain/entities/browse_sort.dart';

/// Shows the sort options and returns the picked one (null if dismissed).
Future<BrowseSort?> showSortSheet(BuildContext context, BrowseSort current) {
  return showModalBottomSheet<BrowseSort>(
    context: context,
    backgroundColor: AppColors.darkGrey,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: Text(
              'Sort by',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          for (final sort in BrowseSort.values)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              title: Text(
                sort.label,
                style: TextStyle(
                  color: sort == current ? AppColors.yellow : AppColors.white,
                  fontWeight:
                      sort == current ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              trailing: sort == current
                  ? const Icon(Icons.check_rounded, color: AppColors.yellow)
                  : null,
              onTap: () => Navigator.pop(context, sort),
            ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}
