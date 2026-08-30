import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../models/user_profile_data.dart';
import 'allergies_picker_section.dart';
import 'avatar_picker_row.dart';
import 'profile_form_fields.dart';

/// Initial Onboarding Setup Dialog opened upon login.
/// All fields are optional and can be skipped or edited later in Profile Settings.
class InitialSetupDialog extends StatefulWidget {
  final UserProfileData initialData;
  final ValueChanged<UserProfileData> onSave;

  const InitialSetupDialog({
    super.key,
    required this.initialData,
    required this.onSave,
  });

  static void show(
    BuildContext context, {
    required UserProfileData initialData,
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
        child: InitialSetupDialog(initialData: initialData, onSave: onSave),
      ),
    );
  }

  @override
  State<InitialSetupDialog> createState() => _InitialSetupDialogState();
}

class _InitialSetupDialogState extends State<InitialSetupDialog> {
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
    _nameController = TextEditingController(text: widget.initialData.fullName);
    _budgetController = TextEditingController(
      text: widget.initialData.monthlyBudget.toStringAsFixed(0),
    );
    _selectedAvatar = widget.initialData.avatarEmoji;
    _familyMembers = widget.initialData.familyMembers;
    _selectedAllergies = List.from(widget.initialData.allergies);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final name = _nameController.text.trim().isEmpty
        ? 'Aanal'
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
            _buildModalHeaderHandle(isDark),
            const SizedBox(height: 16),
            _buildDialogTitle(primaryTextColor, secondaryTextColor),
            const SizedBox(height: 20),
            Text(
              'Choose Profile Photo / Avatar',
              style: AppTextStyles.bodySmall(color: secondaryTextColor),
            ),
            const SizedBox(height: 10),
            AvatarPickerRow(
              selectedAvatar: _selectedAvatar,
              onSelect: (emoji) => setState(() => _selectedAvatar = emoji),
            ),
            const SizedBox(height: 20),
            FullNameInputField(
              controller: _nameController,
              label: 'Full Name (Optional)',
            ),
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
            _buildActionButtons(context),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // --- Private Sub-Widgets Defined Below Build Function ---

  Widget _buildModalHeaderHandle(bool isDark) {
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

  Widget _buildDialogTitle(Color primaryTextColor, Color secondaryTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to ShelfChef AI! 🎉',
          style: AppTextStyles.headingSmall(color: primaryTextColor),
        ),
        const SizedBox(height: 4),
        Text(
          'Customize your kitchen preferences (Optional, can edit anytime in profile settings).',
          style: AppTextStyles.bodySmall(color: secondaryTextColor),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Skip for Now'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _handleSave,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Save & Continue'),
          ),
        ),
      ],
    );
  }
}
