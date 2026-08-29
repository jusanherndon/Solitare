# What start screen does the app open to, and what does Settings contain?

Type: grilling
Status: resolved

Depends on [What are the v1 rules for Undo, resume, tap, and drag?](issues/02-undo-resume-tap-drag.md).
Related: [What else does the About screen show besides the Privacy Policy link?](issues/09-about-screen-contents.md).
Blocks [When no legal move remains, what ending screen does v1 show?](issues/14-no-moves-ending-screen.md).

## Question

v1 opens on a dedicated **start screen**, not the Klondike table. There is also a dedicated **Settings** screen.

Decide for the spec:

- What the start screen shows and which actions it offers (New Game, Resume, Settings, About, and anything else for v1).
- How launch + Resume fit together. Ticket `02` already locked that the next launch restores an unfinished Game (and its Undo stack) onto the table. With a start screen, does launch land on that screen with Resume as a choice, or does an unfinished Game still skip the start screen?
- What Settings contains for v1, and how you reach it from the start screen and from the table. Keep About’s contents on `09` — this ticket only decides that Settings exists and what *it* holds.
- What stays on the table chrome (today: Undo and New Game, locked on `01`) once these screens exist.

Phones only, English only. Do not pull in out-of-scope items (hints, score, timer, statistics, daily challenges, themes, sound, draw-three) unless grilling explicitly brings one in. Plan, don’t implement.

## Answer

v1 always opens on a dedicated **start screen**. An unfinished Game does not skip it. **Resume** is a start-screen action, not an automatic launch. Ticket `02` still describes what Resume *does* (restore the table and Undo stack, not selection or an in-progress drag).

**Start screen.** Title **Klondike Solitaire**. Actions: **New Game**, **Resume**, **About**. Resume is **hidden** unless an unfinished Game exists (first launch and after a win). About’s contents stay on [What else does the About screen show besides the Privacy Policy link?](issues/09-about-screen-contents.md); back from About returns to the start screen.

**Settings.** None in v1. No Settings screen and no Settings button. A later effort can add it when there is a real option to put in it.

**Table chrome.** **Undo**, **New Game**, and **Start**. **Start** goes to the start screen with no confirm; the unfinished Game and Undo stack stay. Resume is how they return.

**New Game.** Confirms only when an unfinished Game would be discarded — from the table, or from the start screen while Resume is showing. No confirm on first launch or after a win. A confirmed New Game deals fresh and starts a new Undo stack (`02`: New Game cannot be undone).
