import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../models/pantry_item.dart';
import '../widgets/manual_entry_form_helpers.dart';

/// Professional, executive-grade manual item entry screen with vector icons.
class ManualItemEntryScreen extends StatefulWidget {
  final Function(PantryItem)? onItemAdded;

  const ManualItemEntryScreen({super.key, this.onItemAdded});

  @override
  State<ManualItemEntryScreen> createState() => _ManualItemEntryScreenState();
}

class _ManualItemEntryScreenState extends State<ManualItemEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController(text: '1');
  final _priceController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _qtyFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  String _selectedCategory = 'Vegetables';
  String _selectedUnit = 'pcs';
  String _selectedStorage = 'Pantry';
  int _selectedExpiryDays = 7;
  DateTime? _customExpiryDate;

  final List<Map<String, dynamic>> _categories = const [
    {'name': 'Vegetables', 'icon': Icons.eco_rounded},
    {'name': 'Fruits', 'icon': Icons.apple_rounded},
    {'name': 'Dairy', 'icon': Icons.local_drink_rounded},
    {'name': 'Grains & Pulses', 'icon': Icons.grain_rounded},
    {'name': 'Spices', 'icon': Icons.local_fire_department_rounded},
    {'name': 'Bakery', 'icon': Icons.bakery_dining_rounded},
    {'name': 'Beverages', 'icon': Icons.local_cafe_rounded},
    {'name': 'Snacks', 'icon': Icons.fastfood_rounded},
    {'name': 'Other', 'icon': Icons.inventory_2_rounded},
  ];

  final List<String> _units = const [
    'pcs',
    'g',
    'kg',
    'ml',
    'L',
    'pack',
    'katori',
    'tbsp',
  ];
  final List<Map<String, dynamic>> _expiryOptions = const [
    {'label': '3 Days', 'days': 3},
    {'label': '1 Week', 'days': 7},
    {'label': '2 Weeks', 'days': 14},
    {'label': '1 Month', 'days': 30},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    _priceController.dispose();
    _nameFocusNode.dispose();
    _qtyFocusNode.dispose();
    _priceFocusNode.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    final expiry =
        _customExpiryDate ??
        DateTime.now().add(Duration(days: _selectedExpiryDays));
    final price = double.tryParse(_priceController.text.trim());
    final newItem = PantryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      category: _selectedCategory,
      quantity: _qtyController.text.trim(),
      unit: _selectedUnit,
      expiryDate: expiry,
      estimatedPrice: price,
      storageLocation: _selectedStorage,
    );
    widget.onItemAdded?.call(newItem);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "${newItem.name}" to Pantry!'),
        backgroundColor: AppColors.secondaryGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context, newItem);
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
    final cardBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: primaryTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Inventory Item',
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ManualEntryFormHelpers.buildLabel('Item Name', primaryTextColor),
              TextFormField(
                controller: _nameController,
                focusNode: _nameFocusNode,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_qtyFocusNode),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Enter item name'
                    : null,
                style: TextStyle(color: primaryTextColor),
                decoration: ManualEntryFormHelpers.inputDeco(
                  hint: 'e.g. Fresh Tomatoes, Besan, Milk',
                  bg: cardBg,
                  border: borderColor,
                  hintColor: secondaryTextColor,
                  prefixIcon: Icon(
                    Icons.edit_outlined,
                    color: secondaryTextColor,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ManualEntryFormHelpers.buildLabel('Category', primaryTextColor),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final String catName = cat['name'] as String;
                    final isSelected = _selectedCategory == catName;
                    return ChoiceChip(
                      avatar: Icon(
                        cat['icon'] as IconData,
                        size: 14,
                        color: isSelected ? Colors.white : primaryTextColor,
                      ),
                      label: Text(catName),
                      selected: isSelected,
                      selectedColor: activeColor,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : primaryTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (_) =>
                          setState(() => _selectedCategory = catName),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ManualEntryFormHelpers.buildLabel(
                          'Quantity',
                          primaryTextColor,
                        ),
                        TextFormField(
                          controller: _qtyController,
                          focusNode: _qtyFocusNode,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) => FocusScope.of(
                            context,
                          ).requestFocus(_priceFocusNode),
                          validator: (val) => val == null || val.trim().isEmpty
                              ? 'Enter qty'
                              : null,
                          style: TextStyle(color: primaryTextColor),
                          decoration: ManualEntryFormHelpers.inputDeco(
                            hint: '1',
                            bg: cardBg,
                            border: borderColor,
                            hintColor: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ManualEntryFormHelpers.buildLabel(
                          'Unit',
                          primaryTextColor,
                        ),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedUnit,
                          dropdownColor: isDark
                              ? const Color(0xFF1E293B)
                              : Colors.white,
                          style: TextStyle(
                            color: primaryTextColor,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: ManualEntryFormHelpers.inputDeco(
                            hint: '',
                            bg: cardBg,
                            border: borderColor,
                            hintColor: secondaryTextColor,
                          ),
                          items: _units
                              .map(
                                (u) =>
                                    DropdownMenuItem(value: u, child: Text(u)),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedUnit = val ?? 'pcs'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ManualEntryFormHelpers.buildLabel(
                'Shelf Life / Expiry',
                primaryTextColor,
              ),
              Wrap(
                spacing: 8,
                children: _expiryOptions.map((opt) {
                  final isSel =
                      _selectedExpiryDays == opt['days'] &&
                      _customExpiryDate == null;
                  return ChoiceChip(
                    label: Text(opt['label'] as String),
                    selected: isSel,
                    selectedColor: AppColors.warningOrange,
                    labelStyle: TextStyle(
                      color: isSel ? Colors.white : primaryTextColor,
                      fontSize: 12,
                    ),
                    onSelected: (_) => setState(() {
                      _selectedExpiryDays = opt['days'] as int;
                      _customExpiryDate = null;
                    }),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ManualEntryFormHelpers.buildLabel(
                'Storage Location',
                primaryTextColor,
              ),
              Row(
                children:
                    [
                      {'name': 'Pantry', 'icon': Icons.inventory_2_rounded},
                      {'name': 'Fridge', 'icon': Icons.kitchen_rounded},
                      {'name': 'Freezer', 'icon': Icons.ac_unit_rounded},
                    ].map((loc) {
                      final String locName = loc['name'] as String;
                      final isSel = _selectedStorage == locName;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            avatar: Icon(
                              loc['icon'] as IconData,
                              size: 14,
                              color: isSel ? Colors.white : primaryTextColor,
                            ),
                            label: Text(
                              locName,
                              style: TextStyle(
                                color: isSel ? Colors.white : primaryTextColor,
                                fontSize: 12,
                              ),
                            ),
                            selected: isSel,
                            selectedColor: isDark
                                ? AppColors.darkAiPurple
                                : AppColors.aiPurple,
                            onSelected: (_) =>
                                setState(() => _selectedStorage = locName),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.check_circle_rounded, size: 20),
                label: const Text('Save to Inventory'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: activeColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
