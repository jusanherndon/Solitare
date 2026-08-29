# How do we produce a Play Android App Bundle from this Flutter project?

Type: research
Status: resolved

Related: a local debug/sideload APK is already done on [Can we build and install the Klondike table prototype on Android locally?](../klondike-solitaire-spec/issues/06-android-local-prototype-build.md). Play does not accept that APK for new apps.

## Question

How do we produce a Play-uploadable **Android App Bundle** of Klondike Solitaire from the Flutter tree (`prototype/klondike-table-flutter` today, product app later), including the target API level Play requires?

Research against Flutter and Google Play primary docs. Cover at least:

- `flutter build appbundle` vs APK; where the `.aab` lands; release vs debug.
- Play App Signing vs an upload key; what a beginner must create (keystore) vs what Play manages.
- **Target API 36:** new apps submitted on or after 31 August 2026 must target Android 16 (API 36). What `compileSdk` / `targetSdk` does current Flutter (`flutter.targetSdkVersion` in this prototype) supply, and what must change if it is below 36? Cite the Play target-API policy and Flutter’s current default.
- Signing: the prototype currently signs release with **debug** keys — call out that this cannot ship, and name the official Flutter signing steps.
- Do not enroll or upload in this ticket. Do not change the prototype.

Recommend one beginner path. Plan, don’t implement.

## Done when

- Findings cite docs.flutter.dev and support.google.com (target API + App Bundle + Play App Signing).
- One recommended command sequence is named, with machine requirements and artifact path.
- Explicit yes/no: does today’s Flutter default meet API 36 for a new-app submit on/after 31 August 2026, and if not, what to set.

## Answer

**API 36: yes.** Flutter 3.47.2 already sets `flutter.compileSdkVersion` and `flutter.targetSdkVersion` to 36; this prototype uses those values, so no SDK bump is needed. Play still wants a **release AAB** (`flutter build appbundle` → `build/app/outputs/bundle/release/app.aab` or `app-release.aab`), not the local APK. Create an upload keystore yourself; Play App Signing (auto for new apps) holds the app signing key. The prototype’s debug-signed `release` config cannot ship — follow Flutter’s Sign the app steps (`keytool` → `android/key.properties` → Gradle `signingConfigs.release`). Findings: `docs/research/flutter-play-aab.md`.
