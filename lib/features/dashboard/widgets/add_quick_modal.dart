import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Modal sheet triggered by center FAB button for quick add actions.
class AddQuickModal extends StatelessWidget {
  final bool isDark;

  const AddQuickModal({super.key, required this.isDark});

  static void show(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AddQuickModal(isDark: isDark),
    );
  }

  @override
  Widget build(BuildContext context) {
    final modalBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    return Container(
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
          const SizedBox(height: 20),
          Text(
            'Quick Add to ShelfChef AI',
            style: TextStyle(
              color: primaryTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          _modalOption(
            context,
            icon: Icons.camera_alt_rounded,
            title: 'Scan Pantry Shelf',
            subtitle: 'Auto-detect items using AI camera',
            color: isDark ? AppColors.darkAccent : AppColors.primaryGreen,
          ),
          const SizedBox(height: 12),
          _modalOption(
            context,
            icon: Icons.receipt_long_rounded,
            title: 'Scan Grocery Bill / Receipt',
            subtitle: 'Parse receipt items & prices automatically',
            color: isDark ? AppColors.darkAiPurple : AppColors.aiPurple,
          ),
          const SizedBox(height: 12),
          _modalOption(
            context,
            icon: Icons.edit_note_rounded,
            title: 'Manual Item Entry',
            subtitle: 'Type item name, quantity & expiry',
            color: AppColors.warningOrange,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _modalOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    final optionBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: optionBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: secondaryTextColor, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: secondaryTextColor),
          ],
        ),
      ),
    );
  }
}
