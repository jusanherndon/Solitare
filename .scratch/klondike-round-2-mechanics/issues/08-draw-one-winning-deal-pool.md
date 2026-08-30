# Fill and ship the draw-one winning-deal pool

Type: task
Status: open

From [What is a winning deal, and how do you start one?](issues/02-winning-deal.md).
Related: [Fill and ship the draw-three winning-deal pool](issues/09-draw-three-winning-deal-pool.md).

## Question

Build a bot and fill the **draw-one** pool ahead of time: start a random deal; if the bot reaches a **win** under current draw-one play (unlimited Stock recycle, legal Tableau subsequences), keep that opening; otherwise skip. Ship about **100–200** openings (not much more) in the app so **Winning deal** can pick from them.

A bot loss is a skip, not a proof the deal is unwinnable. Do not fill the draw-three pool here ([Fill and ship the draw-three winning-deal pool](issues/09-draw-three-winning-deal-pool.md)). Do not wire the **Winning deal** button unless that is the cheapest way to prove the list loads; this ticket is the pool.

## Done when

- A bot can play draw-one to a **win** (keep) or a skip.
- About 100–200 draw-one **winning deals** are in the repo, loadable by the app.
- The answer points at the list (path or asset) and how it was produced.
