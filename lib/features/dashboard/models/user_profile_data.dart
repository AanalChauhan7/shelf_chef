/// User Profile model containing onboarding, kitchen settings & language preference.
class UserProfileData {
  final String fullName;
  final String? imagePath;
  final String avatarEmoji;
  final int familyMembers;
  final double monthlyBudget;
  final List<String> allergies;
  final String preferredLanguage;

  const UserProfileData({
    this.fullName = 'Aanal',
    this.imagePath,
    this.avatarEmoji = '👩‍🍳',
    this.familyMembers = 2,
    this.monthlyBudget = 6000.0,
    this.allergies = const ['Nuts', 'Dairy'],
    this.preferredLanguage = 'English',
  });

  UserProfileData copyWith({
    String? fullName,
    String? imagePath,
    bool clearImagePath = false,
    String? avatarEmoji,
    int? familyMembers,
    double? monthlyBudget,
    List<String>? allergies,
    String? preferredLanguage,
  }) {
    return UserProfileData(
      fullName: fullName ?? this.fullName,
      imagePath: clearImagePath ? null : (imagePath ?? this.imagePath),
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
      familyMembers: familyMembers ?? this.familyMembers,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      allergies: allergies ?? this.allergies,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
    );
  }
}
