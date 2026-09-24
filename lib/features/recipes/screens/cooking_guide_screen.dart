import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../models/generated_recipe.dart';
import '../widgets/cooking_ingredients_list.dart';
import '../widgets/cooking_steps_list.dart';
import '../widgets/cooking_tts_bar.dart';

/// Full-screen cooking guide with step-by-step instructions and TTS Voice Assistant.
class CookingGuideScreen extends StatefulWidget {
  final GeneratedRecipe recipe;
  final int peopleCount;

  const CookingGuideScreen({
    super.key,
    required this.recipe,
    required this.peopleCount,
  });

  @override
  State<CookingGuideScreen> createState() => _CookingGuideScreenState();
}

class _CookingGuideScreenState extends State<CookingGuideScreen> {
  bool _isSpeaking = false;

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
        '${widget.recipe.title} ${widget.recipe.instructions.join(' ')}';
    final detectedLang = TtsService.detectScriptLanguage(fullText);

    final StringBuffer buffer = StringBuffer();
    final isGu = detectedLang == 'Gujarati';
    final isHi = detectedLang == 'Hindi';
    final ingHeader = isGu
        ? 'સામગ્રી: '
        : (isHi ? 'सामग्री: ' : 'Ingredients: ');
    final stepHeader = isGu
        ? 'રસોઈ ના તબક્કા: '
        : (isHi ? 'बनाने की विधि: ' : 'Cooking Steps: ');

    buffer.write('${widget.recipe.title}. $ingHeader');
    final ings = widget.recipe.allIngredientDetails;
    for (int i = 0; i < ings.length; i++) {
      buffer.write('${i + 1}. ${ings[i].displayString}. ');
    }
    buffer.write(stepHeader);
    for (int i = 0; i < widget.recipe.instructions.length; i++) {
      buffer.write(
        '${isGu ? 'તબક્કો' : (isHi ? 'चरण' : 'Step')} ${i + 1}. ${widget.recipe.instructions[i]}. ',
      );
    }

    if (widget.recipe.chefTip.isNotEmpty) {
      final tipHeader = isGu
          ? 'રસોઈયા ની ટીપ: '
          : (isHi ? 'शेफ टिप: ' : 'Chef Tip: ');
      buffer.write('$tipHeader ${widget.recipe.chefTip}');
    }

    await TtsService.speak(
      buffer.toString(),
      language: detectedLang,
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
          'Cooking Guide',
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
            tooltip: 'Read Recipe Aloud (TTS)',
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      Image.network(
                        widget.recipe.displayImageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, error, stackTrace) => Container(
                          height: 200,
                          color:
                              (isDark
                                      ? AppColors.darkAiPurple
                                      : AppColors.aiPurple)
                                  .withValues(alpha: 0.2),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.restaurant_rounded,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${widget.peopleCount} Portions',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.recipe.title,
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.recipe.description,
                  style: TextStyle(color: secondaryTextColor, fontSize: 13),
                ),
                if (widget.recipe.chefTip.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color:
                          (isDark ? AppColors.darkAiPurple : AppColors.aiPurple)
                              .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            (isDark
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
                              const Text(
                                'Chef\'s Pro Tip',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                  color: AppColors.warningOrange,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.recipe.chefTip,
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
                _buildSectionHeader('Ingredients List', isDark),
                const SizedBox(height: 12),
                CookingIngredientsList(
                  ingredients: widget.recipe.allIngredientDetails,
                ),
                const SizedBox(height: 24),
                _buildSectionHeader('Cooking Steps', isDark),
                const SizedBox(height: 12),
                CookingStepsList(steps: widget.recipe.instructions),
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
}
