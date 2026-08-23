# What are the v1 rules for Undo, resume, tap, and drag?

Type: grilling
Status: resolved
GitHub: #7 — https://github.com/jusanherndon/Solitare/issues/7

## Question

What are the v1 interaction details for tap, drag, Undo, and resume — including how tap and drag combine, how deep Undo goes, what leaving the app restores, and whether cards auto-move to Foundations? React to the phone-layout prototype; do not invent a second design in the abstract.

## Comments

### jusanherndon — 2026-08-14T20:36:18Z

**Note from `01` prototype feedback (not a resolution):** the throwaway table now has **Undo** next to New Game (reverses moves, draws, and Stock recycles; selection-only taps are not stacked).

This ticket stays open — still need owner grilling on Undo depth, resume-after-leave, auto-move to Foundations, and how tap vs drag should combine. React to the prototype rather than inventing a second design.

### jusanherndon — 2026-08-23T20:34:00Z

React to the **Flutter** table (`prototype/klondike-table-flutter`), not Expo. [#22](https://github.com/jusanherndon/Solitare/pull/22) won the comparison; [#17](https://github.com/jusanherndon/Solitare/pull/17) closed as worse to use and buggier. Play already in the Flutter twin: Undo next to New Game, tap→tap + drag, double-click auto-move. Resume-after-leave still ungrilled.

## Answer

v1 matches the Flutter table, plus Resume.

**Tap and drag.** Both are first-class. Tap a card, then tap a legal destination; or drag and drop. A tiny slip is a tap, not a drag. An illegal drop snaps back. Tapping an illegal destination, or tapping the same card again, clears the pick and does nothing else. A drag may start from a card already tapped. Drawing from the Stock is a tap on the Stock, not a drag. No selection highlight (locked on `01`).

**Auto-move.** Only on double-tap / double-click. Foundation first if legal, otherwise a legal Tableau pile. Cards never fly to a Foundation on their own.

**Undo.** Unlimited within the current Game: every successful move, draw, Stock recycle, and auto-move, back to the opening Tableau. Selection-only taps do not stack. New Game cannot be undone; it starts a fresh Undo stack.

**Resume.** Next launch restores an unfinished Game (Stock, Waste, Foundations, Tableau, face-up state) and the Undo stack. Do not restore a tap-selection or an in-progress drag. If they already tapped New Game, or the Game is won, launch a fresh Game instead of the finished table. Resume stays on-device (see #9).
