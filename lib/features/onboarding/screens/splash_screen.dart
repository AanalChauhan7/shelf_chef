import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import 'onboarding_screen.dart';

/// Animated Splash Screen for ShelfChef AI branding.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    // Auto navigate after 2.5 seconds
    _navigationTimer = Timer(const Duration(milliseconds: 2500), () {
      _navigateToOnboarding();
    });
  }

  void _navigateToOnboarding() {
    if (!mounted) return;
    _navigationTimer?.cancel();

    final currentUser = AuthService.currentUser;
    Widget destinationScreen;

    if (currentUser != null) {
      final name = currentUser.displayName?.isNotEmpty == true
          ? currentUser.displayName!
          : (currentUser.email?.contains('@') == true
                ? currentUser.email!.split('@').first
                : 'Chef User');
      destinationScreen = DashboardScreen(
        userName: name,
        showSetupOnLaunch: false,
      );
    } else {
      destinationScreen = const OnboardingScreen();
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            destinationScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: GestureDetector(
        onTap: _navigateToOnboarding,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBackground : AppColors.background,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glowing background organic blob circle
              Positioned(
                top: MediaQuery.of(context).size.height * 0.25,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.secondaryGreen.withValues(
                          alpha: isDark ? 0.15 : 0.2,
                        ),
                        AppColors.primaryGreen.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),

              // Main Branding Content
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: AppGradients.primaryGradient,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: AppShadows.primaryGlow,
                        ),
                        child: const Icon(
                          Icons.restaurant_menu_rounded,
                          size: 52,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.p24),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'ShelfChef AI',
                      style: AppTextStyles.displayLarge(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.p8),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Smart Pantry & AI Cooking Companion',
                      style: AppTextStyles.bodyMedium(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),

              // Bottom Loading / Tap hint
              Positioned(
                bottom: AppSizes.p48,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryGreen,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.p16),
                      Text(
                        'Tap anywhere to skip',
                        style: AppTextStyles.caption(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
