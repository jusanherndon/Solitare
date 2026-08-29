# How do we produce a store-signed iOS build from this Flutter project?

Type: research
Status: resolved

Related: local Simulator/device prototype is [Can we build and install the Klondike table prototype on iOS locally?](../klondike-solitaire-spec/issues/07-ios-local-prototype-build.md) (spec map — waits on a MacBook). This ticket is the **App Store** path, not that prototype APK/Simulator check.

## Question

How do we produce a store-signed iOS build of Klondike Solitaire from the Flutter tree (`prototype/klondike-table-flutter` today, product app later) and upload it to App Store Connect?

Research against Apple and Flutter primary docs. Cover at least:

- `flutter build ipa` / Xcode archive vs Transporter vs `xcodebuild`; where the `.ipa` lands.
- Signing: certificates, profiles, automatically managed signing vs manual; what the owner must have besides a Mac and Xcode.
- App Store Connect upload (Xcode Organizer, Transporter, `altool` / `notarytool` if relevant — App Store vs notarization).
- Export compliance / encryption flags for a Flutter Game that uses HTTPS/OS encryption only (`ITSAppUsesNonExemptEncryption`).
- What is *not* required: TestFlight vs submit-for-review is later fog; do not enroll or upload in this ticket.

Recommend one beginner path that matches a few-dependencies Flutter phone Game. Plan, don’t implement. Do not use Expo / EAS.

## Done when

- Findings cite primary sources (developer.apple.com, docs.flutter.dev).
- One recommended command sequence is named, with machine requirements (macOS + Xcode + paid membership) and artifact path.
- Signing and upload are described at a level a beginner can follow later as a task; this ticket does not produce the IPA.

## Answer

Beginner path: paid Apple Developer Program + Xcode **Automatically manage signing** + `flutter build ipa` from the Flutter tree → IPA at `build/ios/ipa/*.ipa` (archive at `build/ios/archive/`) → drag onto **Transporter**. HTTPS/OS encryption only: set `ITSAppUsesNonExemptEncryption` = `NO` in `ios/Runner/Info.plist`. Do not use `notarytool` (Mac notarization). TestFlight vs submit-for-review is later; this ticket did not enroll or upload.

Findings: [`docs/research/flutter-ios-store-build.md`](../../../docs/research/flutter-ios-store-build.md).
