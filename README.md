# CardiBee Flutter

Bangladesh's first credit/debit card offer aggregator.
**Scout. Compare. Save.**

> **Tagline note:** The source prototype uses "See · Compare · Save". The canonical tagline is
> **"Scout. Compare. Save."** — used in this app. The logo asset needs to be updated separately.

---

## Prerequisites

| Tool | Version |
|---|---|
| Flutter SDK | ≥ 3.22 |
| Dart SDK | ≥ 3.3 |
| Android Studio / Xcode | Latest stable |
| Firebase CLI | Required for push notifications |

---

## Quick start

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate localization files
flutter gen-l10n

# 3. Analyze (should return 0 issues)
flutter analyze

# 4. Run tests
flutter test

# 5. Run with mock data (no backend required)
flutter run --dart-define=USE_MOCK_API=true --dart-define=ENV=dev

# 6. Run against dev API
flutter run --dart-define=USE_MOCK_API=false --dart-define=ENV=dev
```

---

## --dart-define keys

| Key | Values | Default | Description |
|---|---|---|---|
| `USE_MOCK_API` | `true` / `false` | `true` | Use mock repositories (no network) |
| `ENV` | `dev` / `staging` / `prod` | `dev` | API base URL selection |

Copy `.env.example` to `.env` and pass with `--dart-define-from-file=.env`.

---

## Fonts

Download and place in `assets/fonts/`:

| File | Source |
|---|---|
| `DMSans-Regular.ttf` | [Google Fonts — DM Sans](https://fonts.google.com/specimen/DM+Sans) |
| `DMSans-Medium.ttf` | |
| `DMSans-SemiBold.ttf` | |
| `DMSans-Bold.ttf` | |
| `SpaceGrotesk-Regular.ttf` | [Google Fonts — Space Grotesk](https://fonts.google.com/specimen/Space+Grotesk) |
| `SpaceGrotesk-Medium.ttf` | |
| `SpaceGrotesk-SemiBold.ttf` | |
| `SpaceGrotesk-Bold.ttf` | |

---

## Firebase setup

1. Create a Firebase project at console.firebase.google.com.
2. Add an Android app (package `com.cardibee.app`) and download `google-services.json`
   → place at `android/app/google-services.json`.
3. Add an iOS app and download `GoogleService-Info.plist`
   → place at `ios/Runner/GoogleService-Info.plist`.
4. Enable **Cloud Messaging** in the Firebase console.
5. Run with `USE_MOCK_API=false` — FCM token registration happens automatically on login.

Firebase is **not required** when `USE_MOCK_API=true`.

---

## Build commands

```bash
# Debug APK (mock)
flutter build apk --debug --dart-define=USE_MOCK_API=true

# Release APK (prod)
flutter build apk --release --dart-define=USE_MOCK_API=false --dart-define=ENV=prod

# iOS (requires macOS + Xcode)
flutter build ios --dart-define=USE_MOCK_API=false --dart-define=ENV=prod
```

---

## Code generation

After adding or changing freezed models or Riverpod generators:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

After changing ARB localization files:

```bash
flutter gen-l10n
```

---

## Project structure

```
lib/
├── main.dart                 # Entry point — ProviderScope + mock overrides
├── app/app.dart              # MaterialApp, theme, router, l10n bootstrap
├── gen/                      # Generated localization files (flutter gen-l10n)
├── core/
│   ├── theme/                # AppColors, AppTypography, AppTokens, AppTheme
│   ├── env/                  # Env (dart-define values)
│   ├── error/                # AppFailure (sealed class)
│   ├── network/              # Dio client, auth interceptor, error mapper
│   ├── storage/              # TokenStorage (secure), PrefsStorage (shared_prefs)
│   ├── routing/              # GoRouter config + route constants
│   └── widgets/              # Shared: AppLogo, AppShell, CreditCardVisual, OfferCardWidget
├── features/
│   ├── auth/                 # OTP flow, UserProfile model, auth provider
│   ├── onboarding/           # 3-slide carousel
│   ├── splash/               # Animated splash
│   ├── home/                 # Offer feed, hero wallet, categories
│   ├── cards/                # UserCard model, list + 4-step add wizard
│   ├── offers/               # Offer model, my-offers + browse
│   ├── offer_detail/         # Full offer detail with T&C
│   ├── favorites/            # Saved offers
│   ├── search/               # Universal search
│   ├── best_card/            # Best-card suggestion
│   ├── compare/              # Side-by-side card comparison
│   ├── notifications/        # Push notification list + preferences
│   ├── subscription/         # Plans + checkout
│   └── profile/              # User settings, dark mode, logout
└── mock/
    ├── fixtures/             # JSON files — must stay in sync with API contract
    ├── mock_auth_repository.dart
    ├── mock_cards_repository.dart
    ├── mock_offers_repository.dart
    ├── mock_notifications_repository.dart
    └── mock_module.dart      # Riverpod overrides for mock mode
```

---

## Adding a new feature

1. Create `lib/features/<name>/domain/<name>_repository.dart` (abstract interface).
2. Create `lib/features/<name>/data/api_<name>_repository.dart` (Dio implementation).
3. Create `lib/features/<name>/data/mock_<name>_repository.dart` (fixture-based).
4. Create `lib/features/<name>/providers/<name>_provider.dart` (Riverpod provider).
5. Register mock override in `lib/mock/mock_module.dart`.
6. Add route in `lib/core/routing/app_router.dart`.
7. Add localization keys to both `assets/l10n/app_en.arb` and `app_bn.arb`.
8. Run `flutter gen-l10n`.

---

## Adding a new locale

1. Create `assets/l10n/app_<code>.arb` with all keys from `app_en.arb`.
2. Add `Locale('<code>')` to `AppLocalizations.supportedLocales` in `lib/gen/app_localizations.dart`.
3. Create `lib/gen/app_localizations_<code>.dart` implementing `AppLocalizations`.
4. Run `flutter gen-l10n`.

---

## Security rules (enforced in code)

- Card `last_digits` field accepts 4–6 digits only; full card numbers are never stored.
- Tokens stored in `flutter_secure_storage` with encrypted shared preferences on Android.
- No token, OTP, or phone number is ever passed to any logging call.
- Mock auth accepts any OTP — never ship with `USE_MOCK_API=true` in production.

---

## API contract

`cardibee_api_contract.json` at the monorepo root is the source of truth for the backend.
Fixture files in `lib/mock/fixtures/` mirror contract example responses exactly.
If you change one, change the other.

---

## Phase status

| Phase | Status |
|---|---|
| 1 — Analyse source | ✅ Done (`MIGRATION_NOTES.md`) |
| 2 — API contract | ✅ Done (`cardibee_api_contract.json`) |
| 3 — Scaffold | ✅ Done (this project) |
| 4 — Mock layer + API client | ✅ Done (mock repos wired, Dio client ready) |
| 5 — Implement screens | 🔜 Next |
| 6 — Polish & deliverables | 🔜 Pending |
