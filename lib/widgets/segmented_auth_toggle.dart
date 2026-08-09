import 'package:flutter/material.dart';
import '../core/core.dart';

/// A premium pill-shaped segmented toggle switch for Log In / Sign Up.
/// Replicates the capsule toggle design from Image 1: rounded pill container
/// with an animated sliding white active tab and sleek typography.
class SegmentedAuthToggle extends StatelessWidget {
  final int selectedIndex; // 0 for Log In, 1 for Sign Up
  final ValueChanged<int> onChanged;

  const SegmentedAuthToggle({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFEEF2F0);
    final activeTabBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final activeTextColor = isDark
        ? AppColors.darkTextPrimary
        : const Color(0xFF1F2937);
    final inactiveTextColor = isDark
        ? AppColors.darkTextSecondary
        : const Color(0xFF6B7280);

    return Container(
      height: 54,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(27),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = (constraints.maxWidth - 8) / 2;

          return Stack(
            children: [
              // Animated sliding white active pill container
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOutCubic,
                left: selectedIndex * tabWidth,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: activeTabBg,
                    borderRadius: BorderRadius.circular(23),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.3 : 0.08,
                        ),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),

              // Interactive Text Buttons
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => onChanged(0),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style:
                              AppTextStyles.titleMedium(
                                color: selectedIndex == 0
                                    ? activeTextColor
                                    : inactiveTextColor,
                              ).copyWith(
                                fontWeight: selectedIndex == 0
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                          child: const Text('Log In'),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => onChanged(1),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style:
                              AppTextStyles.titleMedium(
                                color: selectedIndex == 1
                                    ? activeTextColor
                                    : inactiveTextColor,
                              ).copyWith(
                                fontWeight: selectedIndex == 1
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                          child: const Text('Sign Up'),
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
    );
  }
}
