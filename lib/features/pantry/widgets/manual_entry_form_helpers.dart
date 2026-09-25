import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Clean executive input field decoration & section containers for Manual Entry.
class ManualEntryFormHelpers {
  static InputDecoration inputDeco({
    required String hint,
    required Color bg,
    required Color border,
    required Color hintColor,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: hintColor.withValues(alpha: 0.5),
        fontSize: 13,
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
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
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
    );
  }

  static Widget buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
    required bool isDark,
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: isDark ? AppColors.darkAccent : AppColors.primaryGreen),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  static Widget buildCategoryChips({
    required List<Map<String, dynamic>> categories,
    required String selectedCategory,
    required ValueChanged<String> onSelect,
    required Color primaryTextColor,
    required Color activeColor,
  }) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final String catName = cat['name'] as String;
          final isSelected = selectedCategory == catName;
          return ChoiceChip(
            avatar: Icon(
              cat['icon'] as IconData,
              size: 14,
              color: isSelected ? Colors.white : primaryTextColor,
            ),
            label: Text(catName),
            selected: isSelected,
            selectedColor: activeColor,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : primaryTextColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            onSelected: (_) => onSelect(catName),
          );
        },
      ),
    );
  }

  static Widget buildStorageRow({
    required String selectedStorage,
    required ValueChanged<String> onSelect,
    required Color primaryTextColor,
    required bool isDark,
  }) {
    final locations = [
      {'name': 'Pantry', 'icon': Icons.inventory_2_rounded},
      {'name': 'Fridge', 'icon': Icons.kitchen_rounded},
      {'name': 'Freezer', 'icon': Icons.ac_unit_rounded},
    ];

    return Row(
      children: locations.map((loc) {
        final String locName = loc['name'] as String;
        final isSel = selectedStorage == locName;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              avatar: Icon(
                loc['icon'] as IconData,
                size: 14,
                color: isSel ? Colors.white : primaryTextColor,
              ),
              label: Text(
                locName,
                style: TextStyle(
                  color: isSel ? Colors.white : primaryTextColor,
                  fontSize: 12,
                ),
              ),
              selected: isSel,
              selectedColor: isDark
                  ? AppColors.darkAiPurple
                  : AppColors.aiPurple,
              onSelected: (_) => onSelect(locName),
            ),
          ),
        );
      }).toList(),
    );
  }
}
