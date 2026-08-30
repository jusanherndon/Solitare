# How does Hint work, and where does it sit?

Type: grilling
Status: open

From [What bugs or changes turn up when the owner runs the prototype on Android?](../../klondike-solitaire-spec/issues/17-android-playtest.md).
Related: [When is a Game a loss?](issues/03-loss-check.md) may treat “no active Hints” as part of a loss.

## Question

Owner wants a **Hint** control on the table. Each tap plays an animation of a legal play and cycles to the next, without making the move.

This is not **Auto-move** (double-tap still plays). Decide: where Hint sits on the chrome, which plays are in the cycle (Tableau, Foundation, Stock draw), order, and what happens when no legal play remains. Do not implement until this is locked.
