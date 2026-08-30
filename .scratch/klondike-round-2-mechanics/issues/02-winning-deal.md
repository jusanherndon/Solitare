# What is a winning deal, and how do you start one?

Type: grilling
Status: resolved

From [What bugs or changes turn up when the owner runs the prototype on Android?](../../klondike-solitaire-spec/issues/17-android-playtest.md).
Related: [How does draw-three difficulty work?](issues/04-draw-three.md), [Fill and ship the draw-one winning-deal pool](issues/08-draw-one-winning-deal-pool.md), [Fill and ship the draw-three winning-deal pool](issues/09-draw-three-winning-deal-pool.md), [Implement the Winning deal button](issues/12-winning-deal-button.md).

## Question

Owner wants a deal where a **win** is possible — cards aligned so the Game can be finished.

Decide for the spec: what “winning deal” means (guaranteed win vs likely vs one known-solvable seed), whether it is always on, a New Game variant, or an option, and how you start it.

## Answer

A **winning deal** is an opening layout from which at least one sequence of legal plays reaches a **win** under the draw type of the Game being started (draw-one or draw-three). The player can still lose. A layout the bot finished draw-one is not a **winning deal** for draw-three, and the other way around. Draw-one remains; draw-three is a second type, not a replacement. How draw-three plays (Waste fan, recycle, how the player picks it) stays on [How does draw-three difficulty work?](issues/04-draw-three.md).

**New Game** stays a random shuffle (can be unwinnable). **Winning deal** is a separate button, labeled **Winning deal**, immediately next to **New Game** on the **start screen**, the **win** overlay, and the **loss** overlay. It is hidden while a Game is on the table. Table chrome stays **Undo**, **New Game**, **Start**.

**Confirm** matches **New Game**: warn only when an unfinished Game would be discarded (**Resume** showing on the start screen). After a win or a loss, no confirm. A confirmed **Winning deal** deals from the matching pool and starts a fresh Undo stack. **Winning deal** cannot be undone back into the previous Game.

The app ships **two pools**, about **100–200** openings **each** (not much more). We fill them ahead of time with a bot: random deal; if the bot reaches a **win** under that draw type, keep it; otherwise skip. A bot loss does not prove the deal is unwinnable; it stays out of the pool. Each tap of **Winning deal** picks at random from the pool for the draw type being started; the same opening may come up again. The phone does not run the bot.

Pools: [Fill and ship the draw-one winning-deal pool](issues/08-draw-one-winning-deal-pool.md), [Fill and ship the draw-three winning-deal pool](issues/09-draw-three-winning-deal-pool.md).
