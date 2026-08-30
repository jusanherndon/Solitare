# How does Hint work, and where does it sit?

Type: grilling
Status: open

From [What bugs or changes turn up when the owner runs the prototype on Android?](../../klondike-solitaire-spec/issues/17-android-playtest.md).
Related: blocks [When is a Game a loss?](issues/03-loss-check.md) — a **loss** uses **Hint** (no active Hints) so that check stays easy.

## Question

Owner wants a **Hint** control on the table. Each tap plays an animation of a legal play and cycles to the next, without making the move.

This is not **Auto-move** (double-tap still plays). Decide: where Hint sits on the chrome, which plays are in the cycle (Tableau, Foundation, Stock draw), order, and what happens when no legal play remains. Do not implement until this is locked.

[When is a Game a loss?](issues/03-loss-check.md) already locked: an **active Hint** for that check is only a play that would leave an unseen **face-up** table (Waste, Foundations, face-up Tableau). This ticket still decides which plays Hint *shows* and how it animates, including repeats.

## Comments

### agent — 2026-08-30

From [When is a Game a loss?](issues/03-loss-check.md): **loss** is last resort and uses Hint as the first real check (no full-pass boolean — dropped on [How does draw-three difficulty work?](issues/04-draw-three.md)). Grill which plays are in the Hint cycle with that in mind — if Stock draw or recycle is always a Hint, the **loss** overlay never comes. Repeat for loss is face-up-only; how Hint *animates* a repeating play is this ticket.
