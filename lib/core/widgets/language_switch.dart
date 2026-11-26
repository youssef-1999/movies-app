import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/gen/assets.gen.dart';

/// A pill-shaped toggle between English ('en') and Arabic ('ar').
class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({
    super.key,
    required this.languageCode,
    required this.onChanged,
  });

  /// Currently selected language: 'en' or 'ar'.
  final String languageCode;
  final ValueChanged<String> onChanged;

  static const double _itemWidth = 44;
  static const double _height = 34;

  @override
  Widget build(BuildContext context) {
    final isArabic = languageCode == 'ar';

    return GestureDetector(
      onTap: () => onChanged(isArabic ? 'en' : 'ar'),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.yellow, width: 2),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                alignment: isArabic
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  width: _itemWidth,
                  height: _height,
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _flag(Assets.images.en),
                _flag(Assets.images.ar),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _flag(AssetGenImage image) {
    return SizedBox(
      width: _itemWidth,
      height: _height,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: image.image(fit: BoxFit.contain),
      ),
    );
  }
}
