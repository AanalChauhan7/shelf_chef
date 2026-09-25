import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../pantry/screens/manual_item_entry_screen.dart';
import '../../pantry/screens/receipt_scanner_screen.dart';
import '../../recipes/screens/generate_recipe_screen.dart';

/// Modal sheet triggered by center FAB button for quick add actions.
class AddQuickModal extends StatelessWidget {
  final bool isDark;
  final int familyMembers;
  final String preferredLanguage;

  const AddQuickModal({
    super.key,
    required this.isDark,
    this.familyMembers = 2,
    this.preferredLanguage = 'English',
  });

  static void show(
    BuildContext context, {
    int familyMembers = 2,
    String preferredLanguage = 'English',
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AddQuickModal(
        isDark: isDark,
        familyMembers: familyMembers,
        preferredLanguage: preferredLanguage,
      ),
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
            icon: Icons.auto_awesome_rounded,
            title: 'Generate New Recipe',
            subtitle: 'Scan & add ingredients with custom portion size',
            color: isDark ? AppColors.darkAiPurple : AppColors.aiPurple,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GenerateRecipeScreen(
                    initialPeopleCount: familyMembers,
                    initialLanguage: preferredLanguage,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _modalOption(
            context,
            icon: Icons.receipt_long_rounded,
            title: 'Scan Grocery Bill / Receipt',
            subtitle: 'Parse receipt items & prices automatically',
            color: isDark ? AppColors.darkAccent : AppColors.primaryGreen,
            onTap: () async {
              final rootContext = context;
              Navigator.pop(context);
              final result = await Navigator.push<bool>(
                rootContext,
                MaterialPageRoute(
                  builder: (_) => const ReceiptScannerScreen(),
                ),
              );
              if (result == true && rootContext.mounted) {
                // If needed, root navigator context handles state update
              }
            },
          ),
          const SizedBox(height: 12),
          _modalOption(
            context,
            icon: Icons.edit_note_rounded,
            title: 'Manual Item Entry',
            subtitle: 'Type item name, quantity & expiry',
            color: AppColors.warningOrange,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ManualItemEntryScreen(),
                ),
              );
            },
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
    VoidCallback? onTap,
  }) {
    final optionBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return InkWell(
      onTap: onTap ?? () => Navigator.pop(context),
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
