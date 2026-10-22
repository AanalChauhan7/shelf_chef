import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../pantry/models/pantry_item.dart';

/// Weekly Spending Chart Card displaying live spending analytics & food waste percent.
class SpendingChartCard extends StatelessWidget {
  final List<PantryItem> items;

  const SpendingChartCard({super.key, this.items = const []});

  static const List<String> days = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  List<double> get _weeklySpend {
    final spends = List<double>.filled(7, 0.0);
    for (final item in items) {
      final price = item.estimatedPrice ?? 0.0;
      if (price > 0) {
        final dayIndex = (item.addedDate.weekday - 1).clamp(0, 6);
        spends[dayIndex] += price;
      }
    }
    return spends;
  }

  double get _foodWastedPercent {
    if (items.isEmpty) return 0.0;
    final totalSpent =
        items.fold(0.0, (sum, i) => sum + (i.estimatedPrice ?? 0.0));
    final wastedSpent = items
        .where((i) => i.isExpired)
        .fold(0.0, (sum, i) => sum + (i.estimatedPrice ?? 0.0));

    if (totalSpent > 0) {
      return (wastedSpent / totalSpent) * 100;
    }
    final expiredCount = items.where((i) => i.isExpired).length;
    return (expiredCount / items.length) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final cardBgColor =
        isDark ? const Color(0x991E293B) : const Color(0xCCFFFFFF);
    final borderColor =
        isDark ? Colors.white.withValues(alpha: 0.12) : AppColors.border;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;

    final weeklySpend = _weeklySpend;
    final totalSpent = weeklySpend.fold(0.0, (sum, s) => sum + s);
    final avgDaily = totalSpent / 7.0;
    final wastedPercent = _foodWastedPercent;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(
                  primaryTextColor, secondaryTextColor, totalSpent),
              const SizedBox(height: 24),
              _buildBarChart(weeklySpend, secondaryTextColor, isDark),
              const SizedBox(height: 18),
              _buildBottomStatsRow(isDark, primaryTextColor, activeColor,
                  wastedPercent, avgDaily),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(
      Color primaryText, Color secText, double totalSpent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Weekly Spending Trend',
                style: AppTextStyles.titleMedium(color: primaryText)
                    .copyWith(fontWeight: FontWeight.w700)),
            if (totalSpent > 0)
              Text('₹${totalSpent.toStringAsFixed(0)} total',
                  style: TextStyle(
                      color: primaryText,
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 2),
        Text('Grocery Expense Analytics in INR (₹)',
            style: AppTextStyles.bodySmall(color: secText)),
      ],
    );
  }

  Widget _buildBarChart(
      List<double> weeklySpend, Color secText, bool isDark) {
    final maxSpend = weeklySpend.fold(0.0, (m, s) => s > m ? s : m);

    return SizedBox(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(days.length, (index) {
          final spend = weeklySpend[index];
          final heightFactor =
              maxSpend > 0 ? (spend / maxSpend).clamp(0.12, 1.0) : 0.12;
          final hasSpend = spend > 0;

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 18,
                height: 85 * heightFactor,
                decoration: BoxDecoration(
                  gradient: hasSpend
                      ? const LinearGradient(
                          colors: [Color(0xFF34D399), Color(0xFF10B981)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : null,
                  color: hasSpend
                      ? null
                      : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: hasSpend
                      ? [
                          BoxShadow(
                            color: const Color(0xFF10B981).withValues(alpha: 0.45),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                days[index],
                style: AppTextStyles.bodySmall(color: secText)
                    .copyWith(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBottomStatsRow(bool isDark, Color primaryText, Color activeColor,
      double wastedPercent, double avgDaily) {
    final hasWaste = wastedPercent > 0;
    final wasteColor = hasWaste ? AppColors.dangerRed : activeColor;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Icon(
                hasWaste ? Icons.delete_outline_rounded : Icons.eco_rounded,
                color: wasteColor,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                '${wastedPercent.toStringAsFixed(0)}% Food Wasted',
                style: TextStyle(
                  color: hasWaste ? AppColors.dangerRed : primaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Text('|',
              style: TextStyle(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1))),
          Row(
            children: [
              const Icon(Icons.bolt_rounded, color: AppColors.warningOrange, size: 16),
              const SizedBox(width: 4),
              Text(
                '₹${avgDaily.toStringAsFixed(0)} Avg/Day',
                style: TextStyle(
                    color: primaryText, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
