# Flutter HOW: Play-uploadable Android App Bundle

**Ticket:** [How do we produce a Play Android App Bundle from this Flutter project?](../../.scratch/klondike-play-store/issues/09-flutter-play-aab.md)

**Related (do not re-open):** a local sideload APK is already documented on [Can we build and install the Klondike table prototype on Android locally?](../../.scratch/klondike-solitaire-spec/issues/06-android-local-prototype-build.md). Play does not accept that APK for a new app.

**Out of scope:** enrolling Play Console, uploading a binary, or changing `prototype/klondike-table-flutter`. This is the Flutter HOW; spec-level AAB/API 36 facts already live in [store-listing-requirements.md](store-listing-requirements.md).

Sources are Flutter docs, Play Console Help, and Android Developers, plus this machine’s Flutter SDK defaults, fetched 2026-08-29.

---

## Recommendation (beginner path)

**Stay on current Flutter stable, create an upload keystore, wire official Flutter release signing, then run `flutter build appbundle`.** Upload the resulting `.aab` on the first Play release. Play App Signing enrolls automatically for a new app; Google holds the app signing key. Do not ship the prototype’s debug-signed APK.

**API 36: yes.** Today’s Flutter default already targets API 36. No `compileSdk` / `targetSdk` bump is required on this tree if it keeps `flutter.compileSdkVersion` and `flutter.targetSdkVersion`. What must change before any Play upload is **signing** (replace debug keys).

---

## Play wants an AAB, not the local APK

Starting August 2021, **new apps must publish with the Android App Bundle** on Google Play. Play builds device-specific APKs from that bundle. Using app bundles requires **Play App Signing**. Legacy apps created before August 2021 may still add APKs; that exception does not apply to a new Klondike listing. ([Inspect app versions / Latest releases and bundles](https://support.google.com/googleplay/android-developer/answer/9844279); [Prepare and roll out a release](https://support.google.com/googleplay/android-developer/answer/9859348); [About Android App Bundles](https://developer.android.com/guide/app-bundle))

An Android App Bundle is a publishing format: compiled code and resources in one artifact. You cannot install a `.aab` on a phone the way you sideload an APK. Play generates and signs the APKs users actually install. ([About Android App Bundles](https://developer.android.com/guide/app-bundle))

The resolved local ticket used `flutter build apk` and wrote `build/app/outputs/flutter-apk/app-release.apk`. That path is for sideload and other stores that still take APKs. Flutter’s own deploy guide prefers an app bundle for Play. ([Build and release an Android app](https://docs.flutter.dev/deployment/android))

---

## `flutter build appbundle` vs APK, release vs debug

| Command | Artifact | Use |
| --- | --- | --- |
| `flutter build appbundle` | `.aab` under `build/app/outputs/bundle/release/` | **Play upload** (this ticket) |
| `flutter build apk` | `.apk` under `build/app/outputs/flutter-apk/` | Local sideload (ticket 06), not a new-app Play upload |
| `flutter build appbundle --debug` | debug `.aab` under `build/app/outputs/bundle/debug/` | Dev only; not a Play store-track binary |

`flutter build` **defaults to a release build**. Flutter’s `appbundle` help says `--release` is the default mode and that release builds are the ones suitable for app stores. Debug mode is for a fast development cycle; it is not optimized for size or deployment. ([Build and release an Android app](https://docs.flutter.dev/deployment/android); [Flutter’s build modes](https://docs.flutter.dev/testing/build-modes); this machine’s `flutter build appbundle -h`)

Documented release path, from the project directory (`prototype/klondike-table-flutter` today, product app later):

```bash
cd prototype/klondike-table-flutter
flutter build appbundle
```

The official Flutter page writes the release bundle to:

`[project]/build/app/outputs/bundle/release/app.aab`

By default that bundle includes Dart and the Flutter runtime for armeabi-v7a, arm64-v8a, and x86-64. ([Build and release an Android app](https://docs.flutter.dev/deployment/android))

Android Gradle Plugin often names the same file `app-release.aab`. Flutter’s Gradle finder looks in `build/app/outputs/bundle/release/` for either `app-release.aab` or a legacy `app.aab`. Look in that directory after the build; upload whichever `.aab` is there. (Installed Flutter 3.47.2, `packages/flutter_tools/lib/src/android/gradle.dart`.)

Do **not** pass `--debug` for a closed-testing or production release. Play’s **internal app sharing** page separately allows debuggable bundles for link sharing; those uploads are not store-track releases. ([Share app bundles and APKs internally](https://support.google.com/googleplay/android-developer/answer/9844679))

---

## Target API 36 — Play policy vs today’s Flutter default

**Play policy.** New apps and app updates submitted on or after **31 August 2026** must target **Android 16 (API level 36)** or higher (phone/tablet; Wear / Automotive / TV / XR have different floors). A “new app” is one not yet published on Play. The policy is the app’s `targetSdkVersion`. ([Target API level requirements](https://support.google.com/googleplay/android-developer/answer/11926878))

Klondike is a new phone Game. A first submit on or after that date must target API 36. (Today is 29 August 2026; the floor is two days away.)

**What this prototype actually sets.** `prototype/klondike-table-flutter/android/app/build.gradle.kts` does not hard-code SDK numbers. It uses Flutter’s Gradle extension:

```kotlin
compileSdk = flutter.compileSdkVersion
// ...
minSdk = flutter.minSdkVersion
targetSdk = flutter.targetSdkVersion
```

Flutter documents those `flutter.*` values as the defaults the Gradle plugin supplies. You change them in this file only if you need a newer API or want to lock integers. `compileSdk` is the SDK used to compile; `targetSdk` is the Android version the app is designed and tested to run on — that is the Play target-API field. ([Build and release an Android app — Review the Gradle build configuration](https://docs.flutter.dev/deployment/android))

**Today’s Flutter default is 36.** This machine’s Flutter is **3.47.2** (stable, 2026-08-26). In that SDK:

| Flutter Gradle property | Value in 3.47.2 |
| --- | --- |
| `flutter.compileSdkVersion` | **36** |
| `flutter.targetSdkVersion` | **36** |
| `flutter.minSdkVersion` | 24 |

(`/opt/flutter/packages/flutter_tools/gradle/src/main/kotlin/FlutterExtension.kt`; mirrored in `packages/flutter_tools/lib/src/android/gradle_utils.dart` as `targetSdkVersion = '36'`.) Flutter 3.35.0 release notes record the framework default `targetSdk` bump to 36. ([Flutter 3.35.0 release notes](https://docs.flutter.dev/release/release-notes/release-notes-3.35.0))

**Explicit yes/no:** **Yes** — today’s Flutter default meets API 36 for a new-app submit on or after 31 August 2026. Keep `targetSdk = flutter.targetSdkVersion` (or set `targetSdk = 36`) and keep `compileSdk` at least 36.

**If a future tree is below 36** (older Flutter, or someone locked integers at 35):

1. Prefer **upgrading Flutter** so `flutter.targetSdkVersion` is 36 again.
2. Or set integers in `android/app/build.gradle.kts`: `compileSdk = 36` and `targetSdk = 36`. `compileSdk` must be ≥ `targetSdk`. Install Android SDK platform 36 if the build asks for it. Flutter’s Android setup page expects SDK Platform API 36 to be installed. ([Set up Android development](https://docs.flutter.dev/platform-integration/android/setup); [Build and release an Android app](https://docs.flutter.dev/deployment/android))

Do not lower `targetSdk` to “get the build working.” Play will reject a new-app submit that targets below 36 after 31 August 2026.

---

## Play App Signing vs the upload key

Play App Signing uses **two** keys. Flutter’s deploy page states the same split: you upload an `.aab` signed with an **upload** key; end users get APKs signed with the **app signing** key. ([Use Play App Signing](https://support.google.com/googleplay/android-developer/answer/9842756); [Build and release an Android app — Sign the app](https://docs.flutter.dev/deployment/android); [Sign your app](https://developer.android.com/studio/publish/app-signing))

| Key | Who holds it | What a beginner does |
| --- | --- | --- |
| **Upload key** | You | Create a Java keystore (`.jks` / `.keystore`), RSA **2048 bits or more**. Sign every Play upload with it. If lost or compromised, Play can **reset** this key. |
| **App signing key** | Google Play | For a **new** app, Play **auto-enrolls** and **Google generates** the key (quantum-ready hybrid plus a classical key for older devices). Google signs the APKs users install. You do not create this unless you deliberately replace Google’s key before open testing / production. |

New-app setup in Play Console Help: create the app (auto-enrolled), **create an upload key**, upload the signed bundle. First release also walks Play App Signing on-screen. To use app bundles you must be enrolled. ([Use Play App Signing](https://support.google.com/googleplay/android-developer/answer/9842756); [Prepare and roll out a release](https://support.google.com/googleplay/android-developer/answer/9859348); [Inspect app versions](https://support.google.com/googleplay/android-developer/answer/9844279))

Keep the upload key and app signing key **different**. Do not check the keystore into git. ([Use Play App Signing](https://support.google.com/googleplay/android-developer/answer/9842756); [Build and release an Android app](https://docs.flutter.dev/deployment/android))

Package name / `applicationId` is **fixed** after the first artifact upload. Set the product ID before the first AAB (sibling identifiers ticket). The prototype’s `com.solitare.klondike_table` is a placeholder. ([Build and release an Android app — Application ID](https://docs.flutter.dev/deployment/android); [Create and set up your app](https://support.google.com/googleplay/android-developer/answer/9859152))

---

## The prototype signs release with debug keys — that cannot ship

`prototype/klondike-table-flutter/android/app/build.gradle.kts` still has Flutter’s template:

```kotlin
release {
    // TODO: Add your own signing config for the release build.
    // Signing with the debug keys for now, so `flutter run --release` works.
    signingConfig = signingConfigs.getByName("debug")
}
```

That is exactly the snippet Flutter’s deploy guide shows **before** you configure a release `signingConfigs` block. It is only so `flutter run --release` works locally. ([Build and release an Android app — Configure signing in Gradle](https://docs.flutter.dev/deployment/android))

Android’s signing guide: the debug certificate is created by the build tools and is **insecure by design**; **most app stores, including Google Play, do not accept apps signed with a debug certificate**. When releasing with App Bundles you must sign with an **upload key**; Play App Signing does the rest. ([Sign your app](https://developer.android.com/studio/publish/app-signing))

So: `flutter build appbundle` on this prototype **today** would produce a release-mode AAB still signed with **debug** keys. That is not a Play-uploadable store binary.

### Official Flutter signing steps (do these later; do not implement in this ticket)

From [Build and release an Android app — Sign the app](https://docs.flutter.dev/deployment/android):

1. **Create an upload keystore** (skip if you already have one). On Linux:

   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA \
           -storetype JKS -keysize 2048 -validity 10000 -alias upload
   ```

   `keytool` ships with the JDK. `flutter doctor -v` prints `Java binary at:`; replace `java` with `keytool`. Keep the `.jks` **private** — not in public source control.

2. **Create** `[project]/android/key.properties` (also keep private / out of git):

   ```properties
   storePassword=<password-from-previous-step>
   keyPassword=<password-from-previous-step>
   keyAlias=upload
   storeFile=<keystore-file-location>
   ```

3. **Configure signing in Gradle** in `android/app/build.gradle.kts`: load `key.properties`, add a `signingConfigs { create("release") { ... } }` block, and set the release `signingConfig` to that config **instead of** `debug`. Flutter’s page has the exact Kotlin patch.

4. Optionally `flutter clean` after the Gradle change so a cached debug-signed artifact is not reused.

5. Then `flutter build appbundle`. If those signing steps are done, Flutter signs the bundle with the upload key.

Play’s first-release flow then enrolls Play App Signing and Google signs user APKs. ([Use Play App Signing](https://support.google.com/googleplay/android-developer/answer/9842756))

---

## Machine requirements

Same toolchain as the resolved local APK ticket, plus JDK for `keytool`:

- **Flutter SDK** on stable (this machine: 3.47.2 at `/opt/flutter`)
- **Android SDK** with `ANDROID_HOME` (this machine: `/opt/android-sdk`; Flutter’s setup expects platform API 36)
- **JDK** (this machine: OpenJDK 17; Flutter’s Android toolchain wants Java 17+)

`flutter build appbundle` fails without an Android SDK (`flutter` exits if `androidSdk == null`). ([Set up Android development](https://docs.flutter.dev/platform-integration/android/setup); Flutter `BuildAppBundleCommand`)

No Mac is required for the Android AAB.

---

## Recommended command sequence (plan only)

Do this on the product Flutter tree when it exists; until then the commands are the same under `prototype/klondike-table-flutter`. Do **not** run the keystore or Gradle edits in this research ticket.

1. Confirm `flutter --version` is current stable (3.35+ so `flutter.targetSdkVersion` is 36). Confirm `ANDROID_HOME` and `flutter doctor` Android toolchain.
2. Create `~/upload-keystore.jks` with `keytool` (RSA 2048, alias `upload`). Back it up offline. Never commit it.
3. Write `android/key.properties` pointing at that keystore. Never commit it.
4. Apply Flutter’s Gradle signing patch; stop using `signingConfigs.getByName("debug")` for `release`.
5. Set the **final** `applicationId` before the first Play upload.
6. From the Flutter project root:

   ```bash
   flutter build appbundle
   ```

7. Take `build/app/outputs/bundle/release/app.aab` (or `app-release.aab` in that folder).
8. In Play Console, first release: accept Play App Signing, add that app bundle (closed testing for a post-13-Nov-2023 personal account — see [play-closed-testing.md](play-closed-testing.md)). Do not upload the ticket-06 APK.

---

## What must change vs what can wait

| Item | Change for Play? |
| --- | --- |
| `flutter build appbundle` instead of `flutter build apk` | Yes — format Play requires for new apps |
| `targetSdk` / `compileSdk` on Flutter 3.47.2 + this Gradle file | **No** — already 36 |
| Release signing (debug → upload keystore + `key.properties` + Gradle) | **Yes — blocker** |
| Play App Signing enrollment | Automatic on first new-app upload; you still create the upload keystore |
| Product `applicationId` | Yes, before first upload (not this ticket) |
| Enroll / upload / change the prototype in this ticket | No |
