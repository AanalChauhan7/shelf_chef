import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../models/pantry_item.dart';
import '../widgets/manual_entry_form_sections.dart';

/// Executive-grade manual inventory entry screen with modern cards & date picker.
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
  final _expiryController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _qtyFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _expiryFocusNode = FocusNode();

  String _selectedCategory = 'Vegetables';
  String _selectedUnit = 'pcs';
  String _selectedStorage = 'Pantry';
  DateTime? _selectedExpiryDate;
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _categories = const [
    {'name': 'Vegetables', 'icon': Icons.eco_rounded},
    {'name': 'Fruits', 'icon': Icons.apple_rounded},
    {'name': 'Dairy', 'icon': Icons.local_drink_rounded},
    {'name': 'Grains & Pulses', 'icon': Icons.grain_rounded},
    {'name': 'Spices', 'icon': Icons.local_fire_department_rounded},
    {'name': 'Snacks', 'icon': Icons.fastfood_rounded},
    {'name': 'Other', 'icon': Icons.inventory_2_rounded},
  ];

  final List<String> _units = const ['pcs', 'g', 'kg', 'ml', 'L', 'pack', 'packet', 'tbsp'];

  @override
  void initState() {
    super.initState();
    _selectedExpiryDate = DateTime.now().add(const Duration(days: 7));
    _expiryController.text = _formatDate(_selectedExpiryDate!);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    _priceController.dispose();
    _expiryController.dispose();
    _nameFocusNode.dispose();
    _qtyFocusNode.dispose();
    _priceFocusNode.dispose();
    _expiryFocusNode.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = (dt.year % 100).toString().padLeft(2, '0');
    return '$d/$m/$y';
  }

  DateTime? _parseDateString(String text) {
    final clean = text.trim();
    if (clean.contains('/')) {
      final p = clean.split('/');
      if (p.length == 3) {
        final d = int.tryParse(p[0]) ?? 1;
        final m = int.tryParse(p[1]) ?? 1;
        var y = int.tryParse(p[2]) ?? 2026;
        if (y < 100) y += 2000;
        return DateTime(y, m, d);
      }
    }
    return DateTime.tryParse(clean);
  }

  Future<void> _pickExpiryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedExpiryDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 1825)),
    );
    if (picked != null) {
      setState(() {
        _selectedExpiryDate = picked;
        _expiryController.text = _formatDate(picked);
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final expiry = _parseDateString(_expiryController.text) ??
        _selectedExpiryDate ??
        DateTime.now().add(const Duration(days: 7));
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

    await PantryApiService.addSinglePantryItem(newItem);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    widget.onItemAdded?.call(newItem);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item added successfully!'),
        backgroundColor: AppColors.secondaryGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context, newItem);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Inventory Item',
          style: TextStyle(
            color: primaryColor,
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
              ItemDetailsSectionCard(
                isDark: isDark,
                primary: primaryColor,
                secondary: secondaryColor,
                active: activeColor,
                nameController: _nameController,
                nameFocusNode: _nameFocusNode,
                qtyFocusNode: _qtyFocusNode,
                categories: _categories,
                selectedCategory: _selectedCategory,
                onSelectCategory: (cat) =>
                    setState(() => _selectedCategory = cat),
              ),
              const SizedBox(height: 16),
              QuantityAndPriceSectionCard(
                isDark: isDark,
                primary: primaryColor,
                secondary: secondaryColor,
                qtyController: _qtyController,
                priceController: _priceController,
                qtyFocusNode: _qtyFocusNode,
                priceFocusNode: _priceFocusNode,
                expiryFocusNode: _expiryFocusNode,
                units: _units,
                selectedUnit: _selectedUnit,
                onSelectUnit: (unit) => setState(() => _selectedUnit = unit),
              ),
              const SizedBox(height: 16),
              StorageAndExpirySectionCard(
                isDark: isDark,
                primary: primaryColor,
                secondary: secondaryColor,
                active: activeColor,
                expiryController: _expiryController,
                expiryFocusNode: _expiryFocusNode,
                onPickExpiryDate: _pickExpiryDate,
                onSubmit: _submitForm,
                selectedStorage: _selectedStorage,
                onSelectStorage: (loc) => setState(() => _selectedStorage = loc),
              ),
              const SizedBox(height: 28),
              _buildSubmitButton(activeColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(Color activeColor) {
    return ElevatedButton.icon(
      onPressed: _isSubmitting ? null : _submitForm,
      icon: _isSubmitting
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.check_circle_rounded, size: 20),
      label: Text(_isSubmitting ? 'Saving item...' : 'Save to Inventory'),
      style: ElevatedButton.styleFrom(
        backgroundColor: activeColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
      ),
    );
  }
}
