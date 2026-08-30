# Klondike Solitaire — Flutter prototype (spec v1)

Throwaway phone app that follows [spec.md](../../.scratch/klondike-solitaire-spec/spec.md). Felt-banner chrome (start, About, win, loss) plus layout A table and a bottom thumb dock (**Hint**, **Undo**, **New Game**, **Start**). Not the store product.

**Playtest:** [What bugs or changes turn up when the owner runs the prototype on Android?](../../.scratch/klondike-solitaire-spec/issues/17-android-playtest.md)

## Run

```bash
cd prototype/klondike-table-flutter
flutter run                 # connected Android device
flutter build apk           # sideload: build/app/outputs/flutter-apk/app-release.apk
flutter run -d linux        # desktop, for layout checks
```

First launch: **New Game** or **About**. **Resume** appears after you leave an unfinished Game via **Start**. Win/loss end the Game (no Resume). New Game confirms when it would discard an unfinished Game.

Cards are still placeholder faces/backs; About already credits Fomin/Atlas. Portrait and landscape both use classic top-row layout.

## Analyze / format / test

```bash
flutter pub get
flutter analyze
dart format .
flutter test
```
