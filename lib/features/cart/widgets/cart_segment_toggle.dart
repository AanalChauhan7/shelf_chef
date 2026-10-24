import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/core.dart';

/// Modern capsule sliding toggle for Shopping Cart: "All | To Buy | Done".
class CartSegmentToggle extends StatelessWidget {
  final int selected; // 0 = All, 1 = To Buy, 2 = Done
  final int totalCount;
  final int toBuyCount;
  final int doneCount;
  final ValueChanged<int> onChanged;

  const CartSegmentToggle({
    super.key,
    required this.selected,
    required this.totalCount,
    required this.toBuyCount,
    required this.doneCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trackBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final border = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final activePillBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final activeTextColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final inactiveTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final accentColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;

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
            final tabWidth = constraints.maxWidth / 3;

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
                          color: Colors.black
                              .withValues(alpha: isDark ? 0.35 : 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    _buildTab(
                      index: 0,
                      label: 'All',
                      count: totalCount,
                      icon: Icons.list_alt_rounded,
                      tabWidth: tabWidth,
                      accentColor: accentColor,
                      activeTextColor: activeTextColor,
                      inactiveTextColor: inactiveTextColor,
                      isDark: isDark,
                    ),
                    _buildTab(
                      index: 1,
                      label: 'To Buy',
                      count: toBuyCount,
                      icon: Icons.shopping_basket_rounded,
                      tabWidth: tabWidth,
                      accentColor: accentColor,
                      activeTextColor: activeTextColor,
                      inactiveTextColor: inactiveTextColor,
                      isDark: isDark,
                    ),
                    _buildTab(
                      index: 2,
                      label: 'Done',
                      count: doneCount,
                      icon: Icons.check_circle_rounded,
                      tabWidth: tabWidth,
                      accentColor: accentColor,
                      activeTextColor: activeTextColor,
                      inactiveTextColor: inactiveTextColor,
                      isDark: isDark,
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

  Widget _buildTab({
    required int index,
    required String label,
    required int count,
    required IconData icon,
    required double tabWidth,
    required Color accentColor,
    required Color activeTextColor,
    required Color inactiveTextColor,
    required bool isDark,
  }) {
    final isSelected = selected == index;
    final textColor = isSelected ? activeTextColor : inactiveTextColor;
    final iconColor = isSelected ? accentColor : inactiveTextColor;

    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onChanged(index);
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
                Icon(icon, size: 14, color: iconColor),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
                if (count > 0) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? accentColor.withValues(alpha: 0.15)
                          : (isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        color: isSelected ? accentColor : inactiveTextColor,
                        fontSize: 10,
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
    );
  }
}
