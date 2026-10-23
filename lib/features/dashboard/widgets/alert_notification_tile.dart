import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Clean, glassmorphic tile for individual alerts and notifications.
class AlertNotificationTile extends StatelessWidget {
  final AppNotificationItem item;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const AlertNotificationTile({
    super.key,
    required this.item,
    required this.isDark,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final itemBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final primaryTextColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    Color iconColor;
    IconData icon;
    switch (item.type) {
      case AppNotificationType.expiringSoon:
        iconColor = AppColors.dangerRed;
        icon = Icons.alarm_on_rounded;
        break;
      case AppNotificationType.lowStock:
        iconColor = AppColors.warningOrange;
        icon = Icons.production_quantity_limits_rounded;
        break;
      case AppNotificationType.itemAdded:
        iconColor = AppColors.secondaryGreen;
        icon = Icons.add_shopping_cart_rounded;
        break;
      case AppNotificationType.general:
        iconColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;
        icon = Icons.info_outline_rounded;
        break;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: itemBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? (item.isRead
                    ? Colors.white.withValues(alpha: 0.08)
                    : iconColor.withValues(alpha: 0.35))
                : (item.isRead
                    ? AppColors.border
                    : iconColor.withValues(alpha: 0.35)),
            width: item.isRead ? 1 : 1.3,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.timeAgo,
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.message,
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 11.5,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: onDelete,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.04),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 14,
                  color: secondaryTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
