# Flutter iOS store build: archive, sign, and upload to App Store Connect

**Ticket:** [How do we produce a store-signed iOS build from this Flutter project?](../../.scratch/klondike-app-store/issues/07-flutter-ios-store-build.md)

**Constraints (this map):** plan only. Do not enroll, sign, archive, or upload in this ticket. Do not change the Flutter prototype. The tree today is `prototype/klondike-table-flutter`; the product app later uses the same official Flutter iOS release path. No Expo / EAS. Listing assets, privacy policy, age rating, and enrollment *cost* live in [store listing requirements](store-listing-requirements.md) — this note is the binary + upload path only.

Sources are Apple and Flutter primary docs, fetched 2026-08-29.

---

## Recommended beginner path

One sequence, few extra tools: **Xcode automatic signing + `flutter build ipa` + Transporter**.

**Machine:** a Mac running macOS, with Xcode installed, and a paid [Apple Developer Program](https://developer.apple.com/programs/enroll/) membership. Flutter’s iOS release guide requires Xcode and a Mac; publishing to the App Store also requires enrollment. ([Build and release an iOS app](https://docs.flutter.dev/deployment/ios); [Distributing your app for beta testing and releases](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases)) Individual enrollment facts (99 USD/year, Apple Account with two-factor authentication, legal name, non-P.O.-box address) are already recorded in [store listing requirements](store-listing-requirements.md).

Do this later as a task (not this ticket):

1. **Enroll** in the Apple Developer Program. After you join, Apple creates an App Store Connect account so you can upload builds. ([Distributing your app for beta testing and releases](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases))
2. **Register an explicit App ID** (bundle ID) in Certificates, Identifiers & Profiles, then **create an iOS app record** in App Store Connect and attach that bundle ID. Uploading requires an app record with an explicit App ID. The Account Holder must have signed the latest Business agreement first. ([Register an App ID](https://developer.apple.com/help/account/identifiers/register-an-app-id); [Add a new app](https://developer.apple.com/help/app-store-connect/create-an-app-record/add-a-new-app); [Create an App Store provisioning profile](https://developer.apple.com/help/account/provisioning-profiles/create-an-app-store-provisioning-profile/); [Build and release an iOS app](https://docs.flutter.dev/deployment/ios))
3. From the Flutter project directory, open the workspace Flutter documents: `open ios/Runner.xcworkspace`. On the Runner target, **Signing & Capabilities**: leave **Automatically manage signing** on (Flutter’s default) and select the Team for the paid membership. Set the **Bundle Identifier** to the App ID registered above. ([Build and release an iOS app](https://docs.flutter.dev/deployment/ios); [Preparing your app for distribution](https://developer.apple.com/documentation/xcode/preparing-your-app-for-distribution))
4. Set the user-facing version and a unique build number in `pubspec.yaml` (`version: 1.0.0+1`) or pass `--build-name` / `--build-number` to `flutter build ipa`. On iOS, `build-name` is `CFBundleShortVersionString` and `build-number` is `CFBundleVersion`. Each App Store Connect upload needs a unique build number. ([Build and release an iOS app](https://docs.flutter.dev/deployment/ios); [Preparing your app for distribution](https://developer.apple.com/documentation/xcode/preparing-your-app-for-distribution))
5. If the Game uses only OS-provided encryption (typical HTTPS / ATS), add `ITSAppUsesNonExemptEncryption` = `NO` to `ios/Runner/Info.plist` so App Store Connect does not re-ask export-compliance questions on every version. See [Export compliance](#export-compliance-https--os-encryption-only).
6. From the Flutter project directory, run:

   ```bash
   flutter build ipa
   ```

   That writes an Xcode archive (`.xcarchive`) under `build/ios/archive/` and an App Store `.ipa` under `build/ios/ipa`. ([Build and release an iOS app](https://docs.flutter.dev/deployment/ios))
7. **Upload the IPA** with the [Transporter](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds/) Mac app: drag `build/ios/ipa/*.ipa` onto Transporter. Flutter documents the same drag-and-drop (it calls the app “Apple Transport”). ([Build and release an iOS app](https://docs.flutter.dev/deployment/ios); [Upload builds](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds/))
8. Wait until Apple emails that processing finished. The first upload creates a beta version; the build is not visible until processing completes. **Stop here for this map’s later fog:** choosing TestFlight vs Submit for Review is not part of producing and uploading the signed build. ([Upload builds](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds/); [Build and release an iOS app](https://docs.flutter.dev/deployment/ios))

Do **not** use Expo / EAS, Codemagic CLI, or Fastlane for the first store build. Flutter documents those as optional automation; they add signing and keychain machinery a beginner does not need. ([Build and release an iOS app](https://docs.flutter.dev/deployment/ios))

---

## What each tool does

| Tool | Builds? | Signs? | Uploads? | When to use |
| --- | --- | --- | --- | --- |
| `flutter build ipa` | Yes — archive + App Store IPA | Uses the Xcode project’s signing settings | No | **Recommended build.** Default export is App Store. Other export methods (`--export-method ad-hoc`, `development`, `enterprise`) are for non–App Store distribution. ([Build and release an iOS app](https://docs.flutter.dev/deployment/ios)) |
| Xcode **Product → Archive** + Organizer | Yes — `.xcarchive` | Yes, including cloud-managed distribution certs when you distribute | Yes, if you choose upload | GUI alternative: Validate App, then Distribute App → **TestFlight & App Store**. Flutter also says you can open `build/ios/archive/MyApp.xcarchive` and distribute from Xcode. ([Distributing your app for beta testing and releases](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases); [Build and release an iOS app](https://docs.flutter.dev/deployment/ios); [Cloud-managed certificates](https://developer.apple.com/help/account/certificates/cloud-managed-certificates)) |
| **Transporter** (Mac App Store) | No | No | Yes — `.ipa` / `.pkg` | **Recommended upload** once `flutter build ipa` has written the IPA. Shows progress, warnings, errors, logs, and history. ([Upload builds](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds/)) |
| `xcrun altool` | No | No | Yes — validate and upload | Still documented by Apple and Flutter for App Store Connect. Flutter’s example: `xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey … --apiIssuer …`. Apple’s help: `xcrun altool --validate-app` / `--upload-app` with Apple ID + password (or API key). ([Upload builds](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds/); [Build and release an iOS app](https://docs.flutter.dev/deployment/ios); [TN3147](https://developer.apple.com/documentation/technotes/tn3147-migrating-to-the-latest-notarization-tool)) |
| `xcodebuild` | Yes — `archive` then `-exportArchive` | Via export options / automatic signing | No (export only) | What Xcode and Flutter wrap. Flutter: after one Organizer export, reuse the generated `ExportOptions.plist` with `flutter build ipa --export-options-plist=…`; “See `xcodebuild -h` for details about the keys.” Beginners should not invoke `xcodebuild` directly. ([Build and release an iOS app](https://docs.flutter.dev/deployment/ios); [Creating distribution-signed code for macOS](https://developer.apple.com/documentation/xcode/creating-distribution-signed-code-for-the-mac) documents the same `archive` + `exportArchive` pair) |
| `notarytool` | No | No | **Not App Store Connect** | Mac **notarization** (Direct Distribution / Developer ID), not iOS App Store upload. `altool`’s notarization path is deprecated; `altool` remains valid for App Store submission. ([TN3147](https://developer.apple.com/documentation/technotes/tn3147-migrating-to-the-latest-notarization-tool); [Distributing your app for beta testing and releases](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases)) |

**Where the IPA lands (Flutter):** `build/ios/ipa/*.ipa`. **Where the archive lands:** `build/ios/archive/`. If you instead export from Xcode’s Distribute App flow, Xcode writes a directory containing an IPA and an `ExportOptions.plist` wherever you choose. ([Build and release an iOS app](https://docs.flutter.dev/deployment/ios))

**Xcode version for upload:** App Store Connect’s upload-builds table currently expects iOS apps **built with Xcode 16 or later**; upload via Xcode 6+ is listed as supported, and Transporter / `altool` support all target types. A note says that starting in 2026 you must use Xcode 14 or later to upload. Install current Xcode from the Mac App Store when the task runs. ([Upload builds](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds/))

---

## Signing: certificates, profiles, automatic vs manual

A store-signed iOS build needs a **distribution** signing identity and an **App Store** provisioning profile tied to an **explicit App ID**. Development certificates are for running on devices during development, not for App Store Connect upload. ([Certificates overview](https://developer.apple.com/help/account/certificates/certificates-overview/); [Create an App Store provisioning profile](https://developer.apple.com/help/account/provisioning-profiles/create-an-app-store-provisioning-profile/))

**Certificate types that matter here**

- **Apple Distribution** — “Distribute your iOS … app on devices on designated devices for testing or submit it to App Store Connect.” (Older **iOS Distribution** is “For use with Xcode 11 and earlier.”) ([Certificates overview](https://developer.apple.com/help/account/certificates/certificates-overview/))
- Distribution certificates belong to the **team**. Only one of each distribution type is allowed per team (Developer ID excepted). Only Account Holder or Admin can create them; an individual enrollee *is* the Account Holder. ([Certificates overview](https://developer.apple.com/help/account/certificates/certificates-overview/))

**Automatically manage signing (recommended)**

Flutter leaves **Automatically manage signing** true by default and says that “should be sufficient for most apps.” In Xcode, select the Team on Signing & Capabilities. ([Build and release an iOS app](https://docs.flutter.dev/deployment/ios))

When you assign the project to an Apple Developer Program team, “Xcode creates the necessary signing assets in the associated developer account” on upload or export. ([Preparing your app for distribution](https://developer.apple.com/documentation/xcode/preparing-your-app-for-distribution))

If you choose “Automatically manage signing” when uploading to App Store Connect, **Xcode manages distribution provisioning profiles for you** — you do not have to create an App Store profile by hand. ([Create an App Store provisioning profile](https://developer.apple.com/help/account/provisioning-profiles/create-an-app-store-provisioning-profile/))

Xcode 13+ can **cloud-sign** for distribution in the Organizer archive-and-distribute workflow when no local signing certificate is found. Cloud-managed certificates are tied to the membership and rotate automatically. You can still add an Apple Distribution certificate to the keychain if you want local signing. ([Cloud-managed certificates](https://developer.apple.com/help/account/certificates/cloud-managed-certificates); [Distributing your app for beta testing and releases](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases))

On Distribute App, choosing **Automatically manage signing** lets Xcode manage signing; manual signing uses certificates you supply. ([Distributing your app for beta testing and releases](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases))

**Manual signing (not the beginner path)**

Create an App Store Connect provisioning profile yourself: Distribution → App Store Connect → your explicit App ID → one distribution certificate → Generate → download in Xcode. Use this for large teams, restricted signing access, or CI that cannot use automatic signing. ([Create an App Store provisioning profile](https://developer.apple.com/help/account/provisioning-profiles/create-an-app-store-provisioning-profile/); [Distributing your app to registered devices](https://developer.apple.com/documentation/xcode/distributing-your-app-to-registered-devices))

**What the owner must have besides a Mac and Xcode**

| Need | Why |
| --- | --- |
| Paid Apple Developer Program membership | Required to upload to App Store Connect / TestFlight / App Store. A free Apple ID / Personal Team is not this path. ([Distributing your app for beta testing and releases](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases); [Build and release an iOS app](https://docs.flutter.dev/deployment/ios)) |
| Apple Account signed into Xcode, **Team** selected | Automatic signing and cloud-managed certs attach to that team. ([Preparing your app for distribution](https://developer.apple.com/documentation/xcode/preparing-your-app-for-distribution)) |
| Explicit App ID + App Store Connect app record | Bundle ID in Xcode must match the record. After the first upload, the bundle ID cannot change. ([Add a new app](https://developer.apple.com/help/app-store-connect/create-an-app-record/add-a-new-app); [Preparing your app for distribution](https://developer.apple.com/documentation/xcode/preparing-your-app-for-distribution)) |
| Account Holder signed the latest Business agreement | You cannot add an app record until this is done. ([Add a new app](https://developer.apple.com/help/app-store-connect/create-an-app-record/add-a-new-app)) |
| Role to upload | Account Holder, Admin, App Manager, or Developer. ([Upload builds](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds/)) |
| App Store icon in the binary | 1024×1024 in the asset catalog / Icon Composer — listing spec, not a second Connect upload. ([Preparing your app for distribution](https://developer.apple.com/documentation/xcode/preparing-your-app-for-distribution); [store listing requirements](store-listing-requirements.md)) |

The owner does **not** need to hand-create certificates or profiles if automatic signing stays on. Do not share the Apple Account or distribution certificates outside the organization. ([Certificates overview](https://developer.apple.com/help/account/certificates/certificates-overview/))

---

## App Store Connect upload

After the app record exists, upload with **Xcode, Swift Playground, altool, or Transporter**. The bundle ID and version associate the binary with the app/version; the **build string** uniquely identifies the build. Processing happens on Apple’s side before the build appears; you get email when it finishes. ([Upload builds](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds/))

**Xcode Organizer:** Window → Organizer → Archives. **Validate App** runs a limited check without submitting. **Distribute App** → **TestFlight & App Store** uses recommended settings (automatic signing, upload with symbols, optional build-number management). Custom → App Store Connect lets you **Upload** or **Export** locally for later upload. Before the first upload, create the app record (or Xcode can collect enough to create it). ([Distributing your app for beta testing and releases](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases))

**Transporter:** download from the Mac App Store; drag the IPA. Best match for a Flutter-built `build/ios/ipa/*.ipa`. ([Upload builds](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds/))

**altool:** still a documented App Store upload path (`--validate-app` / `--upload-app`). Flutter documents API-key auth; Apple’s help also shows Apple ID + password. Run `man altool` for the current flags. ([Upload builds](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds/); [Build and release an iOS app](https://docs.flutter.dev/deployment/ios); [TN3147](https://developer.apple.com/documentation/technotes/tn3147-migrating-to-the-latest-notarization-tool))

**notarytool:** do not use for this iOS Game. It talks to the **notary service** (Mac software distributed outside the Mac App Store). Apple: “`altool` is still a good way to perform other tasks, like submitting an app to the App Store.” ([TN3147](https://developer.apple.com/documentation/technotes/tn3147-migrating-to-the-latest-notarization-tool))

---

## Export compliance (HTTPS / OS encryption only)

Uploading to TestFlight or the App Store sends the binary to a U.S. server. Distributing outside the U.S. or Canada is a U.S. export; encryption in the app can trigger export-compliance rules. App Store Connect asks questions on each new version unless the Info.plist already declares the answer. ([Complying with encryption export regulations](https://developer.apple.com/documentation/security/complying-with-encryption-export-regulations); [Overview of export compliance](https://developer.apple.com/help/app-store-connect/manage-app-information/overview-of-export-compliance); [Preparing your app for distribution](https://developer.apple.com/documentation/xcode/preparing-your-app-for-distribution))

**Key:** `ITSAppUsesNonExemptEncryption` (Boolean) in the app’s information property list.

- Set **`NO`** if the app — including third-party libraries — uses **no** encryption, or **only** encryption **exempt from export-compliance documentation**.
- Set **`YES`** if it uses non-exempt (typically proprietary) encryption; then you usually also set `ITSEncryptionExportComplianceCode` to the code Apple issues after reviewing uploaded docs.

If the key is omitted, Connect walks through the questionnaire on every new version. ([ITSAppUsesNonExemptEncryption](https://developer.apple.com/documentation/BundleResources/Information-Property-List/ITSAppUsesNonExemptEncryption); [Complying with encryption export regulations](https://developer.apple.com/documentation/security/complying-with-encryption-export-regulations))

**HTTPS / OS encryption:** Apple’s typical example of **exempt from documentation upload** is encryption built into the OS — “for example, when your app makes HTTPS connections using URLSession.” Proprietary encryption is not exempt. ([Complying with encryption export regulations](https://developer.apple.com/documentation/security/complying-with-encryption-export-regulations))

Apple’s documentation table: **“Your app uses encryption limited to that within the Apple operating system” → no documentation required in App Store Connect.** Industry-standard algorithms *not* in the OS may need a French declaration if you distribute in France; proprietary algorithms may need CCATS plus that French form. ([Export compliance documentation for encryption](https://developer.apple.com/help/app-store-connect/reference/export-compliance-documentation-for-encryption))

If no documentation is required, update Info.plist so you are not asked again. You can also answer the App Encryption Documentation questions in App Information (or **Manage** on a build missing encryption info). ([Determine and upload app encryption documentation](https://developer.apple.com/help/app-store-connect/manage-app-information/determine-and-upload-app-encryption-documentation); [Overview of export compliance](https://developer.apple.com/help/app-store-connect/manage-app-information/overview-of-export-compliance))

**Klondike implication:** a Flutter Game that uses only HTTPS and/or OS crypto, and does not ship custom/proprietary crypto in Dart or plugins, matches Apple’s “OS encryption only” row. Put this in `ios/Runner/Info.plist` (Flutter’s standard iOS property list; the prototype already has this file and does **not** yet set the key):

```xml
<key>ITSAppUsesNonExemptEncryption</key>
<false/>
```

Re-check if later plugins add their own crypto. Apple still says you are responsible for reading the EAR; exempt encryption can still imply a **year-end self-classification report** to the U.S. government (not an App Store Connect upload). ([Complying with encryption export regulations](https://developer.apple.com/documentation/security/complying-with-encryption-export-regulations); [Overview of export compliance](https://developer.apple.com/help/app-store-connect/manage-app-information/overview-of-export-compliance))

---

## What this ticket does *not* require

- **Enroll, archive, or upload now.** Later task tickets do that.
- **TestFlight vs Submit for Review.** Upload creates a processed build. Internal TestFlight and “Submit for Review” are separate Connect steps after processing. Flutter documents both as later release steps. Apple: after beta testing the final build, submit to App Review. ([Build and release an iOS app](https://docs.flutter.dev/deployment/ios); [Distributing your app for beta testing and releases](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases); [Upload builds](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds/))
- **A successful local Simulator/`flutter run` iOS build.** That is [the spec-map local prototype ticket](../../.scratch/klondike-solitaire-spec/issues/07-ios-local-prototype-build.md) (`flutter build ios` / Simulator), still waiting on a MacBook.
- **Changing `prototype/klondike-table-flutter`.** It is a throwaway table prototype (`version: 0.0.0`, display name “Klondike Table”). The product app will use the same `flutter build ipa` path, with a real bundle ID, version `x.y.z+build`, store icon, and the encryption key above.
- **CI, Fastlane, Codemagic, Expo, EAS, Xcode Cloud.** Optional; not the beginner path.
- **Listing copy, screenshots, privacy nutrition labels, age rating.** [store listing requirements](store-listing-requirements.md).
- **Mac notarization / Developer ID / `notarytool`.** iOS App Store apps are not notarized that way.

---

## Flutter project settings to check before the first store IPA

From Flutter’s release guide and Apple’s prepare-for-distribution note, on the Runner target:

- **Display Name** and **Bundle Identifier** (must match the Connect App ID).
- **Automatically manage signing** + **Team**.
- **iOS Deployment Target:** Flutter documents iOS 13 and later; raise it if native code needs a newer API.
- Version / build (`pubspec.yaml` or Xcode Identity).
- App icon in `Assets.xcassets` (replace Flutter placeholders).
- Supported destinations: phones-only for this map (skip iPad storefront extras; see listing spec).

([Build and release an iOS app](https://docs.flutter.dev/deployment/ios); [Preparing your app for distribution](https://developer.apple.com/documentation/xcode/preparing-your-app-for-distribution))

---

## Sources

- [Build and release an iOS app (Flutter)](https://docs.flutter.dev/deployment/ios)
- [Distributing your app for beta testing and releases](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases)
- [Preparing your app for distribution](https://developer.apple.com/documentation/xcode/preparing-your-app-for-distribution)
- [Upload builds (App Store Connect Help)](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds/)
- [Add a new app](https://developer.apple.com/help/app-store-connect/create-an-app-record/add-a-new-app)
- [Register an App ID](https://developer.apple.com/help/account/identifiers/register-an-app-id)
- [Certificates overview](https://developer.apple.com/help/account/certificates/certificates-overview/)
- [Cloud-managed certificates](https://developer.apple.com/help/account/certificates/cloud-managed-certificates)
- [Create an App Store provisioning profile](https://developer.apple.com/help/account/provisioning-profiles/create-an-app-store-provisioning-profile/)
- [Distributing your app to registered devices](https://developer.apple.com/documentation/xcode/distributing-your-app-to-registered-devices)
- [Creating distribution-signed code for macOS](https://developer.apple.com/documentation/xcode/creating-distribution-signed-code-for-the-mac) (`xcodebuild archive` / `exportArchive`)
- [TN3147: Migrating to the latest notarization tool](https://developer.apple.com/documentation/technotes/tn3147-migrating-to-the-latest-notarization-tool)
- [Complying with encryption export regulations](https://developer.apple.com/documentation/security/complying-with-encryption-export-regulations)
- [ITSAppUsesNonExemptEncryption](https://developer.apple.com/documentation/BundleResources/Information-Property-List/ITSAppUsesNonExemptEncryption)
- [Overview of export compliance](https://developer.apple.com/help/app-store-connect/manage-app-information/overview-of-export-compliance)
- [Determine and upload app encryption documentation](https://developer.apple.com/help/app-store-connect/manage-app-information/determine-and-upload-app-encryption-documentation)
- [Export compliance documentation for encryption](https://developer.apple.com/help/app-store-connect/reference/export-compliance-documentation-for-encryption)
- [Become a member — Apple Developer Program](https://developer.apple.com/programs/enroll/) (fee and individual identity: [store listing requirements](store-listing-requirements.md))
