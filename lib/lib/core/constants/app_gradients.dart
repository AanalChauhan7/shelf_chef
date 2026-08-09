import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized Linear & Radial Gradients for ShelfChef AI app.
abstract class AppGradients {
  /// Primary Green Gradient: `#166534 → #22C55E`
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColors.primaryGreen, AppColors.secondaryGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// AI Accent Purple Gradient: `#7C3AED → #A855F7`
  static const LinearGradient aiGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFFA855F7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Subtle Glassmorphism Light Gradient
  static const LinearGradient glassLightGradient = LinearGradient(
    colors: [
      Color(0xB3FFFFFF), // 70% White
      Color(0x66FFFFFF), // 40% White
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Subtle Glassmorphism Dark Gradient
  static const LinearGradient glassDarkGradient = LinearGradient(
    colors: [
      Color(0xB31E293B), // 70% Dark Slate
      Color(0x661E293B), // 40% Dark Slate
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Card Border Gradient for Glowing Eco-Glass Cards
  static const LinearGradient glassBorderGradient = LinearGradient(
    colors: [
      Color(0x66FFFFFF),
      Color(0x1AFFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
