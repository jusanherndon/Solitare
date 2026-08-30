# Implement Hint on the table

Type: task
Status: open
Blocked by: 11

From [How does Hint work, and where does it sit?](issues/05-hint.md). Spec: [spec.md](../../klondike-solitaire-spec/spec.md). Waits on [Implement draw-three in the Flutter prototype](issues/11-draw-three.md) so both draw types use the same cycle.

## Question

Put **Hint** in `prototype/klondike-table-flutter` as locked: table chrome **Hint**, **Undo**, **New Game**, **Start**; ghost of one legal face-up play; new then repeats; dim when empty; wrap; cancel without locking the player in. Not **Auto-move**. Do not reopen the grilling. The **loss** check stays on [Implement the last-resort loss check](issues/14-loss-check.md). Chrome look stays on [How should Undo, New Game, and Start look?](issues/01-table-chrome-look.md) — current felt pills are fine until that prototype lands.

## Done when

- **Hint** is on the table and matches the spec for draw-one and draw-three (Waste top only).
- Empty, wrap, rebuild-after-play, and cancel-during-ghost behaviors are covered by tests or a written playthrough in the answer.
