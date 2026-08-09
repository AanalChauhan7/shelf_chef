import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Monthly Budget Card with glowing progress bar in Indian Currency (₹).
class BudgetCard extends StatelessWidget {
  final double spent;
  final double totalBudget;

  const BudgetCard({
    super.key,
    this.spent = 4250.00,
    this.totalBudget = 6000.00,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = (spent / totalBudget).clamp(0.0, 1.0);
    final remaining = totalBudget - spent;

    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;

    final cardBgColor = isDark
        ? const Color(0x991E293B)
        : const Color(0xCCFFFFFF);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : AppColors.border;

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
              BoxShadow(
                color: activeColor.withValues(alpha: 0.06),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderRow(
                primaryTextColor,
                secondaryTextColor,
                activeColor,
                remaining,
              ),
              const SizedBox(height: 20),
              _buildSpendingAmountText(primaryTextColor, secondaryTextColor),
              const SizedBox(height: 14),
              _buildProgressBar(isDark, activeColor, progress),
              const SizedBox(height: 14),
              _buildFooterInfo(secondaryTextColor, activeColor),
            ],
          ),
        ),
      ),
    );
  }

  // --- Private Sub-Widgets Defined Below Build Function ---

  Widget _buildHeaderRow(
    Color primaryTextColor,
    Color secondaryTextColor,
    Color activeColor,
    double remaining,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: activeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.account_balance_wallet_rounded,
                color: activeColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monthly Budget',
                  style: AppTextStyles.titleMedium(
                    color: primaryTextColor,
                  ).copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  'August 2026',
                  style: AppTextStyles.bodySmall(color: secondaryTextColor),
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: activeColor.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: activeColor.withValues(alpha: 0.3)),
          ),
          child: Text(
            '₹${remaining.toStringAsFixed(0)} Left',
            style: TextStyle(
              color: activeColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpendingAmountText(
    Color primaryTextColor,
    Color secondaryTextColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '₹${spent.toStringAsFixed(0)}',
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          ' / ₹${totalBudget.toStringAsFixed(0)} limit',
          style: AppTextStyles.bodyMedium(color: secondaryTextColor),
        ),
      ],
    );
  }

  Widget _buildProgressBar(bool isDark, Color activeColor, double progress) {
    return Stack(
      children: [
        Container(
          height: 10,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        FractionallySizedBox(
          widthFactor: progress,
          child: Container(
            height: 10,
            decoration: BoxDecoration(
              gradient: AppGradients.primaryGradient,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: activeColor.withValues(alpha: 0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterInfo(Color secondaryTextColor, Color activeColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.trending_down_rounded, size: 14, color: activeColor),
            const SizedBox(width: 4),
            Text(
              '12% lower than last month',
              style: AppTextStyles.bodySmall(color: secondaryTextColor),
            ),
          ],
        ),
        Text(
          'Analytics →',
          style: TextStyle(
            color: activeColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
