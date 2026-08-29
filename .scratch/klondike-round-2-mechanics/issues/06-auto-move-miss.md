# Why does Auto-move miss a legal play, and what should it do?

Type: task
Status: open

From [What bugs or changes turn up when the owner runs the prototype on Android?](../../klondike-solitaire-spec/issues/17-android-playtest.md).

## Question

**Auto-move** (double-tap) sometimes does not send the card to a legal play. Owner asked for a tweak. Treat as a bug, not a rules change, until a play proves the spec is wrong.

Reproduce in `prototype/klondike-table-flutter`, then fix so a double-tap still prefers Foundation if legal, otherwise a legal Tableau pile ([What are the v1 rules for Undo, resume, tap, and drag?](../../klondike-solitaire-spec/issues/02-undo-resume-tap-drag.md)). Record the failing case in the answer.

## Done when

- A missed legal Auto-move can be shown (or the report cannot be reproduced, and that is written down).
- Double-tap matches the locked Auto-move rule on a phone-sized layout, or the spec is reopened with evidence.
