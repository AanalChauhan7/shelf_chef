import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Single interactive grocery cart item tile widget.
class CartItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isDark;
  final Color activeColor;
  final Color primaryColor;
  final Color secondaryColor;
  final ValueChanged<bool?> onCheckChanged;
  final VoidCallback onDelete;

  const CartItemTile({
    super.key,
    required this.item,
    required this.isDark,
    required this.activeColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.onCheckChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool checked = item['checked'] as bool;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: checked,
            activeColor: activeColor,
            onChanged: onCheckChanged,
          ),
          Text(
            item['category'] as String,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item['name'] as String,
              style: TextStyle(
                color: checked ? secondaryColor : primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                decoration: checked ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          Text(
            '₹${item['price']}',
            style: TextStyle(
              color: activeColor,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              size: 20,
              color: AppColors.dangerRed,
            ),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
