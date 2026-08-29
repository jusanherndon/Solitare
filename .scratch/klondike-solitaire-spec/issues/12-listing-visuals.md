# What icon, feature graphic, and screenshots does v1 use?

Type: prototype
Status: open
GitHub: #11 — https://github.com/jusanherndon/Solitare/issues/11
Blocked by: 01

Depends on [What do Apple and Google require to list a free no-account phone game?](https://github.com/jusanherndon/Solitare/issues/5).

Was local `04`. Parked at the end of the map — owner is not ready to lock listing visuals yet. Prototype work lives on branch `prototype/listing-visuals`.

## Question

What listing visuals does v1 use: app icon (Apple 1024, Play 512), Play feature graphic (1024×500), and phone screenshots (Apple 6.9″ set showing the Game in use; Play at least two, preferably three)?

React to the Flutter table prototype (`prototype/klondike-table-flutter`; see `01`). Screenshots must show Tableau, Foundations, Stock, and Waste in play — not a splash only. Phones only; no iPad/tablet screenshot classes. Do not screenshot the closed Expo table ([#17](https://github.com/jusanherndon/Solitare/pull/17)).

## Comments

### jusanherndon — 2026-08-23T20:34:00Z

Listing visuals should come from the Flutter prototype after [#22](https://github.com/jusanherndon/Solitare/pull/22) won the comparison (nicer to build, faster, smaller APK; Expo closed as worse/buggier). Ticket still blocked by `01` until look-and-play is locked.

### cursor-agent — 2026-08-23T20:53:00Z

Started, then parked. `01` is resolved so this ticket is unblocked. Three icon sketches and a feature-graphic sketch exist in the chat; not locked. No screenshots yet. Status returned to open.

### cursor-agent — 2026-08-29T16:12:00Z

Throwaway listing-visuals prototype on branch `prototype/listing-visuals`.

**Run:** from `prototype/listing-visuals`, `python3 -m http.server 8082` → http://localhost:8082/?variant=A
Bottom bar / ← → cycles **A Ace on felt**, **B Corner crop**, **C Fan**. Same three Flutter-table shots on every family.

| Family | Icon | Play feature graphic (1024×500) |
| --- | --- | --- |
| A | Ace of spades, slight tilt, on felt | Landscape table crop + name |
| B | Extreme A♠ corner crop | Mark + listing copy, no table photo |
| C | Fan of three (navy back, Q♥, K♠) | Cards only; tiny name |

**Screenshots** (placeholder cards, not Fomin/Atlas): `shots/portrait-play.png` (mid-Game: Waste + two Foundation Aces), `shots/landscape-play.png` (same Game, rotated), `shots/portrait-deal.png` (opening deal — drop if it reads as splash). Recapture: `cd prototype/klondike-table-flutter && flutter test test/listing_shots_test.dart`.

React: steal bits, reject a family, keep/drop the opening-deal shot. Not shipped art; no “kids.”

### cursor-agent — 2026-08-29T16:16:00Z

Owner is not ready to lock or publish. Unclaimed and moved from `04` to `12` so the frontier can take earlier tickets. Prototype stays on `prototype/listing-visuals` (not merged).
