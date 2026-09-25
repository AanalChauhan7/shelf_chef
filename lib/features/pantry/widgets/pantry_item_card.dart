import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../models/pantry_item.dart';

/// Executive-grade glassmorphic pantry item card widget with freshness indicator bar.
class PantryItemCard extends StatelessWidget {
  final PantryItem item;
  final bool isDark;
  final VoidCallback? onTap;

  const PantryItemCard({
    super.key,
    required this.item,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final secondaryColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;

    Color statusBg = AppColors.secondaryGreen.withValues(alpha: 0.15);
    Color statusColor = AppColors.secondaryGreen;
    IconData statusIcon = Icons.check_circle_outline_rounded;
    String statusLabel = 'Fresh (${item.daysUntilExpiry}d)';
    double freshnessProgress = 0.85;

    if (item.daysUntilExpiry <= 3 && item.daysUntilExpiry >= 0) {
      statusBg = AppColors.warningOrange.withValues(alpha: 0.15);
      statusColor = AppColors.warningOrange;
      statusIcon = Icons.access_time_rounded;
      statusLabel = 'Expiring (${item.daysUntilExpiry}d)';
      freshnessProgress = 0.35;
    } else if (item.daysUntilExpiry < 0) {
      statusBg = AppColors.dangerRed.withValues(alpha: 0.15);
      statusColor = AppColors.dangerRed;
      statusIcon = Icons.error_outline_rounded;
      statusLabel = 'Expired';
      freshnessProgress = 0.05;
    }

    final categoryIcon = _getCategoryIcon(item.category);
    final locationIcon = _getLocationIcon(item.storageLocation);

    final String qtyAndPriceText = item.estimatedPrice != null && item.estimatedPrice! > 0
        ? '${item.displayQty} • ₹${item.estimatedPrice!.toStringAsFixed(0)}'
        : item.displayQty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xCC1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: activeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: activeColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Icon(categoryIcon, size: 18, color: activeColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              qtyAndPriceText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(locationIcon, size: 11, color: secondaryColor),
                          const SizedBox(width: 2),
                          Text(
                            item.storageLocation.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 11, color: statusColor),
                      const SizedBox(width: 3),
                      Text(
                        statusLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: freshnessProgress,
                minHeight: 3,
                backgroundColor: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : const Color(0xFFE2E8F0),
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Dairy':
        return Icons.local_drink_rounded;
      case 'Vegetables':
        return Icons.eco_rounded;
      case 'Fruits':
      case 'Fruit':
        return Icons.apple_rounded;
      case 'Grains & Pulses':
      case 'Grains':
        return Icons.grain_rounded;
      case 'Spices':
        return Icons.local_fire_department_rounded;
      case 'Snacks':
        return Icons.fastfood_rounded;
      default:
        return Icons.inventory_2_rounded;
    }
  }

  static IconData _getLocationIcon(String location) {
    if (location.toLowerCase().contains('fridge')) {
      return Icons.kitchen_rounded;
    } else if (location.toLowerCase().contains('freezer')) {
      return Icons.ac_unit_rounded;
    }
    return Icons.inventory_2_rounded;
  }
}
