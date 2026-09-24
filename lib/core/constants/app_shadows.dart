import 'package:flutter/material.dart';

/// Clean realistic shadows for Matte Eco-Glass UI without heavy neon glows.
abstract class AppShadows {
  /// Subtle elevation shadow for light cards
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0A000000), // 4% black shadow
      blurRadius: 12,
      spreadRadius: 0,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x05000000), // 2% black shadow
      blurRadius: 4,
      spreadRadius: 0,
      offset: Offset(0, 1),
    ),
  ];

  /// Soft shadow for active green buttons / navigation
  static const List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: Color(0x1F10B981), // 12% subtle emerald shadow
      blurRadius: 10,
      spreadRadius: 0,
      offset: Offset(0, 4),
    ),
  ];

  /// Soft shadow for AI Sparkle actions
  static const List<BoxShadow> aiGlow = [
    BoxShadow(
      color: Color(0x1F8B5CF6), // 12% soft purple shadow
      blurRadius: 10,
      spreadRadius: 0,
      offset: Offset(0, 4),
    ),
  ];

  /// Floating navbar shadow
  static const List<BoxShadow> navBarShadow = [
    BoxShadow(
      color: Color(0x1F000000), // 12% dark shadow
      blurRadius: 16,
      spreadRadius: 0,
      offset: Offset(0, 6),
    ),
  ];

  /// Dark mode subtle shadow
  static const List<BoxShadow> darkCardShadow = [
    BoxShadow(
      color: Color(0x40000000), // 25% clean black shadow
      blurRadius: 12,
      spreadRadius: 0,
      offset: Offset(0, 4),
    ),
  ];
}
