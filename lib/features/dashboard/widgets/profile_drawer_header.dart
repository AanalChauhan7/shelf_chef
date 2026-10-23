import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Compact, elevated Top Header component for ProfileDrawer.
class ProfileDrawerHeader extends StatelessWidget {
  final String fullName;
  final String? imagePath;
  final VoidCallback onPickImage;
  final bool isDark;
  final VoidCallback? onClose;
  final String? subtitle;

  const ProfileDrawerHeader({
    super.key,
    required this.fullName,
    this.imagePath,
    required this.onPickImage,
    required this.isDark,
    this.onClose,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;

    final hasPhoto =
        imagePath != null &&
        imagePath!.isNotEmpty &&
        (kIsWeb ||
            imagePath!.startsWith('blob:') ||
            imagePath!.startsWith('http://') ||
            imagePath!.startsWith('https://') ||
            imagePath!.startsWith('data:') ||
            File(imagePath!).existsSync());
    final initialText = fullName.isNotEmpty ? fullName[0].toUpperCase() : 'A';

    final fallback = Container(
      color: activeColor,
      child: Center(
        child: Text(
          initialText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );

    Widget photoWidget() {
      if (kIsWeb ||
          imagePath!.startsWith('blob:') ||
          imagePath!.startsWith('http://') ||
          imagePath!.startsWith('https://') ||
          imagePath!.startsWith('data:')) {
        return Image.network(
          imagePath!,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => fallback,
        );
      }
      return Image.file(
        File(imagePath!),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      child: Column(
        children: [
          // Top Bar with Brand Badge & Close Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: activeColor.withValues(alpha: isDark ? 0.20 : 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? activeColor.withValues(alpha: 0.40)
                        : Colors.white.withValues(alpha: 0.90),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.12),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.eco_rounded,
                      size: 13,
                      color: activeColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'ShelfChef AI',
                      style: TextStyle(
                        color: activeColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              if (onClose != null)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onClose,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.10)
                            : Colors.white.withValues(alpha: 0.70),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.15)
                              : Colors.white.withValues(alpha: 0.85),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? 0.2 : 0.04,
                            ),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: secondaryTextColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),

          // User Avatar with Ambient Glow & Camera Badge
          GestureDetector(
            onTap: onPickImage,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  padding: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppGradients.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: activeColor.withValues(alpha: 0.28),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: ClipOval(child: hasPhoto ? photoWidget() : fallback),
                  ),
                ),
                Positioned(
                  bottom: -1,
                  right: -1,
                  child: Container(
                    padding: const EdgeInsets.all(5.5),
                    decoration: BoxDecoration(
                      color: activeColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? const Color(0xFF111827) : Colors.white,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // User Full Name
          Text(
            fullName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: primaryTextColor,
              fontSize: 16.5,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 3),

          // Subtitle / Email
          Text(
            subtitle ?? 'Smart Kitchen Chef',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
