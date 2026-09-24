import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../models/pantry_item.dart';
import 'pantry_header_banner.dart';
import 'pantry_item_card.dart';
import 'pantry_quick_actions_bar.dart';

/// Professional Pantry Inventory Screen matching the dashboard ecosystem styling.
class PantryEmptyView extends StatefulWidget {
  final VoidCallback onScanReceipt;
  final VoidCallback onAddItemManually;

  const PantryEmptyView({
    super.key,
    required this.onScanReceipt,
    required this.onAddItemManually,
  });

  @override
  State<PantryEmptyView> createState() => _PantryEmptyViewState();
}

class _PantryEmptyViewState extends State<PantryEmptyView> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<PantryItem> _samplePantryItems = [
    PantryItem(
      id: '1',
      name: 'Fresh Tomatoes',
      category: 'Vegetables',
      quantity: '1.5',
      unit: 'kg',
      storageLocation: 'Fridge',
      expiryDate: DateTime.now().add(const Duration(days: 2)),
    ),
    PantryItem(
      id: '2',
      name: 'Besan / Gram Flour',
      category: 'Grains & Pulses',
      quantity: '500',
      unit: 'g',
      storageLocation: 'Pantry',
      expiryDate: DateTime.now().add(const Duration(days: 45)),
    ),
    PantryItem(
      id: '3',
      name: 'Amul Taaza Milk',
      category: 'Dairy',
      quantity: '1',
      unit: 'L',
      storageLocation: 'Fridge',
      expiryDate: DateTime.now().add(const Duration(days: 1)),
    ),
    PantryItem(
      id: '4',
      name: 'Pure Desi Ghee',
      category: 'Dairy',
      quantity: '500',
      unit: 'ml',
      storageLocation: 'Pantry',
      expiryDate: DateTime.now().add(const Duration(days: 90)),
    ),
    PantryItem(
      id: '5',
      name: 'Ratlami Sev',
      category: 'Snacks',
      quantity: '200',
      unit: 'g',
      storageLocation: 'Pantry',
      expiryDate: DateTime.now().add(const Duration(days: 20)),
    ),
  ];

  final List<Map<String, dynamic>> _categories = const [
    {'name': 'All', 'icon': Icons.grid_view_rounded},
    {'name': 'Vegetables', 'icon': Icons.eco_rounded},
    {'name': 'Dairy', 'icon': Icons.local_drink_rounded},
    {'name': 'Grains & Pulses', 'icon': Icons.grain_rounded},
    {'name': 'Snacks', 'icon': Icons.fastfood_rounded},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

    final filteredItems = _samplePantryItems.where((item) {
      final matchesCategory =
          _selectedCategory == 'All' || item.category == _selectedCategory;
      final query = _searchController.text.trim().toLowerCase();
      final matchesQuery =
          query.isEmpty || item.name.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();

    return SafeArea(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: 110,
        ),
        children: [
          PantryHeaderBanner(
            totalItemsCount: _samplePantryItems.length,
            expiringSoonCount: 2,
          ),
          const SizedBox(height: 18),
          PantryQuickActionsBar(
            onScanReceipt: widget.onScanReceipt,
            onAddItemManually: widget.onAddItemManually,
          ),
          const SizedBox(height: 18),
          _buildSearchBar(isDark, primaryTextColor, secondaryTextColor),
          const SizedBox(height: 14),
          _buildCategoryFilterRow(isDark, primaryTextColor),
          const SizedBox(height: 16),
          if (filteredItems.isEmpty)
            _buildEmptyState(primaryTextColor, secondaryTextColor)
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return PantryItemCard(
                  item: filteredItems[index],
                  isDark: isDark,
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark, Color textColor, Color hintColor) {
    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      style: TextStyle(color: textColor, fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Search inventory by item or category...',
        hintStyle: TextStyle(
          color: hintColor.withValues(alpha: 0.6),
          fontSize: 13,
        ),
        prefixIcon: Icon(Icons.search_rounded, color: hintColor, size: 20),
        filled: true,
        fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilterRow(bool isDark, Color textColor) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final String catName = cat['name'] as String;
          final isSel = _selectedCategory == catName;
          return ChoiceChip(
            avatar: Icon(
              cat['icon'] as IconData,
              size: 14,
              color: isSel ? Colors.white : textColor,
            ),
            label: Text(catName),
            selected: isSel,
            selectedColor: isDark
                ? AppColors.darkAccent
                : AppColors.primaryGreen,
            labelStyle: TextStyle(
              color: isSel ? Colors.white : textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            onSelected: (_) => setState(() => _selectedCategory = catName),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(Color textColor, Color secondaryColor) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: secondaryColor),
          const SizedBox(height: 12),
          Text(
            'No matching pantry items found',
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
