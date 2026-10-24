import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../recipes/models/generated_recipe.dart';
export 'ai_recipe_metrics.dart';

/// "AI RECIPE • 98% MATCH" pill badge.
class AiRecipeMatchBadge extends StatelessWidget {
  final String match;
  final Color aiPurple;
  final Color emeraldAccent;

  const AiRecipeMatchBadge({
    super.key,
    required this.match,
    required this.aiPurple,
    required this.emeraldAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            aiPurple.withValues(alpha: 0.2),
            emeraldAccent.withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: aiPurple.withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome, size: 13, color: aiPurple),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              match.isEmpty ? 'AI CHEF PICK' : 'AI CHEF PICK • $match MATCH',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: aiPurple,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Horizontal chips preview showing which pantry ingredients are ready to use.
class AiRecipeIngredientsRow extends StatelessWidget {
  final GeneratedRecipe recipe;
  final bool isDark;
  final Color emeraldAccent;

  const AiRecipeIngredientsRow({
    super.key,
    required this.recipe,
    required this.isDark,
    required this.emeraldAccent,
  });

  @override
  Widget build(BuildContext context) {
    final available = recipe.availableIngredients;
    if (available.isEmpty) return const SizedBox.shrink();

    final shown = available.take(3).toList();
    final remainingCount = available.length - shown.length;
    final secondaryText =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Row(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 100),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.inventory_2_outlined, size: 13, color: emeraldAccent),
                const SizedBox(width: 5),
                Text(
                  'In Pantry:',
                  maxLines: 1,
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                ...shown.map(
                  (ing) => Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: emeraldAccent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: emeraldAccent.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_rounded, size: 11, color: emeraldAccent),
                        const SizedBox(width: 3),
                        Text(
                          ing.name,
                          style: TextStyle(
                            color: emeraldAccent,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (remainingCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0x33334155)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '+$remainingCount more',
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Full-width gradient "Start Cooking Mode" button.
class AiRecipeCookButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AiRecipeCookButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        gradient: AppGradients.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryGreen.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Start Cooking Mode',
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
