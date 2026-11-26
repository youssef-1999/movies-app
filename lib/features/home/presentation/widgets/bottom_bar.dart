import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/gen/assets.gen.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.darkGrey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: currentIndex,
            onTap: onTap,
            items: [
              _item(Assets.icons.home),
              _item(Assets.icons.search),
              _item(Assets.icons.compass ),
              _item(Assets.icons.profile),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _item(String path) {
    return BottomNavigationBarItem(
      label: '',
      icon: _icon(path, const Color.fromARGB(255, 66, 8, 8)),
      activeIcon: _icon(path, AppColors.yellow),
    );
  }

  Widget _icon(String path, Color color) => SvgPicture.asset(
    path,
    width: 28,
    height: 28,
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
  );
}
