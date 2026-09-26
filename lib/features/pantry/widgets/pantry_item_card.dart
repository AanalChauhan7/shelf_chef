import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../models/pantry_item.dart';

/// State-of-the-art glassmorphic pantry item card widget with freshness indicator.
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
    final primaryColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;

    Color statusBg = AppColors.secondaryGreen.withValues(alpha: 0.15);
    Color statusColor = AppColors.secondaryGreen;
    IconData statusIcon = Icons.check_circle_outline_rounded;
    String statusLabel = '${item.daysUntilExpiry}d left';
    double freshnessProgress = (item.daysUntilExpiry / 14.0).clamp(0.08, 1.0);

    if (item.daysUntilExpiry <= 3 && item.daysUntilExpiry >= 0) {
      statusBg = AppColors.warningOrange.withValues(alpha: 0.15);
      statusColor = AppColors.warningOrange;
      statusIcon = Icons.access_time_rounded;
      statusLabel = '${item.daysUntilExpiry}d left';
    } else if (item.daysUntilExpiry < 0) {
      statusBg = AppColors.dangerRed.withValues(alpha: 0.15);
      statusColor = AppColors.dangerRed;
      statusIcon = Icons.error_outline_rounded;
      statusLabel = 'Expired';
      freshnessProgress = 0.05;
    }

    final categoryIcon = _getCategoryIcon(item.category);
    final isFridge = item.storageLocation.toLowerCase().contains('fridge') ||
        item.storageLocation.toLowerCase().contains('refrigerator');

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xCC1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: statusColor.withValues(alpha: isDark ? 0.25 : 0.18), width: 1.2),
        boxShadow: [BoxShadow(color: statusColor.withValues(alpha: isDark ? 0.08 : 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: activeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: activeColor.withValues(alpha: 0.25)),
                      ),
                      child: Icon(categoryIcon, size: 20, color: activeColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: -0.2)),
                              ),
                              if (item.brand.isNotEmpty) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                                  child: Text(item.brand, style: TextStyle(color: secondaryColor, fontSize: 9.5, fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(item.displayQty, style: TextStyle(color: secondaryColor, fontSize: 12, fontWeight: FontWeight.w600)),
                              if (item.estimatedPrice != null && item.estimatedPrice! > 0) ...[
                                Text(' • ', style: TextStyle(color: secondaryColor, fontSize: 12)),
                                Text('₹${item.estimatedPrice!.toStringAsFixed(item.estimatedPrice! % 1 == 0 ? 0 : 2)}', style: TextStyle(color: activeColor, fontSize: 12, fontWeight: FontWeight.w700)),
                              ],
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: (isFridge ? activeColor : AppColors.warningOrange).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(isFridge ? Icons.kitchen_rounded : Icons.inventory_2_rounded, size: 10, color: isFridge ? activeColor : AppColors.warningOrange),
                                    const SizedBox(width: 2),
                                    Text(item.storageLocation, style: TextStyle(color: isFridge ? activeColor : AppColors.warningOrange, fontSize: 9, fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: statusColor.withValues(alpha: 0.3))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, size: 12, color: statusColor),
                          const SizedBox(width: 3),
                          Text(statusLabel, style: TextStyle(color: statusColor, fontSize: 10.5, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: freshnessProgress,
                    minHeight: 4,
                    backgroundColor: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static IconData _getCategoryIcon(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('dairy') || lower.contains('milk')) return Icons.local_drink_rounded;
    if (lower.contains('veg')) return Icons.eco_rounded;
    if (lower.contains('fruit')) return Icons.apple_rounded;
    if (lower.contains('grain') || lower.contains('pulse') || lower.contains('dal')) return Icons.grain_rounded;
    if (lower.contains('spice') || lower.contains('masala')) return Icons.local_fire_department_rounded;
    if (lower.contains('snack') || lower.contains('biscuit')) return Icons.fastfood_rounded;
    if (lower.contains('beverage') || lower.contains('drink')) return Icons.local_bar_rounded;
    return Icons.inventory_2_rounded;
  }
}
