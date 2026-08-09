import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Get Started / Welcome Screen for choosing Login, Signup, or Guest setup.
class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.p24),
          child: Column(
            children: [
              const Spacer(),

              // Hero Glass Card
              GlassContainer(
                borderRadius: AppSizes.radiusXL,
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: AppGradients.primaryGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: AppShadows.primaryGlow,
                      ),
                      child: const Icon(
                        Icons.kitchen_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: AppSizes.p24),
                    Text(
                      'Welcome to\nShelfChef AI',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headingLarge(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.p12),
                    Text(
                      'Manage your pantry effortlessly, scan bills, reduce food waste, and get instant AI recipe ideas.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Action Buttons
              AppButton(
                text: 'Create Account',
                icon: Icons.person_add_outlined,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Signup coming next!')),
                  );
                },
              ),

              const SizedBox(height: AppSizes.p12),

              AppButton.secondary(
                text: 'Log In',
                icon: Icons.login_rounded,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login coming next!')),
                  );
                },
              ),

              const SizedBox(height: AppSizes.p16),

              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Entering as Guest...')),
                  );
                },
                child: Text(
                  'Continue as Guest',
                  style: AppTextStyles.label(
                    color: isDark ? AppColors.darkAccent : AppColors.primaryGreen,
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.p16),
            ],
          ),
        ),
      ),
    );
  }
}
