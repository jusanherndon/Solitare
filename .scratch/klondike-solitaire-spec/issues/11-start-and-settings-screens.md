# What start screen does the app open to, and what does Settings contain?

Type: grilling
Status: open

Depends on [What are the v1 rules for Undo, resume, tap, and drag?](issues/02-undo-resume-tap-drag.md).
Related: [What else does the About screen show besides the Privacy Policy link?](issues/09-about-screen-contents.md).

## Question

v1 opens on a dedicated **start screen**, not the Klondike table. There is also a dedicated **Settings** screen.

Decide for the spec:

- What the start screen shows and which actions it offers (New Game, Resume, Settings, About, and anything else for v1).
- How launch + Resume fit together. Ticket `02` already locked that the next launch restores an unfinished Game (and its Undo stack) onto the table. With a start screen, does launch land on that screen with Resume as a choice, or does an unfinished Game still skip the start screen?
- What Settings contains for v1, and how you reach it from the start screen and from the table. Keep About’s contents on `09` — this ticket only decides that Settings exists and what *it* holds.
- What stays on the table chrome (today: Undo and New Game, locked on `01`) once these screens exist.

Phones only, English only. Do not pull in out-of-scope items (hints, score, timer, statistics, daily challenges, themes, sound, draw-three) unless grilling explicitly brings one in. Plan, don’t implement.
