import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Premium glassmorphic empty state view for Shopping Cart tab.
class ShoppingCartEmptyView extends StatelessWidget {
  final VoidCallback onAddCartItem;
  final VoidCallback onAutoFillExpiring;

  const ShoppingCartEmptyView({
    super.key,
    required this.onAddCartItem,
    required this.onAutoFillExpiring,
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
              _buildCartGlassIllustration(isDark, activeColor),
              const SizedBox(height: 24),
              Text(
                'Your Shopping List is Empty',
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
                  'Items running low in your pantry will automatically appear here, or you can add items for your next grocery trip.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium(
                    color: secondaryTextColor,
                  ).copyWith(height: 1.4),
                ),
              ),
              const SizedBox(height: 32),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // --- Private Sub-Widgets Defined Below Build Function ---

  Widget _buildCartGlassIllustration(bool isDark, Color activeColor) {
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
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 56,
                  color: activeColor,
                ),
                Positioned(
                  top: 24,
                  right: 24,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: activeColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '₹0',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
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

  Widget _buildActionButtons() {
    return Column(
      children: [
        AppButton(
          text: '+ Add Item to Shopping Cart',
          onPressed: onAddCartItem,
          variant: AppButtonVariant.primary,
        ),
        const SizedBox(height: 12),
        AppButton.secondary(
          text: 'Auto-fill Expiring Pantry Items',
          onPressed: onAutoFillExpiring,
        ),
      ],
    );
  }
}
