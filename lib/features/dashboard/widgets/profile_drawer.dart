import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/core.dart';
import '../../auth/screens/auth_screen.dart';
import '../models/user_profile_data.dart';
import '../screens/profile_settings_screen.dart';
import 'privacy_policy_dialog.dart';
import 'profile_drawer_header.dart';
import 'profile_option_tile.dart';
import 'profile_sign_out_tile.dart';

/// Glassmorphic Side Drawer with responsive width (50% on web, standard on mobile) & Sun/Moon theme toggle.
class ProfileDrawer extends StatefulWidget {
  final UserProfileData userProfile;
  final ValueChanged<UserProfileData> onSave;

  const ProfileDrawer({
    super.key,
    required this.userProfile,
    required this.onSave,
  });

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  late UserProfileData _currentProfile;

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
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image != null) {
        final updated = _currentProfile.copyWith(imagePath: image.path);
        _updateProfile(updated);
        if (AuthService.currentUser != null) {
          await AuthService.updateUserProfile(updated);
        } else {
          await GuestStorageService.saveGuestProfile(updated);
        }
      }
    } catch (e) {
      if (kDebugMode) print('Drawer image pick note: $e');
    }
  }

  Future<void> _openFullProfileSettings() async {
    Navigator.pop(context);
    final updated = await Navigator.push<UserProfileData>(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileSettingsScreen(userProfile: _currentProfile),
      ),
    );
    if (updated != null) _updateProfile(updated);
  }

  void _showPrivacyPolicyDialog() {
    PrivacyPolicyDialog.show(context);
  }

  Future<void> _handleSignOut() async {
    await AuthService.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AuthScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive Drawer Width: 50% width on Web/Large screens, standard ~300px on Mobile
    final isWebOrTablet = kIsWeb || screenWidth > 600;
    final drawerWidth = isWebOrTablet
        ? screenWidth * 0.50
        : (screenWidth * 0.82).clamp(280.0, 340.0);

    final glassBgColor = isDark
        ? const Color(0xCC111827)
        : const Color(0xCCFFFFFF);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : AppColors.primaryGreen.withValues(alpha: 0.15);

    return Drawer(
      width: drawerWidth,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRRect(
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(32)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              color: glassBgColor,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(32),
              ),
              border: Border.all(color: borderColor, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                  blurRadius: 24,
                  offset: const Offset(-4, 0),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  ProfileDrawerHeader(
                    fullName: _currentProfile.fullName,
                    imagePath: _currentProfile.imagePath,
                    onPickImage: _pickImage,
                    isDark: isDark,
                  ),
                  Divider(height: 1, color: borderColor),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 14,
                      ),
                      children: [
                        ProfileOptionTile(
                          icon: Icons.tune_rounded,
                          title: 'Profile Settings',
                          subtitle: 'Edit details & budget',
                          onTap: _openFullProfileSettings,
                          isDark: isDark,
                        ),

                        // Interactive Sun / Moon Theme Toggle Switch
                        ProfileOptionTile(
                          icon: isDark
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          title: isDark ? 'Dark Theme' : 'Light Theme',
                          subtitle: isDark
                              ? 'Switch to Light Mode ☀️'
                              : 'Switch to Dark Mode 🌙',
                          onTap: () async {
                            await ThemeService.toggleTheme(isDark);
                          },
                          isDark: isDark,
                        ),

                        ProfileOptionTile(
                          icon: Icons.shield_outlined,
                          title: 'Privacy Policy',
                          subtitle: 'Data & Security',
                          onTap: _showPrivacyPolicyDialog,
                          isDark: isDark,
                        ),
                        ProfileOptionTile(
                          icon: Icons.help_outline_rounded,
                          title: 'AI Support',
                          subtitle: 'Help & FAQs',
                          onTap: () =>
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'AI Support Assistant connected',
                                  ),
                                ),
                              ),
                          isDark: isDark,
                        ),
                        const SizedBox(height: 12),
                        ProfileSignOutTile(onTap: _handleSignOut),
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
}
