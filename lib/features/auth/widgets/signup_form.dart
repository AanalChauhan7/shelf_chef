import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Clean Sign Up Form component for AuthScreen with Form Validation.
class SignupForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool acceptTerms;
  final ValueChanged<bool?> onAcceptTermsChanged;
  final VoidCallback onSubmit;

  const SignupForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.acceptTerms,
    required this.onAcceptTermsChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return KeyedSubtree(
      key: const ValueKey('signup_form'),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: 'Full Name',
              hint: 'Chef Alex',
              controller: nameController,
              prefixIcon: Icons.person_outline_rounded,
              validator: AppValidators.validateFullName,
            ),
            const SizedBox(height: AppSizes.p16),
            AppTextField(
              label: 'Email Address',
              hint: 'alex@kitchen.com',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.mail_outline_rounded,
              validator: AppValidators.validateEmail,
            ),
            const SizedBox(height: AppSizes.p16),
            AppTextField(
              label: 'Password',
              hint: 'Min 6 chars with 1 special char (e.g. @,#,\$)',
              controller: passwordController,
              isPassword: true,
              prefixIcon: Icons.lock_outline_rounded,
              validator: AppValidators.validatePassword,
            ),
            const SizedBox(height: AppSizes.p12),

            // Terms Checkbox
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: acceptTerms,
                    onChanged: onAcceptTermsChanged,
                    activeColor: isDark
                        ? AppColors.darkAccent
                        : AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.p8),
                Expanded(
                  child: Text(
                    'I agree to Terms of Service & Privacy Policy',
                    style: AppTextStyles.bodySmall(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.p20),
            AppButton(
              text: 'Create Account',
              icon: Icons.check_circle_outline_rounded,
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  if (!acceptTerms) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please accept Terms of Service & Privacy Policy to continue',
                        ),
                        backgroundColor: AppColors.dangerRed,
                      ),
                    );
                    return;
                  }
                  onSubmit();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
