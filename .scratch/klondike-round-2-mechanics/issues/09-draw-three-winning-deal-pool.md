# Fill and ship the draw-three winning-deal pool

Type: task
Status: resolved
Blocked by: 08

From [What is a winning deal, and how do you start one?](issues/02-winning-deal.md).
Depends on [How does draw-three difficulty work?](issues/04-draw-three.md) (resolved) and [Fill and ship the draw-one winning-deal pool](issues/08-draw-one-winning-deal-pool.md).

## Question

After draw-three play is locked, run the same bot under **draw-three** rules: random deal; keep if the bot reaches a **win** under those rules; otherwise skip. Ship about **100–200** openings (not much more) as a **separate** list from draw-one. A draw-one **win** does not go in this pool.

## Done when

- About 100–200 draw-three **winning deals** are in the repo, loadable by the app, distinct from the draw-one list.
- The answer points at the list and how it was produced.

## Answer

**150** draw-three seeds in `prototype/klondike-table-flutter/lib/game/winning_deal_pool.dart` (`drawThreeWinningDealSeeds`), distinct list from draw-one. Same hint-follow bot under **draw-three** rules; a draw-one **win** was not copied in. Filled by `dart run tool/fill_winning_deals.dart` (1361 deals tried).

## Comments

### agent — 2026-09-05

Regenerated after Hint cycle changes (same pass as draw-one). Dropped seeds 372, 447, 963, 1330; added 1403, 1412, 1419, 1429. Pool still 150. `dart run tool/fill_winning_deals.dart --three`.
