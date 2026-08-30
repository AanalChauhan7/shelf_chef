import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Premium glassmorphic empty state view for Pantry Inventory tab.
class PantryEmptyView extends StatelessWidget {
  final VoidCallback onScanReceipt;
  final VoidCallback onAddItemManually;

  const PantryEmptyView({
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
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildGlassIllustration(isDark, activeColor),
              const SizedBox(height: 24),
              Text(
                'Your Pantry is Empty',
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Scan your grocery receipt or add items manually to start tracking expiration dates & AI waste prevention.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium(
                    color: secondaryTextColor,
                  ).copyWith(height: 1.4),
                ),
              ),
              const SizedBox(height: 32),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  // --- Private Sub-Widgets Defined Below Build Function ---

  Widget _buildGlassIllustration(bool isDark, Color activeColor) {
    final cardBg = isDark ? const Color(0xCC1E293B) : const Color(0xF2FFFFFF);

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: cardBg,
            shape: BoxShape.circle,
            border: Border.all(
              color: activeColor.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: activeColor.withValues(alpha: 0.2),
                blurRadius: 28,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, size: 56, color: activeColor),
                Positioned(
                  bottom: 24,
                  right: 24,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.warningOrange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        AppButton.ai(
          text: 'Scan Grocery Receipt',
          onPressed: onScanReceipt,
          icon: Icons.qr_code_scanner_rounded,
        ),
        const SizedBox(height: 12),
        AppButton.secondary(
          text: '+ Add Item Manually',
          onPressed: onAddItemManually,
        ),
      ],
    );
  }
}
