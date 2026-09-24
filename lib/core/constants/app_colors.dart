import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Centralized color palette for ShelfChef AI app.
/// Refined matte dark palette removing harsh neon glows.
abstract class AppColors {
  // --- Light Theme Colors ---
  static const Color primaryGreen = Color(0xFF166534);
  static const Color secondaryGreen = Color(0xFF22C55E);
  static const Color aiPurple = Color(0xFF8B5CF6);
  static const Color warningOrange = Color(0xFFF97316);
  static const Color dangerRed = Color(0xFFEF4444);
  static const Color background = Color(0xFFF7FAF7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);
  static const Color shadowColor = Color(0x0F000000);

  // Status / Category background tints
  static const Color warningBg = Color(0xFFFFF7ED);
  static const Color dangerBg = Color(0xFFFEF2F2);
  static const Color successBg = Color(0xFFF0FDF4);
  static const Color aiBg = Color(0xFFF5F3FF);

  // --- Dark Theme Colors (Matte, Refined, Non-Glow) ---
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkAccent = Color(0xFF10B981); // Matte Emerald
  static const Color darkAiPurple = Color(0xFF8B5CF6); // Soft Purple
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155); // Subtle Matte Border

  // --- Glassmorphism overlay colors ---
  static const Color glassLightSurface = Color(0x99FFFFFF);
  static const Color glassLightBorder = Color(0x40FFFFFF);
  static const Color glassDarkSurface = Color(0xCC1E293B);
  static const Color glassDarkBorder = Color(0x26FFFFFF);

  // --- Curated Accent Color Palette ---
  static const List<Color> accentPalette = [
    Color(0xFF10B981), // Emerald
    Color(0xFF8B5CF6), // AI Purple
    Color(0xFFF59E0B), // Warm Gold
    Color(0xFF3B82F6), // Ocean Blue
    Color(0xFFEC4899), // Rose Pink
    Color(0xFF06B6D4), // Cyan
    Color(0xFF22C55E), // Vivid Green
    Color(0xFFF97316), // Coral Orange
  ];

  static final math.Random _random = math.Random();

  /// Global constant utility function to generate / pick a random harmonized accent color.
  static Color getRandomColor([int? seed]) {
    if (seed != null) {
      return accentPalette[seed.abs() % accentPalette.length];
    }
    return accentPalette[_random.nextInt(accentPalette.length)];
  }
}
