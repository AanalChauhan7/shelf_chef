import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Clean Sign Up Form component for AuthScreen with Form Validation & Enter key submission.
class SignupForm extends StatefulWidget {
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
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (widget.formKey.currentState?.validate() ?? false) {
      if (!widget.acceptTerms) {
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
      widget.onSubmit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return KeyedSubtree(
      key: const ValueKey('signup_form'),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: 'Full Name',
              hint: 'Chef Alex',
              controller: widget.nameController,
              prefixIcon: Icons.person_outline_rounded,
              validator: AppValidators.validateFullName,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_emailFocusNode);
              },
            ),
            const SizedBox(height: AppSizes.p16),
            AppTextField(
              label: 'Email Address',
              hint: 'alex@kitchen.com',
              controller: widget.emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.mail_outline_rounded,
              validator: AppValidators.validateEmail,
              focusNode: _emailFocusNode,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
            ),
            const SizedBox(height: AppSizes.p16),
            AppTextField(
              label: 'Password',
              hint: 'Min 6 chars with 1 special char (e.g. @,#,\$)',
              controller: widget.passwordController,
              isPassword: true,
              prefixIcon: Icons.lock_outline_rounded,
              validator: AppValidators.validatePassword,
              focusNode: _passwordFocusNode,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submitForm(),
            ),
            const SizedBox(height: AppSizes.p12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: widget.acceptTerms,
                    onChanged: widget.onAcceptTermsChanged,
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
              onPressed: _submitForm,
            ),
          ],
        ),
      ),
    );
  }
}
