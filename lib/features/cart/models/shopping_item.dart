/// Model representing a Shopping List item.
class ShoppingItem {
  final String id;
  final String name;
  final String quantity;
  final String unit;
  final String itemType;
  final bool isChecked;

  ShoppingItem({
    required this.id,
    required this.name,
    required this.quantity,
    this.unit = '',
    this.itemType = 'Grocery',
    this.isChecked = false,
  });

  String get formattedQuantity {
    final parsed = num.tryParse(quantity);
    if (parsed != null && parsed == parsed.roundToDouble()) {
      return parsed.toInt().toString();
    }
    return quantity;
  }

  String get displayQtyUnit {
    final q = formattedQuantity.trim();
    final u = unit.trim();
    if (u.isEmpty) return q;
    return '$q $u';
  }

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    final rawQty = json['quantity'] ?? json['qty'] ?? json['size'] ?? 1;
    final qtyStr = (rawQty is num && rawQty == rawQty.roundToDouble())
        ? rawQty.toInt().toString()
        : rawQty.toString();

    final rawUnit = json['unit'] ?? json['default_unit'] ?? '';
    final rawName = json['name'] ??
        json['display_name'] ??
        json['item_name'] ??
        json['original_name'] ??
        'Item';
    final rawType = json['item_type'] ??
        json['type'] ??
        json['category'] ??
        json['source'] ??
        'Grocery';
    final rawChecked =
        json['is_checked'] ?? json['checked'] ?? json['completed'] ?? false;
    final rawId = json['id'] ?? DateTime.now().millisecondsSinceEpoch;

    return ShoppingItem(
      id: rawId.toString(),
      name: rawName.toString(),
      quantity: qtyStr,
      unit: rawUnit.toString(),
      itemType: rawType.toString(),
      isChecked: rawChecked == true || rawChecked.toString() == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': num.tryParse(quantity) ?? 1,
      'unit': unit,
      'item_type': itemType,
    };
  }

  ShoppingItem copyWith({
    String? id,
    String? name,
    String? quantity,
    String? unit,
    String? itemType,
    bool? isChecked,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      itemType: itemType ?? this.itemType,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
