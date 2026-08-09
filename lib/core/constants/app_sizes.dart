import 'package:flutter/material.dart';

/// Centralized size constants, paddings, border radii, and dimensions.
abstract class AppSizes {
  // --- Padding & Spacing ---
  static const double p4 = 4.0;
  static const double p8 = 8.0;
  static const double p12 = 12.0;
  static const double p16 = 16.0;
  static const double p20 = 20.0;
  static const double p24 = 24.0;
  static const double p28 = 28.0;
  static const double p32 = 32.0;
  static const double p40 = 40.0;
  static const double p48 = 48.0;

  // --- Border Radii ---
  static const double radiusXS = 8.0;
  static const double radiusSM = 12.0;
  static const double radiusMD = 16.0;
  static const double radiusLG = 24.0; // Primary eco-glass card radius
  static const double radiusXL = 32.0;
  static const double radiusPill = 100.0;

  // Radius objects for quick reuse
  static const BorderRadius borderXS = BorderRadius.all(
    Radius.circular(radiusXS),
  );
  static const BorderRadius borderSM = BorderRadius.all(
    Radius.circular(radiusSM),
  );
  static const BorderRadius borderMD = BorderRadius.all(
    Radius.circular(radiusMD),
  );
  static const BorderRadius borderLG = BorderRadius.all(
    Radius.circular(radiusLG),
  );
  static const BorderRadius borderXL = BorderRadius.all(
    Radius.circular(radiusXL),
  );
  static const BorderRadius borderPill = BorderRadius.all(
    Radius.circular(radiusPill),
  );

  // --- Widget Heights & Sizes ---
  static const double buttonHeightSm = 40.0;
  static const double buttonHeightMd = 52.0;
  static const double buttonHeightLg = 60.0;

  static const double inputHeight = 56.0;
  static const double navBarHeight = 72.0;
  static const double fabSize = 56.0;

  // --- Icon Sizes ---
  static const double iconSM = 18.0;
  static const double iconMD = 24.0;
  static const double iconLG = 32.0;
  static const double iconXL = 48.0;
}
