import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../recipes/models/generated_recipe.dart';

/// 3-column stats row highlighting Cook Time, Calories, and Difficulty.
class AiRecipeMetricsRow extends StatelessWidget {
  final GeneratedRecipe recipe;
  final bool isDark;
  final Color aiPurple;

  const AiRecipeMetricsRow({
    super.key,
    required this.recipe,
    required this.isDark,
    required this.aiPurple,
  });

  @override
  Widget build(BuildContext context) {
    final metricBg =
        isDark ? const Color(0x660F172A) : const Color(0xFFF8FAFC);
    final borderColor =
        isDark ? Colors.white.withValues(alpha: 0.08) : AppColors.border;
    final primaryTextColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Row(
      children: [
        _buildMetricItem(
          icon: Icons.timer_outlined,
          iconColor: aiPurple,
          value: recipe.prepTime,
          label: 'Cook Time',
          metricBg: metricBg,
          borderColor: borderColor,
          primaryText: primaryTextColor,
          secondaryText: secondaryTextColor,
        ),
        const SizedBox(width: 8),
        _buildMetricItem(
          icon: Icons.local_fire_department_rounded,
          iconColor: AppColors.warningOrange,
          value: recipe.calories,
          label: 'Energy',
          metricBg: metricBg,
          borderColor: borderColor,
          primaryText: primaryTextColor,
          secondaryText: secondaryTextColor,
        ),
        const SizedBox(width: 8),
        _buildMetricItem(
          icon: Icons.outdoor_grill_outlined,
          iconColor: AppColors.secondaryGreen,
          value: recipe.difficulty,
          label: 'Difficulty',
          metricBg: metricBg,
          borderColor: borderColor,
          primaryText: primaryTextColor,
          secondaryText: secondaryTextColor,
        ),
      ],
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    required Color metricBg,
    required Color borderColor,
    required Color primaryText,
    required Color secondaryText,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: metricBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 14, color: iconColor),
                  const SizedBox(width: 4),
                  Text(
                    value,
                    maxLines: 1,
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
