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

  bool get isExpiringSoon => daysUntilExpiry <= 15 && daysUntilExpiry >= 0;
  bool get isExpired => daysUntilExpiry < 0;

  static DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;
    final trimmed = raw.toString().trim();
    if (trimmed.isEmpty) return null;
    if (trimmed.contains('/')) {
      final p = trimmed.split('/');
      if (p.length == 3) {
        final d = int.tryParse(p[0]) ?? 1;
        final m = int.tryParse(p[1]) ?? 1;
        var y = int.tryParse(p[2]) ?? 2026;
        if (y < 100) y += 2000;
        return DateTime(y, m, d);
      }
    } else if (trimmed.contains('-')) {
      final p = trimmed.split('-');
      if (p.length == 3) {
        if (p[0].length == 4) {
          return DateTime.tryParse(trimmed);
        } else {
          final d = int.tryParse(p[0]) ?? 1;
          final m = int.tryParse(p[1]) ?? 1;
          var y = int.tryParse(p[2]) ?? 2026;
          if (y < 100) y += 2000;
          return DateTime(y, m, d);
        }
      }
    }
    return DateTime.tryParse(trimmed);
  }

  factory PantryItem.fromJson(Map<String, dynamic> json) {
    final expDate = _parseDate(json['expiry_date']);
    final purchaseDate =
        _parseDate(json['purchase_date'] ?? json['added_date']);

    final qtyNum = json['quantity'];
    final priceVal = json['price'];
    double? parsedPrice;
    if (priceVal != null) {
      if (priceVal is num) {
        parsedPrice = priceVal.toDouble();
      } else {
        parsedPrice = double.tryParse(priceVal.toString());
      }
    }

    return PantryItem(
      id: (json['id'] ?? DateTime.now().millisecondsSinceEpoch).toString(),
      name: json['display_name'] ?? json['name'] ?? 'Unknown Item',
      category: json['category'] ?? 'Other',
      quantity: qtyNum != null ? qtyNum.toString() : '1',
      unit: json['default_unit'] ?? json['unit'] ?? 'pcs',
      expiryDate: expDate,
      estimatedPrice: parsedPrice,
      storageLocation: json['store'] ?? json['storage'] ?? 'Pantry',
      brand: json['brand'] ?? '',
      subcategory: json['subcategory'] ?? '',
      size: json['size'] ?? '',
      addedDate: purchaseDate,
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
