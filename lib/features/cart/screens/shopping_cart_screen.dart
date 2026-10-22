import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../../core/services/recipe_store.dart';
import '../../recipes/widgets/recipes_status_views.dart';
import '../models/shopping_item.dart';
import '../widgets/add_shopping_item_dialog.dart';
import '../widgets/shopping_cart_empty_view.dart';
import '../widgets/shopping_item_tile.dart';
import '../widgets/shopping_list_header.dart';

/// Shopping List screen backed by the `/shopping-list` API: load, add, check,
/// delete, clear, and generate the list from the pantry.
class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  ShoppingCartScreenState createState() => ShoppingCartScreenState();
}

class ShoppingCartScreenState extends State<ShoppingCartScreen> {
  final ScrollController _scrollController = ScrollController();
  List<ShoppingItem> _items = [];
  bool _isLoading = true;
  bool _busy = false; // generating or clearing
  String? _error;

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
    if (showLoading && _items.isEmpty) setState(() => _isLoading = true);
    try {
      final list = await ShoppingApiService.fetchShoppingList();
      if (!mounted) return;
      setState(() {
        _items = list;
        _error = null;
        _isLoading = false;
      });
    } on ShoppingApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = "Couldn't read your shopping list. Please try again.";
        _isLoading = false;
      });
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _openAddItemDialog() async {
    final newItem = await AddShoppingItemDialog.show(context);
    if (newItem != null && mounted) await _loadShoppingList(showLoading: false);
  }

  Future<void> _generateList() async {
    final saved = RecipeStore.instance.saved;
    String? recipeName;
    if (saved.isNotEmpty) {
      if (saved.length == 1) {
        recipeName = saved.first.name;
      } else {
        recipeName = await showDialog<String>(
          context: context,
          builder: (ctx) => SimpleDialog(
            title: const Text('Generate missing items for:'),
            children: saved
                .map(
                  (r) => SimpleDialogOption(
                    onPressed: () => Navigator.pop(ctx, r.name),
                    child: Text(r.name),
                  ),
                )
                .toList(),
          ),
        );
      }
    }

    if (saved.isNotEmpty && recipeName == null) return;

    setState(() => _busy = true);
    final error = await ShoppingApiService.generateShoppingList(
      recipeName: recipeName,
    );
    if (!mounted) return;
    if (error == null) await _loadShoppingList(showLoading: false);
    if (!mounted) return;
    setState(() => _busy = false);
    _showMessage(error ?? 'Missing ingredients added to shopping list!');
  }

  Future<void> _confirmClearList() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear shopping list?'),
        content: const Text('This removes every item from your list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);
    final ok = await ShoppingApiService.clearShoppingList();
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (ok) _items = [];
    });
    if (!ok) _showMessage("Couldn't clear the list. Please try again.");
  }

  void _replaceItem(String id, ShoppingItem item) {
    if (!mounted) return;
    setState(() {
      _items = _items.map((i) => i.id == id ? item : i).toList();
    });
  }

  Future<void> _toggleItemChecked(ShoppingItem item) async {
    _replaceItem(item.id, item.copyWith(isChecked: !item.isChecked));
    final ok = await ShoppingApiService.toggleCheckItem(item.id);
    if (ok || !mounted) return;
    _replaceItem(item.id, item); // roll back
    _showMessage("Couldn't update the item. Please try again.");
  }

  Future<void> _deleteItem(ShoppingItem item) async {
    setState(() => _items = _items.where((i) => i.id != item.id).toList());
    final ok = await ShoppingApiService.deleteShoppingItem(item.id);
    if (ok || !mounted) return;
    _showMessage("Couldn't remove the item. Please try again.");
    await _loadShoppingList(showLoading: false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || (_busy && _items.isEmpty)) return _buildLoadingView();
    if (_error != null && _items.isEmpty) {
      return SafeArea(
        child: RecipesErrorView(message: _error!, onRetry: () => _loadShoppingList()),
      );
    }
    if (_items.isEmpty) {
      return ShoppingCartEmptyView(
        onAddCartItem: _openAddItemDialog,
        onGenerate: _generateList,
      );
    }
    return _buildListView();
  }

  // --- Private Sub-Widgets Defined Below Build Function ---

  Widget _buildLoadingView() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;
    final secondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(strokeWidth: 2.5, color: activeColor),
          const SizedBox(height: 16),
          Text(
            _busy ? 'Updating Shopping List...' : 'Loading Shopping List...',
            style: TextStyle(color: secondary, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;
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
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 110),
          children: [
            ShoppingListHeader(
              itemCount: _items.length,
              onAdd: _openAddItemDialog,
              onGenerate: _generateList,
              onClear: _confirmClearList,
            ),
            if (_busy) ...[
              const SizedBox(height: 10),
              LinearProgressIndicator(color: activeColor),
            ],
            const SizedBox(height: 18),
            for (int i = 0; i < _items.length; i++) ...[
              if (i > 0) const SizedBox(height: 10),
              ShoppingItemTile(
                key: ValueKey('cart_tile_${_items[i].id}'),
                item: _items[i],
                onToggleChecked: (_) => _toggleItemChecked(_items[i]),
                onDelete: () => _deleteItem(_items[i]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
