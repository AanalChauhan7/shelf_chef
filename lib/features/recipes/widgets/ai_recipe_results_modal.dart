import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../models/generated_recipe.dart';
import '../models/ingredient_item.dart';
import 'ai_generated_card.dart';

/// Modal bottom sheet presenting real Gemini AI generated recipes.
class AiRecipeResultsModal extends StatelessWidget {
  final int peopleCount;
  final List<IngredientItem> ingredients;
  final List<GeneratedRecipe> recipes;
  final bool isDark;

  const AiRecipeResultsModal({
    super.key,
    required this.peopleCount,
    required this.ingredients,
    required this.recipes,
    required this.isDark,
  });

  static void show(
    BuildContext context, {
    required int peopleCount,
    required List<IngredientItem> ingredients,
    required List<GeneratedRecipe> recipes,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AiRecipeResultsModal(
        peopleCount: peopleCount,
        ingredients: ingredients,
        recipes: recipes,
        isDark: isDark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final modalBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final ingredientNames = ingredients.map((i) => i.name).join(', ');

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: modalBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF475569)
                    : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: AppGradients.aiGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gemini AI Recipes',
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Scaled for $peopleCount ${peopleCount == 1 ? 'person' : 'people'} • ${ingredients.length} items used',
                      style: TextStyle(color: secondaryTextColor, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (isDark ? AppColors.darkAiPurple : AppColors.aiPurple)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (isDark ? AppColors.darkAiPurple : AppColors.aiPurple)
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.stars_rounded,
                  color: isDark ? AppColors.darkAiPurple : AppColors.aiPurple,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    ingredients.isEmpty
                        ? 'Using general pantry items'
                        : 'Using: $ingredientNames',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: recipes.length,
              separatorBuilder: (_, index) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                return AiGeneratedCard(
                  recipe: recipes[index],
                  peopleCount: peopleCount,
                  isDark: isDark,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
