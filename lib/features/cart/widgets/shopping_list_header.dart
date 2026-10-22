import 'package:flutter/material.dart';
import '../../../core/core.dart';

enum _ListAction { generate, clear }

/// Title row of the Shopping List: item count, Add button and a menu with
/// "Generate from pantry" and "Clear list".
class ShoppingListHeader extends StatelessWidget {
  final int itemCount;
  final VoidCallback onAdd;
  final VoidCallback onGenerate;
  final VoidCallback onClear;

  const ShoppingListHeader({
    super.key,
    required this.itemCount,
    required this.onAdd,
    required this.onGenerate,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;

    return Row(
      children: [
        Expanded(
          child: _buildTitle(primaryTextColor, secondaryTextColor),
        ),
        _buildAddButton(activeColor),
        _buildMenu(primaryTextColor),
      ],
    );
  }

  // --- Private Sub-Widgets Defined Below Build Function ---

  Widget _buildTitle(Color primary, Color secondary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shopping List', style: AppTextStyles.headingMedium(color: primary)),
        const SizedBox(height: 2),
        Text(
          '$itemCount ${itemCount == 1 ? "item" : "items"} to buy',
          style: TextStyle(color: secondary, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildAddButton(Color activeColor) {
    return ElevatedButton.icon(
      onPressed: onAdd,
      icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
      label: const Text(
        'Add Item',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: activeColor,
        // The app theme gives ElevatedButtons an infinite minimum width,
        // which crashes layout inside a Row (this caused the blank Cart).
        minimumSize: const Size(0, 40),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _buildMenu(Color iconColor) {
    return PopupMenuButton<_ListAction>(
      tooltip: 'More',
      icon: Icon(Icons.more_vert_rounded, color: iconColor),
      onSelected: (action) =>
          action == _ListAction.generate ? onGenerate() : onClear(),
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: _ListAction.generate,
          child: Text('Generate from pantry'),
        ),
        PopupMenuItem(
          value: _ListAction.clear,
          child: Text('Clear list'),
        ),
      ],
    );
  }
}
