import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../../core/services/gemini_recipe_service.dart';
import '../models/generated_recipe.dart';
import '../models/ingredient_item.dart';
import '../widgets/ai_recipe_results_modal.dart';
import '../widgets/ingredient_input_section.dart';
import '../widgets/language_selector_card.dart';
import '../widgets/people_counter_card.dart';
import '../widgets/search_recipe_bottom_bar.dart';

/// Screen for generating AI recipes from manual & scanned ingredients.
class GenerateRecipeScreen extends StatefulWidget {
  final int initialPeopleCount;
  final String initialLanguage;

  const GenerateRecipeScreen({
    super.key,
    this.initialPeopleCount = 2,
    this.initialLanguage = 'English',
  });

  @override
  State<GenerateRecipeScreen> createState() => _GenerateRecipeScreenState();
}

class _GenerateRecipeScreenState extends State<GenerateRecipeScreen> {
  late int _peopleCount;
  late String _selectedLanguage;
  bool _isSearching = false;

  late List<IngredientItem> _ingredients;

  @override
  void initState() {
    super.initState();
    _peopleCount = widget.initialPeopleCount;
    _selectedLanguage = widget.initialLanguage;
    _ingredients = const [
      IngredientItem(
        id: '1',
        name: 'Ripe Tomatoes',
        quantity: '3',
        unit: 'pcs',
      ),
      IngredientItem(id: '2', name: 'Whole Eggs', quantity: '4', unit: 'pcs'),
      IngredientItem(id: '3', name: 'Fresh Milk', quantity: '500', unit: 'ml'),
    ];
    _loadPantryIngredients();
  }

  /// Replaces the sample ingredients with the user's real pantry (GET /pantry).
  Future<void> _loadPantryIngredients() async {
    final items = await PantryApiService.fetchPantryItems();
    if (!mounted || items.isEmpty) return;
    setState(() {
      _ingredients = items
          .where((item) => !item.isExpired)
          .map(
            (item) => IngredientItem(
              id: item.id,
              name: item.name,
              quantity: item.quantity,
              unit: item.unit,
            ),
          )
          .toList();
    });
  }

  void _searchRecipeWithAi() async {
    if (_ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least 1 ingredient to search recipes.'),
        ),
      );
      return;
    }

    setState(() => _isSearching = true);
    var title = 'Chef Recipes';
    var recipes = await _fetchRecipesFromApi();
    if (recipes.isEmpty) {
      // Server unreachable: fall back to on-device suggestions.
      title = 'Offline Suggestions';
      recipes = await GeminiRecipeService.generateRecipes(
        ingredients: _ingredients,
        peopleCount: _peopleCount,
        preferredLanguage: _selectedLanguage,
      );
    }
    if (!mounted) return;
    setState(() => _isSearching = false);

    AiRecipeResultsModal.show(
      context,
      peopleCount: _peopleCount,
      ingredients: _ingredients,
      recipes: recipes,
      title: title,
    );
  }

  /// Top three recipes (Gujarati, Indian, Global) from `GET /recipes`.
  Future<List<GeneratedRecipe>> _fetchRecipesFromApi() async {
    try {
      final all = await RecipeApiService.fetchRecipes(
        servings: _peopleCount,
        language: _selectedLanguage,
        timeout: const Duration(seconds: 25),
      );
      return RecipeApiService.topThreeByCategory(all);
    } on RecipeApiException {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: primaryTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Generate AI Recipe',
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color:
                        (isDark ? AppColors.darkAiPurple : AppColors.aiPurple)
                            .withValues(alpha: isDark ? 0.0 : 0.08),
                    blurRadius: 90,
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    children: [
                      Text(
                        'Customize your ingredients, portions & language preference to find zero-waste recipes.',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 16),
                      LanguageSelectorCard(
                        selectedLanguage: _selectedLanguage,
                        onChanged: (lang) {
                          setState(() => _selectedLanguage = lang);
                        },
                      ),
                      const SizedBox(height: 16),
                      PeopleCounterCard(
                        count: _peopleCount,
                        defaultFamilyCount: widget.initialPeopleCount,
                        onChanged: (newCount) {
                          setState(() => _peopleCount = newCount);
                        },
                      ),
                      const SizedBox(height: 16),
                      IngredientInputSection(
                        ingredients: _ingredients,
                        onChanged: (newList) {
                          setState(() => _ingredients = newList);
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                SearchRecipeBottomBar(
                  isDark: isDark,
                  isSearching: _isSearching,
                  onPressed: _searchRecipeWithAi,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
