import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Floating audio bar showing active Text-to-Speech status.
class CookingTtsBar extends StatelessWidget {
  final bool isSpeaking;
  final VoidCallback onStop;

  const CookingTtsBar({
    super.key,
    required this.isSpeaking,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    if (!isSpeaking) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.aiPurple,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.aiGlow,
      ),
      child: Row(
        children: [
          const Icon(Icons.graphic_eq_rounded, color: Colors.white, size: 22),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'AI Chef Voice Assistant Reading Aloud...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            onPressed: onStop,
            icon: const Icon(Icons.stop_circle_rounded, color: Colors.white),
            tooltip: 'Stop Audio',
          ),
        ],
      ),
    );
  }
}
