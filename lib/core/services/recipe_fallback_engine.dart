import '../../features/recipes/models/generated_recipe.dart';
import '../../features/recipes/models/ingredient_item.dart';

/// Fallback engine providing 3 rich TV-host style recipes when API is offline or demo.
class RecipeFallbackEngine {
  static List<GeneratedRecipe> getFallbackRecipes(
    List<IngredientItem> ingredients,
    int peopleCount,
    String lang,
  ) {
    final names = ingredients.map((i) => i.name.toLowerCase()).toList();
    final isBesanCurd = names.any(
      (n) =>
          n.contains('besan') ||
          n.contains('curd') ||
          n.contains('dahi') ||
          n.contains('chhas') ||
          n.contains('buttermilk'),
    );

    if (lang == 'Gujarati') {
      return _getGujaratiFallback(isBesanCurd, peopleCount);
    } else if (lang == 'Hindi') {
      return _getHindiFallback(isBesanCurd, peopleCount);
    }
    return _getEnglishFallback(isBesanCurd, peopleCount);
  }

  static List<GeneratedRecipe> _getGujaratiFallback(
    bool isBesanCurd,
    int count,
  ) {
    if (isBesanCurd) {
      return [
        GeneratedRecipe(
          category: 'Gujarati',
          name: 'કાઠિયાવાડી કઢી (Kathiyawadi Kadhi)',
          description:
              'ચટાકેદાર બેસન અને તાજી છાશમાંથી બનેલી ખાટી-મીઠી કાઠિયાવાડી કઢી.',
          servings: count,
          prepTimeMinutes: 10,
          cookTimeMinutes: 15,
          totalTimeMinutes: 25,
          difficulty: 'Easy',
          caloriesPerServing: 280,
          matchPercent: '99%',
          availableIngredients: [
            RecipeIngredientDetail(
              name: 'બેસન (Besan)',
              quantity: '${40 * count} g',
            ),
            RecipeIngredientDetail(
              name: 'છાશ / દહીં (Buttermilk)',
              quantity: '${250 * count} ml',
            ),
          ],
          assumedStaples: [
            RecipeIngredientDetail(
              name: 'મીઠું (Salt)',
              quantity: 'સ્વાદ અનુસાર',
              type: 'assumed',
            ),
            RecipeIngredientDetail(
              name: 'તેલ / ઘી (Oil/Ghee)',
              quantity: '૧ tbsp',
              type: 'assumed',
            ),
            RecipeIngredientDetail(
              name: 'પાણી (Water)',
              quantity: '૧૦૦ ml',
              type: 'assumed',
            ),
          ],
          missingIngredients: [
            RecipeIngredientDetail(
              name: 'રાય, જીરું, લીમડો, ગોળ',
              quantity: '૧ tsp દરેક',
              type: 'missing',
            ),
          ],
          steps: [
            RecipeStepDetail(
              stepNumber: 1,
              instruction:
                  'વાસણમાં બેસન અને છાશ ઉમેરી ઝેરણીથી બરાબર હલાવી ગઠ્ઠા વગરનું લીસું ખીરું બનાવો.',
              durationMinutes: 3,
            ),
            RecipeStepDetail(
              stepNumber: 2,
              instruction:
                  'કડાઈમાં ૧ ચમચી ઘી ગરમ કરી તેમાં રાય, જીરું, હિંગ અને કઢી પત્તાનો તાજો વઘાર કરો.',
              durationMinutes: 2,
            ),
            RecipeStepDetail(
              stepNumber: 3,
              instruction:
                  'તૈયાર ખીરું વઘારમાં રેડો અને ગઠ્ઠા ન પડે તે માટે સતત હલાવતા રહો.',
              durationMinutes: 4,
            ),
            RecipeStepDetail(
              stepNumber: 4,
              instruction:
                  'હળદર, ગોળ અને મીઠું ઉમેરી ધીમા તાપે ૮-૧૦ મિનિટ સુંદર ઉભરો આવે ત્યાં સુધી ઉકાળો.',
              durationMinutes: 10,
            ),
          ],
          chefTip:
              'કઢીને સતત હલાવતા રહેવાથી તે ફાટી જતી નથી અને એકરસ સ્વાદિષ્ટ બને છે!',
        ),
        GeneratedRecipe(
          category: 'Indian',
          name: 'ચટાકેદાર બેસન પકોડા (Besan Pakoda)',
          description: 'કરકરા ક્રિસ્પી મસાલેદાર પકોડા, ગરમાગરમ ચટણી સાથે.',
          servings: count,
          prepTimeMinutes: 10,
          cookTimeMinutes: 10,
          totalTimeMinutes: 20,
          difficulty: 'Easy',
          caloriesPerServing: 340,
          matchPercent: '96%',
          availableIngredients: [
            RecipeIngredientDetail(
              name: 'બેસન (Besan)',
              quantity: '${60 * count} g',
            ),
          ],
          assumedStaples: [
            RecipeIngredientDetail(
              name: 'તેલ (Oil)',
              quantity: 'તળવા માટે',
              type: 'assumed',
            ),
            RecipeIngredientDetail(
              name: 'મીઠું અને હળદર',
              quantity: 'સ્વાદ મુજબ',
              type: 'assumed',
            ),
          ],
          missingIngredients: [
            RecipeIngredientDetail(
              name: 'ડુંગળી અને લીલા મરચાં',
              quantity: '૧ નંગ',
              type: 'missing',
            ),
          ],
          steps: [
            RecipeStepDetail(
              stepNumber: 1,
              instruction:
                  'બાઉલમાં બેસન, સમારેલી ડુંગળી, મરચાં અને અજમો મિક્સ કરો.',
              durationMinutes: 4,
            ),
            RecipeStepDetail(
              stepNumber: 2,
              instruction: 'થોડું પાણી ઉમેરી ઘટ્ટ પકોડાનું ખીરું તૈયાર કરો.',
              durationMinutes: 2,
            ),
            RecipeStepDetail(
              stepNumber: 3,
              instruction:
                  'ગરમ તેલમાં નાના પકોડા મૂકી સોનેરી રંગના થાય ત્યાં સુધી તળો.',
              durationMinutes: 8,
            ),
          ],
          chefTip: 'ખીરામાં ૧ ચમચી ગરમ તેલ ઉમેરવાથી પકોડા વધારે ક્રિસ્પી બનશે.',
        ),
        GeneratedRecipe(
          category: 'Global',
          name: 'મસાલા બેસન ક્રેપ્સ (Global Besan Pancakes)',
          description: 'વેજિટેબલ સ્ટફ્ડ ગ્લોબલ સ્ટાઇલ બેસન ક્રેપ્સ.',
          servings: count,
          prepTimeMinutes: 10,
          cookTimeMinutes: 10,
          totalTimeMinutes: 20,
          difficulty: 'Easy',
          caloriesPerServing: 310,
          matchPercent: '92%',
          availableIngredients: [
            RecipeIngredientDetail(
              name: 'બેસન (Besan)',
              quantity: '${50 * count} g',
            ),
          ],
          assumedStaples: [
            RecipeIngredientDetail(
              name: 'પાણી (Water)',
              quantity: '૧૦૦ ml',
              type: 'assumed',
            ),
            RecipeIngredientDetail(
              name: 'તેલ (Oil)',
              quantity: '૧ tbsp',
              type: 'assumed',
            ),
          ],
          missingIngredients: [
            RecipeIngredientDetail(
              name: 'ટામેટાં અને કોથમીર',
              quantity: '૫૦ g',
              type: 'missing',
            ),
          ],
          steps: [
            RecipeStepDetail(
              stepNumber: 1,
              instruction: 'બેસનમાં પાણી ઉમેરી પાતળું ક્રેપ્સ ખીરું બનાવો.',
              durationMinutes: 3,
            ),
            RecipeStepDetail(
              stepNumber: 2,
              instruction: 'નૉન-સ્ટિક તવા પર ખીરું પાથરી બંને બાજુ શેકી લો.',
              durationMinutes: 6,
            ),
          ],
          chefTip: 'તવા પર થોડું બટર લગાવવાથી રેસ્ટોરન્ટ જેવો ટેસ્ટ મળશે.',
        ),
      ];
    }

    return [
      GeneratedRecipe(
        category: 'Gujarati',
        name: 'કાઠિયાવાડી સેવ ટામેટાંનું શાક (Sev Tameta)',
        description: 'ખાટું-મીઠું અને મસાલેદાર કાઠિયાવાડી રસાવાળું શાક.',
        servings: count,
        prepTimeMinutes: 10,
        cookTimeMinutes: 10,
        totalTimeMinutes: 20,
        difficulty: 'Easy',
        caloriesPerServing: 320,
        matchPercent: '98%',
        availableIngredients: [
          RecipeIngredientDetail(
            name: 'ટામેટાં (Tomatoes)',
            quantity: '${150 * count} g',
          ),
        ],
        assumedStaples: [
          RecipeIngredientDetail(
            name: 'તેલ (Oil)',
            quantity: '૨ tbsp',
            type: 'assumed',
          ),
          RecipeIngredientDetail(
            name: 'હળદર-મરચું (Spices)',
            quantity: '૧ tsp',
            type: 'assumed',
          ),
        ],
        missingIngredients: [
          RecipeIngredientDetail(
            name: 'રતલામી સેવ (Ratlami Sev)',
            quantity: '${40 * count} g',
            type: 'missing',
          ),
        ],
        steps: [
          RecipeStepDetail(
            stepNumber: 1,
            instruction: 'ટામેટાંના મધ્યમ કદના ટુકડા સમારી લો.',
            durationMinutes: 3,
          ),
          RecipeStepDetail(
            stepNumber: 2,
            instruction:
                'તેલમાં રાય-જીરુંનો વઘાર કરી ટામેટાં અને મસાલા ઉમેરી ૫ મિનિટ સાંતળો.',
            durationMinutes: 5,
          ),
          RecipeStepDetail(
            stepNumber: 3,
            instruction: 'પીરસતા પહેલાં ઉપર ક્રિસ્પી સેવ ઉમેરો.',
            durationMinutes: 2,
          ),
        ],
        chefTip: 'સેવને છેલ્લે જ ઉમેરો જેથી તે નરમ ન પડે.',
      ),
      GeneratedRecipe(
        category: 'Indian',
        name: 'દેશી દાળ તડકા (Desi Dal Tadka)',
        description: 'ધાબા સ્ટાઇલ લસણીયા વઘારવાળી પૌષ્ટિક તુવેર દાળ.',
        servings: count,
        prepTimeMinutes: 10,
        cookTimeMinutes: 15,
        totalTimeMinutes: 25,
        difficulty: 'Easy',
        caloriesPerServing: 360,
        matchPercent: '95%',
        availableIngredients: [
          RecipeIngredientDetail(
            name: 'દાળ (Dal)',
            quantity: '${80 * count} g',
          ),
        ],
        assumedStaples: [
          RecipeIngredientDetail(
            name: 'પાણી (Water)',
            quantity: '૩૦૦ ml',
            type: 'assumed',
          ),
          RecipeIngredientDetail(
            name: 'મીઠું (Salt)',
            quantity: '૧ tsp',
            type: 'assumed',
          ),
        ],
        missingIngredients: [
          RecipeIngredientDetail(
            name: 'લસણ અને જીરું',
            quantity: '૧ tbsp',
            type: 'missing',
          ),
        ],
        steps: [
          RecipeStepDetail(
            stepNumber: 1,
            instruction: 'દાળને કૂકરમાં ૩ સીટી સુધી બાફી લો.',
            durationMinutes: 12,
          ),
          RecipeStepDetail(
            stepNumber: 2,
            instruction: 'ઘીમાં લસણ અને સૂકા મરચાંનો કડક વઘાર દાળ પર રેડો.',
            durationMinutes: 3,
          ),
        ],
        chefTip: 'વઘાર કરતી વખતે ઘીનો ઉપયોગ કરવાથી સુગંધ અદ્ભુત આવે છે.',
      ),
      GeneratedRecipe(
        category: 'Global',
        name: 'ઇટાલિયન વેજીટેબલ સૂપ (Minestrone Soup)',
        description: 'તાજા ટામેટાં અને જડીબુટ્ટીઓ સાથે ગુણકારી સૂપ.',
        servings: count,
        prepTimeMinutes: 10,
        cookTimeMinutes: 15,
        totalTimeMinutes: 25,
        difficulty: 'Medium',
        caloriesPerServing: 220,
        matchPercent: '90%',
        availableIngredients: [
          RecipeIngredientDetail(
            name: 'ટામેટાં (Tomatoes)',
            quantity: '${100 * count} g',
          ),
        ],
        assumedStaples: [
          RecipeIngredientDetail(
            name: 'પાણી (Water)',
            quantity: '૨૫૦ ml',
            type: 'assumed',
          ),
          RecipeIngredientDetail(
            name: 'મીઠું (Salt)',
            quantity: '૧ tsp',
            type: 'assumed',
          ),
        ],
        missingIngredients: [
          RecipeIngredientDetail(
            name: 'ઓરેગાનો અને બટર',
            quantity: '૧ tsp',
            type: 'missing',
          ),
        ],
        steps: [
          RecipeStepDetail(
            stepNumber: 1,
            instruction: 'ટામેટાં અને શાકભાજીની પ્યુરી બનાવી ઉકાળો.',
            durationMinutes: 10,
          ),
          RecipeStepDetail(
            stepNumber: 2,
            instruction: 'ઓરેગાનો અને કાળા મરી ભભરાવી ગરમ સૂપ પીરસો.',
            durationMinutes: 5,
          ),
        ],
        chefTip: 'તાજી તુલસી કે ઓરેગાનો ઉમેરવાથી ઇટાલિયન ટેસ્ટ મળશે.',
      ),
    ];
  }

  static List<GeneratedRecipe> _getHindiFallback(bool isBesanCurd, int count) {
    if (isBesanCurd) {
      return [
        GeneratedRecipe(
          category: 'Gujarati',
          name: 'काठियावाड़ी कढ़ी (Kathiyawadi Kadhi)',
          description: 'बेसन और ताजा छाछ से बनी खट्टी-मीठी काठियावाड़ी कढ़ी।',
          servings: count,
          prepTimeMinutes: 10,
          cookTimeMinutes: 15,
          totalTimeMinutes: 25,
          difficulty: 'Easy',
          caloriesPerServing: 280,
          matchPercent: '99%',
          availableIngredients: [
            RecipeIngredientDetail(
              name: 'बेसन (Besan)',
              quantity: '${40 * count} g',
            ),
            RecipeIngredientDetail(
              name: 'दही / छाछ (Buttermilk)',
              quantity: '${250 * count} ml',
            ),
          ],
          assumedStaples: [
            RecipeIngredientDetail(
              name: 'नमक (Salt)',
              quantity: 'स्वादानुसार',
              type: 'assumed',
            ),
            RecipeIngredientDetail(
              name: 'तेल / घी (Oil/Ghee)',
              quantity: '1 tbsp',
              type: 'assumed',
            ),
          ],
          missingIngredients: [
            RecipeIngredientDetail(
              name: 'राई, जीरा, कड़ी पत्ता, गुड़',
              quantity: '1 tsp प्रत्येक',
              type: 'missing',
            ),
          ],
          steps: [
            RecipeStepDetail(
              stepNumber: 1,
              instruction:
                  'बर्तन में बेसन और छाछ मिलाकर बिना गांठ का घोल बनाएं।',
              durationMinutes: 3,
            ),
            RecipeStepDetail(
              stepNumber: 2,
              instruction:
                  'कढ़ाई में घी गरम करके राई, जीरा, हींग और कड़ी पत्ता का तड़का लगाएं।',
              durationMinutes: 2,
            ),
            RecipeStepDetail(
              stepNumber: 3,
              instruction: 'बेसन का घोल तड़के में डालकर लगातार चलाते रहें।',
              durationMinutes: 4,
            ),
            RecipeStepDetail(
              stepNumber: 4,
              instruction: 'गुड़, हल्दी और नमक डालकर 8-10 मिनट तक उबालें।',
              durationMinutes: 10,
            ),
          ],
          chefTip:
              'कढ़ी को लगातार चलाते रहने से बेसन फटता नहीं है और कढ़ी गाढ़ी बनती है!',
        ),
        GeneratedRecipe(
          category: 'Indian',
          name: 'चटपटे बेसन पकोड़े (Besan Pakoda)',
          description: 'क्रिस्पी और मसालेदार बेसन के पकोड़े।',
          servings: count,
          prepTimeMinutes: 10,
          cookTimeMinutes: 10,
          totalTimeMinutes: 20,
          difficulty: 'Easy',
          caloriesPerServing: 340,
          matchPercent: '96%',
          availableIngredients: [
            RecipeIngredientDetail(
              name: 'बेसन (Besan)',
              quantity: '${60 * count} g',
            ),
          ],
          assumedStaples: [
            RecipeIngredientDetail(
              name: 'तेल (Oil)',
              quantity: 'तलने के लिए',
              type: 'assumed',
            ),
            RecipeIngredientDetail(
              name: 'नमक और हल्दी',
              quantity: 'स्वादानुसार',
              type: 'assumed',
            ),
          ],
          missingIngredients: [
            RecipeIngredientDetail(
              name: 'प्याज़ और हरी मिर्च',
              quantity: '1 नग',
              type: 'missing',
            ),
          ],
          steps: [
            RecipeStepDetail(
              stepNumber: 1,
              instruction: 'बेसन में प्याज, मिर्च और अजवाइन मिलाएं।',
              durationMinutes: 4,
            ),
            RecipeStepDetail(
              stepNumber: 2,
              instruction:
                  'पानी मिलाकर गाढ़ा घोल बनाएं और सुनहरे होने तक तलें।',
              durationMinutes: 8,
            ),
          ],
          chefTip:
              'घोल में 1 चम्मच गरम तेल मिलाने से पकोड़े अधिक कुरकुरे बनते हैं।',
        ),
        GeneratedRecipe(
          category: 'Global',
          name: 'बेसन वेज क्रेप्स (Besan Crepes)',
          description: 'ग्लोबल स्टाइल में बना नमकीन बेसन पैनकेक।',
          servings: count,
          prepTimeMinutes: 10,
          cookTimeMinutes: 10,
          totalTimeMinutes: 20,
          difficulty: 'Easy',
          caloriesPerServing: 310,
          matchPercent: '92%',
          availableIngredients: [
            RecipeIngredientDetail(
              name: 'बेसन (Besan)',
              quantity: '${50 * count} g',
            ),
          ],
          assumedStaples: [
            RecipeIngredientDetail(
              name: 'पानी (Water)',
              quantity: '100 ml',
              type: 'assumed',
            ),
          ],
          missingIngredients: [
            RecipeIngredientDetail(
              name: 'टमाटर और धनिया',
              quantity: '50 g',
              type: 'missing',
            ),
          ],
          steps: [
            RecipeStepDetail(
              stepNumber: 1,
              instruction:
                  'बेसन का पतला घोल बनाकर तवे पर फैलाएं और दोनों तरफ सेकें।',
              durationMinutes: 8,
            ),
          ],
          chefTip: 'तवे पर थोड़ा बटर लगाने से अच्छा स्वाद आता है।',
        ),
      ];
    }

    return [
      GeneratedRecipe(
        category: 'Gujarati',
        name: 'काठियावाड़ी सेव टमाटर सब्जी (Sev Tameta)',
        description: 'प्रसिद्ध खट्टी-मीठी और मसालेदार सेव टमाटर की सब्जी।',
        servings: count,
        prepTimeMinutes: 10,
        cookTimeMinutes: 10,
        totalTimeMinutes: 20,
        difficulty: 'Easy',
        caloriesPerServing: 320,
        matchPercent: '98%',
        availableIngredients: [
          RecipeIngredientDetail(
            name: 'टमाटर (Tomatoes)',
            quantity: '${150 * count} g',
          ),
        ],
        assumedStaples: [
          RecipeIngredientDetail(
            name: 'तेल (Oil)',
            quantity: '2 tbsp',
            type: 'assumed',
          ),
          RecipeIngredientDetail(
            name: 'मसाले (Spices)',
            quantity: '1 tsp',
            type: 'assumed',
          ),
        ],
        missingIngredients: [
          RecipeIngredientDetail(
            name: 'रतलामी सेव (Ratlami Sev)',
            quantity: '${40 * count} g',
            type: 'missing',
          ),
        ],
        steps: [
          RecipeStepDetail(
            stepNumber: 1,
            instruction:
                'टमाटर काटकर तेल में राई-जीरा का तड़का लगाएं और 5 मिनट पकाएं।',
            durationMinutes: 5,
          ),
          RecipeStepDetail(
            stepNumber: 2,
            instruction: 'परोसते समय ऊपर से सेव डालें।',
            durationMinutes: 2,
          ),
        ],
        chefTip: 'सेव को सबसे अंत में डालें ताकि वह क्रिस्पी रहे।',
      ),
      GeneratedRecipe(
        category: 'Indian',
        name: 'देसी दाल तड़का (Desi Dal Tadka)',
        description: 'ढाबा स्टाइल लहसुनी तड़के वाली दाल।',
        servings: count,
        prepTimeMinutes: 10,
        cookTimeMinutes: 15,
        totalTimeMinutes: 25,
        difficulty: 'Easy',
        caloriesPerServing: 360,
        matchPercent: '95%',
        availableIngredients: [
          RecipeIngredientDetail(
            name: 'दाल (Dal)',
            quantity: '${80 * count} g',
          ),
        ],
        assumedStaples: [
          RecipeIngredientDetail(
            name: 'पानी (Water)',
            quantity: '300 ml',
            type: 'assumed',
          ),
        ],
        missingIngredients: [
          RecipeIngredientDetail(
            name: 'लहसुन और जीरा',
            quantity: '1 tbsp',
            type: 'missing',
          ),
        ],
        steps: [
          RecipeStepDetail(
            stepNumber: 1,
            instruction: 'दाल उबालकर लहसुन-मिर्च का कड़क तड़का लगाएं।',
            durationMinutes: 15,
          ),
        ],
        chefTip: 'तड़के में देसी घी का उपयोग करें।',
      ),
      GeneratedRecipe(
        category: 'Global',
        name: 'इतालवी टमाटर सूप (Minestrone Soup)',
        description: 'ताजा टमाटरों और जड़ी-बूटियों से बना सूप।',
        servings: count,
        prepTimeMinutes: 10,
        cookTimeMinutes: 15,
        totalTimeMinutes: 25,
        difficulty: 'Medium',
        caloriesPerServing: 220,
        matchPercent: '90%',
        availableIngredients: [
          RecipeIngredientDetail(
            name: 'टमाटर (Tomatoes)',
            quantity: '${100 * count} g',
          ),
        ],
        assumedStaples: [
          RecipeIngredientDetail(
            name: 'पानी (Water)',
            quantity: '250 ml',
            type: 'assumed',
          ),
        ],
        missingIngredients: [
          RecipeIngredientDetail(
            name: 'ओरेगानो और बटर',
            quantity: '1 tsp',
            type: 'missing',
          ),
        ],
        steps: [
          RecipeStepDetail(
            stepNumber: 1,
            instruction: 'टमाटर की प्यूरी बनाकर ओरेगानो डालकर पकाएं।',
            durationMinutes: 12,
          ),
        ],
        chefTip: 'ताजा बटर डालने से सूप गाढ़ा बनता है।',
      ),
    ];
  }

  static List<GeneratedRecipe> _getEnglishFallback(
    bool isBesanCurd,
    int count,
  ) {
    if (isBesanCurd) {
      return [
        GeneratedRecipe(
          category: 'Gujarati',
          name: 'Authentic Kathiyawadi Kadhi',
          description:
              'A sweet & tangy authentic Gujarati buttermilk curry infused with mustard & curry leaves.',
          servings: count,
          prepTimeMinutes: 10,
          cookTimeMinutes: 15,
          totalTimeMinutes: 25,
          difficulty: 'Easy',
          caloriesPerServing: 280,
          matchPercent: '99%',
          availableIngredients: [
            RecipeIngredientDetail(
              name: 'Gram Flour (Besan)',
              quantity: '${40 * count} g',
            ),
            RecipeIngredientDetail(
              name: 'Buttermilk / Curd',
              quantity: '${250 * count} ml',
            ),
          ],
          assumedStaples: [
            RecipeIngredientDetail(
              name: 'Salt',
              quantity: 'to taste',
              type: 'assumed',
            ),
            RecipeIngredientDetail(
              name: 'Ghee / Oil',
              quantity: '1 tbsp',
              type: 'assumed',
            ),
            RecipeIngredientDetail(
              name: 'Water',
              quantity: '100 ml',
              type: 'assumed',
            ),
          ],
          missingIngredients: [
            RecipeIngredientDetail(
              name: 'Mustard seeds, Cumin, Curry leaves, Jaggery',
              quantity: '1 tsp each',
              type: 'missing',
            ),
          ],
          steps: [
            RecipeStepDetail(
              stepNumber: 1,
              instruction:
                  'Whisk the gram flour into buttermilk until completely smooth without any lumps.',
              durationMinutes: 3,
            ),
            RecipeStepDetail(
              stepNumber: 2,
              instruction:
                  'Heat ghee in a heavy pan, add mustard seeds, cumin, hing, and curry leaves until they splutter.',
              durationMinutes: 2,
            ),
            RecipeStepDetail(
              stepNumber: 3,
              instruction:
                  'Pour the buttermilk mixture into the pan while stirring continuously on medium flame.',
              durationMinutes: 4,
            ),
            RecipeStepDetail(
              stepNumber: 4,
              instruction:
                  'Add turmeric, jaggery, and salt, then simmer gently for 8-10 minutes until aromatic.',
              durationMinutes: 10,
            ),
          ],
          chefTip:
              'Whisk constantly while bringing to a boil to prevent the buttermilk from curdling!',
        ),
        GeneratedRecipe(
          category: 'Indian',
          name: 'Crispy Besan Pakoda',
          description:
              'Golden spiced gram flour fritters crispy on the outside.',
          servings: count,
          prepTimeMinutes: 10,
          cookTimeMinutes: 10,
          totalTimeMinutes: 20,
          difficulty: 'Easy',
          caloriesPerServing: 340,
          matchPercent: '96%',
          availableIngredients: [
            RecipeIngredientDetail(
              name: 'Gram Flour (Besan)',
              quantity: '${60 * count} g',
            ),
          ],
          assumedStaples: [
            RecipeIngredientDetail(
              name: 'Oil',
              quantity: 'for deep frying',
              type: 'assumed',
            ),
            RecipeIngredientDetail(
              name: 'Salt & Turmeric',
              quantity: 'to taste',
              type: 'assumed',
            ),
          ],
          missingIngredients: [
            RecipeIngredientDetail(
              name: 'Onion & Green Chillies',
              quantity: '1 medium',
              type: 'missing',
            ),
          ],
          steps: [
            RecipeStepDetail(
              stepNumber: 1,
              instruction:
                  'Combine gram flour, sliced onions, chillies, and spices in a mixing bowl.',
              durationMinutes: 4,
            ),
            RecipeStepDetail(
              stepNumber: 2,
              instruction:
                  'Add water bit by bit to form a thick drop-consistency batter.',
              durationMinutes: 2,
            ),
            RecipeStepDetail(
              stepNumber: 3,
              instruction:
                  'Drop spoonfuls into hot oil and fry until golden crisp and cooked through.',
              durationMinutes: 8,
            ),
          ],
          chefTip:
              'Adding 1 tsp of hot oil to the batter makes the pakodas extra crispy!',
        ),
        GeneratedRecipe(
          category: 'Global',
          name: 'Savory Besan Crepes',
          description:
              'Protein-packed savory Mediterranean-style chickpea flour crepes.',
          servings: count,
          prepTimeMinutes: 10,
          cookTimeMinutes: 10,
          totalTimeMinutes: 20,
          difficulty: 'Easy',
          caloriesPerServing: 310,
          matchPercent: '92%',
          availableIngredients: [
            RecipeIngredientDetail(
              name: 'Gram Flour (Besan)',
              quantity: '${50 * count} g',
            ),
          ],
          assumedStaples: [
            RecipeIngredientDetail(
              name: 'Water',
              quantity: '100 ml',
              type: 'assumed',
            ),
            RecipeIngredientDetail(
              name: 'Olive Oil',
              quantity: '1 tbsp',
              type: 'assumed',
            ),
          ],
          missingIngredients: [
            RecipeIngredientDetail(
              name: 'Tomatoes & Herbs',
              quantity: '50 g',
              type: 'missing',
            ),
          ],
          steps: [
            RecipeStepDetail(
              stepNumber: 1,
              instruction:
                  'Whisk gram flour with water and salt to a thin crepe batter.',
              durationMinutes: 3,
            ),
            RecipeStepDetail(
              stepNumber: 2,
              instruction:
                  'Pour on a hot non-stick skillet and cook until golden brown on both sides.',
              durationMinutes: 6,
            ),
          ],
          chefTip:
              'Serve with fresh herb dip or salsa for an authentic global brunch experience.',
        ),
      ];
    }

    return [
      GeneratedRecipe(
        category: 'Gujarati',
        name: 'Kathiyawadi Sev Tameta Nu Shaak',
        description:
            'Classic Gujarati sweet & spicy tomato curry topped with crisp Ratlami Sev.',
        servings: count,
        prepTimeMinutes: 10,
        cookTimeMinutes: 10,
        totalTimeMinutes: 20,
        difficulty: 'Easy',
        caloriesPerServing: 320,
        matchPercent: '98%',
        availableIngredients: [
          RecipeIngredientDetail(
            name: 'Tomatoes',
            quantity: '${150 * count} g',
          ),
        ],
        assumedStaples: [
          RecipeIngredientDetail(
            name: 'Oil',
            quantity: '2 tbsp',
            type: 'assumed',
          ),
          RecipeIngredientDetail(
            name: 'Red Chili & Turmeric',
            quantity: '1 tsp',
            type: 'assumed',
          ),
        ],
        missingIngredients: [
          RecipeIngredientDetail(
            name: 'Ratlami Sev',
            quantity: '${40 * count} g',
            type: 'missing',
          ),
        ],
        steps: [
          RecipeStepDetail(
            stepNumber: 1,
            instruction: 'Chop ripe tomatoes into medium cubes.',
            durationMinutes: 3,
          ),
          RecipeStepDetail(
            stepNumber: 2,
            instruction:
                'Temper mustard seeds in oil, add tomatoes and spices, and cook until juicy soft.',
            durationMinutes: 5,
          ),
          RecipeStepDetail(
            stepNumber: 3,
            instruction: 'Top with crunchy Ratlami Sev right before serving.',
            durationMinutes: 2,
          ),
        ],
        chefTip:
            'Add the Sev right before eating so it retains its iconic crunch!',
      ),
      GeneratedRecipe(
        category: 'Indian',
        name: 'Dhaba Style Dal Tadka',
        description:
            'Comforting yellow lentils finished with a garlic and ghee tempering.',
        servings: count,
        prepTimeMinutes: 10,
        cookTimeMinutes: 15,
        totalTimeMinutes: 25,
        difficulty: 'Easy',
        caloriesPerServing: 360,
        matchPercent: '95%',
        availableIngredients: [
          RecipeIngredientDetail(
            name: 'Lentils (Dal)',
            quantity: '${80 * count} g',
          ),
        ],
        assumedStaples: [
          RecipeIngredientDetail(
            name: 'Water',
            quantity: '300 ml',
            type: 'assumed',
          ),
        ],
        missingIngredients: [
          RecipeIngredientDetail(
            name: 'Garlic & Cumin',
            quantity: '1 tbsp',
            type: 'missing',
          ),
        ],
        steps: [
          RecipeStepDetail(
            stepNumber: 1,
            instruction: 'Pressure cook lentils until soft and creamy.',
            durationMinutes: 12,
          ),
          RecipeStepDetail(
            stepNumber: 2,
            instruction:
                'Pour hot garlic-chilli ghee tempering over cooked lentils and serve warm.',
            durationMinutes: 3,
          ),
        ],
        chefTip: 'Use pure ghee for tempering to get authentic Dhaba flavor.',
      ),
      GeneratedRecipe(
        category: 'Global',
        name: 'Fresh Italian Tomato Soup',
        description:
            'Rich, smooth tomato soup seasoned with oregano and fresh herbs.',
        servings: count,
        prepTimeMinutes: 10,
        cookTimeMinutes: 15,
        totalTimeMinutes: 25,
        difficulty: 'Medium',
        caloriesPerServing: 220,
        matchPercent: '90%',
        availableIngredients: [
          RecipeIngredientDetail(
            name: 'Tomatoes',
            quantity: '${100 * count} g',
          ),
        ],
        assumedStaples: [
          RecipeIngredientDetail(
            name: 'Water',
            quantity: '250 ml',
            type: 'assumed',
          ),
        ],
        missingIngredients: [
          RecipeIngredientDetail(
            name: 'Oregano & Butter',
            quantity: '1 tsp',
            type: 'missing',
          ),
        ],
        steps: [
          RecipeStepDetail(
            stepNumber: 1,
            instruction: 'Simmer fresh tomato puree with garlic and oregano.',
            durationMinutes: 12,
          ),
        ],
        chefTip: 'Finish with a drizzle of cream or extra virgin olive oil.',
      ),
    ];
  }
}
