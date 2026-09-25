import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Premium glassmorphic quick action cards bar for Pantry Screen.
class PantryQuickActionsBar extends StatelessWidget {
  final VoidCallback onScanReceipt;
  final VoidCallback onAddItemManually;

  const PantryQuickActionsBar({
    super.key,
    required this.onScanReceipt,
    required this.onAddItemManually,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final activeGreen = isDark ? AppColors.darkAccent : AppColors.primaryGreen;
    final aiPurple = isDark ? AppColors.darkAiPurple : AppColors.aiPurple;

    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            title: 'Scan Bill',
            subtitle: 'AI OCR Extraction',
            badgeText: '✨ AI',
            icon: Icons.qr_code_scanner_rounded,
            themeColor: activeGreen,
            isDark: isDark,
            primaryColor: primaryTextColor,
            secondaryColor: secondaryTextColor,
            onTap: onScanReceipt,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildActionCard(
            title: 'Manual Entry',
            subtitle: 'Custom Item Input',
            badgeText: '+ Add',
            icon: Icons.edit_note_rounded,
            themeColor: aiPurple,
            isDark: isDark,
            primaryColor: primaryTextColor,
            secondaryColor: secondaryTextColor,
            onTap: onAddItemManually,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required String badgeText,
    required IconData icon,
    required Color themeColor,
    required bool isDark,
    required Color primaryColor,
    required Color secondaryColor,
    required VoidCallback onTap,
  }) {
    final cardBg = isDark ? const Color(0xCC1E293B) : const Color(0xCCFFFFFF);
    final borderColor = themeColor.withValues(alpha: isDark ? 0.35 : 0.22);

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderColor, width: 1.1),
              boxShadow: [
                BoxShadow(
                  color: themeColor.withValues(alpha: 0.08),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: themeColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: themeColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Icon(icon, size: 16, color: themeColor),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: themeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: themeColor.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(
                          color: themeColor,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
