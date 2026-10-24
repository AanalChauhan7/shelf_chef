import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Monthly Budget Card with live spending amount and glowing progress bar.
class BudgetCard extends StatelessWidget {
  final double spentAmount;
  final double totalBudget;

  const BudgetCard({
    super.key,
    this.spentAmount = 0.0,
    this.totalBudget = 6000.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isExceeded = spentAmount > totalBudget;
    final progress =
        totalBudget > 0 ? (spentAmount / totalBudget).clamp(0.0, 1.0) : 1.0;
    final remaining = totalBudget - spentAmount;
    final overAmount = spentAmount - totalBudget;
    final primaryTextColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;
    final cardBgColor =
        isDark ? const Color(0xCC1E293B) : const Color(0xCCFFFFFF);
    final borderColor =
        isDark ? Colors.white.withValues(alpha: 0.12) : AppColors.border;

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
                color: (isExceeded ? AppColors.dangerRed : activeColor)
                    .withValues(alpha: 0.08),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(primaryTextColor, secondaryTextColor, activeColor,
                  remaining, isExceeded, overAmount),
              const SizedBox(height: 20),
              _buildSpendingText(primaryTextColor, secondaryTextColor, isExceeded),
              const SizedBox(height: 14),
              _buildProgressBar(isDark, activeColor, progress, isExceeded),
              const SizedBox(height: 14),
              _buildFooter(secondaryTextColor, activeColor, isExceeded, overAmount),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color primaryText, Color secText, Color activeColor,
      double remaining, bool isExceeded, double overAmount) {
    final badgeColor = isExceeded ? AppColors.dangerRed : activeColor;
    final now = DateTime.now();
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isExceeded
                      ? Icons.warning_amber_rounded
                      : Icons.account_balance_wallet_rounded,
                  color: badgeColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Monthly Budget',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleMedium(color: primaryText)
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${months[now.month - 1]} ${now.year}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall(color: secText),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
          ),
          child: Text(
            isExceeded
                ? '₹${overAmount.toStringAsFixed(0)} Over'
                : '₹${remaining.toStringAsFixed(0)} Left',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: badgeColor,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpendingText(
      Color primaryText, Color secText, bool isExceeded) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Flexible(
          child: Text(
            '₹${spentAmount.toStringAsFixed(0)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isExceeded ? AppColors.dangerRed : primaryText,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            '/ ₹${totalBudget.toStringAsFixed(0)} limit',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium(color: secText),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(
      bool isDark, Color activeColor, double progress, bool isExceeded) {
    final barGlowColor = isExceeded ? AppColors.dangerRed : activeColor;
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
          widthFactor: isExceeded ? 1.0 : progress,
          child: Container(
            height: 10,
            decoration: BoxDecoration(
              gradient: isExceeded
                  ? const LinearGradient(
                      colors: [Color(0xFFEF4444), Color(0xFFDC2626)])
                  : AppGradients.primaryGradient,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: barGlowColor.withValues(alpha: 0.6),
                  blurRadius: 10,
                  spreadRadius: 1.5,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(Color secText, Color activeColor, bool isExceeded,
      double overAmount) {
    return Row(
      children: [
        Icon(
          isExceeded ? Icons.warning_rounded : Icons.check_circle_outline_rounded,
          size: 14,
          color: isExceeded ? AppColors.dangerRed : activeColor,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            isExceeded
                ? 'Budget exceeded by ₹${overAmount.toStringAsFixed(0)}!'
                : 'Within monthly budget limit',
            style: AppTextStyles.bodySmall(
              color: isExceeded ? AppColors.dangerRed : secText,
            ).copyWith(fontWeight: isExceeded ? FontWeight.w600 : FontWeight.w400),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
