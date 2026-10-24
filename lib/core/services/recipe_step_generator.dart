import '../../features/recipes/models/recipe_parts.dart';

/// Generates realistic, structured cooking steps for recipes missing them,
/// tailored to dish name, category, ingredients, and language.
class RecipeStepGenerator {
  static List<RecipeStepDetail> generate({
    required String name,
    required String category,
    List<RecipeIngredientDetail> ingredients = const [],
    String lang = 'English',
  }) {
    final lower = name.toLowerCase();
    final isGu = lang == 'Gujarati';
    final isHi = lang == 'Hindi';

    if ((lower.contains('shaak') || lower.contains('curry') || lower.contains('sabzi')) &&
        (lower.contains('rotli') || lower.contains('roti') || lower.contains('paratha') || lower.contains('bread'))) {
      return _buildRotliShaakSteps(isGu, isHi);
    }
    if (lower.contains('wedge') || lower.contains('fries') || (lower.contains('potato') && lower.contains('dip'))) {
      return _buildWedgesSteps(isGu, isHi);
    }
    if (lower.contains('rice') || lower.contains('pulao') || lower.contains('khichdi') || lower.contains('jeera')) {
      return _buildRiceSteps(isGu, isHi);
    }
    if (lower.contains('sev') && (lower.contains('tam') || lower.contains('tomato'))) {
      return _buildSevTametaSteps(isGu, isHi);
    }
    if (lower.contains('dal') || lower.contains('lentil') || lower.contains('soup')) {
      return _buildDalSteps(isGu, isHi);
    }
    if (lower.contains('pasta') || lower.contains('noodle') || lower.contains('spaghetti')) {
      return _buildPastaSteps(isGu, isHi);
    }
    return _buildDynamicSteps(ingredients, isGu, isHi);
  }

  static List<RecipeStepDetail> _buildRotliShaakSteps(bool isGu, bool isHi) {
    if (isGu) {
      return const [
        RecipeStepDetail(stepNumber: 1, instruction: 'બટાકાની છાલ ઉતારી ચોરસ ટુકડા કરો અને ટામેટાંને ઝીણા સમારી લો.', durationMinutes: 5),
        RecipeStepDetail(stepNumber: 2, instruction: 'કડાઈમાં ૨ ચમચી તેલ ગરમ કરી રાઈ, જીરું અને હળદરનો વઘાર કરો.', durationMinutes: 3),
        RecipeStepDetail(stepNumber: 3, instruction: 'ટામેટાં, બટાકા, મીઠું અને ૧ કપ પાણી ઉમેરી ઢાંકીને ૧૦-૧૨ મિનિટ ધીમા તાપે ચડવા દો.', durationMinutes: 12),
        RecipeStepDetail(stepNumber: 4, instruction: 'ઘઉંના લોટમાં પાણી અને ચપટી મીઠું નાખી કણક બાંધો, પાતળી રોટલી વણી તવા પર શેકી લો.', durationMinutes: 8),
        RecipeStepDetail(stepNumber: 5, instruction: 'શાક પર તાજી કોથમીર ભભરાવી ગરમાગરમ ફૂલેલી રોટલી સાથે પીરસો.', durationMinutes: 2),
      ];
    }
    if (isHi) {
      return const [
        RecipeStepDetail(stepNumber: 1, instruction: 'आलू को छीलकर टुकड़ों में काटें और टमाटर को बारीक काट लें।', durationMinutes: 5),
        RecipeStepDetail(stepNumber: 2, instruction: 'कड़ाही में 2 चम्मच तेल गरम करके राई, जीरा और हल्दी का तड़का लगाएं।', durationMinutes: 3),
        RecipeStepDetail(stepNumber: 3, instruction: 'टमाटर, आलू, नमक और 1 कप पानी डालकर ढकें और 10-12 मिनट धीमी आंच पर पकने दें।', durationMinutes: 12),
        RecipeStepDetail(stepNumber: 4, instruction: 'गेहूं के आटे में पानी डालकर नरम आटा गूंध लें और तवे पर फुल्का रोटियां सेंक लें।', durationMinutes: 8),
        RecipeStepDetail(stepNumber: 5, instruction: 'सब्जी पर हरा धनिया डालकर गरमा-गरम रोटियों के साथ परोसें।', durationMinutes: 2),
      ];
    }
    return const [
      RecipeStepDetail(stepNumber: 1, instruction: 'Peel and dice the potatoes into bite-sized cubes and chop ripe tomatoes.', durationMinutes: 5),
      RecipeStepDetail(stepNumber: 2, instruction: 'Heat 2 tbsp cooking oil in a pan; add mustard seeds, cumin, and turmeric until aromatic.', durationMinutes: 3),
      RecipeStepDetail(stepNumber: 3, instruction: 'Add chopped tomatoes, potato cubes, salt, and 1 cup of water; cover and simmer for 10-12 minutes until tender.', durationMinutes: 12),
      RecipeStepDetail(stepNumber: 4, instruction: 'Mix whole wheat flour with water and a pinch of salt to form a soft dough, roll thin rotlis, and puff on a hot tava.', durationMinutes: 8),
      RecipeStepDetail(stepNumber: 5, instruction: 'Garnish the hot shaak with fresh coriander and serve warm with puffed rotlis.', durationMinutes: 2),
    ];
  }

  static List<RecipeStepDetail> _buildWedgesSteps(bool isGu, bool isHi) {
    if (isGu) {
      return const [
        RecipeStepDetail(stepNumber: 1, instruction: 'બટાકાને બરાબર ધોઈ લાંબી ફાડીઓમાં (વેજીસમાં) કાપી લો.', durationMinutes: 5),
        RecipeStepDetail(stepNumber: 2, instruction: 'ટુકડાઓને સાફ કપડાથી સૂકવી તેલ, મીઠું અને મરી પાવડર સાથે બરાબર મિક્સ કરો.', durationMinutes: 3),
        RecipeStepDetail(stepNumber: 3, instruction: 'પેનમાં તેલ ગરમ કરી બટાકાની ફાડીઓને ૧૨-૧૪ મિનિટ સોનેરી અને ક્રિસ્પી થાય ત્યાં સુધી સાંતળો.', durationMinutes: 13),
        RecipeStepDetail(stepNumber: 4, instruction: 'નાની પેનમાં ટામેટાં અને મીઠું ધીમા તાપે પકવી ઘટ્ટ ટમેટો ડીપ બનાવી લો.', durationMinutes: 6),
        RecipeStepDetail(stepNumber: 5, instruction: 'ગરમાગરમ ક્રિસ્પી પોટેટો વેજીસને હોમમેડ ટમેટો ડીપ સાથે પીરસો.', durationMinutes: 2),
      ];
    }
    if (isHi) {
      return const [
        RecipeStepDetail(stepNumber: 1, instruction: 'आलू को अच्छी तरह धोकर लंबे वेजेस के आकार में काट लें।', durationMinutes: 5),
        RecipeStepDetail(stepNumber: 2, instruction: 'आलू को पोंछकर तेल, नमक और कुटी हुई काली मिर्च के साथ अच्छी तरह मिलाएं।', durationMinutes: 3),
        RecipeStepDetail(stepNumber: 3, instruction: 'पैन में तेल गरम करके मध्यम आंच पर 12-14 मिनट सुनहरा व कुरकुरा होने तक सेकें।', durationMinutes: 13),
        RecipeStepDetail(stepNumber: 4, instruction: 'छोटे पैन में कटे टमाटर और नमक डालकर धीमी आंच पर गाढ़ा डिप तैयार करें।', durationMinutes: 6),
        RecipeStepDetail(stepNumber: 5, instruction: 'कुरकुरे पोटैटो वेजेस को ताजे टोमैटो डिप के साथ गरमा-गरम परोसें।', durationMinutes: 2),
      ];
    }
    return const [
      RecipeStepDetail(stepNumber: 1, instruction: 'Scrub potatoes clean and slice into lengthwise uniform wedges.', durationMinutes: 5),
      RecipeStepDetail(stepNumber: 2, instruction: 'Pat dry and toss thoroughly with cooking oil, salt, and crushed black pepper.', durationMinutes: 3),
      RecipeStepDetail(stepNumber: 3, instruction: 'Pan-fry in a wide skillet over medium heat for 12-14 minutes, turning until crisp and golden.', durationMinutes: 13),
      RecipeStepDetail(stepNumber: 4, instruction: 'In a small saucepan, simmer chopped tomatoes with a pinch of salt and pepper into a rich dip.', durationMinutes: 6),
      RecipeStepDetail(stepNumber: 5, instruction: 'Drain crispy wedges on paper towels and serve hot with the fresh tomato dip.', durationMinutes: 2),
    ];
  }

  static List<RecipeStepDetail> _buildRiceSteps(bool isGu, bool isHi) {
    if (isGu) {
      return const [
        RecipeStepDetail(stepNumber: 1, instruction: 'ચોખાને પાણીથી ધોઈ લો અને બટાકા કે શાકભાજીને નાના ટુકડામાં સમારી લો.', durationMinutes: 5),
        RecipeStepDetail(stepNumber: 2, instruction: 'તપેલીમાં પાણી અને મીઠું નાખી ચોખાને ધીમા તાપે દાણો છૂટો થાય ત્યાં સુધી બાફી લો.', durationMinutes: 15),
        RecipeStepDetail(stepNumber: 3, instruction: 'કડાઈમાં તેલ ગરમ કરી જીરું ઉમેરો અને સુગંધ આવે ત્યાં સુધી તતડવા દો.', durationMinutes: 2),
        RecipeStepDetail(stepNumber: 4, instruction: 'બટાકા, મીઠું અને મસાલા ઉમેરી ધીમા તાપે સોનેરી થાય ત્યાં સુધી સાંતળો.', durationMinutes: 8),
        RecipeStepDetail(stepNumber: 5, instruction: 'ગરમાગરમ સ્ટીમ્ડ રાઇસ સાથે સ્વાદિષ્ટ જીરા આલૂ પીરસો.', durationMinutes: 2),
      ];
    }
    if (isHi) {
      return const [
        RecipeStepDetail(stepNumber: 1, instruction: 'चावल को अच्छी तरह धो लें और आलू या सब्जियों को छोटे टुकड़ों में काटें।', durationMinutes: 5),
        RecipeStepDetail(stepNumber: 2, instruction: 'पानी और नमक डालकर चावल को धीमी आंच पर 15 मिनट खिले-खिले पकने दें।', durationMinutes: 15),
        RecipeStepDetail(stepNumber: 3, instruction: 'कड़ाही में तेल गरम करके जीरा चटकने तक भूनें।', durationMinutes: 2),
        RecipeStepDetail(stepNumber: 4, instruction: 'आलू, नमक और मसाले डालकर मध्यम आंच पर सुनहरा होने तक भूनें।', durationMinutes: 8),
        RecipeStepDetail(stepNumber: 5, instruction: 'गरमा-गरम चावल के साथ स्वादिष्ट जीरा आलू परोसें।', durationMinutes: 2),
      ];
    }
    return const [
      RecipeStepDetail(stepNumber: 1, instruction: 'Rinse rice in cold water until clear; dice potatoes or vegetables into small cubes.', durationMinutes: 5),
      RecipeStepDetail(stepNumber: 2, instruction: 'Boil 2 cups of water with a pinch of salt, add rice, cover and simmer on low for 15 minutes.', durationMinutes: 15),
      RecipeStepDetail(stepNumber: 3, instruction: 'Heat oil in a pan, add cumin seeds (jeera) and let them sizzle until golden brown.', durationMinutes: 2),
      RecipeStepDetail(stepNumber: 4, instruction: 'Add diced vegetables, salt, and spices; sauté on medium heat until tender-crisp.', durationMinutes: 8),
      RecipeStepDetail(stepNumber: 5, instruction: 'Fluff steamed rice with a fork and serve warm alongside the spiced jeera potatoes.', durationMinutes: 2),
    ];
  }

  static List<RecipeStepDetail> _buildSevTametaSteps(bool isGu, bool isHi) {
    if (isGu) {
      return const [
        RecipeStepDetail(stepNumber: 1, instruction: 'ટામેટાંને ઝીણા સમારી લો અને રાઈ, જીરું અને મસાલા તૈયાર રાખો.', durationMinutes: 4),
        RecipeStepDetail(stepNumber: 2, instruction: 'કડાઈમાં ૨ ચમચી તેલ ગરમ કરી રાઈ, જીરું અને હિંગનો વઘાર કરો.', durationMinutes: 2),
        RecipeStepDetail(stepNumber: 3, instruction: 'ટામેટાં, હળદર, મરચું અને મીઠું ઉમેરી ધીમા તાપે ૭ મિનિટ તેલ છૂટે ત્યાં સુધી સાંતળો.', durationMinutes: 7),
        RecipeStepDetail(stepNumber: 4, instruction: 'થોડું પાણી ઉમેરી ૨ મિનિટ ઉકાળો અને ઉપર ક્રિસ્પી સેવ ઉમેરો.', durationMinutes: 2),
        RecipeStepDetail(stepNumber: 5, instruction: 'સેવનો ક્રંચ જળવાઈ રહે તે માટે ગરમાગરમ રોટલી સાથે તરત જ પીરસો.', durationMinutes: 1),
      ];
    }
    if (isHi) {
      return const [
        RecipeStepDetail(stepNumber: 1, instruction: 'टमाटर को बारीक काट लें और तड़के की सामग्री तैयार करें।', durationMinutes: 4),
        RecipeStepDetail(stepNumber: 2, instruction: 'कड़ाही में 2 चम्मच तेल गरम करके राई, जीरा और हींग का तड़का लगाएं।', durationMinutes: 2),
        RecipeStepDetail(stepNumber: 3, instruction: 'टमाटर, हल्दी, मिर्च और नमक डालकर धीमी आंच पर 7 मिनट तेल छोड़ने तक भूनें।', durationMinutes: 7),
        RecipeStepDetail(stepNumber: 4, instruction: 'थोड़ा पानी डालकर 2 मिनट उबालें और ऊपर से रतलामी सेव डालें।', durationMinutes: 2),
        RecipeStepDetail(stepNumber: 5, instruction: 'कुरकुरी सेव के साथ गरमा-गरम रोटी या पराठे के साथ तुरंत परोसें।', durationMinutes: 1),
      ];
    }
    return const [
      RecipeStepDetail(stepNumber: 1, instruction: 'Finely chop ripe tomatoes and prepare mustard seeds, cumin, and spices.', durationMinutes: 4),
      RecipeStepDetail(stepNumber: 2, instruction: 'Heat 2 tbsp oil in a pan, temper mustard seeds, cumin, and a pinch of hing.', durationMinutes: 2),
      RecipeStepDetail(stepNumber: 3, instruction: 'Add chopped tomatoes, turmeric, chili powder, and salt; cook until juicy and oil separates.', durationMinutes: 7),
      RecipeStepDetail(stepNumber: 4, instruction: 'Add a splash of water, simmer for 2 minutes, and top with crisp Ratlami Sev.', durationMinutes: 2),
      RecipeStepDetail(stepNumber: 5, instruction: 'Serve immediately with hot phulkas or parathas while sev is still crunchy.', durationMinutes: 1),
    ];
  }

  static List<RecipeStepDetail> _buildDalSteps(bool isGu, bool isHi) {
    if (isGu) {
      return const [
        RecipeStepDetail(stepNumber: 1, instruction: 'દાળને સ્વચ્છ પાણીથી ધોઈ કૂકરમાં પાણી અને હળદર સાથે બાફી લો.', durationMinutes: 10),
        RecipeStepDetail(stepNumber: 2, instruction: 'નાની પેનમાં ઘી ગરમ કરી જીરું, લસણ અને હિંગનો વઘાર તૈયાર કરો.', durationMinutes: 3),
        RecipeStepDetail(stepNumber: 3, instruction: 'વઘારને બાફેલી દાળમાં ઉમેરી ધીમા તાપે ૫ મિનિટ ઉકાળો.', durationMinutes: 5),
        RecipeStepDetail(stepNumber: 4, instruction: 'કોથમીર ભભરાવી ગરમાગરમ ભાત કે રોટલી સાથે પીરસો.', durationMinutes: 2),
      ];
    }
    if (isHi) {
      return const [
        RecipeStepDetail(stepNumber: 1, instruction: 'दाल को धोकर कुकर में पानी और हल्दी के साथ 3 सीटी तक पकाएं।', durationMinutes: 10),
        RecipeStepDetail(stepNumber: 2, instruction: 'पैन में घी गरम करके जीरा, लहसुन और हींग का खुशबूदार तड़का लगाएं।', durationMinutes: 3),
        RecipeStepDetail(stepNumber: 3, instruction: 'तड़के को पकी हुई दाल में डालकर 5 मिनट धीमी आंच पर उबालें।', durationMinutes: 5),
        RecipeStepDetail(stepNumber: 4, instruction: 'हरा धनिया डालकर गरमा-गरम चावल या रोटी के साथ परोसें।', durationMinutes: 2),
      ];
    }
    return const [
      RecipeStepDetail(stepNumber: 1, instruction: 'Rinse lentils thoroughly and pressure cook with water, salt, and turmeric until creamy.', durationMinutes: 10),
      RecipeStepDetail(stepNumber: 2, instruction: 'In a small pan, heat ghee or oil and prepare a fragrant tempering with cumin, garlic, and chilies.', durationMinutes: 3),
      RecipeStepDetail(stepNumber: 3, instruction: 'Pour the sizzling tempering into the cooked dal and simmer gently for 5 minutes.', durationMinutes: 5),
      RecipeStepDetail(stepNumber: 4, instruction: 'Garnish with freshly chopped coriander and serve hot with steamed rice or roti.', durationMinutes: 2),
    ];
  }

  static List<RecipeStepDetail> _buildPastaSteps(bool isGu, bool isHi) {
    if (isGu) {
      return const [
        RecipeStepDetail(stepNumber: 1, instruction: 'તપેલીમાં મીઠાવાળું પાણી ઉકાળી પાસ્તા/નૂડલ્સને નરમ થાય ત્યાં સુધી બાફી લો.', durationMinutes: 8),
        RecipeStepDetail(stepNumber: 2, instruction: 'પેનમાં તેલ ગરમ કરી શાકભાજી અને મસાલા તેજ તાપે ૩ મિનિટ સાંતળો.', durationMinutes: 4),
        RecipeStepDetail(stepNumber: 3, instruction: 'ટામેટાંનો સોસ અને મરી પાવડર ઉમેરી ઘટ્ટ થાય ત્યાં સુધી પકવો.', durationMinutes: 5),
        RecipeStepDetail(stepNumber: 4, instruction: 'બાફેલા પાસ્તાને સોસમાં બરાબર મિક્સ કરી ગરમાગરમ પીરસો.', durationMinutes: 2),
      ];
    }
    if (isHi) {
      return const [
        RecipeStepDetail(stepNumber: 1, instruction: 'उबलते पानी में नमक डालकर पास्ता/नूडल्स को अल डेंटे होने तक उबालें।', durationMinutes: 8),
        RecipeStepDetail(stepNumber: 2, instruction: 'पैन में तेल गरम करके सब्जियों को तेज आंच पर 3 मिनट टॉस करें।', durationMinutes: 4),
        RecipeStepDetail(stepNumber: 3, instruction: 'टमाटर सॉस और काली मिर्च डालकर धीमी आंच पर सॉस तैयार करें।', durationMinutes: 5),
        RecipeStepDetail(stepNumber: 4, instruction: 'उबले पास्ता को सॉस के साथ मिलाएं और गरमा-गरम परोसें।', durationMinutes: 2),
      ];
    }
    return const [
      RecipeStepDetail(stepNumber: 1, instruction: 'Bring salted water to a rolling boil and cook pasta/noodles until al dente.', durationMinutes: 8),
      RecipeStepDetail(stepNumber: 2, instruction: 'Heat oil in a skillet and sauté chopped vegetables and seasonings until tender-crisp.', durationMinutes: 4),
      RecipeStepDetail(stepNumber: 3, instruction: 'Stir in tomato sauce or seasonings and simmer gently for 5 minutes.', durationMinutes: 5),
      RecipeStepDetail(stepNumber: 4, instruction: 'Toss drained pasta thoroughly with the sauce and serve warm.', durationMinutes: 2),
    ];
  }

  static List<RecipeStepDetail> _buildDynamicSteps(List<RecipeIngredientDetail> ings, bool isGu, bool isHi) {
    final names = ings.map((e) => e.name).where((n) => n.isNotEmpty).take(2).join(' & ');
    final ingLabel = names.isNotEmpty ? names : 'ingredients';

    if (isGu) {
      return const [
        RecipeStepDetail(stepNumber: 1, instruction: 'બધી સામગ્રીને સ્વચ્છ પાણીથી ધોઈ યોગ્ય કદમાં સમારીને તૈયાર કરો.', durationMinutes: 5),
        RecipeStepDetail(stepNumber: 2, instruction: 'કડાઈમાં તેલ અથવા ઘી ગરમ કરી જીરું અને મસાલાનો સુગંધિત વઘાર કરો.', durationMinutes: 3),
        RecipeStepDetail(stepNumber: 3, instruction: 'મુખ્ય સામગ્રી ઉમેરી ધીમા તાપે ૧૦-૧૨ મિનિટ સારી રીતે ચડવા દો.', durationMinutes: 12),
        RecipeStepDetail(stepNumber: 4, instruction: 'કોથમીર ભભરાવી ગરમાગરમ રોટલી કે ભાત સાથે પીરસો.', durationMinutes: 2),
      ];
    }
    if (isHi) {
      return const [
        RecipeStepDetail(stepNumber: 1, instruction: 'सभी सामग्री को धोकर उचित आकार में काट कर तैयार कर लें।', durationMinutes: 5),
        RecipeStepDetail(stepNumber: 2, instruction: 'कड़ाही में तेल या घी गरम करके जीरा और मसालों का तड़का लगाएं।', durationMinutes: 3),
        RecipeStepDetail(stepNumber: 3, instruction: 'मुख्य सामग्री डालकर धीमी आंच पर 10-12 मिनट अच्छी तरह पकने दें।', durationMinutes: 12),
        RecipeStepDetail(stepNumber: 4, instruction: 'हरा धनिया डालकर गरमा-गरम रोटी या चावल के साथ परोसें।', durationMinutes: 2),
      ];
    }
    return [
      RecipeStepDetail(stepNumber: 1, instruction: 'Wash, peel, and prep all $ingLabel into uniform bite-sized pieces.', durationMinutes: 5),
      const RecipeStepDetail(stepNumber: 2, instruction: 'Heat cooking oil in a pan over medium heat; add spices until fragrant.', durationMinutes: 3),
      RecipeStepDetail(stepNumber: 3, instruction: 'Add $ingLabel, season with salt and spices, and sauté for 8-10 minutes.', durationMinutes: 9),
      const RecipeStepDetail(stepNumber: 4, instruction: 'Simmer gently until thoroughly cooked, garnish with fresh herbs, and serve hot.', durationMinutes: 3),
    ];
  }
}
