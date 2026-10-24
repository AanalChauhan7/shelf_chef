import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/core.dart';

enum _ListAction { generate, clear }

/// Modernized title row for the Shopping Cart tab:
/// dynamic item count badge, subtitle, action menu, and vibrant "+ Add Item" pill button.
class ShoppingListHeader extends StatelessWidget {
  final int itemCount;
  final VoidCallback onAdd;
  final VoidCallback onGenerate;
  final VoidCallback onClear;

  const ShoppingListHeader({
    super.key,
    required this.itemCount,
    required this.onAdd,
    required this.onGenerate,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final border = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      'Cart',
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: activeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$itemCount ${itemCount == 1 ? "item" : "items"}',
                        style: TextStyle(
                          color: activeColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Pantry essentials & shopping needs',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildActionMenu(cardBg, border, primaryTextColor, isDark),
          const SizedBox(width: 8),
          _buildAddButton(activeColor, isDark),
        ],
      ),
    );
  }

  Widget _buildActionMenu(
      Color cardBg, Color border, Color iconColor, bool isDark) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: PopupMenuButton<_ListAction>(
        tooltip: 'More options',
        padding: EdgeInsets.zero,
        icon: Icon(Icons.more_vert_rounded, color: iconColor, size: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onSelected: (action) {
          HapticFeedback.lightImpact();
          if (action == _ListAction.generate) {
            onGenerate();
          } else {
            onClear();
          }
        },
        itemBuilder: (_) => const [
          PopupMenuItem(
            value: _ListAction.generate,
            child: Row(
              children: [
                Icon(Icons.auto_awesome_rounded,
                    size: 18, color: AppColors.aiPurple),
                SizedBox(width: 10),
                Text('Generate from pantry', style: TextStyle(fontSize: 13.5)),
              ],
            ),
          ),
          PopupMenuItem(
            value: _ListAction.clear,
            child: Row(
              children: [
                Icon(Icons.delete_sweep_rounded,
                    size: 18, color: AppColors.dangerRed),
                SizedBox(width: 10),
                Text('Clear list',
                    style:
                        TextStyle(fontSize: 13.5, color: AppColors.dangerRed)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(Color activeColor, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          onAdd();
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [AppColors.darkAccent, const Color(0xFF059669)]
                  : [AppColors.primaryGreen, const Color(0xFF059669)],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: activeColor.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, color: Colors.white, size: 17),
              SizedBox(width: 4),
              Text(
                'Add Item',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
