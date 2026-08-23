# Can we build and install the Klondike table prototype on Android locally?

Type: task
Status: resolved
GitHub: #13 — https://github.com/jusanherndon/Solitare/issues/13

Supports [How should the Klondike table look and play on a phone in portrait and landscape?](issues/01-klondike-table-look-and-play.md).

## Question

Can we produce a phone-installable Android build of the Flutter Klondike table prototype on this machine?

The comparison prototype is `prototype/klondike-table-flutter` (see `01`). Starting point: `flutter build apk` (needs Flutter SDK + `ANDROID_HOME` / Android SDK). This ticket is done when a beginner can follow repo docs, run one documented command, get an APK, and sideload it onto a phone.

Not store submission, not CI, and not the product app — a local prototype artifact only. Do not revive the Expo / EAS / `npm run prototype:table:apk:local` path; that table was dropped.

## Done when

- One documented command produces an APK from `prototype/klondike-table-flutter` (`flutter build apk` is the starting point).
- README states machine requirements (Flutter SDK, `ANDROID_HOME`) and where the APK is written.
- A successful local build has been demonstrated.

## Comments

### jusanherndon — 2026-08-23T20:34:00Z

Owner chose the Flutter prototype over Expo ([#22](https://github.com/jusanherndon/Solitare/pull/22) merged; [#17](https://github.com/jusanherndon/Solitare/pull/17) closed as worse/buggier). Flutter was nicer to build with, took less time, and produced a smaller APK — so a local Android APK has already been produced once. This ticket is still the docs + repeatable-command work, aimed at that Flutter tree, not Expo.

### jusanherndon — 2026-08-23T20:56:00Z

Owner can already make Android builds locally with Flutter and the Android SDK. Closing this ticket. iOS local builds wait until a MacBook (`07`).

## Answer

Yes. On this machine, `cd prototype/klondike-table-flutter && flutter build apk` produces a sideloadable APK using the Flutter SDK and Android SDK (`ANDROID_HOME`). Command and output path are in that prototype README. Not store submission. iOS is `07` and waits on a Mac.
