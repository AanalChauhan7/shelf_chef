import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/dashboard/models/user_profile_data.dart';

/// Local Device Storage Service for Guest Mode.
/// All data is stored strictly on device disk via SharedPreferences.
/// When the user uninstalls the app, the OS automatically erases all data completely.
class GuestStorageService {
  static const String _guestProfileKey = 'guest_user_profile_data';
  static const String _isGuestKey = 'is_guest_mode_active';

  /// Set Guest Mode active status
  static Future<void> setGuestMode(bool isGuest) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isGuestKey, isGuest);
  }

  /// Check if Guest Mode is currently active
  static Future<bool> isGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isGuestKey) ?? false;
  }

  /// Save Guest User Profile locally on device disk
  static Future<void> saveGuestProfile(UserProfileData profile) async {
    final prefs = await SharedPreferences.getInstance();
    final profileMap = {
      'fullName': profile.fullName,
      'familyMembers': profile.familyMembers,
      'monthlyBudget': profile.monthlyBudget,
      'allergies': profile.allergies,
      'imagePath': profile.imagePath,
      'isGuest': true,
    };
    await prefs.setString(_guestProfileKey, jsonEncode(profileMap));
    await prefs.setBool(_isGuestKey, true);
  }

  /// Load Guest User Profile from local device disk
  static Future<UserProfileData> loadGuestProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString(_guestProfileKey);
    if (rawJson != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(rawJson);
        return UserProfileData(
          fullName: data['fullName'] ?? 'Guest Chef',
          familyMembers: (data['familyMembers'] as num?)?.toInt() ?? 1,
          monthlyBudget: (data['monthlyBudget'] as num?)?.toDouble() ?? 6000.0,
          allergies: List<String>.from(data['allergies'] ?? []),
          imagePath: data['imagePath'],
        );
      } catch (_) {}
    }
    return UserProfileData(fullName: 'Guest Chef');
  }

  /// Clear all local guest data
  static Future<void> clearGuestProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_guestProfileKey);
    await prefs.remove(_isGuestKey);
  }
}
