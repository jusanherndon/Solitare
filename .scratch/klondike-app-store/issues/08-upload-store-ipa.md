# Can we produce and upload a store-signed IPA?

Type: task
Status: open
Blocked by: 04, 05, 06

HITL for Apple Account / Transporter sign-in. Needs a Mac with Xcode (same machine as spec [Can we build and install the Klondike table prototype on iOS locally?](../klondike-solitaire-spec/issues/07-ios-local-prototype-build.md)).

Depends on [How do we produce a store-signed iOS build from this Flutter project?](issues/07-flutter-ios-store-build.md). Path: `docs/research/flutter-ios-store-build.md`.

## Question

Can we produce a store-signed IPA of Klondike Solitaire and upload it to App Store Connect?

Follow the locked beginner path: register the explicit App ID and create the Connect app record (bundle ID from [What bundle ID and application ID does v1 use?](issues/05-store-identifiers.md)), leave **Automatically manage signing** on, set `ITSAppUsesNonExemptEncryption` = `NO` in `ios/Runner/Info.plist`, run `flutter build ipa`, drag `build/ios/ipa/*.ipa` onto **Transporter**. Do not hand-create certificates. Do not use `notarytool`, Expo, or EAS.

The 1024 icon in the binary is [What App Store icon and 6.9″ screenshots does v1 use?](issues/04-app-store-listing-visuals.md). TestFlight vs Submit for Review is [Do we use TestFlight before Submit for Review?](issues/09-testflight-vs-submit.md) — stop after processing finishes.

## Done when

- App Store Connect has an iOS app record named Klondike Solitaire with the locked bundle ID.
- A comment links a successful Transporter (or Organizer) upload and the processed build in Connect — not Apple passwords.
- The IPA was built with automatic signing and the encryption plist key above.
