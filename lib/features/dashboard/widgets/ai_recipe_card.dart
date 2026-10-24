import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../../core/services/recipe_store.dart';
import '../../recipes/models/generated_recipe.dart';
import 'ai_recipe_card_parts.dart';

/// Premium, typographic AI Recipe Recommendation Card without photo thumbnails.
/// Highlights match percentage, key cooking metrics, and pantry ingredients used.
class AiRecipeCard extends StatelessWidget {
  final VoidCallback onStartCooking;
  final GeneratedRecipe? recipe;

  const AiRecipeCard({
    super.key,
    required this.onStartCooking,
    this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final aiPurple = isDark ? AppColors.darkAiPurple : AppColors.aiPurple;
    final emeraldAccent =
        isDark ? AppColors.darkAccent : AppColors.primaryGreen;
    final primaryTextColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: GestureDetector(
          onTap: onStartCooking,
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: _cardDecoration(isDark, aiPurple),
            child: ListenableBuilder(
              listenable: RecipeStore.instance,
              builder: (context, _) {
              final activeRecipe = recipe ?? RecipeStore.instance.featured;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderRow(activeRecipe, isDark, aiPurple, emeraldAccent),
                  const SizedBox(height: 12),
                  _buildTitleAndDescription(
                    activeRecipe,
                    primaryTextColor,
                    secondaryTextColor,
                  ),
                  if (activeRecipe != null) ...[
                    const SizedBox(height: 14),
                    AiRecipeMetricsRow(
                      recipe: activeRecipe,
                      isDark: isDark,
                      aiPurple: aiPurple,
                    ),
                    const SizedBox(height: 12),
                    AiRecipeIngredientsRow(
                      recipe: activeRecipe,
                      isDark: isDark,
                      emeraldAccent: emeraldAccent,
                    ),
                  ],
                  const SizedBox(height: 18),
                  AiRecipeCookButton(onPressed: onStartCooking),
                ],
              );
            },
          ),
        ),
      ),
    ),
  );
}

  BoxDecoration _cardDecoration(bool isDark, Color aiPurple) {
    return BoxDecoration(
      color: isDark ? const Color(0xCC1E293B) : const Color(0xF2FFFFFF),
      borderRadius: BorderRadius.circular(28),
      border: Border.all(
        color: aiPurple.withValues(alpha: isDark ? 0.35 : 0.25),
        width: 1.2,
      ),
      boxShadow: [
        BoxShadow(
          color: aiPurple.withValues(alpha: 0.12),
          blurRadius: 20,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  Widget _buildHeaderRow(
    GeneratedRecipe? recipe,
    bool isDark,
    Color aiPurple,
    Color emeraldAccent,
  ) {
    final categoryText = recipe != null
        ? '${recipe.category} • ${recipe.servings} Servings'
        : 'Smart Suggestion';
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxBadgeWidth = constraints.maxWidth;
        return Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxBadgeWidth),
              child: AiRecipeMatchBadge(
                match: recipe?.matchPercent ?? '',
                aiPurple: aiPurple,
                emeraldAccent: emeraldAccent,
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxBadgeWidth),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0x33334155) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : AppColors.border,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.restaurant_rounded,
                      size: 12,
                      color: secondaryTextColor,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        categoryText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTitleAndDescription(
    GeneratedRecipe? recipe,
    Color primaryTextColor,
    Color secondaryTextColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _titleText(recipe),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _subtitleText(recipe),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: secondaryTextColor,
            fontSize: 12,
            height: 1.35,
          ),
        ),
      ],
    );
  }

  String _titleText(GeneratedRecipe? recipe) {
    if (recipe != null) return recipe.title;
    final store = RecipeStore.instance;
    final waiting = store.suggestedLoading ||
        (!store.suggestedLoaded && store.suggestedError == null);
    return waiting ? 'Finding your top match…' : 'No recipe match yet';
  }

  String _subtitleText(GeneratedRecipe? recipe) {
    if (recipe != null) {
      final text = recipe.description.trim();
      return text.isEmpty || text == 'Delicious recipe.'
          ? '${recipe.category} meal ready in ${recipe.prepTime}'
          : text;
    }
    return RecipeStore.instance.suggestedLoading
        ? 'Checking ingredients available in your pantry...'
        : 'Add items to your pantry to get smart recipe suggestions';
  }
}
