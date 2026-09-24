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

  PantryItem({
    required this.id,
    required this.name,
    this.category = 'Other',
    required this.quantity,
    this.unit = 'pcs',
    this.expiryDate,
    this.estimatedPrice,
    this.storageLocation = 'Pantry',
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

  PantryItem copyWith({
    String? id,
    String? name,
    String? category,
    String? quantity,
    String? unit,
    DateTime? expiryDate,
    double? estimatedPrice,
    String? storageLocation,
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
      addedDate: addedDate ?? this.addedDate,
    );
  }
}
