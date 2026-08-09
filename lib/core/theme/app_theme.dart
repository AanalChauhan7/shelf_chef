import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';

/// App theme manager containing Light and Dark [ThemeData].
abstract class AppTheme {
  /// Light Theme Configuration
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.poppinsTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryGreen,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryGreen,
        secondary: AppColors.secondaryGreen,
        tertiary: AppColors.aiPurple,
        surface: AppColors.surface,
        error: AppColors.dangerRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: AppTextStyles.displayLarge(color: AppColors.textPrimary),
        headlineLarge: AppTextStyles.headingLarge(color: AppColors.textPrimary),
        headlineMedium: AppTextStyles.headingMedium(
          color: AppColors.textPrimary,
        ),
        headlineSmall: AppTextStyles.headingSmall(color: AppColors.textPrimary),
        titleLarge: AppTextStyles.titleLarge(color: AppColors.textPrimary),
        titleMedium: AppTextStyles.titleMedium(color: AppColors.textPrimary),
        titleSmall: AppTextStyles.titleSmall(color: AppColors.textSecondary),
        bodyLarge: AppTextStyles.bodyLarge(color: AppColors.textPrimary),
        bodyMedium: AppTextStyles.bodyMedium(color: AppColors.textPrimary),
        bodySmall: AppTextStyles.bodySmall(color: AppColors.textSecondary),
        labelLarge: AppTextStyles.buttonMedium(color: Colors.white),
        labelMedium: AppTextStyles.label(color: AppColors.textSecondary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppSizes.borderLG),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: AppTextStyles.headingSmall(
          color: AppColors.textPrimary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.p20,
          vertical: AppSizes.p16,
        ),
        hintStyle: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
        labelStyle: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: AppSizes.borderMD,
          borderSide: const BorderSide(color: AppColors.border, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSizes.borderMD,
          borderSide: const BorderSide(color: AppColors.border, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSizes.borderMD,
          borderSide: const BorderSide(
            color: AppColors.primaryGreen,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSizes.borderMD,
          borderSide: const BorderSide(color: AppColors.dangerRed, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(AppSizes.buttonHeightMd),
          shape: RoundedRectangleBorder(borderRadius: AppSizes.borderMD),
          textStyle: AppTextStyles.buttonLarge(),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
    );
  }

  /// Dark Theme Configuration
  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.poppinsTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.darkAccent,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkAccent,
        secondary: AppColors.secondaryGreen,
        tertiary: AppColors.darkAiPurple,
        surface: AppColors.darkSurface,
        error: AppColors.dangerRed,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: AppColors.darkTextPrimary,
        onError: Colors.white,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: AppTextStyles.displayLarge(
          color: AppColors.darkTextPrimary,
        ),
        headlineLarge: AppTextStyles.headingLarge(
          color: AppColors.darkTextPrimary,
        ),
        headlineMedium: AppTextStyles.headingMedium(
          color: AppColors.darkTextPrimary,
        ),
        headlineSmall: AppTextStyles.headingSmall(
          color: AppColors.darkTextPrimary,
        ),
        titleLarge: AppTextStyles.titleLarge(color: AppColors.darkTextPrimary),
        titleMedium: AppTextStyles.titleMedium(
          color: AppColors.darkTextPrimary,
        ),
        titleSmall: AppTextStyles.titleSmall(
          color: AppColors.darkTextSecondary,
        ),
        bodyLarge: AppTextStyles.bodyLarge(color: AppColors.darkTextPrimary),
        bodyMedium: AppTextStyles.bodyMedium(color: AppColors.darkTextPrimary),
        bodySmall: AppTextStyles.bodySmall(color: AppColors.darkTextSecondary),
        labelLarge: AppTextStyles.buttonMedium(color: Colors.white),
        labelMedium: AppTextStyles.label(color: AppColors.darkTextSecondary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppSizes.borderLG),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
        titleTextStyle: AppTextStyles.headingSmall(
          color: AppColors.darkTextPrimary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.p20,
          vertical: AppSizes.p16,
        ),
        hintStyle: AppTextStyles.bodyMedium(color: AppColors.darkTextSecondary),
        labelStyle: AppTextStyles.bodyMedium(
          color: AppColors.darkTextSecondary,
        ),
        border: OutlineInputBorder(
          borderRadius: AppSizes.borderMD,
          borderSide: const BorderSide(color: AppColors.darkBorder, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSizes.borderMD,
          borderSide: const BorderSide(color: AppColors.darkBorder, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSizes.borderMD,
          borderSide: const BorderSide(color: AppColors.darkAccent, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSizes.borderMD,
          borderSide: const BorderSide(color: AppColors.dangerRed, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkAccent,
          foregroundColor: Colors.black,
          elevation: 0,
          minimumSize: const Size.fromHeight(AppSizes.buttonHeightMd),
          shape: RoundedRectangleBorder(borderRadius: AppSizes.borderMD),
          textStyle: AppTextStyles.buttonLarge(color: Colors.black),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
