# Implement Hint on the table

Type: task
Status: resolved
Blocked by: 11

From [How does Hint work, and where does it sit?](issues/05-hint.md). Spec: [spec.md](../../klondike-solitaire-spec/spec.md). Waits on [Implement draw-three in the Flutter prototype](issues/11-draw-three.md) so both draw types use the same cycle.

## Question

Put **Hint** in `prototype/klondike-table-flutter` as locked: table chrome **Hint**, **Undo**, **New Game**, **Start**; ghost of one legal face-up play; new then repeats; dim when empty; wrap; cancel without locking the player in. Not **Auto-move**. Do not reopen the grilling. The **loss** check stays on [Implement the last-resort loss check](issues/14-loss-check.md). Chrome look stays on [How should Undo, New Game, and Start look?](issues/01-table-chrome-look.md) — current felt pills are fine until that prototype lands.

## Done when

- **Hint** is on the table and matches the spec for draw-one and draw-three (Waste top only).
- Empty, wrap, rebuild-after-play, and cancel-during-ghost behaviors are covered by tests or a written playthrough in the answer.

## Answer

**Hint** sits top-right with **Undo**, **New Game**, **Start**. Cycle is `hintCycle` in `lib/game/hint.dart`: face-up plays only (Waste top in draw-three), new then repeats, wrap via `HintCursor`. Empty list dims the button. Tests: `test/hint_test.dart`.

**Cancel during ghost (playthrough):** Tap Hint → ghost of play 0 starts. Tap Hint again before it fades → ghost stops, cycle advances to 1, next Hint tap shows play 1 (does not start it on the cancel tap). Tap a Tableau card during a ghost → ghost clears, cycle does not advance; the tap is a normal select. A successful drop then rebuilds the cycle from the new table.

## Comments

### agent — 2026-08-30

Owner tweak: do not Hint a Foundation Ace back onto Tableau. Do Hint a Foundation card onto Tableau when a waiting Waste or Tableau card can play onto it after the pull (a 3 comes down to give a showing 2 a home).

### agent — 2026-08-30

Owner tweak: do not Hint a King that already sits on an empty Tableau pile onto another empty pile. Still Hint a King that uncovers a face-down card.

