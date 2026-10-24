import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/core.dart';
import '../models/shopping_item.dart';

/// Modern interactive card tile widget for an item in the Shopping Cart.
class ShoppingItemTile extends StatelessWidget {
  final ShoppingItem item;
  final ValueChanged<bool?> onToggleChecked;
  final VoidCallback onDelete;

  const ShoppingItemTile({
    super.key,
    required this.item,
    required this.onToggleChecked,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final border = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    final itemName = item.name.isEmpty ? 'Item' : item.name;
    final isRecipe = item.itemType.toLowerCase() == 'recipe';
    final isChecked = item.isChecked;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onToggleChecked(!isChecked);
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isChecked
                  ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0))
                  : border,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCheckButton(isChecked, activeColor, isDark),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      itemName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isChecked ? secondaryColor : primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        decoration: isChecked ? TextDecoration.lineThrough : null,
                        decorationColor: secondaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (item.displayQtyUnit.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6.5, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF0F172A)
                                  : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.displayQtyUnit,
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.5, vertical: 2),
                          decoration: BoxDecoration(
                            color: isRecipe
                                ? AppColors.aiPurple.withValues(alpha: 0.12)
                                : activeColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isRecipe) ...[
                                const Icon(
                                  Icons.auto_awesome_rounded,
                                  size: 10,
                                  color: AppColors.aiPurple,
                                ),
                                const SizedBox(width: 3),
                              ],
                              Text(
                                isRecipe ? 'Recipe' : 'Manual',
                                style: TextStyle(
                                  color: isRecipe
                                      ? AppColors.aiPurple
                                      : activeColor,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildDeleteButton(secondaryColor, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckButton(bool isChecked, Color activeColor, bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isChecked ? activeColor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isChecked
              ? activeColor
              : (isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
          width: 1.8,
        ),
      ),
      alignment: Alignment.center,
      child: isChecked
          ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
          : null,
    );
  }

  Widget _buildDeleteButton(Color secondaryColor, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onDelete();
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.close_rounded,
            size: 16,
            color: isDark ? Colors.white38 : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
