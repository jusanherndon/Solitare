# What Play icon, feature graphic, and screenshots does v1 use?

Type: prototype
Status: open
GitHub: #11 — https://github.com/jusanherndon/Solitare/issues/11

Moved from [Klondike Solitaire spec](../klondike-solitaire-spec/map.md) `12` (Play slice). App Store assets live on [What App Store icon and 6.9″ screenshots does v1 use?](../klondike-app-store/issues/04-app-store-listing-visuals.md). Shared prototype branch `prototype/listing-visuals`.

Depends on [What do Apple and Google require to list a free no-account phone game?](https://github.com/jusanherndon/Solitare/issues/5).
Look-and-play is locked on [How should the Klondike table look and play on a phone in portrait and landscape?](../klondike-solitaire-spec/issues/01-klondike-table-look-and-play.md).
The mark on the home screen / APK is [What launcher icon should the Android APK and iOS IPA use?](../klondike-solitaire-spec/issues/18-launcher-icon.md) — this ticket keeps the 512 listing icon (same art), feature graphic, and screenshots.

Parked — owner is not ready to lock listing visuals yet.

## Question

What Play listing visuals does v1 use: 512×512 store icon (32-bit PNG with alpha), 1024×500 feature graphic (JPEG or 24-bit PNG, no alpha), and at least two phone screenshots (preferably three at ≥1080×1920) showing the Game in use?

React to the Flutter table prototype (`prototype/klondike-table-flutter`). Screenshots must show Tableau, Foundations, Stock, and Waste in play — not a splash only. Phones only; no tablet/TV/Wear classes. Apple 6.9″ screenshot sizes are out of scope here.

## Comments

### jusanherndon — 2026-08-23T20:34:00Z

Listing visuals should come from the Flutter prototype after [#22](https://github.com/jusanherndon/Solitare/pull/22) won the comparison. Ticket still blocked by spec `01` until look-and-play is locked.

### cursor-agent — 2026-08-23T20:53:00Z

Started, then parked. Spec `01` is resolved so this ticket is unblocked. Three icon sketches and a feature-graphic sketch exist in the chat; not locked. No screenshots yet. Status returned to open.

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

Owner is not ready to lock or publish. Prototype stays on `prototype/listing-visuals` (not merged).

### cursor-agent — 2026-08-29T16:50:00Z

Moved onto [Post Klondike Solitaire to Google Play](../map.md) as the Play slice of spec `12`. App Store slice is `04` on the App Store map.
