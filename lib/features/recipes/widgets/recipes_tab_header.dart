import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Title row of the Recipes tab with refresh and "generate with AI" actions.
class RecipesTabHeader extends StatelessWidget {
  final VoidCallback onRefresh;
  final VoidCallback onGenerate;

  const RecipesTabHeader({
    super.key,
    required this.onRefresh,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 8, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Recipes',
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Refresh',
            icon: Icon(Icons.refresh_rounded, color: textColor),
            onPressed: onRefresh,
          ),
          IconButton(
            tooltip: 'Generate with Chef AI',
            icon: Icon(Icons.auto_awesome_rounded, color: textColor),
            onPressed: onGenerate,
          ),
        ],
      ),
    );
  }
}

/// "Suggested | Saved" switch for the Recipes tab.
class RecipesSegmentToggle extends StatelessWidget {
  final int selected; // 0 = Suggested, 1 = Saved
  final int? savedCount;
  final ValueChanged<int> onChanged;

  const RecipesSegmentToggle({
    super.key,
    required this.selected,
    required this.onChanged,
    this.savedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: SegmentedButton<int>(
          showSelectedIcon: false,
          segments: [
            const ButtonSegment(
              value: 0,
              icon: Icon(Icons.auto_awesome_rounded, size: 18),
              label: Text('Suggested'),
            ),
            ButtonSegment(
              value: 1,
              icon: const Icon(Icons.bookmark_rounded, size: 18),
              label: Text(savedCount == null ? 'Saved' : 'Saved ($savedCount)'),
            ),
          ],
          selected: {selected},
          onSelectionChanged: (selection) => onChanged(selection.first),
        ),
      ),
    );
  }
}
