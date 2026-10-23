import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../../core/services/app_language_service.dart';
import '../models/generated_recipe.dart';

/// Interactive ingredient checklist widget for cooking guide.
class CookingIngredientsList extends StatefulWidget {
  final List<RecipeIngredientDetail> ingredients;
  final String language;

  const CookingIngredientsList({
    super.key,
    required this.ingredients,
    this.language = 'English',
  });

  @override
  State<CookingIngredientsList> createState() => _CookingIngredientsListState();
}

class _CookingIngredientsListState extends State<CookingIngredientsList> {
  final Map<int, bool> _checked = {};
  bool _addingToCart = false;
  bool _addedToCart = false;

  Future<void> _addMissingToCart() async {
    final missing = widget.ingredients.where((i) => i.type == 'missing').toList();
    if (missing.isEmpty || _addingToCart) return;

    setState(() => _addingToCart = true);
    var added = 0;

    for (final ing in missing) {
      final q = ShoppingApiService.parseQuantity(ing.quantity);

      final ok = await ShoppingApiService.addShoppingItem(
        name: ing.name.trim(),
        quantity: q.qty.toString(),
        unit: q.unit,
        itemType: 'recipe',
      );
      if (ok) added++;
    }

    if (mounted) {
      setState(() {
        _addingToCart = false;
        _addedToCart = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            added > 0
                ? 'Added $added missing ingredient(s) to Cart!'
                : 'Ingredients are already in Cart.',
          ),
          backgroundColor: AppColors.secondaryGreen,
        ),
      );
    }
  }

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
        children: [
          ...List.generate(widget.ingredients.length, (index) {
          final ing = widget.ingredients[index];
          final isChecked = _checked[index] ?? false;

          Color badgeBg = AppColors.secondaryGreen.withValues(alpha: 0.15);
          Color badgeText = AppColors.secondaryGreen;
          String badgeLabel = AppLanguageService.tr('available', widget.language);

          if (ing.type == 'assumed') {
            badgeBg = (isDark ? AppColors.darkAiPurple : AppColors.aiPurple)
                .withValues(alpha: 0.15);
            badgeText = isDark ? AppColors.darkAiPurple : AppColors.aiPurple;
            badgeLabel = AppLanguageService.tr('staple', widget.language);
          } else if (ing.type == 'missing') {
            badgeBg = AppColors.warningOrange.withValues(alpha: 0.15);
            badgeText = AppColors.warningOrange;
            badgeLabel = AppLanguageService.tr('missing', widget.language);
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
        if (widget.ingredients.any((i) => i.type == 'missing')) ...[
          Divider(
            height: 20,
            thickness: 0.8,
            color: isDark
                ? AppColors.darkBorder.withValues(alpha: 0.4)
                : AppColors.border.withValues(alpha: 0.6),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Builder(
              builder: (context) {
                final missingCount = widget.ingredients
                    .where((i) => i.type == 'missing')
                    .length;

                final List<Color> gradientColors = _addedToCart
                    ? const [Color(0xFF34D399), Color(0xFF10B981)]
                    : const [Color(0xFFFFA756), Color(0xFFFA8128)];

                final shadowColor = _addedToCart
                    ? const Color(0xFF10B981).withValues(alpha: 0.18)
                    : const Color(0xFFFA8128).withValues(alpha: 0.18);

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _addingToCart
                          ? [
                              gradientColors[0].withValues(alpha: 0.75),
                              gradientColors[1].withValues(alpha: 0.75),
                            ]
                          : gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      splashColor: Colors.white.withValues(alpha: 0.22),
                      highlightColor: Colors.white.withValues(alpha: 0.12),
                      onTap: _addingToCart ? null : _addMissingToCart,
                      child: Container(
                        height: 46,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_addingToCart) ...[
                                const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Adding to Cart...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.2,
                                    shadows: [
                                      Shadow(
                                        color: Color(0x24000000),
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ] else if (_addedToCart) ...[
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Added Missing to Cart!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.2,
                                    shadows: [
                                      Shadow(
                                        color: Color(0x24000000),
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ] else ...[
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add_shopping_cart_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Add Missing Ingredients to Cart',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.2,
                                    shadows: [
                                      Shadow(
                                        color: Color(0x24000000),
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                                if (missingCount > 0) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.25),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.4),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      '$missingCount',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 4),
        ],
      ],
    ),
  );
}
}
