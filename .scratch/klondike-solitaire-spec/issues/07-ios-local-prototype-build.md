# Can we build and install the Klondike table prototype on iOS locally?

Type: task
Status: open
GitHub: #14 — https://github.com/jusanherndon/Solitare/issues/14

Supports [How should the Klondike table look and play on a phone in portrait and landscape?](issues/01-klondike-table-look-and-play.md).

## Question

Can we produce a Simulator- or device-installable iOS build of the Flutter Klondike table prototype on a local machine?

The comparison prototype is `prototype/klondike-table-flutter` (see `01`). Starting point: `flutter build ios` / `flutter run` on a Simulator. Local iOS compilation needs macOS and Xcode — the owner override of [#2](https://github.com/jusanherndon/Solitare/issues/2) (Flutter instead of Expo) dropped the EAS cloud path that avoided a Mac.

This ticket is done when repo docs name the command, the machine requirements, and where the `.ipa` or Simulator app lands, and a successful local build has been demonstrated.

Not store submission, not CI, and not the product app — a local prototype artifact only. Do not use Expo / EAS. The App Store IPA path is [How do we produce a store-signed iOS build from this Flutter project?](../../klondike-app-store/issues/07-flutter-ios-store-build.md).

## Done when

- One documented command produces a local iOS build from `prototype/klondike-table-flutter` (`flutter build ios` / `flutter run` on Simulator is the starting point).
- README states that macOS + Xcode are required, and where the artifact is written.
- A successful local build has been demonstrated (Simulator is enough).

## Comments

### jusanherndon — 2026-08-23T20:34:00Z

Owner chose Flutter over Expo after comparing prototypes ([#22](https://github.com/jusanherndon/Solitare/pull/22) merged; [#17](https://github.com/jusanherndon/Solitare/pull/17) closed). The Expo “no Mac for iOS” rationale from #2 no longer applies to this ticket: Flutter’s official iOS path still needs macOS + Xcode.

### jusanherndon — 2026-08-23T20:56:00Z

iOS local builds wait until the owner buys a MacBook. Android is done on `06`. Do not treat EAS/cloud iOS as a substitute. Ticket stays open.
