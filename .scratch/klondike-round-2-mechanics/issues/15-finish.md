# Implement the Finish overlay

Type: task
Status: open
Blocked by: 11

From [When all cards are face-up and a win is possible, how does the Game finish onto the Foundations?](issues/07-win-finish.md). Spec: [spec.md](../../klondike-solitaire-spec/spec.md). Waits on [Implement draw-three in the Flutter prototype](issues/11-draw-three.md) so the gate uses the Waste top in both types.

## Question

Put **Finish** in `prototype/klondike-table-flutter` as locked: overlay **You can finish.** when the gate holds; filled **Finish** then **Continue**; real cards to the Foundations, then **You won!**; **Continue** hides it for the rest of the Game. Not **Auto-move**, not **Hint**, not a Settings toggle. Do not reopen the grilling. Headline wording may change later; do not block on a look pass.

## Done when

- The overlay appears only when the gate is true, runs **Finish** through to the win overlay with no **Undo**, and **Continue** lets a manual win.
- **Resume** restores the overlay or the opted-out flag.
- Tests cover the gate (including a face-up table that still needs Tableau play — no overlay).
