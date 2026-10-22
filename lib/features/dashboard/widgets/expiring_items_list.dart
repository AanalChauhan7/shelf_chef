import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../pantry/models/pantry_item.dart';
import 'expiring_item_card.dart';

/// Horizontal list of Expiring Soon items (expiring within 1 week / 7 days).
class ExpiringItemsList extends StatelessWidget {
  final VoidCallback? onViewAll;
  final List<PantryItem>? liveItems;

  const ExpiringItemsList({super.key, this.onViewAll, this.liveItems});

  List<ExpiringItemData> _getDisplayItems() {
    if (liveItems == null || liveItems!.isEmpty) {
      return [];
    }

    final sorted = List<PantryItem>.from(liveItems!)
      ..sort((a, b) => a.daysUntilExpiry.compareTo(b.daysUntilExpiry));

    // Span of 15 days (0 to 15 days)
    final filtered = sorted
        .where((item) => item.daysUntilExpiry >= 0 && item.daysUntilExpiry <= 15)
        .toList();

    return filtered.map((item) {
      final days = item.daysUntilExpiry;
      final color = days <= 3
          ? AppColors.dangerRed
          : (days <= 7 ? AppColors.warningOrange : const Color(0xFFF59E0B));
      return ExpiringItemData(
        name: item.name,
        daysLeft: days,
        badgeColor: color,
        category: item.category.isEmpty ? 'Pantry' : item.category,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
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
                  child: const Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: AppColors.dangerRed,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Expiring Soon',
                  style: AppTextStyles.headingSmall(color: primaryTextColor),
                ),
              ],
            ),
            TextButton(
              onPressed: onViewAll,
              child: Text(
                'View All →',
                style: TextStyle(
                  color: activeColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (displayItems.isEmpty)
          _buildEmptyPlaceholder(
            isDark,
            primaryTextColor,
            secondaryTextColor,
            activeColor,
          )
        else
          SizedBox(
            height: 124,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: displayItems.length,
              separatorBuilder: (_, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) =>
                  ExpiringItemCard(item: displayItems[index]),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyPlaceholder(
    bool isDark,
    Color primaryTextColor,
    Color secondaryTextColor,
    Color activeColor,
  ) {
    final cardBgColor = isDark ? const Color(0xCC1E293B) : Colors.white;
    final borderColor =
        isDark ? Colors.white.withValues(alpha: 0.08) : AppColors.border;

    return Container(
      width: double.infinity,
      height: 105,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: activeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.eco_rounded, color: activeColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No items expiring soon',
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'All your pantry items are fresh for the next 15 days!',
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
