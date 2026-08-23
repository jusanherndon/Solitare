# PROTOTYPE — Klondike table look & play (Flutter twin of #6)

**Throwaway.** Same question as the Expo prototype on `prototype/klondike-table-layout`: *How should the Klondike table look and play on a phone in portrait and landscape?*

This copy uses **Dart / Flutter SDK only** (no pub packages) so the dependency surface is the Flutter toolchain, not Expo + React Native + a vendor tree.

Layout and play match the current Expo table: classic top row, draw-one with Waste recycle, tap → tap, drag, double-click auto-move, Undo, New Game.

Platforms: **Android** and **iOS** only.

## Run / build

```bash
cd prototype/klondike-table-flutter
flutter run            # connected Android device (iOS Simulator needs a Mac)
flutter build apk      # Android APK → build/app/outputs/flutter-apk/app-release.apk
                       # needs Flutter SDK + Android SDK (`ANDROID_HOME`)
flutter build ios      # iOS — macOS + Xcode only; not available until a Mac exists
```

Rotate to compare portrait vs landscape.

## Play

Double-click to auto-move (Foundation first, then Tableau), or drag / tap → tap. Stock is draw-one; tap the empty Stock to recycle the Waste. Undo reverses moves/draws. New Game deals fresh.
