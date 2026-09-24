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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xCC1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: activeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: activeColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Icon(categoryIcon, size: 20, color: activeColor),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            item.displayQty,
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            ' • ',
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 13,
                            ),
                          ),
                          Icon(locationIcon, size: 12, color: secondaryColor),
                          const SizedBox(width: 3),
                          Text(
                            item.storageLocation.toUpperCase(),
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 12, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusLabel,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Freshness Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: freshnessProgress,
                minHeight: 4,
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
        return Icons.apple_rounded;
      case 'Grains & Pulses':
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
