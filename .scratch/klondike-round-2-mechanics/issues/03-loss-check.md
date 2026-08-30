# When is a Game a loss?

Type: grilling
Status: resolved
Blocked by: 05

From [What bugs or changes turn up when the owner runs the prototype on Android?](../../klondike-solitaire-spec/issues/17-android-playtest.md).
Related: [How does draw-three difficulty work?](issues/04-draw-three.md). **Loss** uses **Hint**; [How does Hint work, and where does it sit?](issues/05-hint.md) is resolved (active Hint = **new** play only). Implementation: [Implement the last-resort loss check](issues/14-loss-check.md).

Reopens the cheap check on [When no legal move remains, what ending screen does v1 show?](../../klondike-solitaire-spec/issues/14-no-moves-ending-screen.md) (Stock empty, Waste empty, no Tableau/Foundation play).

## Question

Owner wants a more comprehensive **loss** check: only face-up / visible cards plus the **Stock** — if none of those have a legal Tableau or Foundation play and nothing is left to draw from the Stock, that is a loss. Do not wait until Stock and Waste are both empty.

The check must **not** run until the Stock has been gone through completely (every card drawn at least once / one full pass). Track that with a boolean on the Game; the comprehensive check is off while it is false.

Owner’s later candidate: a **loss** when all of these hold together:

1. **No active Hints** — Hint has nothing left to show ([How does Hint work, and where does it sit?](issues/05-hint.md)).
2. **No legal play in the drawable cards after a full Stock cycle** — after that pass, nothing left to draw or play from Stock / Waste.
3. **No move repeats** — cycling the same play (or returning to a seen table) does not count as a remaining legal play.

Grill the exact “full pass” rule, what “active Hint” and “repeat” mean, what counts as a legal play among face-up cards and the Stock, and how Undo / recycle interact with the boolean. Draw-three’s pass may differ; lock that on [How does draw-three difficulty work?](issues/04-draw-three.md) or call it out here if this ticket lands first.

## Comments

### jusanherndon — 2026-08-30

A potential way to make the loss check is a combination of: no active hints, no legal moves in the drawable deck after you have cycled through the deck, and no move repeats.

### agent — 2026-08-30

Working rule (owner: keep for now; prefer a missed overlay over a premature **You lost.**):

A **loss** is last resort. The cheap Stock-empty and Waste-empty check is not the only path, but the comprehensive check must not fire early.

Four parts, all required:

1. One full Stock pass has happened (boolean on the Game; check off while false). This boolean is free — test it before any search.
2. **No active Hints** — first real check, so we skip the rest when Hint still has something to show ([How does Hint work, and where does it sit?](issues/05-hint.md)).
3. No card in Stock or Waste that could legally play onto the **current** Tableau or a Foundation.
4. No non-repeating play.

Draw-three’s “full pass” stays on [How does draw-three difficulty work?](issues/04-draw-three.md).

**Repeat (locked):** a table you have already had in this Game, comparing **only face-up cards** (Waste, Foundations, face-up Tableau). Do not look at Stock or face-down Tableau cards. Recycle after the full pass is a repeat unless clause 3 says a buried Stock/Waste card can play on the current table. For Hint-first, an “active Hint” is only a play that would leave an unseen *face-up* table. **Undo** should drop tables that only existed after the undone play. How Hint animates repeats stays on [How does Hint work, and where does it sit?](issues/05-hint.md).

**Full pass (locked, draw-one):** the boolean becomes true the first time every card that started in the Stock (24 after the deal) has been drawn onto the Waste at least once — the draw that first empties the Stock, even if some Waste cards already went to the table. Recycle does not turn it off. The boolean lives on the Game and the Undo stack: Undo of the draw that flipped it turns it false; Redo turns it true. Undo from a **loss** overlay restores it with that table. Draw-three’s pass stays on [How does draw-three difficulty work?](issues/04-draw-three.md).

**When to check (locked):** after each successful move, draw, Stock recycle, or Auto-move — same as today. The draw that flips the boolean is eligible immediately. While the boolean is false, skip the comprehensive check (the deal is never a **loss** this way). A **win** still wins first. Persist the boolean with the unfinished Game so Resume restores it with the Undo stack. Overlay actions stay **Undo**, **Start**, **New Game**, **Winning deal**.

### agent — 2026-08-30

Owner confirmed that comment as the shared understanding of everything this ticket can lock without Hint. Status returns to open; still blocked by [How does Hint work, and where does it sit?](issues/05-hint.md). Do not close, do not patch `CONTEXT.md` **Loss**, until Hint locks which plays count as an **active Hint**. Draw-three’s pass is owned by [How does draw-three difficulty work?](issues/04-draw-three.md).

### agent — 2026-08-30

Amended on [How does draw-three difficulty work?](issues/04-draw-three.md): **drop the full-pass boolean** for both draw types. “Stock emptied once” is the wrong gate for draw-three and redundant for draw-one (clause 3 already peeks Stock/Waste). Same last-resort check for both:

1. **No active Hints** — first real check.
2. No card in Stock or Waste that could legally play onto the **current** Tableau or a Foundation (including a buried draw-three card that is not the Waste top).
3. No play to an unseen **face-up** table.

**When to check** is unchanged except there is no boolean to persist or skip on: after each successful move, draw, Stock recycle, or Auto-move. **Win** first. Overlay actions unchanged. Repeat / Undo-of-seen-tables unchanged. Recycle is a repeat unless clause 2 says a buried Stock/Waste card can play now.

### agent — 2026-08-30

[How does Hint work, and where does it sit?](issues/05-hint.md) is resolved. An **active Hint** for this check is only a **new** play (unseen face-up table). Hint still **shows** repeats, last, and dims when there is no legal face-up play at all; that empty chrome state is not by itself a **loss**. This ticket is unblocked. Do not patch `CONTEXT.md` **Loss** until this ticket closes.

## Answer

A **loss** is last resort. Prefer a missed overlay over a premature **You lost.** No full-pass boolean (dropped for both draw types on [How does draw-three difficulty work?](issues/04-draw-three.md)).

A Game is a **loss** when it is not a **win** and both hold:

1. **No active Hints** — no legal face-up play that would leave an unseen face-up table (Waste, Foundations, face-up Tableau). Repeats do not block a loss. Dimmed **Hint** is not itself a loss. Peeking face-down Tableau or the Stock is not an active Hint ([How does Hint work, and where does it sit?](issues/05-hint.md)).
2. **No Stock or Waste card** that could legally play onto the **current** Tableau or a Foundation — including face-down Stock and buried draw-three cards that are not the Waste top. Recycle is a repeat unless this clause says a buried card can play now.

**Repeat.** A table already seen this Game, comparing only face-up cards. **Undo** drops tables that only existed after the undone play. Seen tables persist with the unfinished Game and the Undo stack so **Resume** restores them.

**When to check.** After each successful Tableau or Foundation play, draw, Stock recycle, **Auto-move**, or **Undo**. **Win** first. A Hint tap does not trigger the check.

**Overlay.** Unchanged: **You lost.** Actions **Undo**, **Start**, **New Game**, **Winning deal**. Undo is the only way back into that Game.
