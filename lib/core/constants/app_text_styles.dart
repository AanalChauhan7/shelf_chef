import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Predefined typography using GoogleFonts.poppins exclusively.
abstract class AppTextStyles {
  // --- Headings (Poppins Bold / SemiBold) ---
  static TextStyle displayLarge({Color? color}) => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: 1.2,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle headingLarge({Color? color}) => GoogleFonts.poppins(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        height: 1.25,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle headingMedium({Color? color}) => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle headingSmall({Color? color}) => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: color ?? AppColors.textPrimary,
      );

  // --- Subtitles & Section Titles (Poppins Medium / SemiBold) ---
  static TextStyle titleLarge({Color? color}) => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle titleMedium({Color? color}) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle titleSmall({Color? color}) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textSecondary,
      );

  // --- Body Text (Poppins Regular / Medium) ---
  static TextStyle bodyLarge({Color? color}) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle bodyMedium({Color? color}) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle bodySmall({Color? color}) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textSecondary,
      );

  // --- Button Text (Poppins SemiBold) ---
  static TextStyle buttonLarge({Color? color}) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: color ?? Colors.white,
      );

  static TextStyle buttonMedium({Color? color}) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: color ?? Colors.white,
      );

  // --- Captions, Badges, Labels ---
  static TextStyle label({Color? color}) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
        color: color ?? AppColors.textSecondary,
      );

  static TextStyle caption({Color? color}) => GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textSecondary,
      );
}
