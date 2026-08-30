import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/core.dart';
import '../models/user_profile_data.dart';
import '../screens/profile_settings_screen.dart';
import 'profile_drawer_header.dart';
import 'profile_option_tile.dart';

/// Glassmorphic Side Drawer matching FloatingNavbar's backdrop blur & glass styling.
class ProfileDrawer extends StatefulWidget {
  final UserProfileData userProfile;
  final ValueChanged<UserProfileData> onSave;

  const ProfileDrawer({super.key, required this.userProfile, required this.onSave});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  late UserProfileData _currentProfile;
  ThemeMode _selectedTheme = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _currentProfile = widget.userProfile;
  }

  void _updateProfile(UserProfileData updated) {
    setState(() => _currentProfile = updated);
    widget.onSave(updated);
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      _updateProfile(_currentProfile.copyWith(imagePath: image.path));
    }
  }

  Future<void> _openFullProfileSettings() async {
    Navigator.pop(context);
    final updated = await Navigator.push<UserProfileData>(
      context,
      MaterialPageRoute(builder: (_) => ProfileSettingsScreen(userProfile: _currentProfile)),
    );
    if (updated != null) {
      _updateProfile(updated);
    }
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('App Theme Preference'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('System Default 📱'),
              trailing: _selectedTheme == ThemeMode.system ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen) : null,
              onTap: () {
                setState(() => _selectedTheme = ThemeMode.system);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Light Mode ☀️'),
              trailing: _selectedTheme == ThemeMode.light ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen) : null,
              onTap: () {
                setState(() => _selectedTheme = ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Dark Mode 🌙'),
              trailing: _selectedTheme == ThemeMode.dark ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen) : null,
              onTap: () {
                setState(() => _selectedTheme = ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy & Terms'),
        content: const SingleChildScrollView(
          child: Text(
            'ShelfChef AI values your privacy.\n\n'
            '• All grocery receipts and pantry scans are processed locally.\n'
            '• Dietary preferences and allergies are stored securely to customize AI recipes.\n'
            '• We never share your personal information or expenditure data with third parties.\n\n'
            'For full terms visit shelfchef.ai/privacy.',
            style: TextStyle(fontSize: 13, height: 1.4),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glassBgColor = isDark ? const Color(0xCC111827) : const Color(0xCCFFFFFF);
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.12) : AppColors.primaryGreen.withValues(alpha: 0.15);

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.52,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRRect(
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(32)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              color: glassBgColor,
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(32)),
              border: Border.all(color: borderColor, width: 1.2),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08), blurRadius: 24, offset: const Offset(-4, 0)),
                BoxShadow(color: AppColors.primaryGreen.withValues(alpha: 0.08), blurRadius: 16, spreadRadius: 1),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  ProfileDrawerHeader(fullName: _currentProfile.fullName, imagePath: _currentProfile.imagePath, onPickImage: _pickImage, isDark: isDark),
                  Divider(height: 1, color: borderColor),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                      children: [
                        ProfileOptionTile(icon: Icons.tune_rounded, title: 'Profile Settings', subtitle: 'Edit details & budget', onTap: _openFullProfileSettings, isDark: isDark),
                        ProfileOptionTile(icon: Icons.brightness_6_rounded, title: 'App Theme', subtitle: _getThemeLabel(), onTap: _showThemeDialog, isDark: isDark),
                        ProfileOptionTile(icon: Icons.shield_outlined, title: 'Privacy Policy', subtitle: 'Data & Security', onTap: _showPrivacyPolicyDialog, isDark: isDark),
                        ProfileOptionTile(icon: Icons.help_outline_rounded, title: 'AI Support', subtitle: 'Help & FAQs', onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('AI Support Assistant connected'))), isDark: isDark),
                        const SizedBox(height: 12),
                        _buildSignOutTile(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Private Sub-Widgets Defined Below Build Function ---

  String _getThemeLabel() {
    switch (_selectedTheme) {
      case ThemeMode.light:
        return 'Light Mode';
      case ThemeMode.dark:
        return 'Dark Mode';
      case ThemeMode.system:
        return 'System Default';
    }
  }

  Widget _buildSignOutTile() {
    return ListTile(
      onTap: () => Navigator.pop(context),
      leading: const Icon(Icons.logout_rounded, color: AppColors.dangerRed, size: 20),
      title: const Text('Sign Out', style: TextStyle(color: AppColors.dangerRed, fontWeight: FontWeight.w700, fontSize: 13)),
    );
  }
}
