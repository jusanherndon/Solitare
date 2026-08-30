# What bugs or changes turn up when the owner playtests round 2 on Android?

Type: task
Status: open
Blocked by: 01, 06, 08, 09

From [What bugs or changes turn up when the owner runs the prototype on Android?](../../klondike-solitaire-spec/issues/17-android-playtest.md). Last ticket on [Round 2 of making the app mechanics](../map.md) — wait until the other open work is done and the round 2 decisions are playable in `prototype/klondike-table-flutter`.

## Question

The owner runs the Flutter prototype on an Android phone after round 2 is in the table, and records bugs and desired changes here.

This is a capture ticket, not an implementation ticket. Play portrait and landscape. Cover at least: **draw-three** (Settings), **Winning deal** (both pools), **Hint**, the **loss** check, **Finish** (including **Continue**), table chrome (**Hint**, **Undo**, **New Game**, **Start**), and the Auto-move / chrome-tap fix. Write each finding under **Comments** — what you saw, what you want instead. A later session can graduate those notes into spec patches or build work.

Do not start until:

- [How should Undo, New Game, and Start look?](issues/01-table-chrome-look.md)
- [Why do Auto-move and chrome buttons sometimes miss a tap, and what should they do?](issues/06-auto-move-miss.md)
- [Fill and ship the draw-one winning-deal pool](issues/08-draw-one-winning-deal-pool.md)
- [Fill and ship the draw-three winning-deal pool](issues/09-draw-three-winning-deal-pool.md)

and the grilled mechanics from this map are in the prototype (not spec-only).

Run `prototype/klondike-table-flutter` (`flutter run` on a connected device, or `flutter build apk` and sideload). Do not treat this as store QA. iOS stays on [Can we build and install the Klondike table prototype on iOS locally?](../../klondike-solitaire-spec/issues/07-ios-local-prototype-build.md).

## Done when

- The owner has played on Android (portrait and landscape).
- Bugs and wanted changes are written in Comments on this ticket.
- A follow-up session has either patched the spec, filed follow-on work, or recorded that nothing needs to change.
