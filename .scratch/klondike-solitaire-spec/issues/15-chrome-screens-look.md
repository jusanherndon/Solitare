# How should the start, About, win, and loss screens look on a phone?

Type: prototype
Status: open

Depends on [What else does the About screen show besides the Privacy Policy link?](issues/09-about-screen-contents.md), [What start screen does the app open to, and what does Settings contain?](issues/11-start-and-settings-screens.md), and [When no legal move remains, what ending screen does v1 show?](issues/14-no-moves-ending-screen.md).

## Question

How should the start screen, About, win screen, and loss screen look on a phone in portrait and landscape?

Contents and behavior are already locked on `09`, `11`, and `14`. This ticket is look and feel: layout, type, how the win overlay feels cool and the loss overlay feels bad, how much of the table shows around those overlays, and what animations play through them. Start screen and About have no table behind them.

Produce a cheap throwaway prototype the owner can react to. Extend `prototype/klondike-table-flutter` (Layout A is already the table source). This is not the product app.

Phones only, English only. No Settings. Do not reopen play rules, Resume, or button sets.
