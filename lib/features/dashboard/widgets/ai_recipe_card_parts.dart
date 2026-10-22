import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../recipes/models/generated_recipe.dart';

/// Rounded food preview on the home AI recipe card (recipe photo, falling
/// back to the bundled onboarding image).
class AiRecipePreviewImage extends StatelessWidget {
  final GeneratedRecipe? recipe;
  final Color aiPurple;

  const AiRecipePreviewImage({
    super.key,
    required this.recipe,
    required this.aiPurple,
  });

  @override
  Widget build(BuildContext context) {
    final fallback = Image.asset(
      'assets/images/onboarding_recipe.jpg',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: aiPurple.withValues(alpha: 0.2),
        child: const Center(child: Text('🍝', style: TextStyle(fontSize: 32))),
      ),
    );
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: aiPurple.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: recipe == null
            ? fallback
            : Image.network(
                recipe!.displayImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => fallback,
              ),
      ),
    );
  }
}

/// "AI RECIPE • 98% MATCH" pill.
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
              match.isEmpty ? 'AI RECIPE' : 'AI RECIPE • $match MATCH',
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

/// Small tinted info chip ("⏱️ 30 mins", "👨‍🍳 Easy Prep", ...).
class AiRecipeInfoBadge extends StatelessWidget {
  final String label;
  final Color color;

  const AiRecipeInfoBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
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
            color: AppColors.secondaryGreen.withValues(alpha: 0.45),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Start Cooking Mode',
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
    );
  }
}
