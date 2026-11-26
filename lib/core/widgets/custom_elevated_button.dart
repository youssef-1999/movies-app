import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.yellow,
    this.textColor = AppColors.black,
    this.textStyle,
    this.borderColor,
    this.icon,
  });

  /// Optional widget shown before the text (e.g. a logo).
  final Widget? icon;

  /// Optional outline around the button.
  final Color? borderColor;

  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;

  /// Defaults to the theme's titleLarge (Inter / SemiBold / 20).
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final style = (textStyle ?? Theme.of(context).textTheme.titleLarge)
        ?.copyWith(color: textColor);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: borderColor == null
                ? BorderSide.none
                : BorderSide(color: borderColor!, width: 2),
          ),
        ),
        onPressed: onPressed,
        child: icon == null
            ? Text(text, style: style)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon!,
                  const SizedBox(width: 10),
                  Flexible(child: Text(text, style: style)),
                ],
              ),
      ),
    );
  }
}
