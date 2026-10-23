import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../../core/services/app_language_service.dart';
import '../../../core/services/recipe_step_generator.dart';
import '../models/generated_recipe.dart';
import '../widgets/cooking_ingredients_list.dart';
import '../widgets/cooking_steps_list.dart';
import '../widgets/cooking_tts_bar.dart';
import '../widgets/recipe_detail_parts.dart';

/// Full-screen cooking guide with step-by-step instructions and TTS Voice Assistant.
class CookingGuideScreen extends StatefulWidget {
  final GeneratedRecipe recipe;
  final int peopleCount;
  final String language;

  const CookingGuideScreen({
    super.key,
    required this.recipe,
    required this.peopleCount,
    this.language = 'English',
  });

  @override
  State<CookingGuideScreen> createState() => _CookingGuideScreenState();
}

class _CookingGuideScreenState extends State<CookingGuideScreen> {
  bool _isSpeaking = false;
  late GeneratedRecipe _localizedRecipe;

  @override
  void initState() {
    super.initState();
    var r = AppLanguageService.translateRecipe(
      widget.recipe,
      widget.language,
    );
    if (r.steps.isEmpty) {
      r = r.withSteps(
        RecipeStepGenerator.generate(
          name: r.name,
          category: r.category,
          ingredients: r.allIngredientDetails,
          lang: widget.language,
        ),
      );
    }
    _localizedRecipe = r;
  }

  @override
  void dispose() {
    TtsService.stop();
    super.dispose();
  }

  Future<void> _toggleTts() async {
    if (_isSpeaking) {
      await TtsService.stop();
      if (mounted) setState(() => _isSpeaking = false);
      return;
    }

    final fullText =
        '${_localizedRecipe.title} ${_localizedRecipe.instructions.join(' ')}';
    final detectedLang = TtsService.detectScriptLanguage(fullText);
    final effectiveLang = (detectedLang == 'English' && widget.language != 'English')
        ? widget.language
        : detectedLang;

    final StringBuffer buffer = StringBuffer();
    final isGu = effectiveLang == 'Gujarati';
    final isHi = effectiveLang == 'Hindi';
    final ingHeader = isGu
        ? 'સામગ્રી: '
        : (isHi ? 'सामग्री: ' : 'Ingredients: ');
    final stepHeader = isGu
        ? 'રસોઈ ના તબક્કા: '
        : (isHi ? 'બનાને કી વિધિ: ' : 'Cooking Steps: ');

    buffer.write('${_localizedRecipe.title}. $ingHeader');
    final ings = _localizedRecipe.allIngredientDetails;
    for (int i = 0; i < ings.length; i++) {
      buffer.write('${i + 1}. ${ings[i].displayString}. ');
    }
    buffer.write(stepHeader);
    for (int i = 0; i < _localizedRecipe.instructions.length; i++) {
      buffer.write(
        '${isGu ? 'તબક્કો' : (isHi ? 'चरण' : 'Step')} ${i + 1}. ${_localizedRecipe.instructions[i]}. ',
      );
    }

    if (_localizedRecipe.chefTip.isNotEmpty) {
      final tipHeader = isGu
          ? 'રસોઈયા ની ટીપ: '
          : (isHi ? 'शेफ टिप: ' : 'Chef Tip: ');
      buffer.write('$tipHeader ${_localizedRecipe.chefTip}');
    }

    await TtsService.speak(
      buffer.toString(),
      language: effectiveLang,
      onStart: () {
        if (mounted) setState(() => _isSpeaking = true);
      },
      onDone: () {
        if (mounted) setState(() => _isSpeaking = false);
      },
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

    final personUnit = widget.peopleCount == 1
        ? AppLanguageService.tr('person', widget.language)
        : AppLanguageService.tr('people', widget.language);

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
          AppLanguageService.tr('cooking_guide', widget.language),
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _toggleTts,
            icon: Icon(
              _isSpeaking ? Icons.volume_up_rounded : Icons.volume_mute_rounded,
              color: isDark ? AppColors.darkAiPurple : AppColors.aiPurple,
              size: 26,
            ),
            tooltip: AppLanguageService.tr('read_aloud_tooltip', widget.language),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildHeaderBadges(isDark, personUnit),
                const SizedBox(height: 14),
                Text(
                  _localizedRecipe.title,
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _localizedRecipe.description,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 14),
                RecipeDetailMetrics(
                  recipe: _localizedRecipe,
                  peopleCount: widget.peopleCount,
                  language: widget.language,
                  isDark: isDark,
                ),
                if (_localizedRecipe.chefTip.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: (isDark ? AppColors.darkAiPurple : AppColors.aiPurple)
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: (isDark
                                ? AppColors.darkAiPurple
                                : AppColors.aiPurple)
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lightbulb_rounded,
                          color: AppColors.warningOrange,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLanguageService.tr('chef_pro_tip', widget.language),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                  color: AppColors.warningOrange,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _localizedRecipe.chefTip,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: primaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                _buildSectionHeader(
                  AppLanguageService.tr('ingredients_list', widget.language),
                  isDark,
                ),
                const SizedBox(height: 12),
                CookingIngredientsList(
                  ingredients: _localizedRecipe.allIngredientDetails,
                  language: widget.language,
                ),
                const SizedBox(height: 24),
                _buildSectionHeader(
                  AppLanguageService.tr('cooking_steps', widget.language),
                  isDark,
                ),
                const SizedBox(height: 12),
                CookingStepsList(steps: _localizedRecipe.instructions),
                const SizedBox(height: 80),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CookingTtsBar(
              isSpeaking: _isSpeaking,
              onStop: () async {
                await TtsService.stop();
                if (mounted) setState(() => _isSpeaking = false);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Row(
      children: [
        Icon(
          Icons.restaurant_menu_rounded,
          color: isDark ? AppColors.darkAccent : AppColors.primaryGreen,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderBadges(bool isDark, String personUnit) {
    final aiPurple = isDark ? AppColors.darkAiPurple : AppColors.aiPurple;
    final emeraldAccent =
        isDark ? AppColors.darkAccent : AppColors.primaryGreen;
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final categoryText = AppLanguageService.translateCategory(
      _localizedRecipe.category,
      widget.language,
    );

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (_localizedRecipe.matchPercent.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  aiPurple.withValues(alpha: 0.2),
                  emeraldAccent.withValues(alpha: 0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: aiPurple.withValues(alpha: 0.35),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome, size: 12, color: aiPurple),
                const SizedBox(width: 4),
                Text(
                  '${_localizedRecipe.matchPercent} MATCH',
                  style: TextStyle(
                    color: aiPurple,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isDark ? const Color(0x33334155) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.restaurant_rounded,
                size: 12,
                color: secondaryTextColor,
              ),
              const SizedBox(width: 5),
              Text(
                categoryText,
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isDark ? const Color(0x33334155) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.people_outline_rounded,
                size: 13,
                color: secondaryTextColor,
              ),
              const SizedBox(width: 5),
              Text(
                '${widget.peopleCount} $personUnit',
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
