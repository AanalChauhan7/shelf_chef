import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../models/generated_recipe.dart';

/// Interactive ingredient checklist widget for cooking guide.
class CookingIngredientsList extends StatefulWidget {
  final List<RecipeIngredientDetail> ingredients;

  const CookingIngredientsList({super.key, required this.ingredients});

  @override
  State<CookingIngredientsList> createState() => _CookingIngredientsListState();
}

class _CookingIngredientsListState extends State<CookingIngredientsList> {
  final Map<int, bool> _checked = {};

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final cardBg = isDark ? AppColors.darkCard : AppColors.surface;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Column(
        children: List.generate(widget.ingredients.length, (index) {
          final ing = widget.ingredients[index];
          final isChecked = _checked[index] ?? false;

          Color badgeBg = AppColors.secondaryGreen.withValues(alpha: 0.15);
          Color badgeText = AppColors.secondaryGreen;
          String badgeLabel = 'Available';

          if (ing.type == 'assumed') {
            badgeBg = (isDark ? AppColors.darkAiPurple : AppColors.aiPurple)
                .withValues(alpha: 0.15);
            badgeText = isDark ? AppColors.darkAiPurple : AppColors.aiPurple;
            badgeLabel = 'Staple';
          } else if (ing.type == 'missing') {
            badgeBg = AppColors.warningOrange.withValues(alpha: 0.15);
            badgeText = AppColors.warningOrange;
            badgeLabel = 'Missing';
          }

          final qtyStr = ing.quantity.isNotEmpty ? ' (${ing.quantity})' : '';

          return CheckboxListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 2,
            ),
            value: isChecked,
            activeColor: AppColors.secondaryGreen,
            onChanged: (val) {
              setState(() => _checked[index] = val ?? false);
            },
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    '${index + 1}. ${ing.name}$qtyStr',
                    style: TextStyle(
                      color: isChecked ? secondaryTextColor : primaryTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      decoration: isChecked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badgeLabel,
                    style: TextStyle(
                      color: badgeText,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
