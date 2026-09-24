import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../../core/services/gemini_recipe_service.dart';
import '../models/ingredient_item.dart';
import '../widgets/ai_recipe_results_modal.dart';
import '../widgets/ingredient_input_section.dart';
import '../widgets/language_selector_card.dart';
import '../widgets/people_counter_card.dart';

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
    final recipes = await GeminiRecipeService.generateRecipes(
      ingredients: _ingredients,
      peopleCount: _peopleCount,
      preferredLanguage: _selectedLanguage,
    );
    if (!mounted) return;
    setState(() => _isSearching = false);

    AiRecipeResultsModal.show(
      context,
      peopleCount: _peopleCount,
      ingredients: _ingredients,
      recipes: recipes,
    );
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
                _buildSearchBottomBar(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBottomBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCard.withValues(alpha: 0.9)
            : Colors.white.withValues(alpha: 0.9),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: _isSearching ? null : _searchRecipeWithAi,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 2,
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: AppGradients.aiGradient,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Container(
              alignment: Alignment.center,
              child: _isSearching
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Gemini AI Chef is Thinking...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Search Recipe with AI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
