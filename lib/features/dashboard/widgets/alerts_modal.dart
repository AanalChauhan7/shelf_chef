import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Centered floating glassmorphic Dialog for displaying kitchen alerts and notifications.
class AlertsDialog extends StatelessWidget {
  final bool isDark;

  const AlertsDialog({super.key, required this.isDark});

  static void show(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => AlertsDialog(isDark: isDark),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dialogBg = isDark ? const Color(0xEE1E293B) : const Color(0xF7FFFFFF);
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: dialogBg,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.15)
                    : AppColors.border,
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.1),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogHeader(primaryTextColor, activeColor, context),
                const SizedBox(height: 14),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildAlertItem(
                        context,
                        icon: Icons.timer_outlined,
                        iconColor: AppColors.dangerRed,
                        title: 'Food Expiry Warning',
                        message:
                            'Organic Whole Milk (1d left) & Strawberries (2d left) are expiring soon.',
                        time: '10m ago',
                      ),
                      const SizedBox(height: 10),
                      _buildAlertItem(
                        context,
                        icon: Icons.account_balance_wallet_outlined,
                        iconColor: AppColors.warningOrange,
                        title: 'Budget Alert',
                        message:
                            '70% of your ₹6,000 monthly budget used. ₹1,750 remaining.',
                        time: '2h ago',
                      ),
                      const SizedBox(height: 10),
                      _buildAlertItem(
                        context,
                        icon: Icons.auto_awesome_outlined,
                        iconColor: isDark
                            ? AppColors.darkAiPurple
                            : AppColors.aiPurple,
                        title: 'AI Recipe Recommendation',
                        message:
                            '98% match recipe "Kathiyawadi Kadhi" ready to cook!',
                        time: '5h ago',
                      ),
                      const SizedBox(height: 10),
                      _buildAlertItem(
                        context,
                        icon: Icons.shopping_bag_outlined,
                        iconColor: activeColor,
                        title: 'Pantry Restock Reminder',
                        message:
                            '3 items are running low: Besan, Taaza Milk, Eggs.',
                        time: '1d ago',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildCloseButton(context, activeColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogHeader(
    Color primaryTextColor,
    Color activeColor,
    BuildContext context,
  ) {
    return Row(
      children: [
        Icon(Icons.notifications_active_rounded, color: activeColor, size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Alerts & Notifications',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: primaryTextColor,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          color: primaryTextColor.withValues(alpha: 0.6),
        ),
      ],
    );
  }

  Widget _buildAlertItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required String time,
  }) {
    final itemBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: itemBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: primaryTextColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      time,
                      style: AppTextStyles.bodySmall(
                        color: secondaryTextColor,
                      ).copyWith(fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 11.5,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context, Color activeColor) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: activeColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text('Close Notifications'),
      ),
    );
  }
}
