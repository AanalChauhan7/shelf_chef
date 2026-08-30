import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Reusable Dietary Allergies & Restrictions Filter Chips selector.
class AllergiesPickerSection extends StatelessWidget {
  final List<String> availableAllergies;
  final List<String> selectedAllergies;
  final ValueChanged<List<String>> onChanged;

  const AllergiesPickerSection({
    super.key,
    required this.availableAllergies,
    required this.selectedAllergies,
    required this.onChanged,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dietary Allergies & Restrictions (Optional)',
          style: TextStyle(
            color: primaryTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'AI will avoid recipes containing selected allergens',
          style: AppTextStyles.bodySmall(color: secondaryTextColor),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableAllergies.map((allergy) {
            final isSelected = selectedAllergies.contains(allergy);
            return FilterChip(
              label: Text(allergy),
              selected: isSelected,
              selectedColor: activeColor.withValues(alpha: 0.25),
              checkmarkColor: activeColor,
              labelStyle: TextStyle(
                color: isSelected ? activeColor : secondaryTextColor,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
              onSelected: (selected) {
                final updated = List<String>.from(selectedAllergies);
                if (selected) {
                  updated.add(allergy);
                } else {
                  updated.remove(allergy);
                }
                onChanged(updated);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
