import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Weekly Spending Chart Card showing daily spending bars in Indian Rupees (₹),
/// without the saved badge.
class SpendingChartCard extends StatelessWidget {
  const SpendingChartCard({super.key});

  final List<double> weeklySpend = const [
    450.0,
    780.0,
    320.0,
    950.0,
    500.0,
    200.0,
    850.0,
  ];
  final List<String> days = const [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  Widget build(BuildContext context) {
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
        ? Colors.white.withValues(alpha: 0.12)
        : AppColors.border;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;

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
              _buildHeaderSection(primaryTextColor, secondaryTextColor),
              const SizedBox(height: 24),
              _buildBarChart(secondaryTextColor),
              const SizedBox(height: 18),
              _buildBottomStatsRow(isDark, primaryTextColor, activeColor),
            ],
          ),
        ),
      ),
    );
  }

  // --- Private Sub-Widgets Defined Below Build Function ---

  Widget _buildHeaderSection(Color primaryTextColor, Color secondaryTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Spending Trend',
          style: AppTextStyles.titleMedium(
            color: primaryTextColor,
          ).copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(
          'Grocery Expense Analytics in INR (₹)',
          style: AppTextStyles.bodySmall(color: secondaryTextColor),
        ),
      ],
    );
  }

  Widget _buildBarChart(Color secondaryTextColor) {
    const maxSpend = 1000.0;

    return SizedBox(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(days.length, (index) {
          final spend = weeklySpend[index];
          final heightFactor = (spend / maxSpend).clamp(0.15, 1.0);

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 18,
                height: 85 * heightFactor,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF34D399), Color(0xFF10B981)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withValues(alpha: 0.45),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                days[index],
                style: AppTextStyles.bodySmall(
                  color: secondaryTextColor,
                ).copyWith(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBottomStatsRow(
    bool isDark,
    Color primaryTextColor,
    Color activeColor,
  ) {
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
              Icon(Icons.eco_rounded, color: activeColor, size: 16),
              const SizedBox(width: 6),
              Text(
                '0% Food Wasted',
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Text(
            '|',
            style: TextStyle(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.bolt_rounded,
                color: AppColors.warningOrange,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '₹425 Avg/Day',
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
