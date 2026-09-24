/// Centralized language service providing localization mappings and language tags.
class AppLanguageService {
  static const List<String> supportedLanguages = [
    'English',
    'Hindi',
    'Gujarati',
  ];

  /// Gets BCP-47 language tag for TTS and locale settings.
  static String getLanguageTag(String lang) {
    switch (lang.toLowerCase()) {
      case 'hindi':
      case 'हिंदी':
        return 'hi-IN';
      case 'gujarati':
      case 'ગુજરાતી':
        return 'gu-IN';
      default:
        return 'en-US';
    }
  }

  /// Display label with flag emoji for UI selectors.
  static String getDisplayLabel(String lang) {
    switch (lang.toLowerCase()) {
      case 'hindi':
        return 'हिंदी (Hindi) 🇮🇳';
      case 'gujarati':
        return 'ગુજરાતી (Gujarati) 🇮🇳';
      default:
        return 'English 🇬🇧';
    }
  }

  /// App UI String translations dictionary.
  static final Map<String, Map<String, String>> _translations = {
    'English': {
      'generate_recipe': 'Generate AI Recipe',
      'quick_add': 'Quick Add to ShelfChef AI',
      'search_ai': 'Search Recipe with AI',
      'ingredients': 'Available Ingredients',
      'people_count': 'Number of People Consuming',
      'cooking_guide': 'Cooking Guide',
      'start_cooking': 'Start Cooking',
      'language_pref': 'Language Preference',
      'gujarati_dishes': 'Gujarati Dishes First',
    },
    'Hindi': {
      'generate_recipe': 'एआई रेसिपी बनाएं',
      'quick_add': 'शेल्फशेफ एआई में त्वरित जोड़ें',
      'search_ai': 'एआई के साथ रेसिपी खोजें',
      'ingredients': 'उपलब्ध सामग्री',
      'people_count': 'खाने वाले लोगों की संख्या',
      'cooking_guide': 'खाना पकाने की गाइड',
      'start_cooking': 'खाना पकाना शुरू करें',
      'language_pref': 'भाषा की पसंद',
      'gujarati_dishes': 'गुजराती व्यंजन पहली पसंद',
    },
    'Gujarati': {
      'generate_recipe': 'એઆઈ રેસિપી બનાવો',
      'quick_add': 'શેલ્ફશેફ એઆઈમાં ઝડપી ઉમેરો',
      'search_ai': 'એઆઈ સાથે રેસિપી શોધો',
      'ingredients': 'ઉપલબ્ધ સામગ્રી',
      'people_count': 'જમવા વાળા લોકોની સંખ્યા',
      'cooking_guide': 'રસોઈ માર્ગદર્શિકા',
      'start_cooking': 'રસોઈ શરૂ કરો',
      'language_pref': 'ભાષાની પસંદગી',
      'gujarati_dishes': 'ગુજરાતી વાનગીઓ પ્રથમ પસંદગી',
    },
  };

  /// Translate key according to user's selected language.
  static String tr(String key, String lang) {
    final langMap = _translations[lang] ?? _translations['English']!;
    return langMap[key] ?? _translations['English']![key] ?? key;
  }
}
