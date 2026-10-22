import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../../core/services/app_language_service.dart';

/// Bottom action bar of the Generate Recipe screen ("Search Recipe with AI").
class SearchRecipeBottomBar extends StatelessWidget {
  final bool isDark;
  final bool isSearching;
  final String language;
  final VoidCallback onPressed;

  const SearchRecipeBottomBar({
    super.key,
    required this.isDark,
    required this.isSearching,
    required this.onPressed,
    this.language = 'English',
  });

  @override
  Widget build(BuildContext context) {
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
          onPressed: isSearching ? null : onPressed,
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
              child: isSearching
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          AppLanguageService.tr('chef_thinking', language),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.auto_awesome_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          AppLanguageService.tr('search_ai', language),
                          style: const TextStyle(
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
