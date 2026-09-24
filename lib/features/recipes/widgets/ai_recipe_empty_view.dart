import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Glassmorphic empty state view for AI Recipe tab with custom visual illustration.
class AiRecipeEmptyView extends StatelessWidget {
  final VoidCallback onGenerateRecipes;

  const AiRecipeEmptyView({super.key, required this.onGenerateRecipes});

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
                'No Recipes Generated Yet',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Your AI recipe book is currently empty. Tap below to generate custom Gujarati, Indian, or Global recipes from your pantry items!',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium(
                    color: secondaryTextColor,
                  ).copyWith(height: 1.4),
                ),
              ),
              const SizedBox(height: 32),
              AppButton.ai(
                text: '⚡ Create Recipe with Chef AI',
                onPressed: onGenerateRecipes,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAiGlassIllustration(bool isDark, Color aiPurple) {
    final cardBg = isDark ? const Color(0xCC1E293B) : const Color(0xF2FFFFFF);
    final emeraldAccent = isDark
        ? AppColors.darkAccent
        : AppColors.primaryGreen;

    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: aiPurple.withValues(alpha: 0.35),
                  blurRadius: 30,
                  spreadRadius: 4,
                ),
                BoxShadow(
                  color: emeraldAccent.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                width: 130,
                height: 130,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: aiPurple.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/onboarding_recipe.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: aiPurple.withValues(alpha: 0.15),
                          child: Center(
                            child: Icon(
                              Icons.restaurant_menu_rounded,
                              size: 48,
                              color: aiPurple,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.45),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [aiPurple, aiPurple.withValues(alpha: 0.8)],
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: aiPurple.withValues(alpha: 0.4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
