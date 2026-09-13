# What bugs or changes turn up when the owner playtests round 2 on Android?

Type: task
Status: open
Blocked by: 06

From [What bugs or changes turn up when the owner runs the prototype on Android?](../../klondike-solitaire-spec/issues/17-android-playtest.md). Last ticket on [Round 2 of making the app mechanics](../map.md) — wait until the other open work is done and the round 2 decisions are playable in `src/klondike-table-flutter`.

## Question

The owner runs the Flutter prototype on an Android phone after round 2 is in the table, and records bugs and desired changes here.

This is a capture ticket, not an implementation ticket. Play portrait and landscape. Cover at least: **draw-three** (Settings), **Winning deal** (both pools), **Hint**, the **loss** check, **Finish** (including **Continue**), table chrome (**Hint**, **Undo**, **New Game**, **Start**), and the Auto-move / chrome-tap fix. Write each finding under **Comments** — what you saw, what you want instead. A later session can graduate those notes into spec patches or build work.

Do not start until:

- [How should Undo, New Game, and Start look?](issues/01-table-chrome-look.md)
- [Why do Auto-move and chrome buttons sometimes miss a tap, and what should they do?](issues/06-auto-move-miss.md)
- [Fill and ship the draw-one winning-deal pool](issues/08-draw-one-winning-deal-pool.md)
- [Fill and ship the draw-three winning-deal pool](issues/09-draw-three-winning-deal-pool.md)
- [Implement draw-three in the Flutter prototype](issues/11-draw-three.md)
- [Implement the Winning deal button](issues/12-winning-deal-button.md)
- [Implement Hint on the table](issues/13-hint.md)
- [Implement the last-resort loss check](issues/14-loss-check.md)
- [Implement the Finish overlay](issues/15-finish.md)

Run `src/klondike-table-flutter` (`flutter run` on a connected device, or `flutter build apk` and sideload). Do not treat this as store QA. iOS stays on [Can we build and install the Klondike table prototype on iOS locally?](../../klondike-solitaire-spec/issues/07-ios-local-prototype-build.md).

## Done when

- The owner has played on Android (portrait and landscape).
- Bugs and wanted changes are written in Comments on this ticket.
- A follow-up session has either patched the spec, filed follow-on work, or recorded that nothing needs to change.

## Comments

### jusanherndon — 2026-09-06T15:40:00Z

Want Stock and Waste flipped to the right of the top row, Tableau still on top. Default should be that right-hand layout. Add a **Settings** option for left-handed play that puts Stock and Waste back on the left, Foundations on the right — the positions they had before the flip.

### jusanherndon — 2026-09-06T15:44:00Z

After the flip, Waste sat on the left of the draw pile. Want Waste on the right of Stock in the default layout. Do not change **Left-handed**: that pair stays Stock then Waste on the left.

### jusanherndon — 2026-09-06T15:59:00Z

Want a **Settings** option so Waste can sit on either side of the draw pile. Default remains Waste to the right of Stock. **Waste on left** puts Waste to the left of Stock. Independent of **Left-handed**.

### jusanherndon — 2026-09-06T16:00:00Z

**Waste on left** must also apply in **Left-handed** layout, not only the right-hand default. Turning it on puts Waste to the left of Stock whether the pair is on the left or the right.

### jusanherndon — 2026-09-13T12:45:00Z

Hint loop-stop from a previous fix still works: the Hint loop stops. After the player makes another new move, a Hint loop can persist again. Want the loop-stop to persist for about the next 5 player moves.

### agent — 2026-09-13T12:50:00Z

Shipped in `src/klondike-table-flutter`: Hint does not show the reverse of a Waste, Tableau, or Foundation play for the next 5 player moves. After that window the reverse can be a Hint again if it is still legal. Loss still treats a reverse to an unseen face-up table as an **active Hint**. Spec: [spec.md](../../klondike-solitaire-spec/spec.md). Tests: `test/hint_test.dart`.

### jusanherndon — 2026-09-13T13:18:00Z

Empty Waste does not need a label. Keep calling it Waste in docs; do not show **Waste** on the slot.

### agent — 2026-09-13T13:20:00Z

Empty Waste is an unlabeled dashed slot, same as Foundations. Spec and [How should the Klondike table look and play on a phone in portrait and landscape?](../../klondike-solitaire-spec/issues/01-klondike-table-look-and-play.md) updated. **Waste on left** Settings is unchanged.
