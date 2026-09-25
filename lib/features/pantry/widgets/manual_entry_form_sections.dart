import 'package:flutter/material.dart';
import '../../../core/core.dart';
import 'manual_entry_form_helpers.dart';

/// Section 1: Item Name & Category
class ItemDetailsSectionCard extends StatelessWidget {
  final bool isDark;
  final Color primary;
  final Color secondary;
  final Color active;
  final TextEditingController nameController;
  final FocusNode nameFocusNode;
  final FocusNode qtyFocusNode;
  final List<Map<String, dynamic>> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelectCategory;

  const ItemDetailsSectionCard({
    super.key,
    required this.isDark,
    required this.primary,
    required this.secondary,
    required this.active,
    required this.nameController,
    required this.nameFocusNode,
    required this.qtyFocusNode,
    required this.categories,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    final inputBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return ManualEntryFormHelpers.buildSectionCard(
      title: 'Item Details',
      icon: Icons.inventory_2_rounded,
      isDark: isDark,
      primaryColor: primary,
      secondaryColor: secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ManualEntryFormHelpers.buildLabel('Item Name', primary),
          TextFormField(
            controller: nameController,
            focusNode: nameFocusNode,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(qtyFocusNode),
            validator: (val) =>
                val == null || val.trim().isEmpty ? 'Enter item name' : null,
            style: TextStyle(color: primary, fontSize: 14),
            decoration: ManualEntryFormHelpers.inputDeco(
              hint: 'e.g. Fresh Tomatoes, Besan, Amul Milk',
              bg: inputBg,
              border: borderColor,
              hintColor: secondary,
              prefixIcon: Icon(Icons.edit_outlined, color: secondary, size: 18),
            ),
          ),
          const SizedBox(height: 14),
          ManualEntryFormHelpers.buildLabel('Category', primary),
          ManualEntryFormHelpers.buildCategoryChips(
            categories: categories,
            selectedCategory: selectedCategory,
            onSelect: onSelectCategory,
            primaryTextColor: primary,
            activeColor: active,
          ),
        ],
      ),
    );
  }
}

/// Section 2: Quantity, Unit & Price
class QuantityAndPriceSectionCard extends StatelessWidget {
  final bool isDark;
  final Color primary;
  final Color secondary;
  final TextEditingController qtyController;
  final TextEditingController priceController;
  final FocusNode qtyFocusNode;
  final FocusNode priceFocusNode;
  final FocusNode expiryFocusNode;
  final List<String> units;
  final String selectedUnit;
  final ValueChanged<String> onSelectUnit;

  const QuantityAndPriceSectionCard({
    super.key,
    required this.isDark,
    required this.primary,
    required this.secondary,
    required this.qtyController,
    required this.priceController,
    required this.qtyFocusNode,
    required this.priceFocusNode,
    required this.expiryFocusNode,
    required this.units,
    required this.selectedUnit,
    required this.onSelectUnit,
  });

  @override
  Widget build(BuildContext context) {
    final inputBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return ManualEntryFormHelpers.buildSectionCard(
      title: 'Quantity & Pricing',
      icon: Icons.payments_rounded,
      isDark: isDark,
      primaryColor: primary,
      secondaryColor: secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ManualEntryFormHelpers.buildLabel('Quantity', primary),
                    TextFormField(
                      controller: qtyController,
                      focusNode: qtyFocusNode,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(priceFocusNode),
                      validator: (val) =>
                          val == null || val.trim().isEmpty ? 'Enter qty' : null,
                      style: TextStyle(color: primary, fontSize: 14),
                      decoration: ManualEntryFormHelpers.inputDeco(
                        hint: '1',
                        bg: inputBg,
                        border: borderColor,
                        hintColor: secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ManualEntryFormHelpers.buildLabel('Unit', primary),
                    DropdownButtonFormField<String>(
                      initialValue: selectedUnit,
                      dropdownColor:
                          isDark ? const Color(0xFF1E293B) : Colors.white,
                      style: TextStyle(
                        color: primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: ManualEntryFormHelpers.inputDeco(
                        hint: '',
                        bg: inputBg,
                        border: borderColor,
                        hintColor: secondary,
                      ),
                      items: units
                          .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                          .toList(),
                      onChanged: (val) => onSelectUnit(val ?? 'pcs'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ManualEntryFormHelpers.buildLabel('Price (₹)', primary),
          TextFormField(
            controller: priceController,
            focusNode: priceFocusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(expiryFocusNode),
            style: TextStyle(color: primary, fontSize: 14),
            decoration: ManualEntryFormHelpers.inputDeco(
              hint: 'e.g. 100',
              bg: inputBg,
              border: borderColor,
              hintColor: secondary,
              prefixIcon: Icon(
                Icons.currency_rupee_rounded,
                color: secondary,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Section 3: Storage & Expiry DatePicker
class StorageAndExpirySectionCard extends StatelessWidget {
  final bool isDark;
  final Color primary;
  final Color secondary;
  final Color active;
  final TextEditingController expiryController;
  final FocusNode expiryFocusNode;
  final VoidCallback onPickExpiryDate;
  final VoidCallback onSubmit;
  final String selectedStorage;
  final ValueChanged<String> onSelectStorage;

  const StorageAndExpirySectionCard({
    super.key,
    required this.isDark,
    required this.primary,
    required this.secondary,
    required this.active,
    required this.expiryController,
    required this.expiryFocusNode,
    required this.onPickExpiryDate,
    required this.onSubmit,
    required this.selectedStorage,
    required this.onSelectStorage,
  });

  @override
  Widget build(BuildContext context) {
    final inputBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return ManualEntryFormHelpers.buildSectionCard(
      title: 'Storage & Expiry',
      icon: Icons.calendar_today_rounded,
      isDark: isDark,
      primaryColor: primary,
      secondaryColor: secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ManualEntryFormHelpers.buildLabel('Expiry Date', primary),
          TextFormField(
            controller: expiryController,
            focusNode: expiryFocusNode,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => onSubmit(),
            style: TextStyle(color: primary, fontSize: 14),
            decoration: ManualEntryFormHelpers.inputDeco(
              hint: 'DD/MM/YY (e.g. 30/09/26)',
              bg: inputBg,
              border: borderColor,
              hintColor: secondary,
              prefixIcon: Icon(
                Icons.edit_calendar_rounded,
                color: secondary,
                size: 18,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_month_rounded, color: active),
                onPressed: onPickExpiryDate,
                tooltip: 'Pick Expiry Date',
              ),
            ),
          ),
          const SizedBox(height: 14),
          ManualEntryFormHelpers.buildLabel('Storage Location', primary),
          ManualEntryFormHelpers.buildStorageRow(
            selectedStorage: selectedStorage,
            onSelect: onSelectStorage,
            primaryTextColor: primary,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}
