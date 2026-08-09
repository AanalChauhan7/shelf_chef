import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_gradients.dart';
import '../core/constants/app_shadows.dart';
import '../core/constants/app_sizes.dart';
import '../core/constants/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, ai, danger, outline }

/// Custom unified button widget for ShelfChef AI app.
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double height;
  final double borderRadius;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height = AppSizes.buttonHeightMd,
    this.borderRadius = AppSizes.radiusMD,
  });

  /// Factory constructor for AI Sparkle actions
  factory AppButton.ai({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon = Icons.auto_awesome,
    bool isLoading = false,
    bool isFullWidth = true,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.ai,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
    );
  }

  /// Factory constructor for Secondary button
  factory AppButton.secondary({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = true,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.secondary,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
    );
  }

  /// Factory constructor for Danger/Delete button
  factory AppButton.danger({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = true,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.danger,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    BoxDecoration decoration;
    TextStyle textStyle;
    Color iconColor;

    switch (variant) {
      case AppButtonVariant.primary:
        decoration = BoxDecoration(
          gradient: AppGradients.primaryGradient,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: onPressed != null ? AppShadows.primaryGlow : null,
        );
        textStyle = AppTextStyles.buttonLarge(color: Colors.white);
        iconColor = Colors.white;
        break;

      case AppButtonVariant.ai:
        decoration = BoxDecoration(
          gradient: AppGradients.aiGradient,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: onPressed != null ? AppShadows.aiGlow : null,
        );
        textStyle = AppTextStyles.buttonLarge(color: Colors.white);
        iconColor = Colors.white;
        break;

      case AppButtonVariant.secondary:
        decoration = BoxDecoration(
          color: isDark ? AppColors.darkCard : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        );
        textStyle = AppTextStyles.buttonLarge(
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        );
        iconColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
        break;

      case AppButtonVariant.danger:
        decoration = BoxDecoration(
          color: AppColors.dangerRed,
          borderRadius: BorderRadius.circular(borderRadius),
        );
        textStyle = AppTextStyles.buttonLarge(color: Colors.white);
        iconColor = Colors.white;
        break;

      case AppButtonVariant.outline:
        decoration = BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isDark ? AppColors.darkAccent : AppColors.primaryGreen,
            width: 1.5,
          ),
        );
        textStyle = AppTextStyles.buttonLarge(
          color: isDark ? AppColors.darkAccent : AppColors.primaryGreen,
        );
        iconColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;
        break;
    }

    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(iconColor),
            ),
          ),
          const SizedBox(width: AppSizes.p12),
        ] else if (icon != null) ...[
          Icon(icon, size: AppSizes.iconSM, color: iconColor),
          const SizedBox(width: AppSizes.p8),
        ],
        Text(text, style: textStyle),
      ],
    );

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: onPressed == null ? 0.5 : 1.0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p20),
            decoration: decoration,
            alignment: Alignment.center,
            child: content,
          ),
        ),
      ),
    );
  }
}
