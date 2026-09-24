import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../models/generated_recipe.dart';
import 'recipe_detail_dialog.dart';

/// Card widget displaying curated AI recipe suggestion item for Recipe Hub.
class AiRecipeHubCard extends StatelessWidget {
  final GeneratedRecipe recipe;
  final bool isDark;
  final Color aiPurple;
  final Color primaryColor;
  final Color secondaryColor;

  const AiRecipeHubCard({
    super.key,
    required this.recipe,
    required this.isDark,
    required this.aiPurple,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return InkWell(
      onTap: () =>
          RecipeDetailDialog.show(context, recipe: recipe, peopleCount: 2),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
          boxShadow: AppShadows.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: aiPurple.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${recipe.matchPercent} MATCH',
                    style: TextStyle(
                      color: aiPurple,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '⏱️ ${recipe.totalTimeMinutes} Mins • ${recipe.difficulty}',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              recipe.name,
              style: TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              recipe.description,
              style: TextStyle(color: secondaryColor, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
