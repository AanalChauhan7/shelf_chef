import 'package:flutter/material.dart';
import '../../recipes/models/generated_recipe.dart';

/// Helper dialogs for the Shopping Cart tab: recipe selection and clear confirmation.
class CartDialogs {
  const CartDialogs._();

  /// Prompts the user to pick which saved recipe to generate missing items for.
  static Future<String?> pickRecipe(
    BuildContext context,
    List<GeneratedRecipe> saved,
  ) async {
    if (saved.isEmpty) return null;
    if (saved.length == 1) return saved.first.name;

    return showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Generate missing items for:'),
        children: saved
            .map(
              (r) => SimpleDialogOption(
                onPressed: () => Navigator.pop(ctx, r.name),
                child: Text(r.name),
              ),
            )
            .toList(),
      ),
    );
  }

  /// Prompts for confirmation before clearing the entire shopping list.
  static Future<bool> confirmClear(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear shopping list?'),
        content: const Text('This removes every item from your list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    return confirmed == true;
  }
}
