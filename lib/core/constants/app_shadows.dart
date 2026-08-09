import 'package:flutter/material.dart';

/// Soft realistic shadows for Premium Eco-Glass UI.
abstract class AppShadows {
  /// Subtle elevation shadow for light cards
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0A000000), // 4% black shadow
      blurRadius: 16,
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

  /// Glowing shadow for active green buttons / navigation
  static const List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: Color(0x3322C55E), // 20% green glow
      blurRadius: 20,
      spreadRadius: 2,
      offset: Offset(0, 8),
    ),
  ];

  /// Glowing shadow for AI Sparkle actions
  static const List<BoxShadow> aiGlow = [
    BoxShadow(
      color: Color(0x408B5CF6), // 25% purple glow
      blurRadius: 20,
      spreadRadius: 2,
      offset: Offset(0, 8),
    ),
  ];

  /// Floating navbar shadow
  static const List<BoxShadow> navBarShadow = [
    BoxShadow(
      color: Color(0x12000000), // 7% shadow
      blurRadius: 24,
      spreadRadius: 0,
      offset: Offset(0, 8),
    ),
  ];

  /// Dark mode subtle shadow
  static const List<BoxShadow> darkCardShadow = [
    BoxShadow(
      color: Color(0x33000000), // 20% black shadow
      blurRadius: 16,
      spreadRadius: 0,
      offset: Offset(0, 6),
    ),
  ];
}
