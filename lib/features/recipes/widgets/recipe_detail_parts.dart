import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../../core/services/app_language_service.dart';
import '../models/generated_recipe.dart';
export 'recipe_detail_callout.dart';

/// Top header for imageless recipe detail dialog: Match badge, category pill & close button.
class RecipeDetailHeader extends StatelessWidget {
  final GeneratedRecipe recipe;
  final String language;
  final bool isDark;
  final VoidCallback onClose;

  const RecipeDetailHeader({
    super.key,
    required this.recipe,
    required this.language,
    required this.isDark,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final aiPurple = isDark ? AppColors.darkAiPurple : AppColors.aiPurple;
    final emeraldAccent = isDark ? AppColors.darkAccent : AppColors.primaryGreen;
    final secondaryTextColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final categoryText = AppLanguageService.translateCategory(recipe.category, language);
    final match = recipe.matchPercent;

    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [aiPurple.withValues(alpha: 0.18), emeraldAccent.withValues(alpha: 0.14)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: aiPurple.withValues(alpha: 0.35)),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, size: 12, color: aiPurple),
                      const SizedBox(width: 4),
                      Text(
                        match.isEmpty ? 'AI PICK' : '$match MATCH',
                        style: TextStyle(color: aiPurple, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.4),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0x33334155) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.08) : AppColors.border),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.restaurant_rounded, size: 11, color: secondaryTextColor),
                      const SizedBox(width: 4),
                      Text(
                        categoryText,
                        style: TextStyle(color: secondaryTextColor, fontSize: 10.5, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: onClose,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.close_rounded, size: 18, color: secondaryTextColor),
          ),
        ),
      ],
    );
  }
}

/// 3-column stats card for recipe details (Cook Time, Calories, Servings).
class RecipeDetailMetrics extends StatelessWidget {
  final GeneratedRecipe recipe;
  final int peopleCount;
  final String language;
  final bool isDark;

  const RecipeDetailMetrics({
    super.key,
    required this.recipe,
    required this.peopleCount,
    required this.language,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final metricBg = isDark ? const Color(0x660F172A) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.08) : AppColors.border;
    final primaryTextColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryTextColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final personUnit = peopleCount == 1
        ? AppLanguageService.tr('person', language)
        : AppLanguageService.tr('people', language);

    return Row(
      children: [
        _metricItem(
          icon: Icons.timer_outlined,
          iconColor: isDark ? AppColors.darkAiPurple : AppColors.aiPurple,
          value: recipe.prepTime,
          label: 'Cook Time',
          bg: metricBg,
          border: borderColor,
          primaryText: primaryTextColor,
          secondaryText: secondaryTextColor,
        ),
        const SizedBox(width: 8),
        _metricItem(
          icon: Icons.local_fire_department_rounded,
          iconColor: AppColors.warningOrange,
          value: recipe.calories,
          label: 'Energy',
          bg: metricBg,
          border: borderColor,
          primaryText: primaryTextColor,
          secondaryText: secondaryTextColor,
        ),
        const SizedBox(width: 8),
        _metricItem(
          icon: Icons.people_outline_rounded,
          iconColor: AppColors.secondaryGreen,
          value: '$peopleCount $personUnit',
          label: 'Portion',
          bg: metricBg,
          border: borderColor,
          primaryText: primaryTextColor,
          secondaryText: secondaryTextColor,
        ),
      ],
    );
  }

  Widget _metricItem({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    required Color bg,
    required Color border,
    required Color primaryText,
    required Color secondaryText,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
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
                    style: TextStyle(color: primaryText, fontSize: 12, fontWeight: FontWeight.w700),
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
                style: TextStyle(color: secondaryText, fontSize: 9.5, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
