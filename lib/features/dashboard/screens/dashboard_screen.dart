import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../../core/services/recipe_store.dart';
import '../../cart/screens/shopping_cart_screen.dart';
import '../../pantry/models/pantry_item.dart';
import '../../pantry/screens/manual_item_entry_screen.dart';
import '../../pantry/screens/receipt_scanner_screen.dart';
import '../../pantry/widgets/pantry_empty_view.dart';
import '../../recipes/screens/generate_recipe_screen.dart';
import '../../recipes/screens/recipes_tab_screen.dart';
import '../models/user_profile_data.dart';
import '../widgets/add_quick_modal.dart';
import '../widgets/alerts_modal.dart';
import '../widgets/dashboard_home_view.dart';
import '../widgets/floating_navbar.dart';
import '../widgets/profile_drawer.dart';
import 'initial_setup_screen.dart';

/// Premium Ecosystem Dashboard for ShelfChef AI supporting both Light & Dark Theme.
class DashboardScreen extends StatefulWidget {
  final String userName;
  final bool showSetupOnLaunch;

  const DashboardScreen({
    super.key,
    this.userName = 'Guest Chef',
    this.showSetupOnLaunch = true,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ShoppingCartScreenState> _cartKey =
      GlobalKey<ShoppingCartScreenState>();
  final GlobalKey<RecipesTabScreenState> _recipesKey =
      GlobalKey<RecipesTabScreenState>();
  int _currentTab = 0; // 0: Home, 1: Pantry, 3: Recipes, 4: Cart
  // Tabs are built lazily so one failing tab can't blank the whole screen.
  final Set<int> _visitedTabs = {0};
  late UserProfileData _userProfile;
  List<PantryItem> _pantryItems = [];

  @override
  void initState() {
    super.initState();
    _userProfile = UserProfileData(fullName: widget.userName);
    _fetchPantryItems();

    if (widget.showSetupOnLaunch) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openInitialSetupDialog();
      });
    } else {
      _loadRecipeSuggestions();
    }
  }

  /// Loads recipe suggestions once (cache first). They are only refreshed
  /// later by the reload button on the Recipes tab.
  void _loadRecipeSuggestions() => RecipeStore.instance.ensureSuggested(
        servings: _userProfile.familyMembers,
        language: _userProfile.preferredLanguage,
      );

  Future<void> _fetchPantryItems() async {
    final items = await PantryApiService.fetchPantryItems();
    if (mounted) {
      setState(() => _pantryItems = items);
      AppNotificationService.instance.checkPantryAlerts(items);
    }
  }

  /// Home pull-to-refresh: new pantry data and another recipe on the card.
  Future<void> _refreshHome() {
    RecipeStore.instance.shuffleFeatured();
    return _fetchPantryItems();
  }

  Future<void> _openInitialSetupDialog() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InitialSetupScreen(
          initialData: _userProfile,
          onSave: (updated) => setState(() => _userProfile = updated),
        ),
      ),
    );
    // Wait for the setup answers (servings, language) before fetching.
    if (mounted) _loadRecipeSuggestions();
  }

  void _handleTabTap(int index) {
    if (index == 0) {
      RecipeStore.instance.shuffleFeatured();
      _fetchPantryItems();
    }
    if (index == 3) _recipesKey.currentState?.reload();
    if (index == 4) _cartKey.currentState?.reload();
    setState(() {
      _currentTab = index;
      _visitedTabs.add(index == 2 ? 0 : index);
    });
  }

  Widget _lazyTab(int index, Widget Function() build) =>
      _visitedTabs.contains(index) ? build() : const SizedBox.shrink();

  void _openAddModal() => AddQuickModal.show(
        context,
        familyMembers: _userProfile.familyMembers,
        preferredLanguage: _userProfile.preferredLanguage,
      );

  void _openAlertsDialog() => AlertsDialog.show(context);

  void _openProfileDrawer() => _scaffoldKey.currentState?.openEndDrawer();

  void _openReceiptScanner() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const ReceiptScannerScreen()),
    );
    if (result == true && mounted) {
      _fetchPantryItems();
      setState(() {
        _currentTab = 1;
        _visitedTabs.add(1);
      });
    }
  }

  void _openManualEntry() async {
    final newItem = await Navigator.push<PantryItem>(
      context,
      MaterialPageRoute(builder: (_) => const ManualItemEntryScreen()),
    );
    if (newItem != null && mounted) {
      _fetchPantryItems();
      setState(() {
        _currentTab = 1;
        _visitedTabs.add(1);
      });
    }
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
              DashboardHomeView(
                userProfile: _userProfile,
                pantryItems: _pantryItems,
                onRefresh: _refreshHome,
                onOpenAlerts: _openAlertsDialog,
                onOpenProfile: _openProfileDrawer,
                onViewAllExpiring: () => setState(() {
        _currentTab = 1;
        _visitedTabs.add(1);
      }),
                onStartCooking: _openGenerateRecipe,
              ),
              _lazyTab(
                1,
                () => PantryEmptyView(
                  onScanReceipt: _openReceiptScanner,
                  onAddItemManually: _openManualEntry,
                ),
              ),
              const SizedBox(),
              _lazyTab(
                3,
                () => RecipesTabScreen(
                  key: _recipesKey,
                  peopleCount: _userProfile.familyMembers,
                  language: _userProfile.preferredLanguage,
                  onGenerateRecipes: _openGenerateRecipe,
                ),
              ),
              _lazyTab(4, () => ShoppingCartScreen(key: _cartKey)),
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
}
