import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';

/// Small dark box with a yellow icon and a value (likes, runtime, rating).
class StatChip extends StatelessWidget {
  final IconData icon;
  final String value;

  const StatChip({super.key, required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.yellow, size: 26),
          const SizedBox(width: 12),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
