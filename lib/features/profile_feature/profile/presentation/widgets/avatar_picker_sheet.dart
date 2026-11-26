import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/features/profile_feature/profile/pfps.dart';


Future<int?> showAvatarPicker(BuildContext context, int selected) {
  return showModalBottomSheet<int>(
    context: context,
    backgroundColor: AppColors.black,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: ProfileAssets.avatarCount,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemBuilder: (context, i) {
          final index = i + 1;
          final isSelected = index == selected;
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.pop(context, index),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.yellow.withValues(alpha: .35)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.yellow : Colors.white24,
                ),
              ),
              child: Image.asset(ProfileAssets.avatar(index)),
            ),
          );
        },
      ),
    ),
  );
}
