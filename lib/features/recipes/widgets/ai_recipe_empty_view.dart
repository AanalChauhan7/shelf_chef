import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Premium glassmorphic empty state view for AI Recipe Hub tab.
class AiRecipeEmptyView extends StatelessWidget {
  final VoidCallback onGenerateRecipes;
  final VoidCallback onAddPantryItems;

  const AiRecipeEmptyView({
    super.key,
    required this.onGenerateRecipes,
    required this.onAddPantryItems,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final aiPurple = isDark ? AppColors.darkAiPurple : AppColors.aiPurple;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAiGlassIllustration(isDark, aiPurple),
              const SizedBox(height: 24),
              Text(
                'No Recipe Suggestions Yet',
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Add at least 3 items to your pantry so Chef AI can generate personalized zero-waste recipes tailored to your dietary preferences.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium(
                    color: secondaryTextColor,
                  ).copyWith(height: 1.4),
                ),
              ),
              const SizedBox(height: 32),
              _buildActionButtons(aiPurple),
            ],
          ),
        ),
      ),
    );
  }

  // --- Private Sub-Widgets Defined Below Build Function ---

  Widget _buildAiGlassIllustration(bool isDark, Color aiPurple) {
    final cardBg = isDark ? const Color(0xCC1E293B) : const Color(0xF2FFFFFF);

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: cardBg,
            shape: BoxShape.circle,
            border: Border.all(
              color: aiPurple.withValues(alpha: 0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: aiPurple.withValues(alpha: 0.25),
                blurRadius: 28,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Center(
            child: Icon(Icons.auto_awesome_rounded, size: 58, color: aiPurple),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(Color aiPurple) {
    return Column(
      children: [
        AppButton.ai(
          text: 'Generate AI Recipes Now',
          onPressed: onGenerateRecipes,
        ),
        const SizedBox(height: 12),
        AppButton.secondary(
          text: '+ Add Pantry Ingredients',
          onPressed: onAddPantryItems,
        ),
      ],
    );
  }
}
