# PROTOTYPE — Klondike table look & play (Flutter twin of #6)

**Throwaway.** Same question as the Expo prototype on `prototype/klondike-table-layout`: *How should the Klondike table look and play on a phone in portrait and landscape?*

This copy uses **Dart / Flutter SDK only** (no pub packages) so the dependency surface is the Flutter toolchain, not Expo + React Native + a vendor tree.

Layout and play match the current Expo table: classic top row, draw-one with Waste recycle, tap → tap, drag, double-click auto-move, Undo, New Game.

## First-time setup (you run this)

From this directory, create linux, web, Android, and iOS platform folders and fetch SDK packages:

```bash
cd prototype/klondike-table-flutter
flutter create . --platforms=linux,web,android,ios --project-name klondike_table --org com.solitare
```

That only writes project files. An APK is `flutter build apk` later (needs the Android SDK). An iOS build is `flutter build ios` later and needs macOS + Xcode.

If `flutter create` adds `cupertino_icons` (or anything else) to `pubspec.yaml`, delete those extra dependencies — this prototype should stay Flutter-SDK-only.

## Run

```bash
flutter run -d linux
# or, if Chrome is available:
flutter run -d chrome
```

Rotate or resize to compare portrait vs landscape.

## Play

Double-click to auto-move (Foundation first, then Tableau), or drag / tap → tap. Stock is draw-one; tap the empty Stock to recycle the Waste. Undo reverses moves/draws. New Game deals fresh.
