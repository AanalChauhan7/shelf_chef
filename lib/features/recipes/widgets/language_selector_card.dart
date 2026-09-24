import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../../core/services/app_language_service.dart';

/// Glassmorphism card for selecting AI recipe language preference.
class LanguageSelectorCard extends StatelessWidget {
  final String selectedLanguage;
  final ValueChanged<String> onChanged;

  const LanguageSelectorCard({
    super.key,
    required this.selectedLanguage,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkCard : AppColors.surface;
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.darkAiPurple : AppColors.aiPurple)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.translate_rounded,
                  color: isDark ? AppColors.darkAiPurple : AppColors.aiPurple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'AI Recipe Language / भाषा / ભાષા',
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: AppLanguageService.supportedLanguages.map((lang) {
              final isSelected = selectedLanguage == lang;
              final activeColor = isDark
                  ? AppColors.darkAiPurple
                  : AppColors.aiPurple;
              return ChoiceChip(
                label: Text(
                  AppLanguageService.getDisplayLabel(lang),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : secondaryTextColor,
                  ),
                ),
                selected: isSelected,
                selectedColor: activeColor,
                backgroundColor: isDark
                    ? const Color(0xFF0F172A)
                    : const Color(0xFFF1F5F9),
                onSelected: (val) {
                  if (val) onChanged(lang);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
