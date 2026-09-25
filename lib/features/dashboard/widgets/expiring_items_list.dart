import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../pantry/models/pantry_item.dart';

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

/// Horizontal list of Expiring Soon items (expiring within 5 days).
class ExpiringItemsList extends StatelessWidget {
  final VoidCallback? onViewAll;
  final List<PantryItem>? liveItems;

  const ExpiringItemsList({super.key, this.onViewAll, this.liveItems});

  List<ExpiringItemData> _getDisplayItems() {
    if (liveItems != null && liveItems!.isNotEmpty) {
      final sorted = List<PantryItem>.from(liveItems!)
        ..sort((a, b) => a.daysUntilExpiry.compareTo(b.daysUntilExpiry));

      final filtered = sorted.where((item) => item.daysUntilExpiry >= 0 && item.daysUntilExpiry <= 5).toList();

      if (filtered.isNotEmpty) {
        return filtered.map((item) {
          final days = item.daysUntilExpiry;
          final color = days <= 2 ? AppColors.dangerRed : AppColors.warningOrange;
          return ExpiringItemData(
            name: item.name,
            daysLeft: days,
            badgeColor: color,
            category: item.category.isEmpty ? 'Pantry' : item.category,
          );
        }).toList();
      }
    }

    return const [
      ExpiringItemData(name: 'Greek Plain Yogurt', daysLeft: 2, badgeColor: AppColors.dangerRed, category: 'Dairy'),
      ExpiringItemData(name: 'Fresh Strawberries', daysLeft: 3, badgeColor: AppColors.warningOrange, category: 'Fruit'),
      ExpiringItemData(name: 'Artisan Wheat Bread', daysLeft: 4, badgeColor: AppColors.warningOrange, category: 'Bakery'),
      ExpiringItemData(name: 'Amul Taaza Milk', daysLeft: 5, badgeColor: Color(0xFFF59E0B), category: 'Dairy'),
    ];
  }

  IconData _getCategoryIcon(String cat) {
    final lower = cat.toLowerCase();
    if (lower.contains('dairy') || lower.contains('milk')) return Icons.local_drink_rounded;
    if (lower.contains('fruit')) return Icons.apple_rounded;
    if (lower.contains('veg')) return Icons.eco_rounded;
    if (lower.contains('bakery') || lower.contains('bread')) return Icons.bakery_dining_rounded;
    if (lower.contains('meat') || lower.contains('protein')) return Icons.restaurant_rounded;
    return Icons.widgets_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;
    final displayItems = _getDisplayItems();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.dangerRed.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.timer_outlined, size: 16, color: AppColors.dangerRed),
                ),
                const SizedBox(width: 8),
                Text('Expiring Soon', style: AppTextStyles.headingSmall(color: primaryTextColor)),
              ],
            ),
            TextButton(
              onPressed: onViewAll,
              child: Text(
                'View All →',
                style: TextStyle(color: activeColor, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 124,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: displayItems.length,
            separatorBuilder: (_, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) => _buildExpiringCard(context, displayItems[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildExpiringCard(BuildContext context, ExpiringItemData item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryTextColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final cardBgColor = isDark ? const Color(0xCC1E293B) : Colors.white;
    final borderColor = item.badgeColor.withValues(alpha: isDark ? 0.25 : 0.2);
    final progressRatio = (1.0 - (item.daysLeft / 5.0)).clamp(0.15, 1.0);

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
                      Icon(_getCategoryIcon(item.category), size: 13, color: secondaryTextColor),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          item.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: secondaryTextColor, fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: item.badgeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${item.daysLeft}d left',
                    style: TextStyle(color: item.badgeColor, fontSize: 10, fontWeight: FontWeight.w800),
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
