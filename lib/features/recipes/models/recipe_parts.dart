/// Small, forgiving JSON helpers shared by the recipe models.
///
/// Recipes can come from Gemini, the Smart Pantry API or the offline fallback
/// engine, and each names its fields slightly differently.
class RecipeJson {
  /// First non-null value found under any of [keys].
  static dynamic pick(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      if (json[key] != null) return json[key];
    }
    return null;
  }

  /// Parses `15`, `"15"` or `"15 mins"` into an int.
  static int? toInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    final match = RegExp(r'\d+').firstMatch(value.toString());
    return match == null ? null : int.tryParse(match.group(0)!);
  }

  static String text(dynamic value) => value?.toString().trim() ?? '';

  static List<RecipeIngredientDetail> ingredients(
    dynamic raw,
    String type,
  ) {
    if (raw is! List) return [];
    return raw
        .map((e) {
          if (e is Map) {
            return RecipeIngredientDetail.fromJson(
              Map<String, dynamic>.from(e),
              type: type,
            );
          }
          return RecipeIngredientDetail(
            name: e.toString(),
            quantity: '',
            type: type,
          );
        })
        .where((e) => e.name.isNotEmpty)
        .toList();
  }

  static List<RecipeStepDetail> steps(dynamic raw) {
    List<dynamic> list = [];
    if (raw is List) {
      list = raw;
    } else if (raw is String && raw.trim().isNotEmpty) {
      list = raw.split(RegExp(r'\r?\n')).where((l) => l.trim().isNotEmpty).toList();
    }
    final steps = <RecipeStepDetail>[];
    for (final e in list) {
      final index = steps.length + 1;
      if (e is Map) {
        steps.add(
          RecipeStepDetail.fromJson(Map<String, dynamic>.from(e), index: index),
        );
      } else {
        steps.add(RecipeStepDetail(stepNumber: index, instruction: e.toString()));
      }
    }
    return steps.where((s) => s.instruction.isNotEmpty).toList();
  }

  /// "85%" for 85, 0.85 or "85%". Empty when the source gave nothing.
  static String match(dynamic raw) {
    if (raw == null) return '';
    if (raw is num) {
      final pct = raw <= 1 ? raw * 100 : raw;
      return '${pct.round()}%';
    }
    final s = raw.toString().trim();
    if (s.isEmpty) return '';
    return s.contains('%') ? s : '$s%';
  }
}

/// Single ingredient detail item with quantity and source type.
class RecipeIngredientDetail {
  final String name;
  final String quantity;
  final String type; // 'available', 'assumed', 'missing'

  const RecipeIngredientDetail({
    required this.name,
    required this.quantity,
    this.type = 'available',
  });

  String get displayString => quantity.isNotEmpty ? '$name — $quantity' : name;

  factory RecipeIngredientDetail.fromJson(
    Map<String, dynamic> json, {
    String type = 'available',
  }) {
    final amount = RecipeJson.text(
      RecipeJson.pick(json, [
        'quantity',
        'amount',
        'qty',
        'required_quantity',
        'available_quantity',
      ]),
    );
    final unit = RecipeJson.text(json['unit']);
    final qty = (unit.isNotEmpty && !amount.endsWith(unit))
        ? '$amount $unit'.trim()
        : amount;

    return RecipeIngredientDetail(
      name: RecipeJson.text(
        RecipeJson.pick(json, ['name', 'ingredient', 'item']),
      ),
      quantity: qty,
      type: type,
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'quantity': quantity};
}

/// Single step detail item with duration and instruction.
class RecipeStepDetail {
  final int stepNumber;
  final String instruction;
  final int durationMinutes;

  const RecipeStepDetail({
    required this.stepNumber,
    required this.instruction,
    this.durationMinutes = 0,
  });

  factory RecipeStepDetail.fromJson(Map<String, dynamic> json, {int index = 1}) {
    return RecipeStepDetail(
      stepNumber: RecipeJson.toInt(
            RecipeJson.pick(json, ['stepNumber', 'step_number', 'step']),
          ) ??
          index,
      instruction: RecipeJson.text(
        RecipeJson.pick(json, ['instruction', 'description', 'text']),
      ),
      durationMinutes: RecipeJson.toInt(
            RecipeJson.pick(json, ['durationMinutes', 'duration_minutes', 'duration']),
          ) ??
          0,
    );
  }

  Map<String, dynamic> toJson() => {
        'stepNumber': stepNumber,
        'instruction': instruction,
        'durationMinutes': durationMinutes,
      };
}
