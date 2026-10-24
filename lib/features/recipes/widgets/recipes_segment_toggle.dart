import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/core.dart';

/// Improvised modern capsule sliding toggle for "Suggested | Saved".
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trackBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final border = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final activePillBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final activeTextColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final inactiveTextColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final accentColor = isDark ? AppColors.darkAiPurple : AppColors.aiPurple;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 48,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: trackBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: border),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final tabWidth = constraints.maxWidth / 2;

            return Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeInOutCubic,
                  left: selected * tabWidth,
                  top: 0,
                  bottom: 0,
                  width: tabWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      color: activePillBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? border : Colors.transparent,
                        width: isDark ? 0.8 : 0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          onChanged(0);
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.auto_awesome_rounded,
                                  size: 15,
                                  color: selected == 0 ? accentColor : inactiveTextColor,
                                ),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    'Suggested',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: selected == 0 ? activeTextColor : inactiveTextColor,
                                      fontSize: 13,
                                      fontWeight: selected == 0 ? FontWeight.w700 : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          onChanged(1);
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.bookmark_rounded,
                                  size: 15,
                                  color: selected == 1 ? accentColor : inactiveTextColor,
                                ),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    'Saved',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: selected == 1 ? activeTextColor : inactiveTextColor,
                                      fontSize: 13,
                                      fontWeight: selected == 1 ? FontWeight.w700 : FontWeight.w500,
                                    ),
                                  ),
                                ),
                                if (savedCount != null && savedCount! > 0) ...[
                                  const SizedBox(width: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                    decoration: BoxDecoration(
                                      color: selected == 1
                                          ? accentColor.withValues(alpha: 0.15)
                                          : (isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '$savedCount',
                                      style: TextStyle(
                                        color: selected == 1 ? accentColor : inactiveTextColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
