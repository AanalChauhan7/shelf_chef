import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../auth/screens/get_started_screen.dart';

class OnboardingItem {
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;

  const OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
  });
}

/// Onboarding Carousel screen with 3 slides and Skip navigation.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _slides = const [
    OnboardingItem(
      title: 'Smart Pantry Management',
      description:
          'Keep track of groceries, expiry dates, and categories. Never let food go to waste unnoticed.',
      icon: Icons.inventory_2_rounded,
      accentColor: AppColors.primaryGreen,
    ),
    OnboardingItem(
      title: 'AI Recipes & Cooking Mode',
      description:
          'Generate delicious recipes based on available ingredients, select serving size, and listen to step-by-step voice guidance.',
      icon: Icons.auto_awesome_rounded,
      accentColor: AppColors.aiPurple,
    ),
    OnboardingItem(
      title: 'Grocery Budget & Analytics',
      description:
          'Set a monthly spending limit, track expense graphs, and get cheaper alternative product suggestions when budget exceeds.',
      icon: Icons.account_balance_wallet_rounded,
      accentColor: AppColors.secondaryGreen,
    ),
  ];

  void _navigateToGetStarted() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const GetStartedScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToGetStarted();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar (Skip Button)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.p20,
                vertical: AppSizes.p12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSizes.p8),
                      Text(
                        'ShelfChef AI',
                        style: AppTextStyles.titleMedium(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: _navigateToGetStarted,
                    child: Text(
                      'Skip',
                      style: AppTextStyles.buttonMedium(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Onboarding PageView Carousel
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.p24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Eco-Glass Icon Container
                        GlassContainer(
                          borderRadius: AppSizes.radiusXL,
                          padding: const EdgeInsets.all(AppSizes.p32),
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: item.accentColor.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item.icon,
                              size: 64,
                              color: item.accentColor,
                            ),
                          ),
                        ),

                        const SizedBox(height: AppSizes.p40),

                        // Title
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headingLarge(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),

                        const SizedBox(height: AppSizes.p16),

                        // Description
                        Text(
                          item.description,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyLarge(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation Area (Indicators + Next Button)
            Padding(
              padding: const EdgeInsets.all(AppSizes.p24),
              child: Column(
                children: [
                  // Eco-Glass Dot Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (index) {
                      final isActive = _currentPage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 28 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primaryGreen
                              : (isDark
                                  ? AppColors.darkBorder
                                  : AppColors.border),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: AppSizes.p24),

                  // Next / Get Started Button
                  _currentPage == _slides.length - 1
                      ? AppButton(
                          text: 'Get Started',
                          icon: Icons.arrow_forward_rounded,
                          onPressed: _navigateToGetStarted,
                        )
                      : AppButton(
                          text: 'Next',
                          icon: Icons.chevron_right_rounded,
                          onPressed: _nextPage,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
