# Can we build and install the Klondike table prototype on Android locally?

Type: task
Status: open
GitHub: #13 — https://github.com/jusanherndon/Solitare/issues/13

Supports [How should the Klondike table look and play on a phone in portrait and landscape?](issues/01-klondike-table-look-and-play.md).

## Question

Can we produce a phone-installable Android build of the Klondike table prototype on this machine, without EAS cloud?

A local Gradle APK path already exists (`npm run prototype:table:apk:local`, needs `ANDROID_HOME` / Android SDK). This ticket is done when a beginner can follow repo docs, run one documented command, get an APK, and sideload it onto a phone.

Not store submission, not CI, and not the product app — a local prototype artifact only.

## Done when

- One documented root command produces an APK (existing `prototype:table:apk:local` is the starting point).
- README / `scriptsHelp` states machine requirements (`ANDROID_HOME`) and where the APK is written.
- A successful local build has been demonstrated.
