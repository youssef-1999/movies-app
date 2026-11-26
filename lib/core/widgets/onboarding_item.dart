import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/core/extensions/padding_extension.dart';
import 'package:movies/core/widgets/custom_elevated_button.dart';

class OnboardingItem extends StatelessWidget {
  const OnboardingItem({
    super.key,
    required this.image,
    required this.title,
    required this.buttonText,
    required this.onPressed,
    this.description,
    this.onBack,
  });

  final ImageProvider image;
  final String title;
  final String? description;
  final String buttonText;
  final VoidCallback onPressed;

  /// When set, a "Back" button is shown under the main button.
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(image: image, fit: BoxFit.cover),
      ),
      child: Container(
        // Darkens the bottom of the image so the text stays readable
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              AppColors.black.withValues(alpha: 0.6),
              AppColors.black,
            ],
            stops: const [0.4, 0.7, 1],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              Text(
                title,
                textAlign: TextAlign.center,
                style: textTheme.headlineLarge,
              ).paddingSymmetric(horizontal: 16, vertical: 9),
              if (description != null)
                Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge,
                ).paddingSymmetric(horizontal: 16),
              CustomElevatedButton(
                text: buttonText,
                onPressed: onPressed,
              ).paddingOnly(top: 24, left: 16, right: 16),
              if (onBack != null)
                CustomElevatedButton(
                  text: "Back",
                  backgroundColor: AppColors.black,
                  textColor: AppColors.yellow,
                  borderColor: AppColors.yellow,
                  onPressed: onBack,
                ).paddingOnly(top: 16, left: 16, right: 16),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
