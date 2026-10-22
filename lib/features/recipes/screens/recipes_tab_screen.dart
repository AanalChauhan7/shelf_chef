import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../../core/services/recipe_store.dart';
import '../models/generated_recipe.dart';
import '../widgets/ai_generated_card.dart';
import '../widgets/ai_recipe_empty_view.dart';
import '../widgets/recipe_detail_dialog.dart';
import '../widgets/recipes_status_views.dart';
import '../widgets/recipes_tab_header.dart';

/// Recipes tab: pantry-based suggestions (`GET /recipes`) and the user's
/// saved recipes (`GET /saved-recipes`).
///
/// Data lives in [RecipeStore]. Suggestions are fetched once and reused; only
/// the reload button (or pull-to-refresh) asks the API for new ones.
class RecipesTabScreen extends StatefulWidget {
  final int peopleCount;
  final String language;
  final VoidCallback onGenerateRecipes;

  const RecipesTabScreen({
    super.key,
    required this.peopleCount,
    required this.language,
    required this.onGenerateRecipes,
  });

  @override
  RecipesTabScreenState createState() => RecipesTabScreenState();
}

class RecipesTabScreenState extends State<RecipesTabScreen> {
  int _segment = 0; // 0 = Suggested, 1 = Saved

  RecipeStore get _store => RecipeStore.instance;

  /// Called by the dashboard each time the Recipes tab is opened. Suggestions
  /// are kept as-is if already loaded; reload only happens on the reload button.
  void reload() {
    _loadSuggestedIfNeeded();
    _store.loadSaved(silent: true);
  }

  void _loadSuggestedIfNeeded() {
    if (_store.suggested.isNotEmpty) return;
    _store.ensureSuggested(
      servings: widget.peopleCount,
      language: widget.language,
    );
  }

  Future<void> _refreshCurrent() async {
    if (_segment == 1) return _store.loadSaved();
    final fresh = await _store.refreshSuggested(
      servings: widget.peopleCount,
      language: widget.language,
    );
    if (fresh || !mounted || _store.suggestedOffline) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Couldn't refresh recipes. Showing your previous ones."),
      ),
    );
  }

  void _onSegmentChanged(int value) {
    setState(() => _segment = value);
    if (value == 1) {
      _store.loadSaved(silent: _store.saved.isNotEmpty);
    } else {
      _loadSuggestedIfNeeded();
    }
  }

  Future<void> _openRecipe(GeneratedRecipe recipe) async {
    var full = recipe;
    // Saved-recipe lists may only hold summaries: fetch the full recipe.
    if (recipe.isSaved && recipe.steps.isEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
      try {
        full = await RecipeApiService.fetchSavedRecipe(recipe.id!);
      } on RecipeApiException {
        // Fall back to the summary we already have.
      }
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
    }
    if (!mounted) return;
    RecipeDetailDialog.show(
      context,
      recipe: full,
      peopleCount: widget.peopleCount,
      language: widget.language,
      onSavedChanged: _store.onSavedChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: ListenableBuilder(
        listenable: _store,
        builder: (context, _) => Column(
          children: [
            RecipesTabHeader(
              onRefresh: _refreshCurrent,
              onGenerate: widget.onGenerateRecipes,
            ),
            RecipesSegmentToggle(
              selected: _segment,
              savedCount: _store.savedLoaded ? _store.saved.length : null,
              onChanged: _onSegmentChanged,
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildBody(isDark)),
          ],
        ),
      ),
    );
  }

  // --- Private Sub-Widgets Defined Below Build Function ---

  Widget _buildBody(bool isDark) {
    final isSuggested = _segment == 0;
    final loading =
        isSuggested ? _store.suggestedLoading : _store.savedLoading;
    final loaded = isSuggested ? _store.suggestedLoaded : _store.savedLoaded;
    final error = isSuggested ? _store.suggestedError : _store.savedError;
    final items = isSuggested ? _store.suggested : _store.saved;

    // Suggestions show the spinner on every reload so the tap is visible.
    if (loading && (isSuggested || !loaded)) {
      return RecipesLoadingView(
        message: isSuggested
            ? 'Finding recipes for what is in your pantry…\n'
                'The first load can take up to a minute.'
            : 'Loading your saved recipes…',
      );
    }
    if (error != null && !loaded) {
      return RecipesErrorView(message: error, onRetry: _refreshCurrent);
    }
    if (items.isEmpty) {
      return isSuggested
          ? AiRecipeEmptyView(onGenerateRecipes: widget.onGenerateRecipes)
          : const SavedRecipesEmptyView();
    }
    return _buildRecipeList(items, isDark);
  }

  Widget _buildRecipeList(List<GeneratedRecipe> items, bool isDark) {
    final list = RefreshIndicator(
      onRefresh: _refreshCurrent,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
        itemCount: items.length,
        separatorBuilder: (_, index) => const SizedBox(height: 14),
        itemBuilder: (_, index) => AiGeneratedCard(
          recipe: items[index],
          peopleCount: widget.peopleCount,
          language: widget.language,
          isDark: isDark,
          onSavedChanged: _store.onSavedChanged,
          onTap: () => _openRecipe(items[index]),
        ),
      ),
    );
    if (!(_segment == 0 && _store.suggestedOffline)) return list;
    return Column(
      children: [
        OfflineRecipesBanner(onRetry: _refreshCurrent),
        Expanded(child: list),
      ],
    );
  }
}
