# When no legal move remains, what ending screen does v1 show?

Type: grilling
Status: resolved
Blocked by: 11

Depends on [What start screen does the app open to, and what does Settings contain?](issues/11-start-and-settings-screens.md).
Related: [What are the v1 rules for Undo, resume, tap, and drag?](issues/02-undo-resume-tap-drag.md).

## Question

After each successful move, draw, Stock recycle, or auto-move, v1 **auto-checks whether any legal play remains**. If none does, the Game leaves the table for a dedicated **ending screen**. That screen has buttons to go to the **start screen** (locked on `11`) and to start a **New Game** (a fresh deal).

Decide for the spec:

- What counts as “no legal play.” Ticket `02` already locked tap, drag, draw-one, unlimited Undo, and auto-move on double-tap only. Computer-Klondike already locked unlimited Stock recycle. Does “no move” mean no Tableau or Foundation play *and* nothing left to draw or recycle — or something stricter (a cycle that cannot make progress)?
- How this ending relates to a **win**. Ticket `02` already says a won Game does not Resume onto the finished table. Same ending screen, a different one, or win stays unspecified until later?
- What the ending screen shows (copy, whether the table is still visible behind it) and which actions it offers. Owner intent: at least **start screen** and **New Game**. Anything else for v1 (Undo from here)?
- How Resume treats a stuck Game: next launch lands on this ending screen, on the start screen, or back on the table?

Phones only, English only. Do not pull in hints, score, timer, or other out-of-scope items. Plan, don’t implement. Wait for `11` to lock the start screen (names, how you reach it) before resolving the buttons that go there.

## Answer

After each successful move, draw, Stock recycle, or auto-move, v1 checks for **no legal play**: no Tableau move, no Foundation move, Stock empty, Waste empty. Do not detect futile Stock cycles in v1.

That shape is a **win** when all 52 cards sit on the Foundations, otherwise a **loss**. Two different overlay screens, not one screen with two headlines. Wins should feel cool; losses should feel bad. Look and animations are the visual pass ([How should the start, About, win, and loss screens look on a phone?](issues/15-chrome-screens-look.md)).

Both overlays leave the **table visible behind** them and do not fully cover it, so animations can show through.

**Win screen.** Headline **You won!** Actions: **Start** (start screen) and **New Game**. No Undo.

**Loss screen.** Headline **You lost.** Actions: **Start**, **New Game**, and **Undo** (back to the table, last move reversed). Undo is the only way back into that Game.

A win or a loss **ends the Game**. **Resume** does not apply; the start screen hides Resume. **Start** goes to the start screen. **New Game** deals fresh with no confirm (nothing unfinished to discard). No score, timer, or other extra copy.
