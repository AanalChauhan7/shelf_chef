import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../../widgets/google_logo.dart';
import '../../../widgets/segmented_auth_toggle.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../widgets/login_form.dart';
import '../widgets/signup_form.dart';

/// Interactive Authentication Screen featuring Segmented Pill Toggle from Image 1.
class AuthScreen extends StatefulWidget {
  final int initialTabIndex; // 0 for Log In, 1 for Sign Up

  const AuthScreen({super.key, this.initialTabIndex = 0});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late int _selectedTab;
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();

  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();

  final TextEditingController _signupNameController = TextEditingController();
  final TextEditingController _signupEmailController = TextEditingController();
  final TextEditingController _signupPasswordController =
      TextEditingController();

  bool _rememberMe = false;
  bool _acceptTerms = false;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTabIndex;
  }

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signupNameController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    super.dispose();
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const DashboardScreen(userName: 'Aanal'),
      ),
      (route) => false,
    );
  }

  void _handleLogin() => _navigateToDashboard();

  void _handleSignup() => _navigateToDashboard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSizes.p20),
              _buildBrandHeader(isDark),
              const SizedBox(height: AppSizes.p28),
              _buildSegmentedToggle(),
              const SizedBox(height: AppSizes.p28),
              _buildFormSwitcher(),
              const SizedBox(height: AppSizes.p32),
              _buildOrDivider(isDark),
              const SizedBox(height: AppSizes.p24),
              _buildGoogleSignInButton(isDark),
              const SizedBox(height: AppSizes.p32),
            ],
          ),
        ),
      ),
    );
  }

  // --- Private Sub-Widgets Defined Below Build Function ---

  Widget _buildBrandHeader(bool isDark) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: AppGradients.primaryGradient,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.kitchen_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: AppSizes.p12),
          Text(
            'ShelfChef AI',
            style: AppTextStyles.headingLarge(
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedToggle() {
    return SegmentedAuthToggle(
      selectedIndex: _selectedTab,
      onChanged: (index) {
        setState(() {
          _selectedTab = index;
        });
      },
    );
  }

  Widget _buildFormSwitcher() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: _selectedTab == 0
          ? LoginForm(
              formKey: _loginFormKey,
              emailController: _loginEmailController,
              passwordController: _loginPasswordController,
              rememberMe: _rememberMe,
              onRememberMeChanged: (val) =>
                  setState(() => _rememberMe = val ?? false),
              onSubmit: _handleLogin,
            )
          : SignupForm(
              formKey: _signupFormKey,
              nameController: _signupNameController,
              emailController: _signupEmailController,
              passwordController: _signupPasswordController,
              acceptTerms: _acceptTerms,
              onAcceptTermsChanged: (val) =>
                  setState(() => _acceptTerms = val ?? false),
              onSubmit: _handleSignup,
            ),
    );
  }

  Widget _buildOrDivider(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p12),
          child: Text(
            'OR',
            style: AppTextStyles.label(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleSignInButton(bool isDark) {
    return InkWell(
      onTap: _navigateToDashboard,
      borderRadius: BorderRadius.circular(26),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const GoogleLogo(size: 20),
            const SizedBox(width: 12),
            Text(
              'Continue with Google',
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : const Color(0xFF1F2937),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
