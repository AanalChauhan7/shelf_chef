import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../models/pantry_item.dart';

/// Modal bottom sheet showing itemized items extracted from grocery bill scan.
class ExtractedReceiptItemsSheet extends StatefulWidget {
  final String storeName;
  final double totalAmount;
  final List<PantryItem> initialItems;
  final Function(List<PantryItem>) onConfirmAdd;

  const ExtractedReceiptItemsSheet({
    super.key,
    required this.storeName,
    required this.totalAmount,
    required this.initialItems,
    required this.onConfirmAdd,
  });

  static void show(
    BuildContext context, {
    required String storeName,
    required double totalAmount,
    required List<PantryItem> initialItems,
    required Function(List<PantryItem>) onConfirmAdd,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExtractedReceiptItemsSheet(
        storeName: storeName,
        totalAmount: totalAmount,
        initialItems: initialItems,
        onConfirmAdd: onConfirmAdd,
      ),
    );
  }

  @override
  State<ExtractedReceiptItemsSheet> createState() =>
      _ExtractedReceiptItemsSheetState();
}

class _ExtractedReceiptItemsSheetState
    extends State<ExtractedReceiptItemsSheet> {
  late List<PantryItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.initialItems);
  }

  void _removeItem(int index) {
    setState(() => _items.removeAt(index));
  }

  void _addNewItem() {
    setState(() {
      _items.add(
        PantryItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'Extra Grocery Item',
          quantity: '1',
          unit: 'pcs',
          estimatedPrice: 40.0,
          category: 'Other',
        ),
      );
    });
  }

  double get _calculatedTotal {
    return _items.fold(0.0, (sum, i) => sum + (i.estimatedPrice ?? 0.0));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF475569)
                    : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: activeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  color: activeColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.storeName,
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'AI Extracted ${_items.length} items • Total: ₹${_calculatedTotal.toStringAsFixed(0)}',
                      style: TextStyle(color: secondaryTextColor, fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _addNewItem,
                icon: Icon(
                  Icons.add_circle_outline_rounded,
                  color: activeColor,
                ),
                tooltip: 'Add item',
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = _items[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0F172A)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: activeColor.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getCategoryIcon(item.category),
                          size: 18,
                          color: activeColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: TextStyle(
                                color: primaryTextColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${item.displayQty} • ${item.storageLocation} • Exp: ${item.daysUntilExpiry}d',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '₹${item.estimatedPrice?.toStringAsFixed(0) ?? "0"}',
                        style: TextStyle(
                          color: primaryTextColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.dangerRed,
                          size: 20,
                        ),
                        onPressed: () => _removeItem(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _items.isEmpty
                ? null
                : () {
                    widget.onConfirmAdd(_items);
                    Navigator.pop(context);
                  },
            icon: const Icon(Icons.check_rounded, size: 20),
            label: Text('Confirm & Add ${_items.length} Items to Pantry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: activeColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Dairy':
        return Icons.local_drink_rounded;
      case 'Vegetables':
        return Icons.eco_rounded;
      case 'Fruits':
        return Icons.apple_rounded;
      case 'Grains & Pulses':
        return Icons.grain_rounded;
      case 'Spices':
        return Icons.local_fire_department_rounded;
      default:
        return Icons.shopping_basket_rounded;
    }
  }
}
