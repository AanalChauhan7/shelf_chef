import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../models/shopping_item.dart';
import '../widgets/add_shopping_item_dialog.dart';
import '../widgets/shopping_cart_empty_view.dart';
import '../widgets/shopping_item_tile.dart';

/// Full Shopping List screen handling API fetch, empty state, and list display with checkboxes.
class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  ShoppingCartScreenState createState() => ShoppingCartScreenState();
}

class ShoppingCartScreenState extends State<ShoppingCartScreen> {
  final ScrollController _scrollController = ScrollController();
  List<ShoppingItem> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadShoppingList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Public reload hook invoked when switching to Cart tab
  void reload() => _loadShoppingList(showLoading: false);

  Future<void> _loadShoppingList({bool showLoading = true}) async {
    if (!mounted) return;
    if (showLoading && _items.isEmpty) {
      setState(() => _isLoading = true);
    }
    try {
      final list = await ShoppingApiService.fetchShoppingList();
      if (mounted) {
        setState(() {
          _items = list;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _openAddItemDialog() async {
    final newItem = await AddShoppingItemDialog.show(context);
    if (newItem != null && mounted) {
      await _loadShoppingList(showLoading: false);
    }
  }

  void _toggleItemChecked(int index) async {
    final item = _items[index];
    setState(() {
      _items[index] = item.copyWith(isChecked: !item.isChecked);
    });
    await ShoppingApiService.toggleCheckItem(item.id);
  }

  void _deleteItem(int index) async {
    final item = _items[index];
    setState(() {
      _items.removeAt(index);
    });
    await ShoppingApiService.deleteShoppingItem(item.id);
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
      return ShoppingCartEmptyView(onAddCartItem: _openAddItemDialog);
    }

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _loadShoppingList,
        color: activeColor,
        child: ListView(
          controller: _scrollController,
          primary: false,
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
                      '${_items.length} ${_items.length == 1 ? "item" : "items"} to buy',
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
              ShoppingItemTile(
                key: ValueKey('cart_tile_${_items[i].id}'),
                item: _items[i],
                onToggleChecked: (_) => _toggleItemChecked(i),
                onDelete: () => _deleteItem(i),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
