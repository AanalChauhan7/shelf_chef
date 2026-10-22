import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../../core/services/recipe_store.dart';
import '../../recipes/models/generated_recipe.dart';
import 'ai_recipe_card_parts.dart';

/// Premium, futuristic AI Recipe Suggestion Card with high-end food preview,
/// glowing purple/emerald accents, responsive wrapping, and zero overflow errors.
///
/// Shows one of the top-3 suggested recipes from [RecipeStore]. It never fetches on its
/// own after the first load: new suggestions only arrive when the user taps
/// reload on the Recipes tab.
class AiRecipeCard extends StatelessWidget {
  /// Opens the "Generate AI Recipe" page.
  final VoidCallback onStartCooking;

  const AiRecipeCard({super.key, required this.onStartCooking});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final aiPurple = isDark ? AppColors.darkAiPurple : AppColors.aiPurple;
    final emeraldAccent =
        isDark ? AppColors.darkAccent : AppColors.primaryGreen;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: _cardDecoration(isDark, aiPurple),
          child: ListenableBuilder(
            listenable: RecipeStore.instance,
            builder: (context, _) {
              final recipe = RecipeStore.instance.featured;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(recipe, isDark, aiPurple, emeraldAccent),
                  const SizedBox(height: 16),
                  _buildBadgesSection(recipe, aiPurple, emeraldAccent),
                  const SizedBox(height: 18),
                  AiRecipeCookButton(
                    onPressed: onStartCooking,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // --- Private Sub-Widgets Defined Below Build Function ---

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
          color: aiPurple.withValues(alpha: 0.15),
          blurRadius: 20,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  Widget _buildHeaderSection(
    GeneratedRecipe? recipe,
    bool isDark,
    Color aiPurple,
    Color emeraldAccent,
  ) {
    final primaryTextColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AiRecipePreviewImage(recipe: recipe, aiPurple: aiPurple),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AiRecipeMatchBadge(
                match: recipe?.matchPercent ?? '',
                aiPurple: aiPurple,
                emeraldAccent: emeraldAccent,
              ),
              const SizedBox(height: 6),
              Text(
                _titleText(recipe),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _subtitleText(recipe),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall(color: secondaryTextColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadgesSection(
    GeneratedRecipe? recipe,
    Color aiPurple,
    Color emeraldAccent,
  ) {
    if (recipe == null) return const SizedBox.shrink();
    final pantryCount = recipe.availableIngredients.length;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        AiRecipeInfoBadge(label: '⏱️ ${recipe.prepTime}', color: aiPurple),
        AiRecipeInfoBadge(
          label: '👨‍🍳 ${recipe.difficulty} Prep',
          color: emeraldAccent,
        ),
        if (pantryCount > 0)
          AiRecipeInfoBadge(
            label: '♻️ Uses $pantryCount Pantry Items',
            color: AppColors.warningOrange,
          ),
      ],
    );
  }

  // --- Text helpers ---

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
      // Skip the model's "Delicious recipe." placeholder.
      return text.isEmpty || text == 'Delicious recipe.'
          ? '${recipe.category} • ${recipe.calories}'
          : text;
    }
    return RecipeStore.instance.suggestedLoading
        ? 'Checking what is in your pantry'
        : 'Add pantry items to get suggestions';
  }
}
