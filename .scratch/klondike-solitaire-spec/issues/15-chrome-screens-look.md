# How should the start, About, win, and loss screens look on a phone?

Type: prototype
Status: resolved

Depends on [What else does the About screen show besides the Privacy Policy link?](issues/09-about-screen-contents.md), [What start screen does the app open to, and what does Settings contain?](issues/11-start-and-settings-screens.md), and [When no legal move remains, what ending screen does v1 show?](issues/14-no-moves-ending-screen.md).

## Question

How should the start screen, About, win screen, and loss screen look on a phone in portrait and landscape?

Contents and behavior are already locked on `09`, `11`, and `14`. This ticket is look and feel: layout, type, how the win overlay feels cool and the loss overlay feels bad, how much of the table shows around those overlays, and what animations play through them. Start screen and About have no table behind them.

Produce a cheap throwaway prototype the owner can react to. Extend `prototype/klondike-table-flutter` (Layout A is already the table source). This is not the product app.

Phones only, English only. No Settings. Do not reopen play rules, Resume, or button sets.

## Answer

v1 uses **A — Felt banner**. Same felt green (`#1F6B45`) and chrome-button language as the table. Start and About have no table behind them. Win and loss are overlays on the live table, not replacement screens.

**Start.** Cream title **Klondike Solitaire**. Stacked rounded chrome buttons: **New Game** (filled / primary), **Resume** (only while an unfinished Game exists), **About**. Portrait: title and buttons stacked in the middle of the felt. Landscape: title on the left, the same button stack on the right.

**About.** Felt, cream body type, gold underlined tappable rows (Support, Source, Privacy Policy, Licenses). A **Start** chrome button top-left returns to the start screen. Licenses is Flutter’s standard list, reached from this screen.

**Win overlay.** Table stays visible around a centered dark rounded card with a gold border. Headline **You won!** in gold. Actions: **Start**, then filled **New Game**. Dim the table (~40%). Gold sparkles rise through the open felt around the card.

**Loss overlay.** Table stays visible but goes greyscale and dims harder (~50%). A darker card sits slightly below center, red-tinted border, headline **You lost.** in muted grey. Grey dust falls. Actions: filled **Undo** first, then **Start**, then **New Game**.

**Table chrome** (from `11`): **Undo**, **New Game**, **Start** — same chrome buttons, top-right. The New Game confirm from `11` uses this same felt card + chrome-button language.

Rejected: **B — Letterbox** (cinematic bars, huge type) and **C — Bottom sheet** (card fan + sheet). Primary source: `prototype/klondike-table-flutter` on branch `prototype/chrome-screens-look` (yellow bars are prototype chrome, not product).
