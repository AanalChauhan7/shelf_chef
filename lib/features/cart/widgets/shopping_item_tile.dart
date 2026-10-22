import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../models/shopping_item.dart';

/// Card tile widget for a single item in the Shopping Cart list.
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
    final cardBg = isDark ? const Color(0xCC1E293B) : Colors.white;

    final itemName = item.name.isEmpty ? 'Item' : item.name;
    final itemType = item.itemType.isEmpty ? 'Grocery' : item.itemType;
    final isChecked = item.isChecked;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isDark ? Colors.white.withValues(alpha: 0.08) : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
        leading: Checkbox(
          value: isChecked,
          activeColor: activeColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          onChanged: onToggleChecked,
        ),
        title: Text(
          itemName,
          style: TextStyle(
            color: isChecked ? secondaryColor : primaryColor,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            decoration: isChecked ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          item.displayQtyUnit,
          style: TextStyle(
            color: secondaryColor,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: activeColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                itemType,
                style: TextStyle(
                  color: activeColor,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                size: 19,
                color: isDark ? Colors.white38 : AppColors.textSecondary,
              ),
              tooltip: 'Remove',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
