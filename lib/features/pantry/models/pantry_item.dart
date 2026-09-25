/// Model representing an item in the user's Pantry Inventory.
class PantryItem {
  final String id;
  final String name;
  final String category;
  final String quantity;
  final String unit;
  final DateTime? expiryDate;
  final double? estimatedPrice;
  final String storageLocation;
  final DateTime addedDate;

  final String brand;
  final String subcategory;
  final String size;

  PantryItem({
    required this.id,
    required this.name,
    this.category = 'Other',
    required this.quantity,
    this.unit = 'pcs',
    this.expiryDate,
    this.estimatedPrice,
    this.storageLocation = 'Pantry',
    this.brand = '',
    this.subcategory = '',
    this.size = '',
    DateTime? addedDate,
  }) : addedDate = addedDate ?? DateTime.now();

  String get displayQty => '$quantity $unit'.trim();

  int get daysUntilExpiry {
    if (expiryDate == null) return 999;
    final now = DateTime.now();
    return expiryDate!
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  bool get isExpiringSoon => daysUntilExpiry <= 3 && daysUntilExpiry >= 0;
  bool get isExpired => daysUntilExpiry < 0;

  factory PantryItem.fromJson(Map<String, dynamic> json) {
    DateTime? expDate;
    final rawExp = json['expiry_date'] as String?;
    if (rawExp != null && rawExp.isNotEmpty) {
      if (rawExp.contains('/')) {
        final p = rawExp.split('/');
        if (p.length == 3) {
          final d = int.tryParse(p[0]) ?? 1;
          final m = int.tryParse(p[1]) ?? 1;
          var y = int.tryParse(p[2]) ?? 2026;
          if (y < 100) y += 2000;
          expDate = DateTime(y, m, d);
        }
      } else {
        expDate = DateTime.tryParse(rawExp);
      }
    }

    final qtyNum = json['quantity'];
    final priceNum = json['price'];

    return PantryItem(
      id: (json['id'] ?? DateTime.now().millisecondsSinceEpoch).toString(),
      name: json['display_name'] ?? json['name'] ?? 'Unknown Item',
      category: json['category'] ?? 'Other',
      quantity: qtyNum != null ? qtyNum.toString() : '1',
      unit: json['default_unit'] ?? json['unit'] ?? 'pcs',
      expiryDate: expDate,
      estimatedPrice: priceNum != null ? (priceNum as num).toDouble() : null,
      storageLocation: json['store'] ?? json['storage'] ?? 'Pantry',
      brand: json['brand'] ?? '',
      subcategory: json['subcategory'] ?? '',
      size: json['size'] ?? '',
    );
  }

  Map<String, dynamic> toBulkPostJson() {
    final exp = expiryDate;
    final expFormatted = exp != null
        ? '${exp.day.toString().padLeft(2, '0')}/${exp.month.toString().padLeft(2, '0')}/${(exp.year % 100).toString().padLeft(2, '0')}'
        : '';
    final now = DateTime.now();
    final purchaseFormatted =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${(now.year % 100).toString().padLeft(2, '0')}';

    return {
      'name': name,
      'quantity': num.tryParse(quantity) ?? 1,
      'unit': unit,
      'brand': brand,
      'category': category,
      'subcategory': subcategory,
      'storage': storageLocation == 'Fridge' ? 'Refrigerator' : storageLocation,
      'size': size,
      'price': estimatedPrice ?? 0,
      'purchase_date': purchaseFormatted,
      'expiry_date': expFormatted,
      'store': storageLocation,
    };
  }

  PantryItem copyWith({
    String? id,
    String? name,
    String? category,
    String? quantity,
    String? unit,
    DateTime? expiryDate,
    double? estimatedPrice,
    String? storageLocation,
    String? brand,
    String? subcategory,
    String? size,
    DateTime? addedDate,
  }) {
    return PantryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      expiryDate: expiryDate ?? this.expiryDate,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      storageLocation: storageLocation ?? this.storageLocation,
      brand: brand ?? this.brand,
      subcategory: subcategory ?? this.subcategory,
      size: size ?? this.size,
      addedDate: addedDate ?? this.addedDate,
    );
  }
}
