# What do Hint, Loss, and Finish do wrong across many Games?

Type: research
Status: resolved

The owner wants those three systems to feel better: **You lost.**, **Hint**, **You can finish.** Capture problems a bot can hit by playing a lot of Games — Hint loops, how few cards need to be visible before a Finish-style win is forced, and anything else.

## Answer

A Hint-follow probe (`src/klondike-table-flutter/tool/probe_playthroughs.dart`) played 2000 draw-one and 2000 draw-three deals. Full write-up: [loss-hint-finish-playthroughs.md](../../../docs/research/loss-hint-finish-playthroughs.md).

**Hint.** Loop-stop dims the button while an **active Hint** still blocks a **loss** (about half of draw-one Games). 23 draw-one Games were stuck: empty Stock/Waste, dimmed Hint, no overlay (seed 17). 49 draw-one Games looped a seen table (seed 8). Draw-three mostly recycles forever (1685 / 2000) because a buried card peeks as playable but never becomes Waste top.

**Loss.** Almost every **You lost.** still leaves a legal drag Hint has filtered (break a built cascade, King-empty hop, Foundation Ace back down). Seed 1 can still drop 5♥ onto 6♠ when the overlay fires. Spec prefers a missed overlay; this is the opposite.

**Finish.** Today’s gate needs all 52 face-up. The same Foundation-only peel already wins with **6 still face-down / 46 face-up** (seed 21). 19% of draw-one Hint-follow wins could have seen **You can finish.** earlier. A full solver knowing the deal from 7 face-up cards is **winning deal**, not Finish.

Replay: `dart run tool/probe_playthroughs.dart --seed 17` (from `src/klondike-table-flutter`).

## Comments
