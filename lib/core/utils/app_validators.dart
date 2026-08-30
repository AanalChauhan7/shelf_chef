/// Centralized App Form Validation Utilities.
class AppValidators {
  AppValidators._();

  /// Validates email address format
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'Enter a valid email address (e.g. name@domain.com)';
    }
    return null;
  }

  /// Validates password strength, length & special character requirement
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    final specialCharRegExp = RegExp(r'[!@#$%^&*(),.?":{}|<>\-_=+]');
    if (!specialCharRegExp.hasMatch(value)) {
      return 'Include at least one special character (e.g. @, #, \$, !)';
    }
    return null;
  }

  /// Validates password confirmation matching
  static String? validateConfirmPassword(
    String? value,
    String originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != originalPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validates required full name
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  /// Validates optional full name
  static String? validateOptionalFullName(String? value) {
    if (value != null && value.trim().isNotEmpty && value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  /// Validates required monthly grocery budget
  static String? validateBudget(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Monthly budget is required';
    }
    final budget = double.tryParse(value.trim());
    if (budget == null || budget <= 0) {
      return 'Enter a valid amount (e.g. ₹5000)';
    }
    return null;
  }

  /// Validates optional monthly grocery budget
  static String? validateOptionalBudget(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      final budget = double.tryParse(value.trim());
      if (budget == null || budget < 0) {
        return 'Enter a valid budget amount';
      }
    }
    return null;
  }
}
