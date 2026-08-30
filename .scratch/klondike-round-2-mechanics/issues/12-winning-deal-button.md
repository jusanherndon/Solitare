# Implement the Winning deal button

Type: task
Status: resolved
Blocked by: 08, 09, 11

From [What is a winning deal, and how do you start one?](issues/02-winning-deal.md). Pools: [Fill and ship the draw-one winning-deal pool](issues/08-draw-one-winning-deal-pool.md), [Fill and ship the draw-three winning-deal pool](issues/09-draw-three-winning-deal-pool.md). Type in **Settings**: [Implement draw-three in the Flutter prototype](issues/11-draw-three.md).

## Question

Wire **Winning deal** in `prototype/klondike-table-flutter`: a button immediately next to **New Game** on the start screen, win overlay, and loss overlay; hidden on the table. Same confirm as **New Game**. After confirm (or with no confirm), deal from the pool for the type in **Settings** and start a new Undo stack. Cannot be undone back into the previous Game. Do not reopen the grilling. Do not fill the pools here.

## Done when

- **Winning deal** is playable on start / win / loss, picks from the matching pool, and confirms only when an unfinished Game would be discarded.
- **New Game** is still a random shuffle.

## Answer

**Winning deal** sits next to **New Game** on the start screen, win overlay, and loss overlay (`variant_a.dart`). Hidden on the table and on Finish. `pickWinningDealSeed` in `lib/game/winning_deal.dart` picks a random seed from the Settings draw-type pool. Confirm matches **New Game** (only while Resume would be discarded). Fresh Undo stack; cannot undo into the previous Game. **New Game** is still a timestamp shuffle.
