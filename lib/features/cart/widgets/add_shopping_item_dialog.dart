import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../models/shopping_item.dart';

/// Modal dialog for adding items to the Shopping List.
class AddShoppingItemDialog extends StatefulWidget {
  const AddShoppingItemDialog({super.key});

  static Future<ShoppingItem?> show(BuildContext context) {
    return showDialog<ShoppingItem>(
      context: context,
      builder: (context) => const AddShoppingItemDialog(),
    );
  }

  @override
  State<AddShoppingItemDialog> createState() => _AddShoppingItemDialogState();
}

class _AddShoppingItemDialogState extends State<AddShoppingItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController(text: '1');
  final _unitController = TextEditingController();

  String _itemType = 'Grocery';
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final isGrocery = _itemType == 'Grocery';
    final unitVal = _unitController.text.trim();

    if (isGrocery && unitVal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter unit for grocery item (e.g. kg, pcs, L)'),
          backgroundColor: AppColors.warningOrange,
        ),
      );
      return;
    }

    final newItem = ShoppingItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      quantity: _qtyController.text.trim(),
      unit: unitVal,
      itemType: _itemType,
    );

    setState(() => _isSaving = true);

    final success = await ShoppingApiService.addShoppingItem(
      name: newItem.name,
      quantity: newItem.quantity,
      unit: newItem.unit,
      itemType: newItem.itemType,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item added to Shopping List!'),
          backgroundColor: AppColors.secondaryGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, newItem);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add item. Please check connection.'),
          backgroundColor: AppColors.dangerRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;

    final isGrocery = _itemType == 'Grocery';

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Add Shopping Item',
                        style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w800)),
                    IconButton(
                      icon:
                          Icon(Icons.close_rounded, color: secondaryTextColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Item Type',
                    style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Grocery 🛒'),
                        selected: _itemType == 'Grocery',
                        selectedColor: activeColor,
                        labelStyle: TextStyle(
                            color: _itemType == 'Grocery'
                                ? Colors.white
                                : primaryTextColor,
                            fontWeight: FontWeight.w700),
                        onSelected: (val) {
                          if (val) setState(() => _itemType = 'Grocery');
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Other 📦'),
                        selected: _itemType == 'Other',
                        selectedColor: activeColor,
                        labelStyle: TextStyle(
                            color: _itemType == 'Other'
                                ? Colors.white
                                : primaryTextColor,
                            fontWeight: FontWeight.w700),
                        onSelected: (val) {
                          if (val) setState(() => _itemType = 'Other');
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Item Name *',
                  hint: 'e.g. Tomatoes or Paper Towels',
                  controller: _nameController,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Item name required'
                      : null,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: AppTextField(
                        label: 'Quantity *',
                        hint: '1',
                        controller: _qtyController,
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: AppTextField(
                        label: isGrocery
                            ? 'Unit (Required) *'
                            : 'Unit (Optional)',
                        hint: isGrocery
                            ? 'e.g. kg, g, L, pcs'
                            : 'e.g. pcs or blank',
                        controller: _unitController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isSaving ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('Add Item',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
