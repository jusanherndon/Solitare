# When is a Game a loss?

Type: grilling
Status: open

From [What bugs or changes turn up when the owner runs the prototype on Android?](../../klondike-solitaire-spec/issues/17-android-playtest.md).
Related: [How does draw-three difficulty work?](issues/04-draw-three.md).

Reopens the cheap check on [When no legal move remains, what ending screen does v1 show?](../../klondike-solitaire-spec/issues/14-no-moves-ending-screen.md) (Stock empty, Waste empty, no Tableau/Foundation play).

## Question

Owner wants a more comprehensive **loss** check: only face-up / visible cards plus the **Stock** — if none of those have a legal Tableau or Foundation play and nothing is left to draw from the Stock, that is a loss. Do not wait until Stock and Waste are both empty.

The check must **not** run until the Stock has been gone through completely (every card drawn at least once / one full pass). Track that with a boolean on the Game; the comprehensive check is off while it is false.

Decide the exact “full pass” rule, what counts as a legal play among face-up cards and the Stock, and how Undo / recycle interact with the boolean. Draw-three’s pass may differ; lock that on [How does draw-three difficulty work?](issues/04-draw-three.md) or call it out here if this ticket lands first.
