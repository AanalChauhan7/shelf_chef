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

/// Premium Frosted Glassmorphic Side Drawer with responsive width & Sun/Moon theme toggle.
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

  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, bottom: 6, top: 10),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive Drawer Width: 45% on Web/Large screens, standard ~310px on Mobile
    final isWebOrTablet = kIsWeb || screenWidth > 600;
    final drawerWidth = isWebOrTablet
        ? (screenWidth * 0.45).clamp(340.0, 440.0)
        : (screenWidth * 0.82).clamp(290.0, 340.0);

    // True translucent frosted glass gradients
    final glassGradient = isDark
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xD90F172A), // 85% dark slate
              Color(0xA61E293B), // 65% slate card
            ],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xEBFFFFFF), // 92% pure white top highlight
              Color(0xB3F1F5F9), // 70% soft frosted light slate
            ],
          );

    final glassBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.16)
        : Colors.white.withValues(alpha: 0.85);

    final dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.white.withValues(alpha: 0.7);

    final sectionColor = isDark
        ? AppColors.darkTextSecondary.withValues(alpha: 0.8)
        : AppColors.textSecondary.withValues(alpha: 0.85);

    return Drawer(
      width: drawerWidth,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRRect(
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(32)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              gradient: glassGradient,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(32),
              ),
              border: Border.all(color: glassBorderColor, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.08),
                  blurRadius: 32,
                  offset: const Offset(-8, 0),
                ),
                BoxShadow(
                  color: (isDark ? AppColors.darkAccent : AppColors.primaryGreen)
                      .withValues(alpha: isDark ? 0.08 : 0.04),
                  blurRadius: 40,
                  offset: const Offset(-4, 0),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Ambient Frosted Glass Specular Glow Orbs
                Positioned(
                  top: -30,
                  right: -30,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (isDark ? AppColors.darkAccent : AppColors.secondaryGreen)
                          .withValues(alpha: isDark ? 0.14 : 0.10),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 90,
                  left: -40,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.aiPurple.withValues(alpha: isDark ? 0.10 : 0.06),
                    ),
                  ),
                ),

                // Main Drawer Content
                SafeArea(
                  child: Column(
                    children: [
                      ProfileDrawerHeader(
                        fullName: _currentProfile.fullName,
                        imagePath: _currentProfile.imagePath,
                        onPickImage: _pickImage,
                        isDark: isDark,
                        onClose: () => Navigator.pop(context),
                        subtitle: AuthService.currentUser?.email ?? 'Smart Kitchen Chef',
                      ),
                      Divider(height: 1, thickness: 1, color: dividerColor),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          children: [
                            _buildSectionHeader('PREFERENCES & SETTINGS', sectionColor),
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
                              trailing: Transform.scale(
                                scale: 0.78,
                                child: Switch.adaptive(
                                  value: isDark,
                                  activeThumbColor: AppColors.darkAccent,
                                  activeTrackColor:
                                      AppColors.darkAccent.withValues(alpha: 0.4),
                                  inactiveThumbColor: AppColors.primaryGreen,
                                  inactiveTrackColor:
                                      AppColors.primaryGreen.withValues(alpha: 0.2),
                                  onChanged: (_) async {
                                    await ThemeService.toggleTheme(isDark);
                                  },
                                ),
                              ),
                              isDark: isDark,
                            ),

                            _buildSectionHeader('SUPPORT & LEGAL', sectionColor),
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

                            _buildSectionHeader('SESSION', sectionColor),
                            ProfileSignOutTile(
                              onTap: _handleSignOut,
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ),

                      // Brand & Version Footer
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.eco_rounded,
                              size: 13,
                              color: (isDark ? AppColors.darkAccent : AppColors.primaryGreen)
                                  .withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'ShelfChef AI • Smart Kitchen',
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.darkTextSecondary.withValues(alpha: 0.6)
                                    : AppColors.textSecondary.withValues(alpha: 0.7),
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
