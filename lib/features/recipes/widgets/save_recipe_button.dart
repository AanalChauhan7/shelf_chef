import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../../core/services/app_language_service.dart';
import '../models/generated_recipe.dart';

/// Bookmark button that saves / un-saves a recipe through the
/// `/saved-recipes` API and reports the updated recipe via [onChanged].
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
  }

  Future<void> _toggleSaved() async {
    if (_busy) return;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);

    try {
      final wasSaved = _recipe.isSaved;
      if (wasSaved) {
        await RecipeApiService.deleteSavedRecipe(_recipe.id!);
        _recipe = _recipe.withId(null);
      } else {
        _recipe = await RecipeApiService.saveRecipe(_recipe);
      }
      widget.onChanged?.call(_recipe);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            wasSaved
                ? AppLanguageService.tr('recipe_removed', widget.language)
                : AppLanguageService.tr('recipe_saved', widget.language),
          ),
        ),
      );
    } on RecipeApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.darkAiPurple : AppColors.aiPurple;
    final saved = _recipe.isSaved;

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
