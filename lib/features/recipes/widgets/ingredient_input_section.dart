import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../models/ingredient_item.dart';
import 'ingredient_add_form.dart';
import 'ingredient_tile.dart';

/// Section for adding, scanning, and editing ingredients with quantities.
class IngredientInputSection extends StatelessWidget {
  final List<IngredientItem> ingredients;
  final ValueChanged<List<IngredientItem>> onChanged;

  const IngredientInputSection({
    super.key,
    required this.ingredients,
    required this.onChanged,
  });

  void _addIngredient(IngredientItem newItem) {
    final updated = List<IngredientItem>.from(ingredients)..add(newItem);
    onChanged(updated);
  }

  void _removeIngredient(String id) {
    final updated = ingredients.where((i) => i.id != id).toList();
    onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkCard : AppColors.surface;
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.darkAiPurple : AppColors.aiPurple)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.kitchen_rounded,
                  color: isDark ? AppColors.darkAiPurple : AppColors.aiPurple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Available Ingredients',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          IngredientAddForm(onAdd: _addIngredient),
          const SizedBox(height: 14),
          if (ingredients.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'No ingredients added yet. Enter items above.',
                  style: TextStyle(color: secondaryTextColor, fontSize: 12),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ingredients.length,
              separatorBuilder: (_, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = ingredients[index];
                return IngredientTile(
                  item: item,
                  onRemove: () => _removeIngredient(item.id),
                  isDark: isDark,
                );
              },
            ),
        ],
      ),
    );
  }
}
