import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../widgets/add_quick_modal.dart';
import '../widgets/ai_recipe_card.dart';
import '../widgets/alerts_modal.dart';
import '../widgets/budget_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/expiring_items_list.dart';
import '../widgets/floating_navbar.dart';
import '../widgets/profile_settings_modal.dart';
import '../widgets/spending_chart_card.dart';

/// Premium Ecosystem Dashboard for ShelfChef AI supporting both Light & Dark Theme
/// based on docs/PROJECT_OVERVIEW.md specifications.
class DashboardScreen extends StatefulWidget {
  final String userName;

  const DashboardScreen({super.key, this.userName = 'Aanal'});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentTab = 0; // 0: Home, 1: Pantry, 3: Recipes, 4: Profile
  late String _currentUserName;

  @override
  void initState() {
    super.initState();
    _currentUserName = widget.userName;
  }

  void _handleTabTap(int index) {
    setState(() {
      _currentTab = index;
    });
  }

  void _openAddModal() => AddQuickModal.show(context);

  void _openAlertsModal() => AlertsModal.show(context);

  void _openProfileSettings() {
    ProfileSettingsModal.show(
      context,
      userName: _currentUserName,
      onSave: (newName) {
        setState(() {
          _currentUserName = newName;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
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

          // Main Screen Views
          IndexedStack(
            index: _currentTab == 2 ? 0 : _currentTab,
            children: [
              _buildHomeDashboardView(isDark),
              _buildPlaceholderView(
                'Pantry Inventory',
                Icons.inventory_2_rounded,
                isDark,
              ),
              const SizedBox(), // Index 2 reserved for FAB modal
              _buildPlaceholderView(
                'AI Recipe Hub',
                Icons.auto_awesome_rounded,
                isDark,
              ),
              _buildPlaceholderView(
                'User Profile & Settings',
                Icons.person_rounded,
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
              userName: _currentUserName,
              onOpenAlerts: _openAlertsModal,
              onOpenProfile: _openProfileSettings,
            ),
            const SizedBox(height: 24),
            const BudgetCard(),
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

  /// Placeholder view for Pantry, Recipes, Profile tabs
  Widget _buildPlaceholderView(String title, IconData icon, bool isDark) {
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
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Interactive Module Active',
              style: TextStyle(color: secondaryTextColor, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
