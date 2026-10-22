import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../models/shopping_item.dart';
import '../widgets/add_shopping_item_dialog.dart';
import '../widgets/shopping_cart_empty_view.dart';

/// Full Shopping List screen handling API fetch, empty state, and list display with checkboxes.
class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  List<ShoppingItem> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadShoppingList();
  }

  Future<void> _loadShoppingList({bool showLoading = true}) async {
    if (!mounted) return;
    if (showLoading) setState(() => _isLoading = true);
    try {
      final list = await ShoppingApiService.fetchShoppingList();
      if (mounted) {
        setState(() {
          if (list.isNotEmpty || showLoading) {
            _items = list.isNotEmpty ? list : _items;
          }
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted && showLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openAddItemDialog() async {
    final newItem = await AddShoppingItemDialog.show(context);
    if (newItem != null && mounted) {
      setState(() {
        _items.insert(0, newItem);
        _isLoading = false;
      });
      _loadShoppingList(showLoading: false);
    }
  }

  void _toggleItemChecked(int index) {
    setState(() {
      final item = _items[index];
      _items[index] = item.copyWith(isChecked: !item.isChecked);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;

    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(strokeWidth: 2.5, color: activeColor),
            const SizedBox(height: 16),
            Text(
              'Loading Shopping List...',
              style: TextStyle(color: secondaryTextColor, fontSize: 13),
            ),
          ],
        ),
      );
    }

    if (_items.isEmpty) {
      return ShoppingCartEmptyView(
        onAddCartItem: _openAddItemDialog,
      );
    }

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _loadShoppingList,
        color: activeColor,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.only(
              left: 20, right: 20, top: 16, bottom: 110),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shopping List',
                      style:
                          AppTextStyles.headingMedium(color: primaryTextColor),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_items.length} items to buy',
                      style:
                          TextStyle(color: secondaryTextColor, fontSize: 13),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _openAddItemDialog,
                  icon: const Icon(Icons.add_rounded,
                      size: 18, color: Colors.white),
                  label: const Text(
                    'Add Item',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            for (int i = 0; i < _items.length; i++) ...[
              if (i > 0) const SizedBox(height: 10),
              _buildShoppingItemTile(context, _items[i], i, isDark,
                  primaryTextColor, secondaryTextColor, activeColor),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildShoppingItemTile(
    BuildContext context,
    ShoppingItem? item,
    int index,
    bool isDark,
    Color primaryColor,
    Color secondaryColor,
    Color activeColor,
  ) {
    if (item == null) return const SizedBox.shrink();
    final cardBg = isDark ? const Color(0xCC1E293B) : Colors.white;
    final itemName = item.name.isEmpty ? 'Item' : item.name;
    final itemType = item.itemType.isEmpty ? 'Grocery' : item.itemType;
    final isChecked = item.isChecked;

    return Container(
      key: ValueKey(item.id),
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
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Checkbox(
          value: isChecked,
          activeColor: activeColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          onChanged: (_) => _toggleItemChecked(index),
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
        trailing: Container(
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
      ),
    );
  }
}
