import 'package:flutter/material.dart';
import '../../../core/core.dart';

class OnboardingSlide {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingSlide({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

/// Slide card for OnboardingScreen carousel.
class OnboardingSlideCard extends StatelessWidget {
  final OnboardingSlide slide;
  final bool isDark;

  const OnboardingSlideCard({
    super.key,
    required this.slide,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.p24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Clean Image Card
          Container(
            height: 280,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                slide.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: isDark
                        ? AppColors.darkCard
                        : const Color(0xFFE2E8F0),
                    child: const Center(
                      child: Icon(
                        Icons.kitchen_rounded,
                        size: 64,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: AppSizes.p32),

          // Title
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.headingLarge(
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: AppSizes.p12),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p12),
            child: Text(
              slide.description,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
