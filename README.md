# ShelfChef AI

Smart pantry, grocery, and meal-planning mobile app. Manages food inventory, tracks expiry dates, scans grocery bills via OCR, suggests AI-powered recipes from ingredients on hand, tracks grocery budget/expenses, and reads recipes aloud via text-to-speech.

📄 **Full project spec (screens, UI/UX, color system, user flows, features):**
see [`docs/PROJECT_OVERVIEW.md`](docs/PROJECT_OVERVIEW.md)

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter |
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
├── README.md                  # you are here
├── docs/
│   └── PROJECT_OVERVIEW.md    # full requirements & design spec
├── lib/
├── android/
├── ios/
└── pubspec.yaml
```
