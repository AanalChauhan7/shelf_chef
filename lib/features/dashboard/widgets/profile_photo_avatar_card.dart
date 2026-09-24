import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/core.dart';
import 'avatar_picker_row.dart';

/// Interactive Profile Photo and Avatar Emoji Selection Card for ProfileSettingsScreen.
class ProfilePhotoAvatarCard extends StatelessWidget {
  final String? imagePath;
  final String fullName;
  final String selectedEmoji;
  final VoidCallback onPickImage;
  final ValueChanged<String> onEmojiSelected;
  final bool isDark;

  const ProfilePhotoAvatarCard({
    super.key,
    required this.imagePath,
    required this.fullName,
    required this.selectedEmoji,
    required this.onPickImage,
    required this.onEmojiSelected,
    required this.isDark,
  });

  bool _hasValidPhoto() {
    if (imagePath == null || imagePath!.isEmpty) return false;
    if (kIsWeb ||
        imagePath!.startsWith('blob:') ||
        imagePath!.startsWith('http://') ||
        imagePath!.startsWith('https://') ||
        imagePath!.startsWith('data:')) {
      return true;
    }
    try {
      return File(imagePath!).existsSync();
    } catch (_) {
      return false;
    }
  }

  Widget _buildPhotoWidget(Widget fallback) {
    if (imagePath == null || imagePath!.isEmpty) return fallback;

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

    if (imagePath!.startsWith('assets/')) {
      return Image.asset(
        imagePath!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
      );
    }

    try {
      return Image.file(
        File(imagePath!),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
      );
    } catch (_) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;
    final hasPhoto = _hasValidPhoto();
    final initialLetter = fullName.isNotEmpty ? fullName[0].toUpperCase() : 'A';

    final fallbackWidget = Center(
      child: Text(
        initialLetter,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.w800,
        ),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white10 : AppColors.border),
      ),
      child: Column(
        children: [
          Row(
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
                            ? _buildPhotoWidget(fallbackWidget)
                            : fallbackWidget,
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
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasPhoto
                          ? 'Custom photo uploaded'
                          : 'Optional (shows initial)',
                      style: TextStyle(
                        color: isDark ? Colors.white60 : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    OutlinedButton.icon(
                      onPressed: onPickImage,
                      icon: const Icon(Icons.upload_rounded, size: 14),
                      label: const Text(
                        'Change Photo',
                        style: TextStyle(fontSize: 12),
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
          const Divider(height: 24),
          AvatarPickerRow(
            selectedAvatar: selectedEmoji,
            onSelect: onEmojiSelected,
          ),
        ],
      ),
    );
  }
}
