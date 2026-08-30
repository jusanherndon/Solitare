# When all cards are face-up and a win is possible, how does the Game finish onto the Foundations?

Type: grilling
Status: resolved

From [What bugs or changes turn up when the owner runs the prototype on Android?](../../klondike-solitaire-spec/issues/17-android-playtest.md).

## Question

Once every card is face-up and a **win** is possible, owner wants the Game to finish itself onto the Foundations (cards move without further taps). Optional. This is not **Auto-move** (double-tap still one card).

Decide: always on vs a toggle, what “win is possible” means (any remaining Foundation plays vs a full forced finish), and whether the player can interrupt. Do not implement until this is locked.

## Answer

**Finish** is a mid-Game overlay, not **Auto-move**, not **Hint**, not a Settings toggle, not table chrome.

**Gate.** Stock empty, every card face-up, and a sequence of legal Foundation plays from the Waste top and Tableau tops (peeling as they go) reaches a **win**. Draw-three still only the Waste top. If the gate is false, no overlay — [When is a Game a loss?](issues/03-loss-check.md) still decides. Empty Stock plus all face-up is not itself a **loss**.

**When.** After each successful Tableau or Foundation play, draw, Stock recycle, **Auto-move**, or **Undo** — same checkpoints as win/loss. **Win** first. Then show **Finish** only while the gate is true and they have not tapped **Continue** this Game. A **Hint** tap does not open it.

**Look.** Same family as the win overlay: table visible, dimmed, still in color (not greyscale). Headline **You can finish.** (wording may change in a look pass). Filled **Finish**, then **Continue**. No **Start**, **New Game**, or **Winning deal**.

**Finish** (the action). Real cards move onto the Foundations, one at a time: Waste top, then Tableau left to right; Foundations left to right. Repeat until a **win**, then the win overlay. Cannot stop mid-flight. Cannot **Undo** that sequence. **Hint** and the table stay blocked while it runs.

**Continue.** Back to the table. Hides **Finish** for the rest of this Game, even if the gate stays true and even after **Undo**. Manual win from there.

**Resume.** Restore the overlay if it was up, or the opted-out flag if they already chose **Continue**. Do not restore an in-progress Finish animation.
