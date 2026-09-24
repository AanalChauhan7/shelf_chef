import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App Theme Management Service with persistent dark/light mode toggle.
class ThemeService {
  static const String _prefKey = 'app_theme_mode';
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
    ThemeMode.system,
  );

  /// Initializes saved theme mode from SharedPreferences.
  static Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedStr = prefs.getString(_prefKey);
      if (savedStr == 'light') {
        themeNotifier.value = ThemeMode.light;
      } else if (savedStr == 'dark') {
        themeNotifier.value = ThemeMode.dark;
      } else {
        themeNotifier.value = ThemeMode.system;
      }
    } catch (_) {}
  }

  /// Toggle between Light and Dark mode.
  static Future<void> toggleTheme(bool isCurrentlyDark) async {
    final nextMode = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(nextMode);
  }

  /// Sets exact ThemeMode and saves to SharedPreferences.
  static Future<void> setThemeMode(ThemeMode mode) async {
    themeNotifier.value = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (mode == ThemeMode.light) {
        await prefs.setString(_prefKey, 'light');
      } else if (mode == ThemeMode.dark) {
        await prefs.setString(_prefKey, 'dark');
      } else {
        await prefs.remove(_prefKey);
      }
    } catch (_) {}
  }
}
