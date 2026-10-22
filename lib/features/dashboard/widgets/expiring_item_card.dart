import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Data model for an expiring pantry item card.
class ExpiringItemData {
  final String name;
  final int daysLeft;
  final Color badgeColor;
  final String category;

  const ExpiringItemData({
    required this.name,
    required this.daysLeft,
    required this.badgeColor,
    required this.category,
  });
}

/// Compact card displaying single expiring pantry item.
class ExpiringItemCard extends StatelessWidget {
  final ExpiringItemData item;

  const ExpiringItemCard({super.key, required this.item});

  static IconData getCategoryIcon(String cat) {
    final lower = cat.toLowerCase();
    if (lower.contains('dairy') || lower.contains('milk')) {
      return Icons.local_drink_rounded;
    }
    if (lower.contains('fruit')) return Icons.apple_rounded;
    if (lower.contains('veg')) return Icons.eco_rounded;
    if (lower.contains('bakery') || lower.contains('bread')) {
      return Icons.bakery_dining_rounded;
    }
    if (lower.contains('meat') || lower.contains('protein')) {
      return Icons.restaurant_rounded;
    }
    return Icons.widgets_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final cardBgColor = isDark ? const Color(0xCC1E293B) : Colors.white;
    final borderColor =
        item.badgeColor.withValues(alpha: isDark ? 0.25 : 0.2);
    final progressRatio = (1.0 - (item.daysLeft / 15.0)).clamp(0.15, 1.0);
    final daysText = item.daysLeft == 0 ? 'Today' : '${item.daysLeft}d left';

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: item.badgeColor.withValues(alpha: isDark ? 0.12 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        getCategoryIcon(item.category),
                        size: 13,
                        color: secondaryTextColor,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          item.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: item.badgeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    daysText,
                    style: TextStyle(
                      color: item.badgeColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              item.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressRatio,
                minHeight: 4,
                backgroundColor: item.badgeColor.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(item.badgeColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
