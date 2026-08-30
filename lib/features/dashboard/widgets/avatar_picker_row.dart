import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Reusable Profile Avatar Emoji Picker Row.
class AvatarPickerRow extends StatelessWidget {
  final String selectedAvatar;
  final List<String> avatarOptions;
  final ValueChanged<String> onSelect;

  const AvatarPickerRow({
    super.key,
    required this.selectedAvatar,
    this.avatarOptions = const ['👩‍🍳', '👨‍🍳', '🍳', '🥗', '🥑', '🍕'],
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: avatarOptions.map((emoji) {
        final isSelected = selectedAvatar == emoji;
        return GestureDetector(
          onTap: () => onSelect(emoji),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark ? AppColors.darkAccent : AppColors.primaryGreen)
                        .withValues(alpha: 0.2)
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? (isDark ? AppColors.darkAccent : AppColors.primaryGreen)
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 26)),
          ),
        );
      }).toList(),
    );
  }
}
