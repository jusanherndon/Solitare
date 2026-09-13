# How do we install the Klondike table prototype on a physical iPhone without a connected `flutter run`?

Type: task
Status: resolved

Follows [Can we build and install the Klondike table prototype on iOS locally?](issues/07-ios-local-prototype-build.md), which demonstrated Simulator and `flutter run` only — no physical iPhone, and no path that survives unplugging the Mac. Android already has the disconnected counterpart: [Can we build and install the Klondike table prototype on Android locally?](issues/06-android-local-prototype-build.md) (`flutter build apk` and sideload). Store IPA / TestFlight stay on [Post Klondike Solitaire to the App Store](../../klondike-app-store/map.md).

## Question

How do we load `src/klondike-table-flutter` onto a physical iPhone the owner owns so the app can be played with the Mac disconnected — the iOS counterpart of Android APK sideload?

`flutter run` stays available for connected debug. This ticket is the other mode: install, unplug, play. The owner asked for that non-connected path for testing.

This ticket is done when repo docs name the command(s), any signing or profile caveats that affect unplugged use (debug vs release, certificate trust, expiry on a free Apple ID), and a successful disconnected run has been demonstrated on a physical iPhone.

Not App Store, not TestFlight, not CI.

## Done when

- One documented command sequence installs the prototype on a physical iPhone from `src/klondike-table-flutter` without leaving a `flutter run` session attached.
- After install, the app launches and can be played with the cable unplugged.
- README states that path next to the existing `flutter run` physical-iPhone steps.
- A successful disconnected install has been demonstrated.

## Comments

### agent — 2026-09-07

Demonstrated on two physical iPhone 17 Pro (iOS 26.6.1) with a free Apple ID Personal Team (`SCV7WNWPLC`, Justin Herndon). `flutter build ipa --export-method development` wrote `build/ios/ipa/klondike_table.ipa`. USB `flutter install --use-application-binary=…` installed it; wireless install failed (connection reset). First phone already trusted the developer; second needed Settings → General → VPN & Device Management → Trust. Launched without `flutter run`. Commands also live in the prototype README. Sources: [`docs/research/ios-disconnected-device-install.md`](../../../docs/research/ios-disconnected-device-install.md).

## Answer

Yes, without the paid Apple Developer Program. A free Apple ID / Xcode **Personal Team** is enough to build a **development IPA** and install it from this Mac. It is not Android-style sideload: you cannot AirDrop or open the `.ipa` in Files. Install from the Mac over **USB**, then unplug and play. The profile lasts **7 days**; after that, rebuild and reinstall.

Same Xcode signing as the connected `flutter run` path. Do **not** use plain `flutter build ipa` (that is the App Store export and needs the paid program).

### Settings already in this project

In `ios/Runner.xcworkspace`, Runner target → **Signing & Capabilities**:

- **Automatically manage signing:** on
- **Team:** Justin Herndon (Personal Team). Team ID `SCV7WNWPLC`
- **Bundle Identifier:** `com.solitare.klondikeTable`

Xcode → Settings → Accounts should already have the Apple ID that owns that Personal Team.

### Commands (Mac)

```bash
cd src/klondike-table-flutter
flutter build ipa --export-method development
# IPA: build/ios/ipa/klondike_table.ipa

flutter devices
flutter install -d <UDID> --use-application-binary=build/ios/ipa/klondike_table.ipa
```

Use the USB device’s UDID from `flutter devices` (the line that is `iPhone (mobile)`, not `(wireless)`). Wireless install was unreliable on this session.

### Once per new iPhone

1. Plug in USB. Unlock. Tap **Trust This Computer** if asked.
2. **Settings → Privacy & Security → Developer Mode** — turn on (restart if iOS asks).
3. Run the `flutter install` command above. The home-screen name is **Klondike Table**.
4. First launch on that phone: if iOS refuses to open it, **Settings → General → VPN & Device Management** → tap the developer (the Apple ID / Justin Herndon) → **Trust**.
5. Unplug. Tap **Klondike Table** and play.

Step 4 is the one that blocked the second phone in this session until Trust was tapped.

### Limits (free Apple ID)

- Provisioning profile **expires after 7 days**. Rebuild the IPA and `flutter install` again. App data on the phone is kept if you reinstall the same bundle ID.
- Apple’s Personal Team caps: **3 apps per device**, **3 devices**, **10 App IDs**, all on that 7-day cycle.
- Paid program remains required for TestFlight / App Store — [Post Klondike Solitaire to the App Store](../../klondike-app-store/map.md).
