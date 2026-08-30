import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../models/user_profile_data.dart';
import '../widgets/add_quick_modal.dart';
import '../widgets/ai_recipe_card.dart';
import '../widgets/alerts_modal.dart';
import '../widgets/budget_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/expiring_items_list.dart';
import '../widgets/floating_navbar.dart';
import '../widgets/profile_drawer.dart';
import '../widgets/spending_chart_card.dart';
import 'initial_setup_screen.dart';

/// Premium Ecosystem Dashboard for ShelfChef AI supporting both Light & Dark Theme.
class DashboardScreen extends StatefulWidget {
  final String userName;
  final bool showSetupOnLaunch;

  const DashboardScreen({
    super.key,
    this.userName = 'Aanal',
    this.showSetupOnLaunch = true,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentTab = 0; // 0: Home, 1: Pantry, 3: Recipes, 4: Cart
  late UserProfileData _userProfile;

  @override
  void initState() {
    super.initState();
    _userProfile = UserProfileData(fullName: widget.userName);

    if (widget.showSetupOnLaunch) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openInitialSetupDialog();
      });
    }
  }

  void _openInitialSetupDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InitialSetupScreen(
          initialData: _userProfile,
          onSave: (updatedProfile) {
            setState(() {
              _userProfile = updatedProfile;
            });
          },
        ),
      ),
    );
  }

  void _handleTabTap(int index) {
    setState(() {
      _currentTab = index;
    });
  }

  void _openAddModal() => AddQuickModal.show(context);

  void _openAlertsDialog() => AlertsDialog.show(context);

  void _openProfileDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      endDrawer: ProfileDrawer(
        userProfile: _userProfile,
        onSave: (updatedProfile) {
          setState(() {
            _userProfile = updatedProfile;
          });
        },
      ),
      body: Stack(
        children: [
          // Top Ambient Background Glow Gradients
          Positioned(
            top: -100,
            left: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: activeColor.withValues(alpha: isDark ? 0.15 : 0.08),
                    blurRadius: 100,
                    spreadRadius: 40,
                  ),
                ],
              ),
            ),
          ),

          // Main Screen Views using original placeholder view layout with updated empty state text
          IndexedStack(
            index: _currentTab == 2 ? 0 : _currentTab,
            children: [
              _buildHomeDashboardView(isDark),
              _buildPlaceholderView(
                'Your Pantry is Empty',
                'Scan receipts or add items to track pantry waste',
                Icons.inventory_2_rounded,
                isDark,
              ),
              const SizedBox(), // Index 2 reserved for FAB modal
              _buildPlaceholderView(
                'No Recipe Suggestions Yet',
                'Add pantry ingredients to get AI zero-waste recipes',
                Icons.auto_awesome_rounded,
                isDark,
              ),
              _buildPlaceholderView(
                'Your Shopping List is Empty',
                'Low stock items will automatically appear here',
                Icons.shopping_cart_rounded,
                isDark,
              ),
            ],
          ),

          // Floating Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FloatingNavbar(
              currentIndex: _currentTab,
              onTap: _handleTabTap,
              onAddPressed: _openAddModal,
            ),
          ),
        ],
      ),
    );
  }

  // --- Private Sub-Widgets Defined Below Build Function ---

  /// Main Home Dashboard View with concise clean build logic
  Widget _buildHomeDashboardView(bool isDark) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: 110,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardHeader(
              userName: _userProfile.fullName,
              imagePath: _userProfile.imagePath,
              avatarEmoji: _userProfile.avatarEmoji,
              onOpenAlerts: _openAlertsDialog,
              onOpenProfile: _openProfileDrawer,
            ),
            const SizedBox(height: 24),
            BudgetCard(totalBudget: _userProfile.monthlyBudget),
            const SizedBox(height: 24),
            const ExpiringItemsList(),
            const SizedBox(height: 24),
            const AiRecipeCard(),
            const SizedBox(height: 24),
            const SpendingChartCard(),
          ],
        ),
      ),
    );
  }

  /// Original Placeholder view layout with updated empty state text
  Widget _buildPlaceholderView(
    String title,
    String subtitle,
    IconData icon,
    bool isDark,
  ) {
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;

    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: activeColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 56, color: activeColor),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(color: secondaryTextColor, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
