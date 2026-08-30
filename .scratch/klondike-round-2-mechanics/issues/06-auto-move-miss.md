# Why do Auto-move and chrome buttons sometimes miss a tap, and what should they do?

Type: task
Status: open

From [What bugs or changes turn up when the owner runs the prototype on Android?](../../klondike-solitaire-spec/issues/17-android-playtest.md).

## Question

Taps on the table sometimes fail. Two symptoms may be the same bug:

1. **Auto-move** (double-tap) sometimes does not send the card to a legal play.
2. Chrome buttons (**Undo**, **New Game**, **Start**, and possibly other taps) sometimes do not respond at all.

Owner’s later note: this may be **timing** — a gesture window, animation, or input lock — not Auto-move’s destination rule being wrong. Investigate both symptoms together. Treat as a bug, not a rules change, until a play proves the spec is wrong.

Reproduce in `prototype/klondike-table-flutter`. If Auto-move’s choice of pile is the miss, fix so a double-tap still prefers Foundation if legal, otherwise a legal Tableau pile ([What are the v1 rules for Undo, resume, tap, and drag?](../../klondike-solitaire-spec/issues/02-undo-resume-tap-drag.md)). If taps are dropped or delayed, find that cause and fix so chrome buttons and double-tap still fire when the player intends them. Record the failing case (and whether it was destination vs timing) in the answer.

## Done when

- A missed legal Auto-move and/or an unresponsive tap can be shown (or the report cannot be reproduced, and that is written down).
- If the miss is timing or input-lock, the answer names the cause.
- Double-tap matches the locked Auto-move rule on a phone-sized layout, and chrome buttons respond, or the spec is reopened with evidence.

## Comments

### jusanherndon — 2026-08-30

May be more than a missed Auto-move destination. Sometimes the buttons do not respond at all. Possible timing issue. Scope of this ticket widened to both symptoms.

### agent — 2026-08-30

Owner asked to sharpen Auto-move (destination, not just a missed tap). Double-tap now takes the first play **Hint** would show for that card: Foundation first if legal; no Foundation-to-Foundation; no Foundation Ace onto Tableau; a Foundation card onto Tableau only when a waiting Waste or Tableau card can play onto it; no built Tableau-run shift unless it frees a Foundation play. Shared list is `legalHintPlays` in `lib/game/plays.dart`. Chrome-button miss still open.
