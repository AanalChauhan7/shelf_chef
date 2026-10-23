import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Styled Sign Out list tile for profile drawer with light frosted glass styling.
class ProfileSignOutTile extends StatelessWidget {
  final VoidCallback onTap;
  final bool? isDark;

  const ProfileSignOutTile({
    super.key,
    required this.onTap,
    this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final dark = isDark ?? (Theme.of(context).brightness == Brightness.dark);
    final secondaryTextColor = dark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    // Soft, light frosted glass background
    final tileGradient = dark
        ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.06),
              Colors.white.withValues(alpha: 0.02),
            ],
          )
        : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.72),
              const Color(0xFFFFF1F2).withValues(alpha: 0.35),
            ],
          );

    final tileBorderColor = dark
        ? Colors.white.withValues(alpha: 0.11)
        : Colors.white.withValues(alpha: 0.85);

    // Lighter, pleasant rose-red accent
    final accentRed =
        dark ? const Color(0xFFF87171) : const Color(0xFFE11D48);

    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 6),
      decoration: BoxDecoration(
        gradient: tileGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: tileBorderColor,
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? 0.15 : 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
          if (!dark)
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.7),
              blurRadius: 1,
              offset: const Offset(0, -1),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: accentRed.withValues(alpha: 0.12),
          highlightColor: accentRed.withValues(alpha: 0.06),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                // Light rose icon container
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: accentRed.withValues(alpha: dark ? 0.14 : 0.08),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: accentRed.withValues(alpha: dark ? 0.22 : 0.14),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: accentRed,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),

                // Title & Subtitle with lighter, muted text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Sign Out',
                        style: TextStyle(
                          color: accentRed,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'End current session',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Subtle circular pill trailing indicator
                Container(
                  padding: const EdgeInsets.all(4.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.white.withValues(alpha: 0.65),
                    border: Border.all(
                      color: dark
                          ? Colors.white.withValues(alpha: 0.10)
                          : Colors.white.withValues(alpha: 0.80),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: secondaryTextColor,
                    size: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
