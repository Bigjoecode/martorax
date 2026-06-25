# MartoraX — *Your City In Your Pocket*

A cross-platform (Flutter) marketplace + logistics super-app for the Nigerian
market (Asaba / Ogbogonogo hubs). It brings together shoppers, vendors, service
providers and riders with escrow-protected payments ("SafePay"), live deals,
group buys and AI-assisted discovery.

## Repository layout

| Path | What it is |
|------|------------|
| `my_app/` | The Flutter application (Android / iOS / web / desktop). This is what builds the APK. |
| `martorax app screens/` | Design reference — HTML mockups + screenshots for ~150 screens. |
| `setup_flutter.ps1` | Helper script to bootstrap a Flutter dev environment on Windows. |

## The app (`my_app/`)

- **Framework:** Flutter 3.32 / Dart 3.8
- **State:** `flutter_riverpod`
- **Routing:** `go_router` (auth-gated, role-gated, stateful tab shell)
- **Backend:** Supabase (auth, Postgres, Edge Functions)
- **Payments:** Paystack via a server-authoritative `verify-payment-and-hold`
  Edge Function — the client never holds the secret key and cannot influence the
  charged amount.

### Feature areas (`my_app/lib/features/`)
Onboarding · Auth · Home/Search · Product detail & bargain · Cart & Checkout ·
Vendor (register, KYC, dashboard, inventory, go-live, analytics) · Service
Provider (register, KYC, portfolio, bookings, leads, chat) · Rider (register,
dashboard, in-transit, earnings) · Wallet & Escrow · Market hubs & trends ·
Live deals · Group buy · AI feed / concierge / smart quote · Admin dashboards.

### Backend (`my_app/supabase/`)
- `functions/verify-payment-and-hold/` — Paystack init + verify + escrow hold.
- `migrations/` — order/escrow creation, hardening, stock decrement, business
  profile fields.
- `lib/core/supabase/supabase_schema.sql` — base schema.

## Build the APK

```bash
cd my_app
flutter pub get
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

> The release build is currently signed with the **debug** keystore so it can be
> sideloaded immediately. For Play Store distribution, generate an upload
> keystore and wire it into `android/app/build.gradle.kts` (see *What's left*).

## Run in development

```bash
cd my_app
flutter pub get
flutter run
```

## What's left before a production release

- [ ] **Release signing:** replace the debug `signingConfig` with a real upload
      keystore (`android/key.properties`).
- [ ] **Application ID:** change `com.example.my_app` to a real id
      (e.g. `com.martorax.app`) — Play Store rejects `com.example.*`.
- [ ] **App icon:** replace the default Flutter launcher icon with MartoraX branding.
- [ ] **Deploy backend:** apply Supabase migrations and deploy the Edge Function;
      set the live Paystack keys.
- [ ] **Maps:** "Google Maps integration coming soon" placeholders in the
      map/discovery screens.
