# Umeed (उम्मीद) · Civic-Tech Mobile Application

> **"Speak your problem. We find your scheme."**
> A mobile-first civic-tech app bridging the access gap for Indian government schemes with a dual-door Voice-first and Text-first approach across all 22 Eighth Schedule Indian languages plus English.

---

## 🌟 The Problem & The Solution

- **The Problem:** Government welfare schemes exist in abundance, but access does not. Existing portals like *myScheme* are text chatbots demanding a dozen-plus tedious inputs in formal bureaucratic language. Low-literacy, rural, and digital-first learners drop off early.
- **The Solution:** Umeed provides **one unified platform with two doors in**:
  1. **Voice Mode** (Saffron Orange `#F28C28`): Recommended for low-literacy users. Spoken prompts, live waveform, friendly voice AI, and trained human Help Desk verification.
  2. **Text Mode** (Deep Navy `#0B1830` with India Green `#1F9D6B` border): For those who can read and type. Instant profile building and immediate scheme matching.
- **Unified Profile:** Both modes populate the exact same `UserProfile` object. Users can toggle between Voice and Text mode at any moment without losing a single answer.

---

## 🎨 Design Language & Accessibility

- **Palette:**
  - Saffron Orange: `#F28C28` (Primary brand & #1 Best Match)
  - Deep Navy: `#0B1830` (Secondary background & headings)
  - Mid Navy: `#1C3A56` (Interactive outlines & subtle accents)
  - Cream: `#FAF6EE` (Warm, non-glare scaffold background)
  - India Green: `#1F9D6B` / `#2FB586` (Success, verification & #2 Better Match)
  - Rank Good: `#4A6572` (#3 Good Match)
  - High Contrast: 4.5:1 or better across all text elements.
- **Typography:** Domine for headings; Nunito Sans for body text; Indic script Noto fonts.
- **Accessibility First:** Minimum 56dp tap targets, large typography, one question per screen, icons + text labels, and a prominent **"Listen" button on every text screen**. Support for TalkBack and VoiceOver.

---

## 🗺️ The 9-Step Core Flow

1. **Splash & Consent:** Brand identity and an auto-read plain-language consent explaining minimal data collection and 30-day auto-deletion.
2. **Mode Selection (Voice vs Text):** Two large cards with spoken audio prompt on screen load.
3. **Language Selection (23 Languages):** English at top + 22 Scheduled Indian Languages alphabetically with native scripts, "Hear it" previews, and instant dynamic RTL support for Urdu (`ur`), Kashmiri (`ks`), and Sindhi (`sd`).
4. **The 12 Questions:** One question per screen (`q_name` to `q_need`). Pulsing mic, live audio waveform, multi-take recording, skippable sensitive items with spoken rationale, and end-of-intake summary review.
5. **Help Desk Handoff & Busy-Day Logic:** Voice recordings route to the Civic Help Desk. If queue > threshold, allocates a confirmed next-day slot and schedules SMS reminders.
5b. **Text Mode Instant Match:** Instant dashboard transition for typed users.
6. **Ranked Dashboard:** 3 prioritized tiers: `#1 Best Match` (orange), `#2 Better` (green), `#3 Good` (grey-blue), plus remaining schemes, plain-words eligibility rationales, and "Data last checked" footer.
7. **Understand & Listen:** Official legal text collapsed in dashed box; plain-words simplification shown first; translated and read aloud via Big Orange Listen button.
8. **Decide (Four Actions):** Apply Now, Compare side-by-side, Save for later (deadline alerts), Ask the Help Desk.
9. **Help Desk First & 4-Stage Stepper:** Documents remain locked until user consults helper or opts to skip. 4 stages: *Prepare*, *Verify*, *Apply* (guided official handoff without proxy submission), and *Track*.

---

## 🏗️ Technical Architecture

```
umeed/
├── assets/
│   ├── data/
│   │   └── mock_schemes.json       # 16 realistic multi-ministry schemes (mock: true)
│   └── l10n/
│       ├── en.json                 # English
│       ├── hi.json                 # Hindi (हिन्दी)
│       ├── mr.json                 # Marathi (मराठी)
│       └── [as, bn, brx, ...].json # 20 other Scheduled Indian Languages
├── lib/
│   ├── core/
│   │   ├── l10n/
│   │   │   └── app_localizations.dart  # Fallback chain: Selected -> Hindi -> English
│   │   ├── routing/
│   │   │   └── app_router.dart         # Declarative GoRouter configuration
│   │   └── theme/
│   │       └── app_theme.dart          # Accessible palette & 56dp touch targets
│   ├── data/
│   │   └── repositories/
│   │       ├── help_desk_repository.dart
│   │       ├── profile_repository.dart
│   │       └── scheme_repository.dart
│   ├── domain/
│   │   └── models/
│   │       ├── help_desk_submission.dart
│   │       ├── scheme.dart
│   │       └── user_profile.dart
│   ├── features/
│   │   ├── admin/
│   │   │   └── help_desk_console_screen.dart # Web console for civic helpers (/helpdesk)
│   │   ├── dashboard/
│   │   │   └── dashboard_screen.dart
│   │   ├── intake/
│   │   │   ├── help_desk_handoff_screen.dart
│   │   │   ├── intake_screen.dart
│   │   │   ├── question_config.dart
│   │   │   └── waveform_widget.dart
│   │   ├── onboarding/
│   │   │   ├── language_selection_screen.dart
│   │   │   ├── mode_selection_screen.dart
│   │   │   └── splash_and_consent_screen.dart
│   │   ├── roadmap/
│   │   │   └── roadmap_hooks.dart
│   │   ├── scheme_detail/
│   │   │   ├── scheme_application_journey_screen.dart
│   │   │   ├── scheme_compare_screen.dart
│   │   │   └── scheme_detail_screen.dart
│   │   └── settings/
│   │       └── settings_and_privacy_screen.dart
│   ├── providers/
│   │   └── app_providers.dart          # Riverpod state providers
│   ├── services/
│   │   ├── bhashini_service.dart       # Bhashini ASR/TTS/NMT interface & mock
│   │   └── ranking_service.dart        # 3-Factor ranking engine
│   └── main.dart
├── test/
│   ├── eligibility_matcher_test.dart   # Demographic & economic boundary unit tests
│   ├── mode_selection_widget_test.dart # Widget test for Voice vs Text cards
│   └── ranking_service_test.dart       # Unit tests for scoring & ranking
├── pubspec.yaml
├── README.md
└── TODO.md                             # Production readiness, Bhashini keys & linguistic reviews
```

---

## 🚀 Setup & How to Run

### Prerequisites
- Flutter SDK (`>= 3.10.0`)
- Dart SDK (`>= 3.0.0`)

### 1. Install Dependencies
```bash
cd umeed
flutter pub get
```

### 2. Run on Mobile (Android / iOS)
```bash
# Run on connected Android device / emulator
flutter run -d android

# Run on iOS simulator
flutter run -d ios
```

### 3. Run on Web / Responsive Desktop
```bash
flutter run -d chrome
```

### 4. Open Help Desk Console Directly
Navigate to `/helpdesk` in the browser or tap **"Open Helper Web Console"** on the Handoff screen to view the queue of pending recordings and approve submissions.

---

## 🧪 Running Automated Tests

Run the unit tests and widget tests using the standard Flutter test runner:

```bash
# Run all unit tests
flutter test test/ranking_service_test.dart
flutter test test/eligibility_matcher_test.dart

# Run widget tests
flutter test test/mode_selection_widget_test.dart

# Run all test suites
flutter test
```

---

## 🔒 Privacy & Legal Compliance

- **DPDP Act 2023 Ready:** Minimal data collection; explicit audio consent read aloud; 30-day auto-purge for voice takes.
- **Delete My Data:** Single-tap complete wipe of profile and cached recordings in Settings.
- **Legal Disclaimer:** Umeed is an informational and guidance aid; official eligibility and approvals are decided solely by the respective government authority.
