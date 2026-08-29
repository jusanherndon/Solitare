# What bugs or changes turn up when the owner runs the prototype on Android?

Type: task
Status: open

Depends on [Can we build and install the Klondike table prototype on Android locally?](issues/06-android-local-prototype-build.md). Related: [How should the start, About, win, and loss screens look on a phone?](issues/15-chrome-screens-look.md), [spec.md](../spec.md).

## Question

The owner runs the Flutter prototype on an Android phone and records bugs and desired changes here.

This is a capture ticket, not an implementation ticket. Play the table and the felt-banner chrome (start, About, win, loss) in portrait and landscape. Write each finding under **Comments** — what you saw, what you want instead. A later session can graduate those notes into spec patches or build work.

Run `prototype/klondike-table-flutter` (`flutter run` on a connected device, or `flutter build apk` and sideload). Felt-banner chrome is in this tree (start, About, table, win, loss). There is no variant switcher.

Do not treat this as store QA. iOS is [Can we build and install the Klondike table prototype on iOS locally?](issues/07-ios-local-prototype-build.md).

## Done when

- The owner has played on Android (portrait and landscape).
- Bugs and wanted changes are written in Comments on this ticket.
- A follow-up session has either patched the spec, filed follow-on work, or recorded that nothing needs to change.

## Comments
