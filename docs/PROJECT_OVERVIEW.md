# 📱 ShelfChef AI — Project Documentation

## 🧠 Project Overview

ShelfChef AI is a smart pantry, grocery, and meal-planning mobile application designed to help users manage food items, track expiry dates, plan shopping, control grocery expenses, and receive AI-powered recipe suggestions based on ingredients already available at home.

The app combines inventory management, OCR bill scanning, AI meal suggestions, text-to-speech cooking guidance, shopping assistance, expiry reminders, and budget tracking in a single modern application.

The main goal is to make kitchen management simple, intelligent, and visually engaging.

---

## 🎯 Core Objectives

- Organize grocery and pantry items efficiently
- Prevent food from expiring unnoticed
- Suggest recipes using available ingredients
- Automatically identify missing ingredients
- Add missing items directly to the shopping list
- Track total grocery expenses
- Set a monthly grocery budget
- Suggest cheaper alternatives when the budget is exceeded
- Provide voice-assisted recipe reading through text-to-speech

---

## 👥 Target Users

- Students living away from home
- Working professionals
- Homemakers
- Families
- People who frequently forget expiry dates
- Users who want better grocery budgeting

---

## 🎨 Type of UI / UX

### Design Style
**Premium Eco-Glass Startup UI**

### Visual Characteristics
- Large rounded corners (24px)
- Floating cards
- Soft realistic shadows
- Subtle gradients
- Frosted glass overlays
- Curved layouts
- Organic blurred background shapes
- Smooth transitions and micro-animations
- Minimal clutter with strong visual hierarchy

### Inspiration
- Spotify
- Apple Health
- Notion
- Blinkit
- Modern fintech applications

The app should feel **calm, premium, intelligent, and easy to use**.

---

## 🌈 Color Theme

| Role | Hex | Usage |
|---|---|---|
| Primary Green | `#166534` | Buttons, active states, navigation, key actions |
| Secondary Green | `#22C55E` | Highlights, progress bars, success states |
| AI Accent Purple | `#8B5CF6` | AI assistant, smart insights, sparkle actions |
| Warning Orange | `#F97316` | Expiring soon, low stock, budget alerts |
| Danger Red | `#EF4444` | Expired items, delete actions |
| Background | `#F7FAF7` | Main application background |
| Surface / Cards | `#FFFFFF` | Cards, sheets, dialogs, navbar |
| Primary Text | `#111827` | Headings and important information |
| Secondary Text | `#6B7280` | Descriptions, metadata, helper text |

### Gradients
- **Primary Gradient:** `#166534 → #22C55E`
- **AI Gradient:** `#7C3AED → #A855F7`

### Dark Mode
| Role | Hex |
|---|---|
| Background | `#0F172A` |
| Surface | `#111827` |
| Card | `#1E293B` |
| Accent | `#22C55E` |
| AI Purple | `#A855F7` |
| Text | `#F8FAFC` |

---

## 🔤 Typography

- **Poppins Bold** — Main headings
- **Poppins Medium** — Section titles
- **Inter Regular** — Body text
- **Inter Semibold** — Buttons and labels

---

## 🧭 Navigation Structure

**Floating Curved Bottom Navigation Bar**
- Home
- Pantry
- Recipes
- Profile

Floating curved bar with a glowing center Add button and soft shadow. This navigation is one of the main premium UI elements of the project.

### Center Add Button Opens
- Add item manually
- Scan bill
- Scan barcode
- Voice add

---

## 📄 Screens

| Screen | Purpose |
|---|---|
| Splash | Branding |
| Onboarding 1 | Pantry management |
| Onboarding 2 | AI recipes |
| Onboarding 3 | Budget tracking |
| Welcome | Choose login/signup |
| Login | Authentication |
| Signup | Registration |
| Home Dashboard | Main overview |
| Pantry | Inventory management |
| Add Item | Manual/barcode entry |
| Bill Scan | OCR import |
| AI Recipes | Recipe generation |
| Recipe Detail | Cooking mode |
| Shopping List | Purchase planning |
| Expiry Reminders | Alerts |
| Analytics | Expense graphs |
| Notifications | All alerts |
| Profile & Settings | User preferences |

---

## 🚀 Complete User Flow

1. Splash
2. Onboarding
3. Login / Google Sign-In
4. Set monthly budget
5. Home Dashboard
6. Add Item
7. Scan Bill
8. Pantry Updated
9. Select people count
10. Generate AI recipes
11. Add missing items
12. Listen to recipe
13. Track expenses & budget

---

## 🏠 Home Dashboard (Most Important Screen)

### Includes
- Greeting with user avatar
- Pantry item count
- Expiring soon count
- Low stock count
- Monthly budget card
- Total expenses card
- Quick actions row
- AI recipe hero card
- Expiring today section
- Recent activity section
- Sparkle icon for AI assistant

---

## 🧠 AI Pantry Assistant (WOW Feature)

**Trigger:** Tap the sparkle icon on the dashboard.

### Example Suggestions
- "Use spinach today"
- "You can cook Palak Paneer"
- "Add milk to shopping list"
- "You have spent ₹1840 this month"

### Actions
- Cook Now
- Add to Shopping
- Remind Me
- Dismiss

This makes the app feel like a real AI kitchen companion, not a simple CRUD app.

---

## 🥫 Pantry Page

### Features
- Search bar
- Category chips
- Food image
- Quantity and unit
- Expiry countdown
- Status badges
- Swipe to edit/delete/use
- Floating add button

### Categories
- Vegetables
- Fruits
- Dairy
- Grains
- Snacks
- Others

---

## ➕ Add Item Page

### Tabs
- Manual
- Barcode

### Fields
- Item name
- Quantity
- Unit
- Category
- Purchase date
- Expiry date
- Storage location

### Smart Logic
If category = Vegetables, expiry is estimated automatically.

---

## 🧾 Bill Scan Page

**Flow:** Scan → Extract items → Select → Add to pantry

---

## 🍳 AI Recipe Flow

### Step 1: Detect Pantry Ingredients
Example: Potato, Onion, Tomato, Curd

### Step 2: Select People Count (Mandatory)
1 / 2 / 3 / 4 / 5+

⚠️ Recipe cannot open until people count is selected.

### Step 3: Generate Recipes
Based on: pantry ingredients + number of people

---

## 📄 Recipe Card

### Each Card Shows
- Large food photograph
- Recipe name
- Cooking time
- Difficulty
- Calories
- Available ingredients count
- Missing ingredients count
- Open Recipe button

---

## 📖 Recipe Detail Page

### Includes
- Large image
- Serves count
- Time and calories
- Available ingredients ✔
- Missing ingredients ⚠
- Add Missing to Shopping List
- Step-by-step cooking mode

---

## 🔊 Text-to-Speech

**Speaker Icon on Recipe Page** — when tapped, the app reads aloud:
- Recipe title
- Ingredients
- Cooking steps

### Controls
▶ Play · ⏸ Pause · ⏹ Stop

**Technology:** `flutter_tts`

This is a major accessibility and premium feature.

---

## 🛒 Shopping List

### Sections
- AI suggested items
- Manually added items
- Estimated total cost
- Mark as purchased

### If Budget Exceeds — show cheaper alternatives:

| Product | Current | Cheaper |
|---|---|---|
| Amul Milk | ₹34 | ₹30 |
| Basmati Rice | ₹120 | ₹95 |

---

## ⏰ Expiry Reminders

### Tabs
- Today
- Tomorrow
- This Week

### Actions
- Use Now
- Add to Recipe
- Dismiss

---

## 💰 Expense & Budget System

- User sets monthly budget (e.g. ₹3000)

### Dashboard Shows
- Total spent
- Remaining amount
- Progress bar

### Budget Exceeded
- Red warning card
- Suggest cheaper alternatives
- Highlight expensive shopping items

---

## 📊 Analytics Page

### Includes
- Monthly budget
- Total expenses
- Remaining amount
- Category-wise spending
- Weekly spending graph
- Daily spending trend
- Top expensive items

### Charts
- Donut chart
- Weekly bar chart
- Daily line graph

---

## 🔔 Notifications

### Types
- Expiring items
- Low stock
- Recipe available
- Budget exceeded
- Shopping reminder

---

## 👤 Profile & Settings

### Includes
- Curved glass header
- Avatar
- Language (English/Gujarati)
- Dark mode
- Notifications
- Location services
- Privacy
- Help & Support
- Logout

---

## 🎞️ Micro-Interactions

- Floating navbar lift animation
- Glowing add button
- Progress rings
- Skeleton loading
- Empty state illustrations
- Swipe animations
- Smooth page transitions

---

## 📐 Coding Standards & Architectural Constraints

1. **250-Line File Limit**:
   - No `.dart` source file should exceed **250 lines**.
   - If any widget, screen, or logic file exceeds 250 lines, refactor it into dedicated helper widgets, modals, sub-components, or delegate files.

2. **Ultra-Clean `build()` Method Standard**:
   - The `build()` method must contain concise, clean, high-level code listing only top-level layout containers.
   - All sub-views, section builders, modal dialogs, and helper methods must be declared separately below the `build()` method under `// --- Private Sub-Widgets Defined Below Build Function ---`.

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

4. **Consistent Design System & Theme Adaptability**:
   - Support both Light & Dark modes seamlessly across all screens.
   - Use `AppGradients.primaryGradient` (`#166534 → #22C55E`) for all primary buttons and `AppColors.getRandomColor()` for harmonized dynamic accents.