import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/core.dart';
import '../models/user_profile_data.dart';
import '../widgets/allergies_picker_section.dart';
import '../widgets/profile_form_fields.dart';
import '../widgets/profile_photo_card.dart';

/// Full-Page Onboarding Setup Screen displayed immediately after Login (No back button).
class InitialSetupScreen extends StatefulWidget {
  final UserProfileData initialData;
  final ValueChanged<UserProfileData> onSave;

  const InitialSetupScreen({
    super.key,
    required this.initialData,
    required this.onSave,
  });

  @override
  State<InitialSetupScreen> createState() => _InitialSetupScreenState();
}

class _InitialSetupScreenState extends State<InitialSetupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _budgetController;
  final FocusNode _budgetFocusNode = FocusNode();
  late int _familyMembers;
  late List<String> _selectedAllergies;
  String? _imagePath;

  final List<String> _availableAllergies = const [
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
    _familyMembers = widget.initialData.familyMembers;
    _selectedAllergies = List.from(widget.initialData.allergies);
    _imagePath = widget.initialData.imagePath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    _budgetFocusNode.dispose();
    super.dispose();
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
        setState(() => _imagePath = image.path);
      }
    } catch (e) {
      if (kDebugMode) print('Image pick note: $e');
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? true) {
      final budget = double.tryParse(_budgetController.text.trim()) ?? 6000.0;
      final updated = widget.initialData.copyWith(
        fullName: _nameController.text.trim().isEmpty
            ? 'Guest Chef'
            : _nameController.text.trim(),
        imagePath: _imagePath,
        familyMembers: _familyMembers,
        monthlyBudget: budget,
        allergies: _selectedAllergies,
      );

      if (AuthService.currentUser != null) {
        await AuthService.updateUserProfile(updated);
      } else {
        await GuestStorageService.saveGuestProfile(updated);
      }

      if (!mounted) return;
      widget.onSave(updated);
      Navigator.pop(context);
    }
  }

  void _skipSetup() {
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

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Welcome! Set Up Kitchen Profile',
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personalize your smart pantry, grocery budget, and dietary preferences. All fields are optional.',
                  style: AppTextStyles.bodySmall(
                    color: secondaryTextColor,
                  ).copyWith(fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 18),
                ProfilePhotoCard(
                  imagePath: _imagePath,
                  fullName: _nameController.text.trim(),
                  onPickImage: _pickImage,
                  isDark: isDark,
                ),
                const SizedBox(height: 18),
                FullNameInputField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_budgetFocusNode);
                  },
                ),
                const SizedBox(height: 16),
                FamilyMembersCounterRow(
                  count: _familyMembers,
                  onDecrement: () {
                    if (_familyMembers > 1) setState(() => _familyMembers--);
                  },
                  onIncrement: () => setState(() => _familyMembers++),
                ),
                const SizedBox(height: 16),
                MonthlyBudgetInputField(
                  controller: _budgetController,
                  focusNode: _budgetFocusNode,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _saveProfile(),
                ),
                const SizedBox(height: 18),
                AllergiesPickerSection(
                  availableAllergies: _availableAllergies,
                  selectedAllergies: _selectedAllergies,
                  onChanged: (updated) =>
                      setState(() => _selectedAllergies = updated),
                ),
                const SizedBox(height: 28),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        AppButton(
          text: 'Save & Continue',
          onPressed: _saveProfile,
          variant: AppButtonVariant.primary,
        ),
        const SizedBox(height: 12),
        AppButton(
          text: 'Skip for Now',
          onPressed: _skipSetup,
          variant: AppButtonVariant.secondary,
        ),
      ],
    );
  }
}
