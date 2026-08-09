import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import 'auth_screen.dart';

/// Clean Get Started / Welcome Screen linking to AuthScreen.
class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  void _navigateToAuth(BuildContext context, int tabIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AuthScreen(initialTabIndex: tabIndex),
      ),
    );
  }

  void _navigateToDashboard(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const DashboardScreen(userName: 'Aanal'),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppSizes.p24),
          child: Column(
            children: [
              const SizedBox(height: AppSizes.p12),
              _buildHeroImageCard(isDark),
              const SizedBox(height: AppSizes.p28),
              _buildWelcomeHeadlineText(isDark),
              const SizedBox(height: AppSizes.p32),
              _buildLoginActionButton(context),
              const SizedBox(height: AppSizes.p12),
              _buildCreateAccountActionButton(context),
              const SizedBox(height: AppSizes.p16),
              _buildContinueAsGuestButton(context, isDark),
            ],
          ),
        ),
      ),
    );
  }

  // --- Private Sub-Widgets Defined Below Build Function ---

  Widget _buildHeroImageCard(bool isDark) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          'assets/images/onboarding_pantry.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildWelcomeHeadlineText(bool isDark) {
    return Column(
      children: [
        Text(
          'Welcome to ShelfChef',
          textAlign: TextAlign.center,
          style: AppTextStyles.headingLarge(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSizes.p12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p12),
          child: Text(
            'Manage your pantry effortlessly, keep track of expiration dates, and cook smart recipes with AI.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginActionButton(BuildContext context) {
    return AppButton(
      text: 'Log In',
      icon: Icons.login_rounded,
      onPressed: () => _navigateToAuth(context, 0),
    );
  }

  Widget _buildCreateAccountActionButton(BuildContext context) {
    return AppButton.secondary(
      text: 'Create Account',
      icon: Icons.person_add_outlined,
      onPressed: () => _navigateToAuth(context, 1),
    );
  }

  Widget _buildContinueAsGuestButton(BuildContext context, bool isDark) {
    return TextButton(
      onPressed: () => _navigateToDashboard(context),
      child: Text(
        'Continue as Guest',
        style: AppTextStyles.bodyMedium(
          color: isDark ? AppColors.darkAccent : AppColors.primaryGreen,
        ).copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
