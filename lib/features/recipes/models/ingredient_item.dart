/// Simple model for an ingredient with name and available quantity.
class IngredientItem {
  final String id;
  final String name;
  final String quantity;
  final String unit;

  const IngredientItem({
    required this.id,
    required this.name,
    required this.quantity,
    this.unit = 'pcs',
  });

  String get displayQty => '$quantity $unit'.trim();

  IngredientItem copyWith({
    String? id,
    String? name,
    String? quantity,
    String? unit,
  }) {
    return IngredientItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }
}
