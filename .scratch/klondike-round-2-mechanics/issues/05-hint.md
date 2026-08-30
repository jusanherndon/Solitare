# How does Hint work, and where does it sit?

Type: grilling
Status: resolved

From [What bugs or changes turn up when the owner runs the prototype on Android?](../../klondike-solitaire-spec/issues/17-android-playtest.md).
Related: blocks [When is a Game a loss?](issues/03-loss-check.md) — a **loss** uses **Hint** (no active Hints) so that check stays easy.

## Question

Owner wants a **Hint** control on the table. Each tap plays an animation of a legal play and cycles to the next, without making the move.

This is not **Auto-move** (double-tap still plays). Decide: where Hint sits on the chrome, which plays are in the cycle (Tableau, Foundation, Stock draw), order, and what happens when no legal play remains. Do not implement until this is locked.

[When is a Game a loss?](issues/03-loss-check.md) already locked: an **active Hint** for that check is only a play that would leave an unseen **face-up** table (Waste, Foundations, face-up Tableau). This ticket still decides which plays Hint *shows* and how it animates, including repeats.

## Comments

### agent — 2026-08-30

From [When is a Game a loss?](issues/03-loss-check.md): **loss** is last resort and uses Hint as the first real check (no full-pass boolean — dropped on [How does draw-three difficulty work?](issues/04-draw-three.md)). Grill which plays are in the Hint cycle with that in mind — if Stock draw or recycle is always a Hint, the **loss** overlay never comes. Repeat for loss is face-up-only; how Hint *animates* a repeating play is this ticket.

## Answer

**Hint** is a table-chrome control, not **Auto-move** (double-tap still plays). It sits on the table during a Game only — not in **Settings**, not on the start screen, not on the win or loss overlay. Top-right, left to right: **Hint**, **Undo**, **New Game**, **Start**.

Each tap animates a **ghost** of one legal play from a face-up playable card — Waste top, a Foundation top, or a face-up Tableau sequence — onto a legal Tableau pile or Foundation, then fades. Real cards stay put. The Game does not change; nothing is pushed onto **Undo**. Hint does not inspect face-down Tableau cards or the Stock. Draw and recycle are not Hints. In draw-three, only the Waste top is a source.

The cycle is rebuilt after a Tableau or Foundation play, **Auto-move**, **Undo**, a Stock draw, or a recycle, then restarted at the first **new** Hint (a play that would leave an unseen face-up table: Waste, Foundations, face-up Tableau). A Hint tap does not rebuild. **New** plays first, **repeats** last. Within each group: Foundation destinations before Tableau; sources Waste, then Foundations left to right, then Tableau left to right; on one Tableau pile, shortest legal run first. Each source-and-destination pair is one step. After the last step, wrap to the first new Hint (or the first repeat if there is no new one). Wrap does not rebuild.

Tapping **Hint** during the ghost **cancels** it and does not start the next Hint; the cycle still advances. Any table tap, drag, Stock, **Auto-move**, **Undo**, **New Game**, or **Start** also cancels. A successful play then rebuilds; a selection-only tap or a cancelled drag only clears the animation.

When the rebuilt list is empty, **Hint** stays in the cluster, **dimmed**, and the tap does nothing — no ghost, and it does not open **You lost.** [When is a Game a loss?](issues/03-loss-check.md) still treats only **new** plays as **active Hints**; repeats can still be shown, last.

Look of the four chrome buttons stays on [How should Undo, New Game, and Start look?](issues/01-table-chrome-look.md).
