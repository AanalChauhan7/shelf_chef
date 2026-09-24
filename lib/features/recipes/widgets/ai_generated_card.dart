import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../models/generated_recipe.dart';
import 'recipe_detail_dialog.dart';

/// Card displaying an AI generated recipe item.
class AiGeneratedCard extends StatelessWidget {
  final GeneratedRecipe recipe;
  final int peopleCount;
  final bool isDark;

  const AiGeneratedCard({
    super.key,
    required this.recipe,
    required this.peopleCount,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return InkWell(
      onTap: () => RecipeDetailDialog.show(
        context,
        recipe: recipe,
        peopleCount: peopleCount,
      ),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    recipe.title,
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color:
                        (isDark ? AppColors.darkAiPurple : AppColors.aiPurple)
                            .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    recipe.category,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkAiPurple
                          : AppColors.aiPurple,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${recipe.matchPercent} Match',
                    style: const TextStyle(
                      color: AppColors.secondaryGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              recipe.description,
              style: TextStyle(color: secondaryTextColor, fontSize: 13),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(Icons.timer_rounded, size: 16, color: secondaryTextColor),
                const SizedBox(width: 4),
                Text(
                  recipe.prepTime,
                  style: TextStyle(color: secondaryTextColor, fontSize: 12),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.local_fire_department_rounded,
                  size: 16,
                  color: AppColors.warningOrange,
                ),
                const SizedBox(width: 4),
                Text(
                  recipe.calories,
                  style: TextStyle(color: secondaryTextColor, fontSize: 12),
                ),
                const Spacer(),
                Text(
                  'Tap to Cook →',
                  style: TextStyle(
                    color: isDark ? AppColors.darkAiPurple : AppColors.aiPurple,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
