import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Clean Log In Form component for AuthScreen.
class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;
  final VoidCallback onSubmit;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return KeyedSubtree(
      key: const ValueKey('login_form'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: 'Email or Username',
            hint: 'alex@kitchen.com',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.mail_outline_rounded,
          ),
          const SizedBox(height: AppSizes.p16),
          AppTextField(
            label: 'Password',
            hint: '••••••••',
            controller: passwordController,
            isPassword: true,
            prefixIcon: Icons.lock_outline_rounded,
          ),
          const SizedBox(height: AppSizes.p12),

          // Remember me & Forgot password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: rememberMe,
                      onChanged: onRememberMeChanged,
                      activeColor: isDark
                          ? AppColors.darkAccent
                          : AppColors.primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.p8),
                  Text(
                    'Remember me',
                    style: AppTextStyles.bodyMedium(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Forgot?',
                  style: AppTextStyles.bodyMedium(
                    color: isDark
                        ? AppColors.darkAccent
                        : AppColors.primaryGreen,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.p20),
          AppButton(
            text: 'Log In',
            icon: Icons.arrow_forward_rounded,
            onPressed: onSubmit,
          ),
        ],
      ),
    );
  }
}
