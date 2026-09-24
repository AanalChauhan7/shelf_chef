import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Clean input field decoration & helpers for Manual Item Entry Screen.
class ManualEntryFormHelpers {
  static InputDecoration inputDeco({
    required String hint,
    required Color bg,
    required Color border,
    required Color hintColor,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: hintColor.withValues(alpha: 0.5),
        fontSize: 13,
      ),
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: bg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.secondaryGreen,
          width: 1.5,
        ),
      ),
    );
  }

  static Widget buildLabel(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
    );
  }

  static IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Dairy':
        return Icons.local_drink_rounded;
      case 'Vegetables':
        return Icons.eco_rounded;
      case 'Fruits':
        return Icons.apple_rounded;
      case 'Grains & Pulses':
        return Icons.grain_rounded;
      case 'Spices':
        return Icons.local_fire_department_rounded;
      case 'Bakery':
        return Icons.bakery_dining_rounded;
      case 'Beverages':
        return Icons.local_cafe_rounded;
      case 'Snacks':
        return Icons.fastfood_rounded;
      default:
        return Icons.inventory_2_rounded;
    }
  }
}
