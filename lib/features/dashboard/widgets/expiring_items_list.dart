import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/core.dart';

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

/// Horizontal list of Expiring Soon cards with clean typography and zero icons,
/// adapting to Light/Dark theme.
class ExpiringItemsList extends StatelessWidget {
  const ExpiringItemsList({super.key});

  final List<ExpiringItemData> items = const [
    ExpiringItemData(
      name: 'Organic Whole Milk',
      daysLeft: 1,
      badgeColor: AppColors.dangerRed,
      category: 'Dairy',
    ),
    ExpiringItemData(
      name: 'Fresh Strawberries',
      daysLeft: 2,
      badgeColor: AppColors.warningOrange,
      category: 'Fruits',
    ),
    ExpiringItemData(
      name: 'Artisan Wheat Bread',
      daysLeft: 3,
      badgeColor: Color(0xFFEAB308),
      category: 'Bakery',
    ),
    ExpiringItemData(
      name: 'Greek Plain Yogurt',
      daysLeft: 4,
      badgeColor: AppColors.secondaryGreen,
      category: 'Dairy',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header (No warning icons per spec)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Expiring Soon',
              style: AppTextStyles.headingSmall(color: primaryTextColor),
            ),
            TextButton(
              onPressed: () {},
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

        const SizedBox(height: 12),

        // Horizontal List (Card height 118px, compact & spacious without icons)
        SizedBox(
          height: 118,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildExpiringCard(context, item);
            },
          ),
        ),
      ],
    );
  }

  // --- Private Sub-Widgets Defined Below Build Function ---

  Widget _buildExpiringCard(BuildContext context, ExpiringItemData item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final cardBgColor = isDark
        ? const Color(0x991E293B)
        : const Color(0xCCFFFFFF);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : AppColors.border;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 156,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Row: Category tag on left, Expiry Days badge on right
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.category,
                      style: AppTextStyles.bodySmall(
                        color: secondaryTextColor,
                      ).copyWith(fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: item.badgeColor.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: item.badgeColor.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      '${item.daysLeft}d left',
                      style: TextStyle(
                        color: item.badgeColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              // Item Name in Bold
              Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),

              // Bottom subtle indicator line
              Container(
                height: 3,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: item.badgeColor.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
