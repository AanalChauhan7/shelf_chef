import '../../features/recipes/models/generated_recipe.dart';

/// Builds the `POST /saved-recipes` body and adapts it to the 422 validation
/// errors FastAPI returns.
///
/// The exact request schema isn't known up front, so the first attempt sends
/// the recipe under many common field names (unknown fields are ignored by
/// FastAPI by default). Each 422 response then tells us which fields are
/// missing, forbidden or of the wrong type, and [adaptTo] fixes them.
class SavedRecipePayload {
  final GeneratedRecipe recipe;
  final Map<String, dynamic> fields = {};

  SavedRecipePayload(this.recipe) {
    for (final key in _initialKeys) {
      fields[key] = _valueFor(key);
    }
  }

  static const List<String> _initialKeys = [
    'name', 'title', 'recipe_name', 'description', 'category', 'cuisine',
    'servings', 'difficulty', 'calories', 'ingredients', 'instructions',
    'steps', 'prep_time_minutes', 'cook_time_minutes', 'total_time_minutes',
    'calories_per_serving', 'available_ingredients', 'missing_ingredients',
    'assumed_staples', 'chef_tip', 'image_url', 'prepTimeMinutes',
    'cookTimeMinutes', 'totalTimeMinutes', 'caloriesPerServing',
    'availableIngredients', 'missingIngredients', 'assumedStaples', 'chefTip',
    'imageUrl',
  ];

  dynamic _valueFor(String key) {
    final r = recipe;
    switch (key.toLowerCase().replaceAll(RegExp(r'[_\- ]'), '')) {
      case 'name':
      case 'title':
      case 'recipename':
      case 'recipetitle':
      case 'dishname':
        return r.name;
      case 'description':
      case 'summary':
        return r.description;
      case 'category':
      case 'cuisine':
      case 'type':
      case 'recipetype':
      case 'mealtype':
        return r.category;
      case 'servings':
      case 'serves':
      case 'peoplecount':
        return r.servings;
      case 'preptimeminutes':
      case 'preptime':
        return r.prepTimeMinutes;
      case 'cooktimeminutes':
      case 'cooktime':
        return r.cookTimeMinutes;
      case 'totaltimeminutes':
      case 'totaltime':
      case 'time':
        return r.totalTimeMinutes;
      case 'difficulty':
        return r.difficulty;
      case 'calories':
      case 'caloriesperserving':
        return r.caloriesPerServing;
      case 'ingredients':
        return r.allIngredientDetails.map((e) => e.toJson()).toList();
      case 'availableingredients':
        return r.availableIngredients.map((e) => e.toJson()).toList();
      case 'missingingredients':
        return r.missingIngredients.map((e) => e.toJson()).toList();
      case 'assumedstaples':
        return r.assumedStaples.map((e) => e.toJson()).toList();
      case 'instructions':
      case 'directions':
      case 'method':
        return r.instructions;
      case 'steps':
        return r.steps.map((e) => e.toJson()).toList();
      case 'cheftip':
      case 'tip':
      case 'notes':
        return r.chefTip;
      case 'imageurl':
      case 'image':
      case 'thumbnail':
        return r.imageUrl ?? '';
      case 'recipe':
      case 'recipedata':
      case 'data':
      case 'details':
      case 'content':
      case 'payload':
        return r.toApiJson();
      default:
        return '';
    }
  }

  /// Fixes [fields] using a FastAPI 422 body. Returns true if anything changed
  /// (i.e. a retry is worthwhile).
  bool adaptTo(dynamic data) {
    final detail = data is Map ? data['detail'] : null;
    if (detail is! List) return false;
    var changed = false;
    for (final e in detail) {
      if (e is! Map || e['loc'] is! List) continue;
      final loc = List<dynamic>.from(e['loc'] as List);
      if (loc.length < 2 || loc.first != 'body') continue;
      final kind = '${e['type']} ${e['msg']}'.toLowerCase();
      if (_fix(loc[1].toString(), loc.sublist(2), kind)) changed = true;
    }
    return changed;
  }

  bool _fix(String key, List<dynamic> rest, String kind) {
    if (kind.contains('extra')) return fields.remove(key) != null;

    if (kind.contains('missing') || kind.contains('required')) {
      if (rest.isEmpty) {
        if (fields.containsKey(key)) return false;
        fields[key] = _valueFor(key);
        return true;
      }
      var changed = false;
      final list = fields[key];
      if (list is List) {
        for (final item in list) {
          if (item is Map && !item.containsKey(rest.last.toString())) {
            item[rest.last.toString()] = '';
            changed = true;
          }
        }
      }
      return changed;
    }

    final value = fields[key];
    if (value == null) return false;
    final isText = kind.contains('string') || kind.contains('str_type');
    final isList = kind.contains('list') || kind.contains('array');
    final isInt = kind.contains('integer') || kind.contains('int_');
    final isObject = kind.contains('dict') ||
        kind.contains('model_attributes') ||
        kind.contains('valid object');

    if (rest.isEmpty) {
      if (isText) {
        fields[key] = _asText(value);
      } else if (isList && value is! List) {
        fields[key] = value is String
            ? value.split(RegExp(r'\r?\n'))
            : [value];
      } else if (isInt) {
        fields[key] = RecipeJson.toInt(value) ?? 0;
      } else if (isObject) {
        fields[key] = recipe.toApiJson();
      } else {
        return false;
      }
      return true;
    }

    if (value is List) {
      if (isText) {
        fields[key] = value.map(_asText).toList();
        return true;
      }
      if (isObject) {
        fields[key] = value
            .map((v) => v is Map ? v : {'name': v.toString()})
            .toList();
        return true;
      }
    }
    return false;
  }

  static String _asText(dynamic v) {
    if (v is List) return v.map(_asText).join('\n');
    if (v is Map) {
      final text = v['instruction'] ?? v['description'];
      if (text != null) return text.toString();
      final name = v['name']?.toString() ?? '';
      final qty = v['quantity']?.toString() ?? '';
      return qty.isEmpty ? name : '$name $qty';
    }
    return v?.toString() ?? '';
  }

  /// Short human-readable summary of a 422 body, e.g. "ingredients: Field required".
  static String describe(dynamic data) {
    final detail = data is Map ? data['detail'] : null;
    if (detail is String) return detail;
    if (detail is! List) return '';
    return detail.whereType<Map>().take(3).map((e) {
      final loc = e['loc'] is List
          ? (e['loc'] as List).skip(1).join('.')
          : '';
      return '$loc: ${e['msg']}';
    }).join('; ');
  }
}
