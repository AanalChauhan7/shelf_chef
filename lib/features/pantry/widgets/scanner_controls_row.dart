import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Bottom control buttons bar for Receipt Scanner Screen.
class ScannerControlsRow extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onCaptureTap;
  final VoidCallback onManualTap;

  const ScannerControlsRow({
    super.key,
    required this.onGalleryTap,
    required this.onCaptureTap,
    required this.onManualTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          iconSize: 32,
          icon: const Icon(Icons.photo_library_rounded, color: Colors.white),
          onPressed: onGalleryTap,
          tooltip: 'Upload from Gallery',
        ),
        GestureDetector(
          onTap: onCaptureTap,
          child: Container(
            width: 72,
            height: 72,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.secondaryGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
        IconButton(
          iconSize: 32,
          icon: const Icon(Icons.edit_note_rounded, color: Colors.white),
          onPressed: onManualTap,
          tooltip: 'Manual Entry',
        ),
      ],
    );
  }
}
