import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Modal sheet for displaying kitchen alerts and notifications.
class AlertsModal extends StatelessWidget {
  final bool isDark;

  const AlertsModal({super.key, required this.isDark});

  static void show(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AlertsModal(isDark: isDark),
    );
  }

  @override
  Widget build(BuildContext context) {
    final modalBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: modalBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.notifications_active_rounded,
                    color: activeColor,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Alerts & Notifications',
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Mark All Read',
                  style: TextStyle(
                    color: activeColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                _alertItem(
                  context,
                  icon: Icons.timer_outlined,
                  iconColor: AppColors.dangerRed,
                  title: 'Food Expiry Warning',
                  message:
                      'Organic Whole Milk (1d left) & Strawberries (2d left) are expiring soon.',
                  time: '10m ago',
                ),
                const SizedBox(height: 10),
                _alertItem(
                  context,
                  icon: Icons.account_balance_wallet_outlined,
                  iconColor: AppColors.warningOrange,
                  title: 'Budget Alert',
                  message:
                      '70% of your ₹6,000 monthly budget used. ₹1,750 remaining.',
                  time: '2h ago',
                ),
                const SizedBox(height: 10),
                _alertItem(
                  context,
                  icon: Icons.auto_awesome_outlined,
                  iconColor: isDark
                      ? AppColors.darkAiPurple
                      : AppColors.aiPurple,
                  title: 'AI Recipe Recommendation',
                  message:
                      '98% match recipe "Avocado & Garlic Pasta" ready to cook!',
                  time: '5h ago',
                ),
                const SizedBox(height: 10),
                _alertItem(
                  context,
                  icon: Icons.shopping_bag_outlined,
                  iconColor: activeColor,
                  title: 'Pantry Restock Reminder',
                  message:
                      '3 items are running low: Greek Yogurt, Wheat Bread, Eggs.',
                  time: '1d ago',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _alertItem(
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: itemBg,
        borderRadius: BorderRadius.circular(18),
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      time,
                      style: AppTextStyles.bodySmall(
                        color: secondaryTextColor,
                      ).copyWith(fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 12,
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
}
