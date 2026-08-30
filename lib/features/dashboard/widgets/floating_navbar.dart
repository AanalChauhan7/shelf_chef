import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// A premium floating capsule navigation bar with backdrop blur glassmorphism,
/// elevated circular emerald FAB, and platform-responsive tab labels (full name on Web/Desktop, icon-only on mobile).
class FloatingNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAddPressed;

  const FloatingNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final navBgColor = isDark
        ? const Color(0xCC111827) // 80% opacity dark slate
        : const Color(0xCCFFFFFF); // 80% opacity white glass

    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : AppColors.primaryGreen.withValues(alpha: 0.15);

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      height: 72,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Glassmorphic Capsule Background Container
          ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: navBgColor,
                  borderRadius: BorderRadius.circular(36),
                  border: Border.all(color: borderColor, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.4 : 0.08,
                      ),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: AppColors.primaryGreen.withValues(alpha: 0.08),
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Index 0: Home
                    _buildNavItem(context, 0, Icons.grid_view_rounded, 'Home'),
                    // Index 1: Pantry
                    _buildNavItem(
                      context,
                      1,
                      Icons.inventory_2_rounded,
                      'Pantry',
                    ),

                    // Center Gap for Elevated Circular FAB
                    const SizedBox(width: 56),

                    // Index 3: Recipes
                    _buildNavItem(
                      context,
                      3,
                      Icons.auto_awesome_rounded,
                      'Recipes',
                    ),
                    // Index 4: Shopping Cart
                    _buildNavItem(
                      context,
                      4,
                      Icons.shopping_cart_rounded,
                      'Cart',
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Center Elevated Circular Emerald FAB
          Positioned(
            top: -14,
            child: GestureDetector(
              onTap: onAddPressed,
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppGradients.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondaryGreen.withValues(alpha: 0.55),
                      blurRadius: 20,
                      spreadRadius: 3,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Navigation tab item (Shows full name on Web/Desktop platforms per request)
  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isActive = currentIndex == index;

    // Show full text name on Web platform or larger screen sizes
    final bool showTextLabel =
        kIsWeb || MediaQuery.of(context).size.width > 600;

    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;
    final inactiveColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: (showTextLabel && isActive) ? 14 : 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? activeColor.withValues(alpha: isDark ? 0.2 : 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: isActive
              ? Border.all(
                  color: activeColor.withValues(alpha: 0.35),
                  width: 1.2,
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isActive ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                color: isActive ? activeColor : inactiveColor,
                size: 22,
              ),
            ),
            if (showTextLabel && isActive) ...[
              const SizedBox(width: 6),
              AnimatedOpacity(
                opacity: isActive ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  label,
                  style: TextStyle(
                    color: activeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
