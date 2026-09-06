# How do we install the Klondike table prototype on a physical iPhone without a connected `flutter run`?

Type: task
Status: open

Follows [Can we build and install the Klondike table prototype on iOS locally?](issues/07-ios-local-prototype-build.md), which demonstrated Simulator and `flutter run` only — no physical iPhone, and no path that survives unplugging the Mac. Android already has the disconnected counterpart: [Can we build and install the Klondike table prototype on Android locally?](issues/06-android-local-prototype-build.md) (`flutter build apk` and sideload). Store IPA / TestFlight stay on [Post Klondike Solitaire to the App Store](../../klondike-app-store/map.md).

## Question

How do we load `prototype/klondike-table-flutter` onto a physical iPhone the owner owns so the app can be played with the Mac disconnected — the iOS counterpart of Android APK sideload?

`flutter run` stays available for connected debug. This ticket is the other mode: install, unplug, play. The owner asked for that non-connected path for testing.

This ticket is done when repo docs name the command(s), any signing or profile caveats that affect unplugged use (debug vs release, certificate trust, expiry on a free Apple ID), and a successful disconnected run has been demonstrated on a physical iPhone.

Not App Store, not TestFlight, not CI.

## Done when

- One documented command sequence installs the prototype on a physical iPhone from `prototype/klondike-table-flutter` without leaving a `flutter run` session attached.
- After install, the app launches and can be played with the cable unplugged.
- README states that path next to the existing `flutter run` physical-iPhone steps.
- A successful disconnected install has been demonstrated.
