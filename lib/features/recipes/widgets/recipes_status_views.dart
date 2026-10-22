import 'package:flutter/material.dart';
import '../../../core/core.dart';

Color _accent(bool isDark) =>
    isDark ? AppColors.darkAiPurple : AppColors.aiPurple;

TextStyle _title(bool isDark) => TextStyle(
      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
      fontSize: 18,
      fontWeight: FontWeight.w800,
    );

TextStyle _body(bool isDark) => TextStyle(
      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
      fontSize: 13,
      height: 1.4,
    );

/// Centered spinner with a message (used while recipes load).
class RecipesLoadingView extends StatelessWidget {
  final String message;

  const RecipesLoadingView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: _accent(isDark)),
            const SizedBox(height: 18),
            Text(message, textAlign: TextAlign.center, style: _body(isDark)),
          ],
        ),
      ),
    );
  }
}

/// Error message with a retry button.
class RecipesErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const RecipesErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 44, color: _accent(isDark)),
            const SizedBox(height: 14),
            Text('Something went wrong', style: _title(isDark)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: _body(isDark)),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty state for the Saved tab.
class SavedRecipesEmptyView extends StatelessWidget {
  const SavedRecipesEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bookmark_border_rounded,
                size: 44, color: _accent(isDark)),
            const SizedBox(height: 14),
            Text('No saved recipes yet', style: _title(isDark)),
            const SizedBox(height: 8),
            Text(
              'Open any recipe and tap Save to keep it here.',
              textAlign: TextAlign.center,
              style: _body(isDark),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown above offline suggestions when the server did not respond.
class OfflineRecipesBanner extends StatelessWidget {
  final VoidCallback onRetry;

  const OfflineRecipesBanner({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.warningOrange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_off_rounded,
              size: 18, color: AppColors.warningOrange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Server didn't respond — showing offline suggestions.",
              style: _body(isDark).copyWith(fontSize: 12),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
