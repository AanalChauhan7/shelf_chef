import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Numbered step-by-step cooking instruction list widget.
class CookingStepsList extends StatelessWidget {
  final List<String> steps;

  const CookingStepsList({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final cardBg = isDark ? AppColors.darkCard : AppColors.surface;

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.border,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.darkAiPurple : AppColors.aiPurple)
                      .withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: isDark ? AppColors.darkAiPurple : AppColors.aiPurple,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  step,
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
