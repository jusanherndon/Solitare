# Implement the last-resort loss check

Type: task
Status: resolved
Blocked by: 13

From [When is a Game a loss?](issues/03-loss-check.md). Spec: [spec.md](../../klondike-solitaire-spec/spec.md). Waits on [Implement Hint on the table](issues/13-hint.md) because an **active Hint** is a **new** play.

## Question

Replace the cheap Stock-empty / Waste-empty **loss** check in `prototype/klondike-table-flutter` with the locked last-resort check: not a **win**, no active Hints, and no Stock or Waste card (including buried draw-three and face-down Stock) that can play on the current Tableau or a Foundation. Repeats do not block a loss. Dimmed **Hint** is not itself a loss. Persist seen face-up tables with **Undo** and **Resume**. Overlay actions unchanged. Do not reopen the grilling.

## Done when

- A Game can lose with cards still in Stock or Waste when the spec says it should, and does not lose while an active Hint remains.
- **Undo** from **You lost.** still returns to the table. Seen tables restore on **Resume**.
- Tests cover the new check (including draw-three buried cards).

## Answer

Last-resort `isLoss` in `lib/game/loss.dart`: not a win, no **active Hint** (new face-up play only), and no Stock or Waste card that can play on the current table — including buried draw-three and face-down Stock. Repeats do not block. Seen face-up tables sit on each Undo snapshot and round-trip in Resume. Tests: `test/loss_test.dart`.

## Comments

