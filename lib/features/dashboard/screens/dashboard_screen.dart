import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../cart/widgets/shopping_cart_empty_view.dart';
import '../../pantry/screens/manual_item_entry_screen.dart';
import '../../pantry/screens/receipt_scanner_screen.dart';
import '../../pantry/widgets/pantry_empty_view.dart';
import '../../recipes/screens/generate_recipe_screen.dart';
import '../../recipes/widgets/ai_recipe_empty_view.dart';
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

  void _openAddModal() => AddQuickModal.show(
    context,
    familyMembers: _userProfile.familyMembers,
    preferredLanguage: _userProfile.preferredLanguage,
  );

  void _openAlertsDialog() => AlertsDialog.show(context);

  void _openProfileDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void _openReceiptScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReceiptScannerScreen()),
    );
  }

  void _openManualEntry() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ManualItemEntryScreen()),
    );
  }

  void _openGenerateRecipe() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GenerateRecipeScreen(
          initialPeopleCount: _userProfile.familyMembers,
          initialLanguage: _userProfile.preferredLanguage,
        ),
      ),
    );
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
                    color: activeColor.withValues(alpha: isDark ? 0.0 : 0.08),
                    blurRadius: 80,
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
          ),
          IndexedStack(
            index: _currentTab == 2 ? 0 : _currentTab,
            children: [
              _buildHomeDashboardView(isDark),
              PantryEmptyView(
                onScanReceipt: _openReceiptScanner,
                onAddItemManually: _openManualEntry,
              ),
              const SizedBox(),
              AiRecipeEmptyView(onGenerateRecipes: _openGenerateRecipe),
              ShoppingCartEmptyView(onAddCartItem: _openManualEntry),
            ],
          ),
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
}
