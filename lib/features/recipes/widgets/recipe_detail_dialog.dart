import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../../core/services/app_language_service.dart';
import '../models/generated_recipe.dart';
import '../screens/cooking_guide_screen.dart';
import 'recipe_detail_parts.dart';
import 'save_recipe_button.dart';

/// Modal dialog displaying comprehensive, imageless details for a recipe suggestion.
class RecipeDetailDialog extends StatelessWidget {
  final GeneratedRecipe recipe;
  final int peopleCount;
  final String language;

  /// Called after the recipe is saved or removed via the Save button.
  final ValueChanged<GeneratedRecipe>? onSavedChanged;

  const RecipeDetailDialog({
    super.key,
    required this.recipe,
    required this.peopleCount,
    this.language = 'English',
    this.onSavedChanged,
  });

  static void show(
    BuildContext context, {
    required GeneratedRecipe recipe,
    required int peopleCount,
    String language = 'English',
    ValueChanged<GeneratedRecipe>? onSavedChanged,
  }) {
    showDialog(
      context: context,
      builder: (_) => RecipeDetailDialog(
        recipe: recipe,
        peopleCount: peopleCount,
        language: language,
        onSavedChanged: onSavedChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final primaryTextColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final maxHeight = MediaQuery.of(context).size.height * 0.85;
    final maxWidth = MediaQuery.of(context).size.width * 0.92;

    return AlertDialog(
      backgroundColor: dialogBg,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      content: SizedBox(
        width: maxWidth.clamp(280.0, 460.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RecipeDetailHeader(
                  recipe: recipe,
                  language: language,
                  isDark: isDark,
                  onClose: () => Navigator.pop(context),
                ),
                const SizedBox(height: 14),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.title,
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          recipe.description,
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 13,
                            height: 1.35,
                          ),
                        ),
                        if (recipe.chefTip.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          _buildChefTipBubble(isDark, secondaryTextColor),
                        ],
                        const SizedBox(height: 16),
                        RecipeDetailMetrics(
                          recipe: recipe,
                          peopleCount: peopleCount,
                          language: language,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 14),
                        RecipeDetailPantryChips(
                          recipe: recipe,
                          isDark: isDark,
                        ),
                        if (recipe.missingIngredients.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          RecipeDetailMissingCallout(
                            recipe: recipe,
                            isDark: isDark,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _buildActionFooter(context, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChefTipBubble(bool isDark, Color secondaryTextColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.darkAiPurple : AppColors.aiPurple)
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: (isDark ? AppColors.darkAiPurple : AppColors.aiPurple)
              .withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡', style: TextStyle(fontSize: 13)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              recipe.chefTip,
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionFooter(BuildContext context, bool isDark) {
    return Row(
      children: [
        SaveRecipeButton(
          recipe: recipe,
          language: language,
          onChanged: onSavedChanged,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              gradient: AppGradients.primaryGradient,
              borderRadius: BorderRadius.circular(23),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondaryGreen.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CookingGuideScreen(
                      recipe: recipe,
                      peopleCount: peopleCount,
                      language: language,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLanguageService.tr('start_cooking', language),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
