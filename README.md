# ShelfChef AI

Smart pantry, grocery, and meal-planning mobile app. Manages food inventory, tracks expiry dates, scans grocery bills via OCR, suggests AI-powered recipes from ingredients on hand, tracks grocery budget/expenses, and reads recipes aloud via text-to-speech.

📄 **Full project spec (screens, UI/UX, color system, user flows, features):**
see [`docs/PROJECT_OVERVIEW.md`](docs/PROJECT_OVERVIEW.md)

## 📐 Coding & Architectural Guidelines

1. **250-Line File Constraint**:
   - No single source file (`.dart`) should exceed **250 lines**.
   - If a file or widget grows beyond 250 lines, refactor it into dedicated helper classes, sub-widgets, or delegates.

2. **Ultra-Clean `build()` Method Standard**:
   - The `build()` method must remain extremely concise, high-level, and readable (listing only top-level layout wrappers and private helper builders).
   - All UI sections, components, and action handlers must be declared as descriptive private methods **separately below the `build()` method** under `// --- Private Sub-Widgets Defined Below Build Function ---`.

3. **Reference Architecture Code Pattern**:
   ```dart
   class WelcomeScreen extends StatelessWidget {
     const WelcomeScreen({super.key});

     void _navigateToSignupScreen(BuildContext context) { ... }
     void _navigateToLoginScreen(BuildContext context) { ... }

     @override
     Widget build(BuildContext context) {
       return Scaffold(
         backgroundColor: context.colors.background,
         body: Column(
           children: [
             _buildCookingHeroBanner(context),
             Expanded(
               child: Padding(
                 padding: AppSizes.paddingScreen,
                 child: Column(
                   children: [
                     _buildCreateAccountActionButton(context),
                     _buildGoogleSignInSocialButton(context),
                     _buildOrDividerLine(context),
                     _buildSignInExistingAccountButton(context),
                     const Spacer(),
                     _buildTermsAndPrivacyFooterText(context),
                   ],
                 ),
               ),
             ),
           ],
         ),
       );
     }

     // --- Private Sub-Widgets Defined Below Build Function ---

     Widget _buildCookingHeroBanner(BuildContext context) { ... }
     Widget _buildSmartPantryBrandBadge() { ... }
     Widget _buildWelcomeHeadlineText() { ... }
     Widget _buildCreateAccountActionButton(BuildContext context) { ... }
     Widget _buildGoogleSignInSocialButton(BuildContext context) { ... }
     Widget _buildOrDividerLine(BuildContext context) { ... }
     Widget _buildSignInExistingAccountButton(BuildContext context) { ... }
     Widget _buildTermsAndPrivacyFooterText(BuildContext context) { ... }
   }
   ```

4. **Design System & Theme Adaptability**:
   - Always support both Light and Dark themes dynamically.
   - Use `AppGradients.primaryGradient` for all primary button actions and `AppColors.getRandomColor()` for harmonized dynamic accents.

5. **BLoC State Management Standard (`flutter_bloc`)**:
   - Business logic for every screen is encapsulated into dedicated BLoC units per feature (`AuthBloc`, `ProfileBloc`, `PantryBloc`).
   - UI widgets listen to state changes using `BlocConsumer` / `BlocBuilder` and trigger actions via typed Events (`AuthLogInSubmitted`, `ProfileUpdateRequested`).

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter |
| State Management | BLoC (`flutter_bloc`) |
| Auth | Firebase Auth |
| Cloud DB | Firestore |
| Local DB | SQLite |
| OCR | Google ML Kit |
| Notifications | flutter_local_notifications |
| Charts | fl_chart |
| Text-to-Speech | flutter_tts |
| Voice Input | speech_to_text |
| AI Recipes | Gemini API |

## Getting Started

```bash
flutter pub get
flutter run
```

## Project Structure

```
shelfchef_ai/
├── README.md                  # project guidelines & reference code pattern
├── docs/
│   └── PROJECT_OVERVIEW.md    # full requirements & design spec
├── lib/
│   ├── core/                  # themes, colors, gradients, sizes
│   ├── features/              # dashboard, auth, onboarding
│   └── widgets/               # reusable UI components
├── android/
├── ios/
└── pubspec.yaml
```
