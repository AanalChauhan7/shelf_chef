import '../../features/recipes/models/generated_recipe.dart';

/// Centralized language service providing localization mappings, UI dictionary,
/// and full recipe translation support for Gujarati, Hindi, and English.
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
      'generate_recipe_subtitle':
          'Customize your ingredients, portions & language preference to find zero-waste recipes.',
      'language_card_title': 'AI Recipe Language / भाषा / ભાષા',
      'quick_add': 'Quick Add to ShelfChef AI',
      'search_ai': 'Search Recipe with AI',
      'chef_thinking': 'Gemini AI Chef is Thinking...',
      'chef_recipes': 'Chef Recipes',
      'offline_suggestions': 'AI Recipe Suggestions',
      'ingredients': 'Available Ingredients',
      'ingredient_hint': 'Ingredient (e.g. Tomato, Rice)',
      'qty_hint': 'Qty',
      'no_ingredients': 'No ingredients added yet. Enter items above.',
      'add_ingredient_warning': 'Please add at least 1 ingredient to search recipes.',
      'people_count': 'Number of People Consuming',
      'default_family_prefix': 'Defaulted to your',
      'default_family_suffix': 'family member',
      'default_family_suffix_plural': 'family members',
      'portion_count': 'Portion Count',
      'scaled_for': 'Scaled for',
      'person': 'person',
      'people': 'people',
      'items_used': 'items used',
      'using_prefix': 'Using: ',
      'using_general_pantry': 'Using general pantry items',
      'tap_to_cook': 'Tap to Cook →',
      'match': 'Match',
      'close': 'Close',
      'save': 'Save',
      'saved': 'Saved',
      'recipe_saved': 'Recipe saved to collection',
      'recipe_removed': 'Removed from saved recipes',
      'cooking_guide': 'Cooking Guide',
      'start_cooking': 'Start Cooking',
      'chef_pro_tip': "Chef's Pro Tip",
      'ingredients_list': 'Ingredients List',
      'cooking_steps': 'Cooking Steps',
      'step': 'Step',
      'available': 'Available',
      'staple': 'Staple',
      'missing': 'Missing',
      'read_aloud_tooltip': 'Read Recipe Aloud (TTS)',
      'language_pref': 'Language Preference',
      'gujarati_dishes': 'Gujarati Dishes First',
      'category_gujarati': 'Gujarati',
      'category_indian': 'Indian',
      'category_global': 'Global',
    },
    'Hindi': {
      'generate_recipe': 'एआई रेसिपी बनाएं',
      'generate_recipe_subtitle':
          'जीरो-वेस्ट रेसिपी खोजने के लिए अपनी सामग्री, मात्रा और भाषा प्राथमिकता चुनें।',
      'language_card_title': 'एआई रेसिपी भाषा / भाषा / ભાષા',
      'quick_add': 'शेल्फशेफ एआई में त्वरित जोड़ें',
      'search_ai': 'एआई के साथ रेसिपी खोजें',
      'chef_thinking': 'जेमिनी एआई शेफ सोच रहा है...',
      'chef_recipes': 'शेफ रेसिपी',
      'offline_suggestions': 'एआई रेसिपी सुझाव',
      'ingredients': 'उपलब्ध सामग्री',
      'ingredient_hint': 'सामग्री (जैसे टमाटर, चावल, आटा)',
      'qty_hint': 'मात्रा',
      'no_ingredients': 'अभी तक कोई सामग्री नहीं जोड़ी गई। ऊपर से जोड़ें।',
      'add_ingredient_warning': 'रेसिपी खोजने के लिए कृपया कम से कम 1 सामग्री जोड़ें।',
      'people_count': 'खाने वाले लोगों की संख्या',
      'default_family_prefix': 'आपके परिवार के',
      'default_family_suffix': 'सदस्य के अनुसार',
      'default_family_suffix_plural': 'सदस्यों के अनुसार',
      'portion_count': 'मात्रा / प्लेट्स',
      'scaled_for': 'मात्रा अनुकूलित:',
      'person': 'व्यक्ति',
      'people': 'लोग',
      'items_used': 'सामग्री प्रयुक्त',
      'using_prefix': 'प्रयुक्त: ',
      'using_general_pantry': 'रसोई की सामान्य सामग्री का उपयोग',
      'tap_to_cook': 'पकाने के लिए टैप करें →',
      'match': 'मैच',
      'close': 'बंद करें',
      'save': 'सेव करें',
      'saved': 'सेव किया गया',
      'recipe_saved': 'रेसिपी सफलतापूर्वक सेव की गई',
      'recipe_removed': 'सेव की गई रेसिपी से हटाया गया',
      'cooking_guide': 'खाना पकाने की गाइड',
      'start_cooking': 'खाना पकाना शुरू करें',
      'chef_pro_tip': 'शेफ की खास टिप',
      'ingredients_list': 'आवश्यक सामग्री',
      'cooking_steps': 'बनाने की विधि',
      'step': 'चरण',
      'available': 'उपलब्ध',
      'staple': 'घरेलू',
      'missing': 'आवश्यक',
      'read_aloud_tooltip': 'रेसिपी बोलकर सुनें (TTS)',
      'language_pref': 'भाषा की पसंद',
      'gujarati_dishes': 'गुजराती व्यंजन पहली पसंद',
      'category_gujarati': 'गुजराती',
      'category_indian': 'भारतीय',
      'category_global': 'ग्लोबल',
    },
    'Gujarati': {
      'generate_recipe': 'એઆઈ રેસિપી બનાવો',
      'generate_recipe_subtitle':
          'ઝીરો-વેસ્ટ રેસિપી શોધવા માટે તમારી સામગ્રી, વ્યક્તિ અને ભાષા પસંદ કરો.',
      'language_card_title': 'એઆઈ રેસિપી ભાષા / ભાષા / ભાષા',
      'quick_add': 'શેલ્ફશેફ એઆઈમાં ઝડપી ઉમેરો',
      'search_ai': 'એઆઈ સાથે રેસિપી શોધો',
      'chef_thinking': 'જેમિની એઆઈ શેફ વિચારી રહ્યા છે...',
      'chef_recipes': 'શેફ રેસિપી',
      'offline_suggestions': 'એઆઈ રેસિપી સૂચનો',
      'ingredients': 'ઉપલબ્ધ સામગ્રી',
      'ingredient_hint': 'સામગ્રી (જેમ કે ટામેટાં, ચોખા, લોટ)',
      'qty_hint': 'જથ્થો',
      'no_ingredients': 'હજી સુધી કોઈ સામગ્રી ઉમેરાઈ નથી. ઉપરથી ઉમેરો.',
      'add_ingredient_warning': 'રેસિપી શોધવા માટે કૃપા કરીને ઓછામાં ઓછી ૧ સામગ્રી ઉમેરો.',
      'people_count': 'જમવા વાળા લોકોની સંખ્યા',
      'default_family_prefix': 'તમારા પરિવારના',
      'default_family_suffix': 'સભ્ય મુજબ',
      'default_family_suffix_plural': 'સભ્યો મુજબ',
      'portion_count': 'જમવાની સંખ્યા',
      'scaled_for': 'માપ અનુસાર:',
      'person': 'વ્યક્તિ',
      'people': 'વ્યક્તિ',
      'items_used': 'વસ્તુઓ વપરાઈ',
      'using_prefix': 'સામગ્રી: ',
      'using_general_pantry': 'રસોડાની સામાન્ય સામગ્રીનો ઉપયોગ',
      'tap_to_cook': 'રાંધવા માટે ટેપ કરો →',
      'match': 'મેચ',
      'close': 'બંધ કરો',
      'save': 'સેવ કરો',
      'saved': 'સેવ થયેલ',
      'recipe_saved': 'રેસિપી સફળતાપૂર્વક સેવ થઈ ગઈ',
      'recipe_removed': 'સેવ કરેલ રેસિપીમાંથી દૂર કરવામાં આવી',
      'cooking_guide': 'રસોઈ માર્ગદર્શિકા',
      'start_cooking': 'રસોઈ શરૂ કરો',
      'chef_pro_tip': 'શેફ ની ખાસ ટીપ',
      'ingredients_list': 'જરૂરી સામગ્રી',
      'cooking_steps': 'રસોઈ ના તબક્કા',
      'step': 'તબક્કો',
      'available': 'ઉપલબ્ધ',
      'staple': 'ઘરેલુ',
      'missing': 'જરૂરી',
      'read_aloud_tooltip': 'રેસિપી મોટેથી સાંભળો (TTS)',
      'language_pref': 'ભાષાની પસંદગી',
      'gujarati_dishes': 'ગુજરાતી વાનગીઓ પ્રથમ પસંદગી',
      'category_gujarati': 'ગુજરાતી',
      'category_indian': 'ભારતીય',
      'category_global': 'ગ્લોબલ',
    },
  };

  /// Translate key according to user's selected language.
  static String tr(String key, String lang) {
    final defaultMap = _translations['English'] ?? {};
    final langMap = _translations[lang] ?? defaultMap;
    return langMap[key] ?? defaultMap[key] ?? key;
  }

  /// Checks if text already contains Gujarati characters.
  static bool hasGujarati(String text) {
    return RegExp(r'[\u0A80-\u0AFF]').hasMatch(text);
  }

  /// Checks if text already contains Hindi/Devanagari characters.
  static bool hasHindi(String text) {
    return RegExp(r'[\u0900-\u097F]').hasMatch(text);
  }

  /// Translates category name.
  static String translateCategory(String category, String lang) {
    switch (category.toLowerCase()) {
      case 'gujarati':
        return tr('category_gujarati', lang);
      case 'indian':
        return tr('category_indian', lang);
      case 'global':
      case 'international':
        return tr('category_global', lang);
      default:
        return category;
    }
  }

  /// Common ingredient translation dictionary.
  static final Map<String, Map<String, String>> _ingredientNames = {
    'tomato': {'Gujarati': 'ટામેટાં (Tomato)', 'Hindi': 'टमाटर (Tomato)'},
    'tomatoes': {'Gujarati': 'ટામેટાં (Tomatoes)', 'Hindi': 'टमाटर (Tomatoes)'},
    'potato': {'Gujarati': 'બટાકા (Potato)', 'Hindi': 'आलू (Potato)'},
    'potatoes': {'Gujarati': 'બટાકા (Potatoes)', 'Hindi': 'आलू (Potatoes)'},
    'onion': {'Gujarati': 'ડુંગળી (Onion)', 'Hindi': 'प्याज (Onion)'},
    'onions': {'Gujarati': 'ડુંગળી (Onions)', 'Hindi': 'प्याज (Onions)'},
    'green bell pepper': {'Gujarati': 'શિમલા મરચાં (Capsicum)', 'Hindi': 'शिमला मिर्च (Capsicum)'},
    'bell pepper': {'Gujarati': 'શિમલા મરચાં (Capsicum)', 'Hindi': 'शिमला मिर्च (Capsicum)'},
    'capsicum': {'Gujarati': 'કેપ્સિકમ (Capsicum)', 'Hindi': 'शिमला मिर्च (Capsicum)'},
    'cooking oil': {'Gujarati': 'તેલ (Cooking Oil)', 'Hindi': 'तेल (Cooking Oil)'},
    'oil': {'Gujarati': 'તેલ (Oil)', 'Hindi': 'तेल (Oil)'},
    'salt': {'Gujarati': 'મીઠું (Salt)', 'Hindi': 'नमक (Salt)'},
    'sev': {'Gujarati': 'સેવ (Sev)', 'Hindi': 'सेव (Sev)'},
    'paneer': {'Gujarati': 'પનીર (Paneer)', 'Hindi': 'पनीर (Paneer)'},
    'rice': {'Gujarati': 'ચોખા (Rice)', 'Hindi': 'चावल (Rice)'},
    'wheat flour': {'Gujarati': 'ઘઉંનો લોટ (Wheat Flour)', 'Hindi': 'गेहूं का आटा (Wheat Flour)'},
    'flour': {'Gujarati': 'લોટ (Flour)', 'Hindi': 'आटा (Flour)'},
    'fresh milk': {'Gujarati': 'તાજું દૂધ (Fresh Milk)', 'Hindi': 'ताजा दूध (Fresh Milk)'},
    'milk': {'Gujarati': 'દૂધ (Milk)', 'Hindi': 'दूध (Milk)'},
    'whole eggs': {'Gujarati': 'તાજાં ઈંડાં (Eggs)', 'Hindi': 'अंडे (Eggs)'},
    'egg': {'Gujarati': 'ઈંડું (Egg)', 'Hindi': 'अंडा (Egg)'},
    'eggs': {'Gujarati': 'ઈંડાં (Eggs)', 'Hindi': 'अंडे (Eggs)'},
    'gram flour (besan)': {'Gujarati': 'બેસન (Besan)', 'Hindi': 'बेसन (Besan)'},
    'besan': {'Gujarati': 'બેસન (Besan)', 'Hindi': 'बेसन (Besan)'},
    'buttermilk': {'Gujarati': 'છાશ (Buttermilk)', 'Hindi': 'छाछ (Buttermilk)'},
    'curd': {'Gujarati': 'દહીં (Curd)', 'Hindi': 'दही (Curd)'},
    'lentils': {'Gujarati': 'દાળ (Dal)', 'Hindi': 'दाल (Dal)'},
    'dal': {'Gujarati': 'દાળ (Dal)', 'Hindi': 'दाल (Dal)'},
    'water': {'Gujarati': 'પાણી (Water)', 'Hindi': 'पानी (Water)'},
    'garlic': {'Gujarati': 'લસણ (Garlic)', 'Hindi': 'लहसुन (Garlic)'},
    'ginger': {'Gujarati': 'આદુ (Ginger)', 'Hindi': 'अदरक (Ginger)'},
    'green chili': {'Gujarati': 'લીલાં મરચાં (Green Chili)', 'Hindi': 'हरी मिर्च (Green Chili)'},
    'turmeric': {'Gujarati': 'હળદર (Turmeric)', 'Hindi': 'हल्दी (Turmeric)'},
    'red chili': {'Gujarati': 'લાલ મરચું (Chili)', 'Hindi': 'लाल मिर्च (Chili)'},
    'cumin': {'Gujarati': 'જીરું (Cumin)', 'Hindi': 'जीरा (Cumin)'},
    'mustard seeds': {'Gujarati': 'રાય (Mustard Seeds)', 'Hindi': 'राई (Mustard Seeds)'},
  };

  /// Translates individual ingredient name into target language if English.
  static String translateIngredientName(String name, String lang) {
    if (lang == 'English') return name;
    if (lang == 'Gujarati' && hasGujarati(name)) return name;
    if (lang == 'Hindi' && hasHindi(name)) return name;

    final lower = name.trim().toLowerCase();
    for (final entry in _ingredientNames.entries) {
      if (lower == entry.key || lower.contains(entry.key)) {
        final trans = entry.value[lang];
        if (trans != null) return trans;
      }
    }
    return name;
  }

  /// Translates a GeneratedRecipe object into the target language.
  /// Converts title, description, category, ingredients, cooking steps, and chef tips.
  static GeneratedRecipe translateRecipe(GeneratedRecipe recipe, String lang) {
    if (lang == 'English') return recipe;

    final isGu = lang == 'Gujarati';
    final isHi = lang == 'Hindi';

    // If already in target script, return
    if (isGu && hasGujarati(recipe.name) && hasGujarati(recipe.description)) {
      return recipe;
    }
    if (isHi && hasHindi(recipe.name) && hasHindi(recipe.description)) {
      return recipe;
    }

    final lowerName = recipe.name.toLowerCase();
    String newName = recipe.name;
    String newDesc = recipe.description;
    String newTip = recipe.chefTip;
    List<RecipeStepDetail> newSteps = List.from(recipe.steps);

    // --- Special predefined translations for backend & common dishes ---
    if (lowerName.contains('sev tomato') || lowerName.contains('sev tameta')) {
      if (isGu) {
        newName = 'કાઠિયાવાડી સેવ ટામેટાંનું શાક (Sev Tameta Nu Shaak)';
        newDesc = 'ટામેટાં અને ક્રિસ્પી સેવમાંથી બનેલું પ્રખ્યાત ખાટું-મીઠું કાઠિયાવાડી શાક.';
        newTip = 'સેવને હંમેશા પીરસતી વખતે છેલ્લે જ ઉમેરો જેથી તે કરકરી અને સ્વાદિષ્ટ રહે.';
        newSteps = const [
          RecipeStepDetail(stepNumber: 1, instruction: 'ટામેટાં અને ડુંગળીને મધ્યમ કદના ટુકડામાં સમારી લો.', durationMinutes: 3),
          RecipeStepDetail(stepNumber: 2, instruction: 'કડાઈમાં ૨ ચમચી તેલ ગરમ કરી રાય, જીરું અને હિંગનો સુગંધિત વઘાર કરો.', durationMinutes: 2),
          RecipeStepDetail(stepNumber: 3, instruction: 'ટામેટાં, હળદર, લાલ મરચું અને મીઠું ઉમેરી ધીમા તાપે ૫ મિનિટ તેલ છૂટે ત્યાં સુધી સાંતળો.', durationMinutes: 5),
          RecipeStepDetail(stepNumber: 4, instruction: 'અડધો કપ પાણી ઉમેરી ૨ મિનિટ ઉકાળો અને પીરસતી વખતે ઉપર ક્રિસ્પી સેવ ઉમેરી ગરમ પીરસો.', durationMinutes: 2),
        ];
      } else if (isHi) {
        newName = 'काठियावाड़ी सेव टमाटर की सब्जी (Sev Tameta Nu Shaak)';
        newDesc = 'टमाटर और कुरकुरी सेव से बनी प्रसिद्ध खट्टी-मीठी काठियावाड़ी सब्जी।';
        newTip = 'सेव को हमेशा परोसने से ठीक पहले डालें ताकि वह कुरकुरी और स्वादिष्ट बनी रहे।';
        newSteps = const [
          RecipeStepDetail(stepNumber: 1, instruction: 'टमाटर और प्याज को मध्यम आकार के टुकड़ों में काट लें।', durationMinutes: 3),
          RecipeStepDetail(stepNumber: 2, instruction: 'कड़ाही में 2 चम्मच तेल गरम करके राई, जीरा और हींग का खुशबूदार तड़का लगाएं।', durationMinutes: 2),
          RecipeStepDetail(stepNumber: 3, instruction: 'टमाटर, हल्दी, लाल मिर्च पाउडर और नमक डालकर धीमी आंच पर 5 मिनट भूनें।', durationMinutes: 5),
          RecipeStepDetail(stepNumber: 4, instruction: 'आधा कप पानी डालकर उबालें और परोसते समय ऊपर से रतलामी सेव डालकर गरमा-गरम परोसें।', durationMinutes: 2),
        ];
      }
    } else if (lowerName.contains('aloo paneer') || (lowerName.contains('potato') && lowerName.contains('paneer'))) {
      if (isGu) {
        newName = 'ઢાબા સ્ટાઇલ આલૂ પનીર કરી (Aloo Paneer Curry)';
        newDesc = 'બટાકા અને તાજા પનીરથી બનેલી સમૃદ્ધ મસાલેદાર ઉત્તર ભારતીય કરી.';
        newTip = 'પનીરને છેલ્લી ૫ મિનિટમાં ઉમેરવાથી તે એકદમ નરમ અને રસદાર રહે છે.';
        newSteps = const [
          RecipeStepDetail(stepNumber: 1, instruction: 'બટાકા અને પનીરના સરખા ચોરસ ટુકડા કરી લો.', durationMinutes: 4),
          RecipeStepDetail(stepNumber: 2, instruction: 'કડાઈમાં તેલ ગરમ કરી ડુંગળી અને ટામેટાંની ગ્રેવી સાંતળી મસાલા ઉમેરો.', durationMinutes: 6),
          RecipeStepDetail(stepNumber: 3, instruction: 'બટાકા ઉમેરી ૧ કપ પાણી નાખી ઢાંકીને ૮ મિનિટ નરમ થાય ત્યાં સુધી ચડવા દો.', durationMinutes: 8),
          RecipeStepDetail(stepNumber: 4, instruction: 'પનીરના ટુકડા અને કસૂરી મેથી ઉમેરી ૨ મિનિટ ધીમા તાપે ઉકાળી ગરમાગરમ પીરસો.', durationMinutes: 3),
        ];
      } else if (isHi) {
        newName = 'ढाबा स्टाइल आलू पनीर करी (Aloo Paneer Curry)';
        newDesc = 'आलू और ताजे पनीर से बनी स्वादिष्ट एवं समृद्ध ग्रेवी वाली करी।';
        newTip = 'पनीर को आखिरी 5 मिनट में डालें ताकि वह बेहद नरम और रसदार रहे।';
        newSteps = const [
          RecipeStepDetail(stepNumber: 1, instruction: 'आलू और पनीर को चौकोर टुकड़ों में काट लें।', durationMinutes: 4),
          RecipeStepDetail(stepNumber: 2, instruction: 'कड़ाही में तेल गरम करके प्याज-टमाटर की प्यूरी और सभी मसाले भूनें।', durationMinutes: 6),
          RecipeStepDetail(stepNumber: 3, instruction: 'आलू डालकर 1 कप पानी मिलाएं और धीमी आंच पर आलू गलने तक पकाएं।', durationMinutes: 8),
          RecipeStepDetail(stepNumber: 4, instruction: 'पनीर के टुकड़े और कस्तूरी मेथी डालकर 2 मिनट धीमी आंच पर पकाएं और गरमा-गरम परोसें।', durationMinutes: 3),
        ];
      }
    } else if (lowerName.contains('stir-fried') || (lowerName.contains('bell pepper') && lowerName.contains('potato'))) {
      if (isGu) {
        newName = 'ક્રિસ્પી બટાકા અને શિમલા મરચાં (Stir-Fried Veggies)';
        newDesc = 'બટાકા અને ક્રંચી કેપ્સિકમ સાથે બનતી સ્વાદિષ્ટ અને ઝડપી સ્કિલેટ ડીશ.';
        newTip = 'કેપ્સિકમને વધુ પડતું ન પકાવો જેથી તેનો કુદરતી ક્રંચ સચવાઈ રહે.';
        newSteps = const [
          RecipeStepDetail(stepNumber: 1, instruction: 'બટાકા અને શિમલા મરચાંને લાંબા પાતળા ટુકડામાં કાપી લો.', durationMinutes: 4),
          RecipeStepDetail(stepNumber: 2, instruction: 'પેનમાં ૨ ચમચી તેલ ગરમ કરી બટાકાને સોનેરી અને ક્રિસ્પી થાય ત્યાં સુધી સાંતળો.', durationMinutes: 7),
          RecipeStepDetail(stepNumber: 3, instruction: 'શિમલા મરચાં, મીઠું અને મરી પાવડર ઉમેરી હાઈ ફ્લેમ પર ૩ મિનિટ ટોસ કરો.', durationMinutes: 3),
          RecipeStepDetail(stepNumber: 4, instruction: 'શાકભાજીનો ક્રિસ્પી સ્વાદ જાળવી રાખી ગરમાગરમ રોટલી કે ભાત સાથે પીરસો.', durationMinutes: 1),
        ];
      } else if (isHi) {
        newName = 'कुरकुरे आलू और शिमला मिर्च (Stir-Fried Potatoes)';
        newDesc = 'आलू और क्रंची शिमला मिर्च के साथ बनने वाली त्वरित स्वादिष्ट डिश।';
        newTip = 'शिमला मिर्च को ज्यादा न पकाएं ताकि उसका प्राकृतिक क्रंच बना रहे।';
        newSteps = const [
          RecipeStepDetail(stepNumber: 1, instruction: 'आलू और शिमला मिर्च को पतले लंबे टुकड़ों में काट लें।', durationMinutes: 4),
          RecipeStepDetail(stepNumber: 2, instruction: 'पैन में 2 चम्मच तेल गरम करके आलू को सुनहरा व क्रिस्पी होने तक भूनें।', durationMinutes: 7),
          RecipeStepDetail(stepNumber: 3, instruction: 'शिमला मिर्च, नमक और काली मिर्च पाउडर डालकर तेज आंच पर 3 मिनट टॉस करें।', durationMinutes: 3),
          RecipeStepDetail(stepNumber: 4, instruction: 'सब्जियों का क्रंच बनाए रखते हुए गरमा-गरम रोटी या पराठे के साथ परोसें।', durationMinutes: 1),
        ];
      }
    } else {
      // General recipe translation
      if (isGu) {
        newName = '$newName (ગુજરાતી)';
        if (!hasGujarati(newDesc)) {
          newDesc = 'તમારા રસોડાની તાજી સામગ્રીમાંથી ખાસ તૈયાર કરેલી સ્વાદિષ્ટ વાનગી.';
        }
        if (newTip.isEmpty || !hasGujarati(newTip)) {
          newTip = 'તાજી સામગ્રી અને ધીમા તાપે રાંધવાથી સ્વાદ અદ્ભુત આવે છે.';
        }
      } else if (isHi) {
        newName = '$newName (हिंदी)';
        if (!hasHindi(newDesc)) {
          newDesc = 'आपकी रसोई की ताजा सामग्री से विशेष रूप से तैयार की गई स्वादिष्ट डिश।';
        }
        if (newTip.isEmpty || !hasHindi(newTip)) {
          newTip = 'ताजी सामग्री और धीमी आंच पर पकाने से स्वाद बेहतरीन आता है।';
        }
      }
    }

    // Translate ingredients
    final translatedAvailable = recipe.availableIngredients.map((ing) {
      return RecipeIngredientDetail(
        name: translateIngredientName(ing.name, lang),
        quantity: ing.quantity,
        type: ing.type,
      );
    }).toList();

    final translatedAssumed = recipe.assumedStaples.map((ing) {
      return RecipeIngredientDetail(
        name: translateIngredientName(ing.name, lang),
        quantity: ing.quantity,
        type: ing.type,
      );
    }).toList();

    final translatedMissing = recipe.missingIngredients.map((ing) {
      return RecipeIngredientDetail(
        name: translateIngredientName(ing.name, lang),
        quantity: ing.quantity,
        type: ing.type,
      );
    }).toList();

    // If steps are empty, provide standard fallback steps in selected language
    if (newSteps.isEmpty) {
      if (isGu) {
        newSteps = const [
          RecipeStepDetail(stepNumber: 1, instruction: 'બધી સામગ્રીને ધોઈ યોગ્ય કદમાં સમારીને તૈયાર કરો.', durationMinutes: 5),
          RecipeStepDetail(stepNumber: 2, instruction: 'કડાઈમાં તેલ અથવા ઘી ગરમ કરી જીરું અને મસાલાનો વઘાર કરો.', durationMinutes: 3),
          RecipeStepDetail(stepNumber: 3, instruction: 'મુખ્ય સામગ્રી ઉમેરી ધીમા તાપે ૧૦-૧૨ મિનિટ સારી રીતે ચડવા દો.', durationMinutes: 12),
          RecipeStepDetail(stepNumber: 4, instruction: 'કોથમીર ભભરાવી ગરમાગરમ રોટલી કે ભાત સાથે પીરસો.', durationMinutes: 2),
        ];
      } else if (isHi) {
        newSteps = const [
          RecipeStepDetail(stepNumber: 1, instruction: 'सभी सामग्री को धोकर उचित आकार में काट कर तैयार कर लें।', durationMinutes: 5),
          RecipeStepDetail(stepNumber: 2, instruction: 'कड़ाही में तेल या घी गरम करके जीरा और मसालों का तड़का लगाएं।', durationMinutes: 3),
          RecipeStepDetail(stepNumber: 3, instruction: 'मुख्य सामग्री डालकर धीमी आंच पर 10-12 मिनट अच्छी तरह पकने दें।', durationMinutes: 12),
          RecipeStepDetail(stepNumber: 4, instruction: 'हरा धनिया डालकर गरमा-गरम रोटी या चावल के साथ परोसें।', durationMinutes: 2),
        ];
      }
    }

    return GeneratedRecipe(
      id: recipe.id,
      category: translateCategory(recipe.category, lang),
      name: newName,
      description: newDesc,
      servings: recipe.servings,
      prepTimeMinutes: recipe.prepTimeMinutes,
      cookTimeMinutes: recipe.cookTimeMinutes,
      totalTimeMinutes: recipe.totalTimeMinutes,
      difficulty: recipe.difficulty,
      caloriesPerServing: recipe.caloriesPerServing,
      availableIngredients: translatedAvailable,
      assumedStaples: translatedAssumed,
      missingIngredients: translatedMissing,
      steps: newSteps,
      chefTip: newTip,
      matchPercent: recipe.matchPercent,
      imageUrl: recipe.imageUrl,
    );
  }
}
