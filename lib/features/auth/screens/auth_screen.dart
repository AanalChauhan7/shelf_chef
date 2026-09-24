import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/core.dart';
import '../widgets/google_sign_in_button.dart';
import '../../../widgets/segmented_auth_toggle.dart';
import '../../dashboard/models/user_profile_data.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/login_form.dart';
import '../widgets/signup_form.dart';

/// Interactive Authentication Screen powered by AuthBloc with minimal blur overlay loader & Google Sign-In.
class AuthScreen extends StatefulWidget {
  final int initialTabIndex; // 0 for Log In, 1 for Sign Up

  const AuthScreen({super.key, this.initialTabIndex = 0});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final AuthBloc _authBloc;
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
    _authBloc = AuthBloc();
    _selectedTab = widget.initialTabIndex;
  }

  @override
  void dispose() {
    _authBloc.close();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signupNameController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    super.dispose();
  }

  void _navigateToDashboard(UserProfileData profile) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => DashboardScreen(userName: profile.fullName),
      ),
      (route) => false,
    );
  }

  void _handleSignedUpSuccess(AuthSignedUpSuccess state) {
    setState(() {
      _selectedTab = 0;
      _loginEmailController.text = state.email;
      _signupPasswordController.clear();
    });
    _authBloc.add(AuthResetToInitial());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Account created successfully! Please log in to your account.',
        ),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider.value(
      value: _authBloc,
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.background,
        body: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSignedUpSuccess) {
                _handleSignedUpSuccess(state);
              } else if (state is AuthAuthenticated) {
                _navigateToDashboard(state.userProfile);
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: AppColors.dangerRed,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is AuthLoading;

              return AppLoadingOverlay(
                isLoading: isLoading,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.p24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppSizes.p20),
                      _buildBrandHeader(isDark),
                      const SizedBox(height: AppSizes.p28),
                      SegmentedAuthToggle(
                        selectedIndex: _selectedTab,
                        onChanged: (idx) => setState(() => _selectedTab = idx),
                      ),
                      const SizedBox(height: AppSizes.p28),
                      _buildFormSwitcher(),
                      const SizedBox(height: AppSizes.p32),
                      _buildOrDivider(isDark),
                      const SizedBox(height: AppSizes.p24),
                      GoogleSignInButton(
                        onPressed: () =>
                            _authBloc.add(AuthGoogleSignInSubmitted()),
                        isDark: isDark,
                      ),
                      const SizedBox(height: AppSizes.p32),
                    ],
                  ),
                ),
              );
            },
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

  Widget _buildFormSwitcher() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _selectedTab == 0
          ? LoginForm(
              formKey: _loginFormKey,
              emailController: _loginEmailController,
              passwordController: _loginPasswordController,
              rememberMe: _rememberMe,
              onRememberMeChanged: (val) =>
                  setState(() => _rememberMe = val ?? false),
              onSubmit: () => _authBloc.add(
                AuthLogInSubmitted(
                  email: _loginEmailController.text.trim(),
                  password: _loginPasswordController.text,
                ),
              ),
            )
          : SignupForm(
              formKey: _signupFormKey,
              nameController: _signupNameController,
              emailController: _signupEmailController,
              passwordController: _signupPasswordController,
              acceptTerms: _acceptTerms,
              onAcceptTermsChanged: (val) =>
                  setState(() => _acceptTerms = val ?? false),
              onSubmit: () => _authBloc.add(
                AuthSignUpSubmitted(
                  email: _signupEmailController.text.trim(),
                  password: _signupPasswordController.text,
                  fullName: _signupNameController.text.trim(),
                ),
              ),
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
}
