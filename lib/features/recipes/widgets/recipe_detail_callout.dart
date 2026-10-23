import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../models/generated_recipe.dart';

/// Callout banner for missing ingredients with direct "Add to Cart" action.
class RecipeDetailMissingCallout extends StatefulWidget {
  final GeneratedRecipe recipe;
  final bool isDark;

  const RecipeDetailMissingCallout({
    super.key,
    required this.recipe,
    required this.isDark,
  });

  @override
  State<RecipeDetailMissingCallout> createState() =>
      _RecipeDetailMissingCalloutState();
}

class _RecipeDetailMissingCalloutState
    extends State<RecipeDetailMissingCallout> {
  bool _adding = false;

  Future<void> _addToCart() async {
    if (_adding) return;
    setState(() => _adding = true);
    try {
      final count = await ShoppingApiService.addMissingIngredientsFromRecipe(
        widget.recipe,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              count > 0
                  ? 'Added $count missing item(s) to Cart!'
                  : 'Items are already in Cart.',
            ),
            backgroundColor: AppColors.secondaryGreen,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _adding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final missing = widget.recipe.missingIngredients;
    if (missing.isEmpty) return const SizedBox.shrink();

    final secondaryTextColor = widget.isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warningOrange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.warningOrange.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shopping_bag_outlined,
                size: 14,
                color: AppColors.warningOrange,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  '${missing.length} Missing Ingredient${missing.length > 1 ? 's' : ''}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.warningOrange,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            missing.map((m) => m.displayString).join(', '),
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 11.5,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _adding ? null : _addToCart,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.warningOrange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_adding)
                      const SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.warningOrange,
                        ),
                      )
                    else
                      const Icon(
                        Icons.add_shopping_cart_rounded,
                        size: 12,
                        color: AppColors.warningOrange,
                      ),
                    const SizedBox(width: 5),
                    const Text(
                      'Add to Cart',
                      style: TextStyle(
                        color: AppColors.warningOrange,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Horizontal chips showing ingredients available from the user's pantry.
class RecipeDetailPantryChips extends StatelessWidget {
  final GeneratedRecipe recipe;
  final bool isDark;

  const RecipeDetailPantryChips({
    super.key,
    required this.recipe,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final available = recipe.availableIngredients;
    if (available.isEmpty) return const SizedBox.shrink();

    final emeraldAccent =
        isDark ? AppColors.darkAccent : AppColors.primaryGreen;
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.inventory_2_outlined, size: 14, color: emeraldAccent),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                'In Your Pantry (${available.length})',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: available.map((ing) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: emeraldAccent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: emeraldAccent.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_rounded, size: 11, color: emeraldAccent),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      ing.displayString,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: emeraldAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
