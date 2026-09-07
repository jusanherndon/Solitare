# Klondike Solitaire — Flutter prototype (spec v1)

Throwaway phone app that follows [spec.md](../../.scratch/klondike-solitaire-spec/spec.md). Felt-banner chrome (start, About, win, loss) plus layout A table and a bottom thumb dock (**Hint**, **Undo**, **New Game**, **Start**). Not the store product.

**Playtest:** [What bugs or changes turn up when the owner runs the prototype on Android?](../../.scratch/klondike-solitaire-spec/issues/17-android-playtest.md)

## Run

```bash
cd prototype/klondike-table-flutter
flutter run                 # connected Android device
flutter build apk           # sideload: build/app/outputs/flutter-apk/app-release.apk
flutter run -d linux        # desktop, for layout checks
open -a Simulator && flutter run -d ios
flutter build ios --simulator
# Simulator app: build/ios/iphonesimulator/Runner.app
flutter build ipa --export-method development
# Device IPA: build/ios/ipa/klondike_table.ipa
flutter devices
flutter install -d <UDID> --use-application-binary=build/ios/ipa/klondike_table.ipa
```

iOS needs **macOS and Xcode**. This prototype has no iOS plugins, so CocoaPods is not required (Flutter doctor may still warn).

**Physical iPhone, connected debug:** USB-connect and tap Trust This Computer; turn on Developer Mode (Settings → Privacy & Security); add your Apple ID in Xcode → Settings → Accounts; in `ios/Runner.xcworkspace`, Runner target → Signing & Capabilities, leave Automatically manage signing on and pick that Team; then `flutter run`.

**Physical iPhone, unplug and play** (the APK-sideload counterpart): same signing as above, then `flutter build ipa --export-method development` and USB `flutter install --use-application-binary=build/ios/ipa/klondike_table.ipa`. Do not use plain `flutter build ipa` (App Store export). Wireless install is unreliable; use USB. The first time on a **new** phone, if it will not launch: Settings → General → VPN & Device Management → trust the developer. Then unplug and tap **Klondike Table**. A free Apple ID is enough. The development profile expires after **7 days** — rebuild and reinstall. The paid Apple Developer Program is only for TestFlight / App Store. Details: [How do we install the Klondike table prototype on a physical iPhone without a connected `flutter run`?](../../.scratch/klondike-solitaire-spec/issues/19-ios-disconnected-device-install.md).

First launch: **New Game** or **About**. **Resume** appears after you leave an unfinished Game via **Start**. Win/loss end the Game (no Resume). New Game confirms when it would discard an unfinished Game.

Cards are still placeholder faces/backs; About already credits Fomin/Atlas. Portrait and landscape both put Foundations on the left and Stock/Waste on the right; **Left-handed** in Settings restores that pair on the left. **Waste on left** puts Waste to the left of Stock in both layouts.

## Analyze / format / test

```bash
flutter pub get
flutter analyze
dart format .
flutter test
```
