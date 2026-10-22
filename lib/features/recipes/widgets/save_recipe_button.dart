import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../../core/services/app_language_service.dart';
import '../../../core/services/recipe_store.dart';
import '../models/generated_recipe.dart';

/// Bookmark button that saves / un-saves a recipe with instant local persistence
/// and background server sync, reporting the updated recipe via [onChanged].
class SaveRecipeButton extends StatefulWidget {
  final GeneratedRecipe recipe;
  final String language;
  final ValueChanged<GeneratedRecipe>? onChanged;

  const SaveRecipeButton({
    super.key,
    required this.recipe,
    this.language = 'English',
    this.onChanged,
  });

  @override
  State<SaveRecipeButton> createState() => _SaveRecipeButtonState();
}

class _SaveRecipeButtonState extends State<SaveRecipeButton> {
  late GeneratedRecipe _recipe;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _recipe = widget.recipe;
    _syncWithStore();
  }

  @override
  void didUpdateWidget(covariant SaveRecipeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.recipe.name != oldWidget.recipe.name ||
        widget.recipe.id != oldWidget.recipe.id) {
      _recipe = widget.recipe;
      _syncWithStore();
    }
  }

  void _syncWithStore() {
    final isSaved = RecipeStore.instance.isRecipeSaved(_recipe);
    if (isSaved && !_recipe.isSaved) {
      final match = RecipeStore.instance.saved.firstWhere(
        (s) => s.name.trim().toLowerCase() == _recipe.name.trim().toLowerCase(),
        orElse: () => _recipe,
      );
      _recipe = _recipe.withId(match.id ?? 'saved');
    } else if (!isSaved && _recipe.isSaved) {
      _recipe = _recipe.withId(null);
    }
  }

  Future<void> _toggleSaved() async {
    if (_busy) return;
    setState(() => _busy = true);

    try {
      final wasSaved = RecipeStore.instance.isRecipeSaved(_recipe);
      final updated = await RecipeStore.instance.toggleSaveRecipe(_recipe);
      if (mounted) {
        setState(() {
          _recipe = updated;
        });
      }
      widget.onChanged?.call(updated);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              wasSaved
                  ? AppLanguageService.tr('recipe_removed', widget.language)
                  : AppLanguageService.tr('recipe_saved', widget.language),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.darkAiPurple : AppColors.aiPurple;

    return ListenableBuilder(
      listenable: RecipeStore.instance,
      builder: (context, _) {
        final saved = RecipeStore.instance.isRecipeSaved(_recipe) || _recipe.isSaved;

        return OutlinedButton.icon(
          onPressed: _busy ? null : _toggleSaved,
          icon: _busy
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: color),
                )
              : Icon(
                  saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  size: 18,
                ),
          label: Text(
            saved
                ? AppLanguageService.tr('saved', widget.language)
                : AppLanguageService.tr('save', widget.language),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            side: BorderSide(color: color.withValues(alpha: 0.5)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );
      },
    );
  }
}
