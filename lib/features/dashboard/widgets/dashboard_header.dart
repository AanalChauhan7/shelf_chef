import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Top Header component displaying dynamic IST greeting, user name, alert bell icon, and profile avatar/initial.
class DashboardHeader extends StatelessWidget {
  final String userName;
  final String? imagePath;
  final String avatarEmoji;
  final VoidCallback onOpenAlerts;
  final VoidCallback onOpenProfile;

  const DashboardHeader({
    super.key,
    required this.userName,
    this.imagePath,
    this.avatarEmoji = '👩‍🍳',
    required this.onOpenAlerts,
    required this.onOpenProfile,
  });

  /// Calculates dynamic greeting based on Indian Standard Time (IST UTC+5:30).
  String _getGreetingIST() {
    final now = DateTime.now().toUtc().add(
      const Duration(hours: 5, minutes: 30),
    );
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return 'Good Morning,';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon,';
    } else {
      return 'Good Evening,';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;

    final greetingText = _getGreetingIST();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildGreetingAndNameColumn(
          greetingText,
          primaryTextColor,
          secondaryTextColor,
        ),
        const SizedBox(width: 12),
        Row(
          children: [
            _buildNotificationBell(isDark, primaryTextColor),
            const SizedBox(width: 10),
            _buildProfileAvatar(activeColor),
          ],
        ),
      ],
    );
  }

  // --- Private Sub-Widgets Defined Below Build Function ---

  Widget _buildGreetingAndNameColumn(
    String greetingText,
    Color primaryTextColor,
    Color secondaryTextColor,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greetingText,
            style: AppTextStyles.bodyMedium(
              color: secondaryTextColor,
            ).copyWith(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Flexible(
                child: Text(
                  userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Text('👋', style: TextStyle(fontSize: 20)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationBell(bool isDark, Color primaryTextColor) {
    return GestureDetector(
      onTap: onOpenAlerts,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isDark ? const Color(0x991E293B) : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.12)
                : AppColors.border,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              color: primaryTextColor,
              size: 22,
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.dangerRed,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(Color activeColor) {
    final hasPhoto = imagePath != null && File(imagePath!).existsSync();
    final initialLetter = userName.isNotEmpty ? userName[0].toUpperCase() : 'A';

    return GestureDetector(
      onTap: onOpenProfile,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppGradients.primaryGradient,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: activeColor.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipOval(
          child: hasPhoto
              ? Image.file(File(imagePath!), fit: BoxFit.cover)
              : Center(
                  child: Text(
                    initialLetter,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
