# iOS disconnected device install (free Apple ID)

**Ticket:** [How do we install the Klondike table prototype on a physical iPhone without a connected `flutter run`?](../../.scratch/klondike-solitaire-spec/issues/19-ios-disconnected-device-install.md)

This note is the **local prototype** path: install a development IPA on a phone you own, unplug, play. It is not App Store / TestFlight. Those stay in [flutter-ios-store-build.md](flutter-ios-store-build.md).

Sources are Apple and Flutter primary docs, plus one local demonstration on 2026-09-07.

---

## Recommended beginner path

**Xcode automatic signing (Personal Team) + `flutter build ipa --export-method development` + USB `flutter install --use-application-binary=…`.**

No paid [Apple Developer Program](https://developer.apple.com/programs/enroll/) membership. A free Apple Account signed into Xcode is a **Personal Team**. ([Developer account overview](https://developer.apple.com/help/account/basics/about-your-developer-account/))

```bash
cd prototype/klondike-table-flutter
flutter build ipa --export-method development
flutter install -d <UDID> --use-application-binary=build/ios/ipa/klondike_table.ipa
```

IPA lands at `build/ios/ipa/*.ipa`. Archive at `build/ios/archive/`. ([Build and release an iOS app](https://docs.flutter.dev/deployment/ios))

Then unplug and launch **Klondike Table** from the home screen.

---

## What a free Apple ID can and cannot do

**Can**

- On-device testing using Xcode / a Personal Team. ([Developer account overview](https://developer.apple.com/help/account/basics/about-your-developer-account/))
- Build a **development** IPA with Flutter’s `--export-method development`. Flutter documents that flag for non–App Store distribution. ([Build and release an iOS app](https://docs.flutter.dev/deployment/ios))
- Install that IPA from the Mac with `flutter install --use-application-binary=` (iOS binary is an IPA). Demonstrated 2026-09-07.

**Cannot**

- App Store, TestFlight, App Store Connect, Certificates/Identifiers/Profiles portal. Those need program membership. ([Developer account overview](https://developer.apple.com/help/account/basics/about-your-developer-account/); [Distributing your app for beta testing and releases](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases))
- Default `flutter build ipa` (export method `app-store`). That path is the store upload. ([Build and release an iOS app](https://docs.flutter.dev/deployment/ios))
- `--export-method ad-hoc`: Flutter says it requires a **distribution certificate**. Personal Team has Apple Development only. ([Build and release an iOS app](https://docs.flutter.dev/deployment/ios); this machine’s identity was `Apple Development: jh4411@msstate.edu`)
- AirDrop / Files-app / “open this IPA on the phone” like an Android APK. Apple’s documented install path for a development build is from Xcode / registered development devices, not a phone-local installer. ([Distributing your app for beta testing and releases](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases))

---

## Personal Team limits

From Apple, for an account **not** in a developer program ([Developer account overview](https://developer.apple.com/help/account/basics/about-your-developer-account/)):

- Up to **10 App IDs**, expire after **7 days**
- Up to **3 devices**, expire after **7 days**
- Up to **3 apps per device**
- Provisioning profiles expire **7 days** from issuance; rebuild and reinstall after expiration

The IPA built this session had `TimeToLive` 7, `LocalProvision` true, `get-task-allow` true, TeamName **Justin Herndon**.

---

## Phone settings used in the demonstration

On the Mac, already set in the Xcode project:

- **Automatically manage signing**
- **Team** Justin Herndon (`SCV7WNWPLC`)
- Bundle ID `com.solitare.klondikeTable`

On each **new** iPhone:

1. USB (wireless `flutter install` failed here with CoreDevice connection reset)
2. **Trust This Computer**
3. **Settings → Privacy & Security → Developer Mode**
4. After install, if launch is denied: **Settings → General → VPN & Device Management** → Trust the developer

The second iPhone in this session installed cleanly but would not launch until that Trust step. Error from `devicectl`: invalid code signature / profile not explicitly trusted by the user.

---

## Flutter export methods

`flutter build ipa --export-method`:

| Value | Flutter help text | Free Apple ID? |
| --- | --- | --- |
| `app-store` (default) | Upload to the App Store | No |
| `ad-hoc` | Designated devices; **requires a distribution certificate** | No |
| `development` | Test on development devices registered with the account | Yes — demonstrated |
| `enterprise` | Apple Developer Enterprise Program | No |

([Build and release an iOS app](https://docs.flutter.dev/deployment/ios); `flutter build ipa -h` on Flutter 3.47.2)

The exported `ExportOptions.plist` for this build used `method` = `debugging` and `signingStyle` = `automatic`.

---

## Not this path

- Store IPA / Transporter / paid enrollment — [flutter-ios-store-build.md](flutter-ios-store-build.md)
- Simulator — [Can we build and install the Klondike table prototype on iOS locally?](../../.scratch/klondike-solitaire-spec/issues/07-ios-local-prototype-build.md)
- Expo / EAS
