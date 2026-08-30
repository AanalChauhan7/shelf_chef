import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Compact Top Header component for half-width ProfileDrawer.
class ProfileDrawerHeader extends StatelessWidget {
  final String fullName;
  final String? imagePath;
  final VoidCallback onPickImage;
  final bool isDark;

  const ProfileDrawerHeader({
    super.key,
    required this.fullName,
    this.imagePath,
    required this.onPickImage,
    required this.isDark,
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

    final hasPhoto = imagePath != null && File(imagePath!).existsSync();
    final initialText = fullName.isNotEmpty ? fullName[0].toUpperCase() : 'A';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      child: Column(
        children: [
          GestureDetector(
            onTap: onPickImage,
            child: Stack(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppGradients.primaryGradient,
                    border: Border.all(color: activeColor, width: 2),
                  ),
                  child: ClipOval(
                    child: hasPhoto
                        ? Image.file(File(imagePath!), fit: BoxFit.cover)
                        : Center(
                            child: Text(
                              initialText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: activeColor,
                      shape: BoxShape.circle,
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
          Text(
            fullName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'ShelfChef AI',
            style: AppTextStyles.bodySmall(
              color: secondaryTextColor,
            ).copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
