import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../models/generated_recipe.dart';
import '../screens/cooking_guide_screen.dart';

/// Modal dialog displaying preview image and details for a Gemini recipe.
class RecipeDetailDialog extends StatelessWidget {
  final GeneratedRecipe recipe;
  final int peopleCount;

  const RecipeDetailDialog({
    super.key,
    required this.recipe,
    required this.peopleCount,
  });

  static void show(
    BuildContext context, {
    required GeneratedRecipe recipe,
    required int peopleCount,
  }) {
    showDialog(
      context: context,
      builder: (_) =>
          RecipeDetailDialog(recipe: recipe, peopleCount: peopleCount),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final maxHeight = MediaQuery.of(context).size.height * 0.8;

    return AlertDialog(
      backgroundColor: dialogBg,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  child: Image.network(
                    recipe.displayImageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, error, stackTrace) => Container(
                      height: 160,
                      color:
                          (isDark ? AppColors.darkAiPurple : AppColors.aiPurple)
                              .withValues(alpha: 0.2),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.soup_kitchen_rounded,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.title,
                        style: TextStyle(
                          color: primaryTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        recipe.description,
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _infoChip(
                            Icons.timer_rounded,
                            recipe.prepTime,
                            isDark,
                          ),
                          _infoChip(
                            Icons.local_fire_department_rounded,
                            recipe.calories,
                            isDark,
                          ),
                          _infoChip(
                            Icons.group_rounded,
                            '$peopleCount Portions',
                            isDark,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close', style: TextStyle(color: secondaryTextColor)),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CookingGuideScreen(
                  recipe: recipe,
                  peopleCount: peopleCount,
                ),
              ),
            );
          },
          icon: const Text('Start Cooking'),
          label: const Icon(Icons.play_arrow_rounded, size: 18),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark
                ? AppColors.darkAiPurple
                : AppColors.aiPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoChip(IconData icon, String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.secondaryGreen),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
