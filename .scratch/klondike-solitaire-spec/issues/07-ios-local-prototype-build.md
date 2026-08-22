# Can we build and install the Klondike table prototype on iOS locally?

Type: task
Status: open
GitHub: #14 — https://github.com/jusanherndon/Solitare/issues/14

Supports [How should the Klondike table look and play on a phone in portrait and landscape?](issues/01-klondike-table-look-and-play.md).

## Question

Can we produce a Simulator- or device-installable iOS build of the Klondike table prototype on a local machine, without EAS cloud?

[Which one-codebase toolkit should a beginner use to ship Klondike Solitaire?](https://github.com/jusanherndon/Solitare/issues/2) chose Expo in part so iOS *shipping* can use EAS cloud (no Mac required). This ticket is the on-machine path: local iOS compilation needs macOS and Xcode.

This ticket is done when repo docs name the command, the machine requirements, and where the `.ipa` or Simulator app lands, and a successful local build has been demonstrated.

Not store submission, not CI, and not the product app — a local prototype artifact only.

## Done when

- One documented command produces a local iOS build (prebuild + Xcode / `expo run:ios` / `eas build --local --platform ios`, whichever fits ADR-0001).
- README / `scriptsHelp` states that macOS + Xcode are required, and where the artifact is written.
- A successful local build has been demonstrated (Simulator is enough).
