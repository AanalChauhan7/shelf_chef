import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../models/ingredient_item.dart';

/// Form inputs for entering ingredient name, quantity, and unit.
class IngredientAddForm extends StatefulWidget {
  final ValueChanged<IngredientItem> onAdd;

  const IngredientAddForm({super.key, required this.onAdd});

  @override
  State<IngredientAddForm> createState() => _IngredientAddFormState();
}

class _IngredientAddFormState extends State<IngredientAddForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  String _selectedUnit = 'pcs';

  final List<String> _units = ['pcs', 'g', 'kg', 'ml', 'L', 'cups', 'tbsp'];

  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final qty = _qtyController.text.trim();
    if (name.isEmpty) return;

    widget.onAdd(
      IngredientItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        quantity: qty.isEmpty ? '1' : qty,
        unit: _selectedUnit,
      ),
    );
    _nameController.clear();
    _qtyController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkCard : AppColors.surface;
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: TextField(
            controller: _nameController,
            style: TextStyle(color: primaryTextColor, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Ingredient (e.g. Tomato)',
              hintStyle: TextStyle(color: secondaryTextColor, fontSize: 12),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              filled: true,
              fillColor: isDark
                  ? const Color(0xFF0F172A)
                  : const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          flex: 3,
          child: TextField(
            controller: _qtyController,
            keyboardType: TextInputType.number,
            style: TextStyle(color: primaryTextColor, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Qty',
              hintStyle: TextStyle(color: secondaryTextColor, fontSize: 12),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 10,
              ),
              filled: true,
              fillColor: isDark
                  ? const Color(0xFF0F172A)
                  : const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        DropdownButton<String>(
          value: _selectedUnit,
          dropdownColor: cardBg,
          isDense: true,
          underline: const SizedBox(),
          items: _units.map((unit) {
            return DropdownMenuItem(
              value: unit,
              child: Text(
                unit,
                style: TextStyle(color: primaryTextColor, fontSize: 11.5),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) setState(() => _selectedUnit = val);
          },
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: _submit,
          icon: const Icon(Icons.add_rounded, size: 20, color: Colors.white),
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          style: IconButton.styleFrom(
            backgroundColor: isDark
                ? AppColors.darkAiPurple
                : AppColors.aiPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
