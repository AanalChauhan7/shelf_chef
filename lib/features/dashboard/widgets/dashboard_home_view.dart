import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../pantry/models/pantry_item.dart';
import '../models/user_profile_data.dart';
import 'ai_recipe_card.dart';
import 'budget_card.dart';
import 'dashboard_header.dart';
import 'expiring_items_list.dart';
import 'spending_chart_card.dart';

/// Scrollable body of the Home tab (header, budget, expiring items, top
/// recipe matches and spending chart).
class DashboardHomeView extends StatelessWidget {
  final UserProfileData userProfile;
  final List<PantryItem> pantryItems;
  final Future<void> Function() onRefresh;
  final VoidCallback onOpenAlerts;
  final VoidCallback onOpenProfile;
  final VoidCallback onViewAllExpiring;
  final VoidCallback onStartCooking;

  const DashboardHomeView({
    super.key,
    required this.userProfile,
    required this.pantryItems,
    required this.onRefresh,
    required this.onOpenAlerts,
    required this.onOpenProfile,
    required this.onViewAllExpiring,
    required this.onStartCooking,
  });

  double get _totalPantrySpent => pantryItems.fold(
        0.0,
        (sum, item) => sum + (item.estimatedPrice ?? 0.0),
      );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: onRefresh,
        color: activeColor,
        child: SingleChildScrollView(
          primary: false,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 12,
            bottom: 110,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              BudgetCard(
                spentAmount: _totalPantrySpent,
                totalBudget: userProfile.monthlyBudget,
              ),
              const SizedBox(height: 24),
              ExpiringItemsList(
                liveItems: pantryItems,
                onViewAll: onViewAllExpiring,
              ),
              const SizedBox(height: 24),
              AiRecipeCard(onStartCooking: onStartCooking),
              const SizedBox(height: 24),
              SpendingChartCard(items: pantryItems),
            ],
          ),
        ),
      ),
    );
  }

  // --- Private Sub-Widgets Defined Below Build Function ---

  Widget _buildHeader() {
    return DashboardHeader(
      userName: userProfile.fullName,
      imagePath: userProfile.imagePath,
      avatarEmoji: userProfile.avatarEmoji,
      onOpenAlerts: onOpenAlerts,
      onOpenProfile: onOpenProfile,
    );
  }
}
