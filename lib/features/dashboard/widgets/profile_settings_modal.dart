import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../models/user_profile_data.dart';
import 'allergies_picker_section.dart';
import 'avatar_picker_row.dart';
import 'profile_form_fields.dart';

/// Modal sheet allowing user to edit full profile info & preferences anytime.
class ProfileSettingsModal extends StatefulWidget {
  final UserProfileData userProfile;
  final ValueChanged<UserProfileData> onSave;

  const ProfileSettingsModal({
    super.key,
    required this.userProfile,
    required this.onSave,
  });

  static void show(
    BuildContext context, {
    required UserProfileData userProfile,
    required ValueChanged<UserProfileData> onSave,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ProfileSettingsModal(userProfile: userProfile, onSave: onSave),
      ),
    );
  }

  @override
  State<ProfileSettingsModal> createState() => _ProfileSettingsModalState();
}

class _ProfileSettingsModalState extends State<ProfileSettingsModal> {
  late TextEditingController _nameController;
  late TextEditingController _budgetController;
  late String _selectedAvatar;
  late int _familyMembers;
  late List<String> _selectedAllergies;

  final List<String> _allergyOptions = const [
    'Nuts',
    'Dairy',
    'Gluten',
    'Soy',
    'Shellfish',
    'Eggs',
    'Peanuts',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userProfile.fullName);
    _budgetController = TextEditingController(
      text: widget.userProfile.monthlyBudget.toStringAsFixed(0),
    );
    _selectedAvatar = widget.userProfile.avatarEmoji;
    _familyMembers = widget.userProfile.familyMembers;
    _selectedAllergies = List.from(widget.userProfile.allergies);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final name = _nameController.text.trim().isEmpty
        ? 'Guest Chef'
        : _nameController.text.trim();
    final budget = double.tryParse(_budgetController.text.trim()) ?? 6000.0;

    final updated = UserProfileData(
      fullName: name,
      avatarEmoji: _selectedAvatar,
      familyMembers: _familyMembers,
      monthlyBudget: budget,
      allergies: _selectedAllergies,
    );

    widget.onSave(updated);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile preferences updated successfully!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildModalHandle(isDark),
            const SizedBox(height: 16),
            _buildHeader(primaryTextColor, secondaryTextColor),
            const SizedBox(height: 20),
            Text(
              'Profile Photo / Avatar',
              style: AppTextStyles.bodySmall(color: secondaryTextColor),
            ),
            const SizedBox(height: 10),
            AvatarPickerRow(
              selectedAvatar: _selectedAvatar,
              onSelect: (emoji) => setState(() => _selectedAvatar = emoji),
            ),
            const SizedBox(height: 20),
            FullNameInputField(controller: _nameController, label: 'Full Name'),
            const SizedBox(height: 18),
            FamilyMembersCounterRow(
              count: _familyMembers,
              onDecrement: () {
                if (_familyMembers > 1) setState(() => _familyMembers--);
              },
              onIncrement: () => setState(() => _familyMembers++),
            ),
            const SizedBox(height: 18),
            MonthlyBudgetInputField(controller: _budgetController),
            const SizedBox(height: 20),
            AllergiesPickerSection(
              availableAllergies: _allergyOptions,
              selectedAllergies: _selectedAllergies,
              onChanged: (updated) =>
                  setState(() => _selectedAllergies = updated),
            ),
            const SizedBox(height: 24),
            _buildSaveButton(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // --- Private Sub-Widgets Defined Below Build Function ---

  Widget _buildModalHandle(bool isDark) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader(Color primaryTextColor, Color secondaryTextColor) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0x2210B981),
          ),
          child: Center(
            child: Text(_selectedAvatar, style: const TextStyle(fontSize: 24)),
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Profile Settings',
              style: AppTextStyles.headingSmall(color: primaryTextColor),
            ),
            Text(
              'Edit name, avatar, family size, budget & allergies',
              style: AppTextStyles.bodySmall(color: secondaryTextColor),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleSave,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text('Save Profile Changes'),
      ),
    );
  }
}
