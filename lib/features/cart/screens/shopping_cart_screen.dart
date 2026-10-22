import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../../core/services/recipe_store.dart';
import '../../recipes/widgets/recipes_status_views.dart';
import '../models/shopping_item.dart';
import '../widgets/add_shopping_item_dialog.dart';
import '../widgets/cart_dialogs.dart';
import '../widgets/cart_progress_bar.dart';
import '../widgets/cart_segment_toggle.dart';
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
  int _segment = 0; // 0 = All, 1 = To Buy, 2 = Done
  bool _isLoading = true;
  bool _busy = false;
  String? _error;

  int get _doneCount => _items.where((i) => i.isChecked).length;
  int get _toBuyCount => _items.where((i) => !i.isChecked).length;
  List<ShoppingItem> get _filteredItems => _segment == 1
      ? _items.where((i) => !i.isChecked).toList()
      : (_segment == 2 ? _items.where((i) => i.isChecked).toList() : _items);

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
      if (mounted) {
        setState(() {
          _error = e.message;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = "Couldn't read your shopping list. Please try again.";
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _openAddItemDialog() async {
    if (await AddShoppingItemDialog.show(context) != null && mounted) {
      await _loadShoppingList(showLoading: false);
    }
  }

  Future<void> _generateList() async {
    final saved = RecipeStore.instance.saved;
    final recipeName = await CartDialogs.pickRecipe(context, saved);
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
    if (!await CartDialogs.confirmClear(context) || !mounted) return;
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
    setState(() => _items = _items.map((i) => i.id == id ? item : i).toList());
  }

  Future<void> _toggleItemChecked(ShoppingItem item) async {
    _replaceItem(item.id, item.copyWith(isChecked: !item.isChecked));
    final ok = await ShoppingApiService.toggleCheckItem(item.id);
    if (ok || !mounted) return;
    _replaceItem(item.id, item);
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
      return SafeArea(child: RecipesErrorView(message: _error!, onRetry: () => _loadShoppingList()));
    }
    if (_items.isEmpty) {
      return ShoppingCartEmptyView(onAddCartItem: _openAddItemDialog, onGenerate: _generateList);
    }
    return _buildListView();
  }

  Widget _buildLoadingView() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(strokeWidth: 2.5, color: activeColor),
          const SizedBox(height: 16),
          Text(
            _busy ? 'Updating Shopping List...' : 'Loading Shopping List...',
            style: TextStyle(
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;
    final displayItems = _filteredItems;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _loadShoppingList,
        color: activeColor,
        child: ListView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.only(bottom: 110),
          children: [
            ShoppingListHeader(
              itemCount: _items.length,
              onAdd: _openAddItemDialog,
              onGenerate: _generateList,
              onClear: _confirmClearList,
            ),
            CartSegmentToggle(
              selected: _segment,
              totalCount: _items.length,
              toBuyCount: _toBuyCount,
              doneCount: _doneCount,
              onChanged: (val) => setState(() => _segment = val),
            ),
            const SizedBox(height: 12),
            CartProgressCard(doneCount: _doneCount, totalCount: _items.length),
            if (_busy) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LinearProgressIndicator(color: activeColor),
              ),
            ],
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: displayItems.isEmpty
                  ? _buildEmptyTabState(isDark)
                  : ListView.separated(
                      shrinkWrap: true,
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: displayItems.length,
                      separatorBuilder: (_, index) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => ShoppingItemTile(
                        key: ValueKey('cart_tile_${displayItems[i].id}'),
                        item: displayItems[i],
                        onToggleChecked: (_) => _toggleItemChecked(displayItems[i]),
                        onDelete: () => _deleteItem(displayItems[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyTabState(bool isDark) {
    final text = _segment == 1 ? 'All caught up! Nothing left to buy.' : 'No purchased items yet.';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
