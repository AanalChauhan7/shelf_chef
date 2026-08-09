import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../auth/screens/get_started_screen.dart';
import '../widgets/onboarding_slide_card.dart';

/// A clean, simple, and elegant onboarding carousel under 170 lines.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlide> _slides = const [
    OnboardingSlide(
      title: 'Smart Pantry Management',
      description:
          'Keep track of your groceries, monitor expiration dates, and keep your kitchen perfectly organized.',
      imagePath: 'assets/images/onboarding_pantry.jpg',
    ),
    OnboardingSlide(
      title: 'AI Recipes & Cooking',
      description:
          'Discover delicious recipes tailored to the ingredients you already have in your pantry.',
      imagePath: 'assets/images/onboarding_recipe.jpg',
    ),
    OnboardingSlide(
      title: 'Grocery Budget & Savings',
      description:
          'Track your monthly spending, reduce food waste, and save money on your grocery bills.',
      imagePath: 'assets/images/onboarding_grocery.jpg',
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
        transitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
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
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar (Minimal Branding + Skip)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.p24,
                vertical: AppSizes.p12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.kitchen_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: AppSizes.p8),
                      Text(
                        'ShelfChef',
                        style: AppTextStyles.titleMedium(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ).copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: _navigateToGetStarted,
                    child: Text(
                      'Skip',
                      style: AppTextStyles.bodyMedium(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Carousel PageView
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
                  return OnboardingSlideCard(
                    slide: _slides[index],
                    isDark: isDark,
                  );
                },
              ),
            ),

            // Bottom Navigation Area (Indicators + Next Button)
            Padding(
              padding: const EdgeInsets.all(AppSizes.p24),
              child: Column(
                children: [
                  // Dot Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (index) {
                      final isActive = _currentPage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primaryGreen
                              : (isDark
                                    ? AppColors.darkBorder
                                    : const Color(0xFFCBD5E1)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: AppSizes.p24),

                  // Button
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
