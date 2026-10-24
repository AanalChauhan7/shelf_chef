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
        leading: Center(
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDark ? const Color(0x33334155) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : AppColors.border,
                ),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 20,
                color: primaryTextColor,
              ),
            ),
          ),
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
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: InkWell(
                onTap: _toggleTts,
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _isSpeaking
                        ? (isDark ? AppColors.darkAiPurple : AppColors.aiPurple)
                            .withValues(alpha: 0.18)
                        : (isDark ? const Color(0x33334155) : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isSpeaking
                          ? (isDark ? AppColors.darkAiPurple : AppColors.aiPurple)
                          : (isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : AppColors.border),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isSpeaking
                            ? Icons.volume_up_rounded
                            : Icons.volume_mute_rounded,
                        color: _isSpeaking
                            ? (isDark
                                ? AppColors.darkAiPurple
                                : AppColors.aiPurple)
                            : secondaryTextColor,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _isSpeaking ? 'Speaking' : 'Listen',
                        style: TextStyle(
                          color: _isSpeaking
                              ? (isDark
                                  ? AppColors.darkAiPurple
                                  : AppColors.aiPurple)
                              : secondaryTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background ambient organic glows
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    (isDark ? AppColors.darkAiPurple : AppColors.aiPurple)
                        .withValues(alpha: isDark ? 0.15 : 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 260,
            left: -80,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    (isDark ? AppColors.darkAccent : AppColors.primaryGreen)
                        .withValues(alpha: isDark ? 0.12 : 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 96),
              children: [
                // Hero Overview Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xCC1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : AppColors.border,
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.25 : 0.04,
                        ),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _localizedRecipe.description,
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 13.5,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Divider(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : AppColors.border.withValues(alpha: 0.7),
                        height: 1,
                      ),
                      const SizedBox(height: 14),
                      RecipeDetailMetrics(
                        recipe: _localizedRecipe,
                        peopleCount: widget.peopleCount,
                        language: widget.language,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
                if (_localizedRecipe.chefTip.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.warningOrange.withValues(
                        alpha: isDark ? 0.12 : 0.08,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.warningOrange.withValues(
                          alpha: isDark ? 0.35 : 0.25,
                        ),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppColors.warningOrange.withValues(
                              alpha: isDark ? 0.2 : 0.15,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lightbulb_rounded,
                            color: AppColors.warningOrange,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLanguageService.tr(
                                  'chef_pro_tip',
                                  widget.language,
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12.5,
                                  color: AppColors.warningOrange,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                _localizedRecipe.chefTip,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: primaryTextColor,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                _buildSectionHeader(
                  title: AppLanguageService.tr(
                    'ingredients_list',
                    widget.language,
                  ),
                  icon: Icons.inventory_2_rounded,
                  iconColor: isDark
                      ? AppColors.darkAccent
                      : AppColors.primaryGreen,
                  count: _localizedRecipe.allIngredientDetails.length,
                  countLabel: 'items',
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                CookingIngredientsList(
                  ingredients: _localizedRecipe.allIngredientDetails,
                  language: widget.language,
                ),
                const SizedBox(height: 28),
                _buildSectionHeader(
                  title: AppLanguageService.tr(
                    'cooking_steps',
                    widget.language,
                  ),
                  icon: Icons.outdoor_grill_rounded,
                  iconColor: isDark
                      ? AppColors.darkAiPurple
                      : AppColors.aiPurple,
                  count: _localizedRecipe.instructions.length,
                  countLabel: 'steps',
                  isDark: isDark,
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

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required Color iconColor,
    required int count,
    required String countLabel,
    required bool isDark,
  }) {
    final primaryTextColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: isDark ? 0.2 : 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 17,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? const Color(0x33334155) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : AppColors.border,
            ),
          ),
          child: Text(
            '$count $countLabel',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
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
