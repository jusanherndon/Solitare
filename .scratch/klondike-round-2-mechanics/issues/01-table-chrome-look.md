# How should Undo, New Game, and Start look?

Type: prototype
Status: resolved

From [What bugs or changes turn up when the owner runs the prototype on Android?](../../klondike-solitaire-spec/issues/17-android-playtest.md).

## Question

Table chrome **Undo**, **New Game**, and **Start** look too simplistic. How should they look on a phone (portrait and landscape)?

Owner does not yet know the replacement. Produce a cheap throwaway prototype to react to — not a polish pass on the current felt pills. Do not drop or rename the actions. The cluster is now **Hint**, **Undo**, **New Game**, **Start** ([How does Hint work, and where does it sit?](issues/05-hint.md)); include **Hint** (dimmed empty state counts). Do not move Hint off the table ([What start screen does the app open to, and what does Settings contain?](../../klondike-solitaire-spec/issues/11-start-and-settings-screens.md)).

The four table-chrome buttons are also too small to tap and read. A playtester who uses bifocals wants them bigger, and wants the rank and suit text on the cards bigger too. The prototype must be readable at phone distance with bifocals — not only a new look at the same small size.

## Comments

### jusanherndon — 2026-08-30T20:36:00Z

**Hint**, **Undo**, **New Game**, and **Start** are too small. Playtester uses bifocals and wants bigger buttons. Rank and suit text on the cards should be bigger too.

### agent — 2026-08-30T21:15:00Z

Five table-chrome looks on the live Flutter table (not a polish of the felt pills). Yellow bar cycles them; `←` / `→` also work. Start a Game to compare. Rank/suit type is larger on every look. Hint still dims when empty.

- **A — Billboard strip** — full-width equal cells at the top
- **B — Thumb dock** — four large tiles along the bottom
- **C — Split play / leave** — Hint and Undo as gold capsules on the left; New Game and Start as underlined links on the right
- **D — 2×2 island** — compact keypad (bottom in portrait, right in landscape)
- **E — Hint-first stack** — Hint as a wide gold bar, the other three in a row under it

Run: `cd prototype/klondike-table-flutter && flutter run` (device) or `flutter run -d linux`. The yellow bar is prototype chrome, not product. Ticket stays open until a look is picked.

## Answer

**B — Thumb dock.** Table chrome sits at the **bottom**: four large gold-bordered tiles, **Hint**, **Undo**, **New Game**, **Start**. Thumbs reach them more easily than a top bar. Rank and suit type on the cards is larger than the first table prototype. Hint still dims when empty. Actions keep those names and stay on the table.

Rejected: **A — Billboard strip**, **C — Split play / leave**, **D — 2×2 island**, **E — Hint-first stack**, and the old top-right felt pills.

Folded into `prototype/klondike-table-flutter` (`_ThumbDock` in `lib/ui/klondike_table.dart`). Spec updated. The five looks were not parked on a throwaway branch (other uncommitted work in the tree).
