import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Clean Profile Photo Card with image picker and initial letter fallback (No emoji avatars).
class ProfilePhotoCard extends StatelessWidget {
  final String? imagePath;
  final String fullName;
  final VoidCallback onPickImage;
  final bool isDark;

  const ProfilePhotoCard({
    super.key,
    required this.imagePath,
    required this.fullName,
    required this.onPickImage,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;
    final hasPhoto = imagePath != null && File(imagePath!).existsSync();
    final initialLetter = fullName.isNotEmpty ? fullName[0].toUpperCase() : 'A';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white10 : AppColors.border),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onPickImage,
            child: Stack(
              children: [
                Container(
                  width: 72,
                  height: 72,
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
                              initialLetter,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
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
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profile Photo',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  hasPhoto
                      ? 'Custom photo uploaded'
                      : 'Optional (shows initial)',
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 6),
                OutlinedButton.icon(
                  onPressed: onPickImage,
                  icon: const Icon(Icons.upload_rounded, size: 14),
                  label: const Text(
                    'Upload Photo',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
