import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../../widgets/google_logo.dart';

/// Styled Google sign in button widget matching app theme.
class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isDark;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(26),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const GoogleLogo(size: 20),
            const SizedBox(width: 12),
            Text(
              'Continue with Google',
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : const Color(0xFF1F2937),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
