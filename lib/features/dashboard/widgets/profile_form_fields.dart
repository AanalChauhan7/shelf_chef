import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Reusable Full Name text field input with optional validator and Enter key handling.
class FullNameInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  const FullNameInputField({
    super.key,
    required this.controller,
    this.label = 'Full Name',
    this.validator,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      validator: validator ?? AppValidators.validateOptionalFullName,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      style: TextStyle(color: primaryTextColor, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
        errorStyle: const TextStyle(
          color: AppColors.dangerRed,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        errorMaxLines: 2,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.dangerRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.dangerRed, width: 1.8),
        ),
      ),
    );
  }
}

/// Reusable Family Members counter controls.
class FamilyMembersCounterRow extends StatelessWidget {
  final int count;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const FamilyMembersCounterRow({
    super.key,
    required this.count,
    required this.onDecrement,
    required this.onIncrement,
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Family Members',
              style: TextStyle(
                color: primaryTextColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            Text(
              'Used for recipe serving size',
              style: AppTextStyles.bodySmall(
                color: secondaryTextColor,
              ).copyWith(fontWeight: FontWeight.w400),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: onDecrement,
              icon: const Icon(Icons.remove_circle_outline_rounded),
              color: activeColor,
            ),
            Text(
              '$count',
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              onPressed: onIncrement,
              icon: const Icon(Icons.add_circle_outline_rounded),
              color: activeColor,
            ),
          ],
        ),
      ],
    );
  }
}

/// Reusable Monthly Grocery Budget input field in INR (₹) with Enter key handling.
class MonthlyBudgetInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  const MonthlyBudgetInputField({
    super.key,
    required this.controller,
    this.validator,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      validator: validator ?? AppValidators.validateOptionalBudget,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      style: TextStyle(color: primaryTextColor, fontSize: 14),
      decoration: InputDecoration(
        labelText: 'Monthly Grocery Budget',
        prefixText: '₹ ',
        prefixStyle: TextStyle(color: activeColor, fontWeight: FontWeight.w600),
        prefixIcon: const Icon(Icons.account_balance_wallet_outlined, size: 20),
        errorStyle: const TextStyle(
          color: AppColors.dangerRed,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        errorMaxLines: 2,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.dangerRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.dangerRed, width: 1.8),
        ),
      ),
    );
  }
}
