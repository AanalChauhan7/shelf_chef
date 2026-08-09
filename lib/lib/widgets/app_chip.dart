import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import '../core/constants/app_text_styles.dart';

enum StatusBadgeType { fresh, expiringSoon, expired, lowStock, info, ai }

/// Custom category chip and status badge for ShelfChef AI app.
class AppChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? activeColor;

  const AppChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = activeColor ?? (isDark ? AppColors.darkAccent : AppColors.primaryGreen);

    final bg = isSelected
        ? primary
        : (isDark ? AppColors.darkCard : const Color(0xFFF3F4F6));

    final textColor = isSelected
        ? Colors.white
        : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary);

    final border = isSelected
        ? primary
        : (isDark ? AppColors.darkBorder : AppColors.border);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.p16,
            vertical: AppSizes.p8,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppSizes.radiusPill),
            border: Border.all(color: border, width: 1.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: AppSizes.iconSM,
                  color: textColor,
                ),
                const SizedBox(width: AppSizes.p4),
              ],
              Text(
                label,
                style: AppTextStyles.label(color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Status badge for food freshness, stock level, and alerts.
class StatusBadge extends StatelessWidget {
  final String label;
  final StatusBadgeType type;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    this.type = StatusBadgeType.fresh,
    this.icon,
  });

  /// Factory constructor for Expiring Soon badge
  factory StatusBadge.expiringSoon({String label = "Expiring Soon"}) {
    return StatusBadge(
      label: label,
      type: StatusBadgeType.expiringSoon,
      icon: Icons.access_time_rounded,
    );
  }

  /// Factory constructor for Expired badge
  factory StatusBadge.expired({String label = "Expired"}) {
    return StatusBadge(
      label: label,
      type: StatusBadgeType.expired,
      icon: Icons.error_outline_rounded,
    );
  }

  /// Factory constructor for Fresh badge
  factory StatusBadge.fresh({String label = "Fresh"}) {
    return StatusBadge(
      label: label,
      type: StatusBadgeType.fresh,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  /// Factory constructor for Low Stock badge
  factory StatusBadge.lowStock({String label = "Low Stock"}) {
    return StatusBadge(
      label: label,
      type: StatusBadgeType.lowStock,
      icon: Icons.warning_amber_rounded,
    );
  }

  /// Factory constructor for AI Sparkle badge
  factory StatusBadge.ai({required String label}) {
    return StatusBadge(
      label: label,
      type: StatusBadgeType.ai,
      icon: Icons.auto_awesome,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (type) {
      case StatusBadgeType.fresh:
        bg = AppColors.successBg;
        fg = AppColors.primaryGreen;
        break;
      case StatusBadgeType.expiringSoon:
        bg = AppColors.warningBg;
        fg = AppColors.warningOrange;
        break;
      case StatusBadgeType.expired:
        bg = AppColors.dangerBg;
        fg = AppColors.dangerRed;
        break;
      case StatusBadgeType.lowStock:
        bg = AppColors.warningBg;
        fg = AppColors.warningOrange;
        break;
      case StatusBadgeType.info:
        bg = const Color(0xFFEFF6FF);
        fg = const Color(0xFF3B82F6);
        break;
      case StatusBadgeType.ai:
        bg = AppColors.aiBg;
        fg = AppColors.aiPurple;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p12,
        vertical: AppSizes.p4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.caption(color: fg).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
