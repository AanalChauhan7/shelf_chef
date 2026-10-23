import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/core.dart';
import 'alert_notification_tile.dart';

/// Centered floating glassmorphic Dialog displaying real kitchen alerts & notifications.
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
    final primaryTextColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: dialogBg,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.15) : AppColors.border,
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
                  child: ValueListenableBuilder<List<AppNotificationItem>>(
                    valueListenable: AppNotificationService.instance.notifications,
                    builder: (context, items, _) {
                      if (items.isEmpty) return _buildEmptyState(primaryTextColor, activeColor);
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return AlertNotificationTile(
                            item: item,
                            isDark: isDark,
                            onTap: () => AppNotificationService.instance.markAsRead(item.id),
                            onDelete: () => AppNotificationService.instance.deleteNotification(item.id),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                _buildFooterActions(context, activeColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogHeader(Color primaryTextColor, Color activeColor, BuildContext context) {
    return Row(
      children: [
        Icon(Icons.notifications_active_rounded, color: activeColor, size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Alerts & Notifications',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: primaryTextColor, fontSize: 17, fontWeight: FontWeight.w800),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.close_rounded, size: 18, color: primaryTextColor.withValues(alpha: 0.7)),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(Color primaryTextColor, Color activeColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: activeColor.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(Icons.done_all_rounded, color: activeColor, size: 36),
          ),
          const SizedBox(height: 14),
          Text('All caught up!', style: TextStyle(color: primaryTextColor, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(
            'No low stock or expiring alerts right now. Your pantry is well stocked!',
            textAlign: TextAlign.center,
            style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary, fontSize: 12, height: 1.3),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterActions(BuildContext context, Color activeColor) {
    return ValueListenableBuilder<List<AppNotificationItem>>(
      valueListenable: AppNotificationService.instance.notifications,
      builder: (context, items, _) {
        if (items.isEmpty) {
          return SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.check_rounded, size: 18),
              label: const Text('Close'),
              style: ElevatedButton.styleFrom(
                backgroundColor: activeColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          );
        }

        return Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 46,
                child: TextButton.icon(
                  onPressed: () => AppNotificationService.instance.clearAll(),
                  icon: Icon(Icons.delete_sweep_rounded, size: 18, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                  label: Text('Clear All', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w700)),
                  style: TextButton.styleFrom(
                    backgroundColor: isDark ? const Color(0x33334155) : const Color(0xFFF1F5F9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: activeColor.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 3))],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    AppNotificationService.instance.markAllAsRead();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.done_all_rounded, size: 18),
                  label: const Text('Mark as Read'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.1),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
