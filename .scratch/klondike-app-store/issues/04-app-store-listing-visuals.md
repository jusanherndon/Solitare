# What App Store icon and 6.9″ screenshots does v1 use?

Type: prototype
Status: open
GitHub: #11 — https://github.com/jusanherndon/Solitare/issues/11

Moved from [Klondike Solitaire spec](../klondike-solitaire-spec/map.md) `12` (iOS slice). Play assets live on [What Play icon, feature graphic, and screenshots does v1 use?](../klondike-play-store/issues/04-play-listing-visuals.md). Shared prototype branch `prototype/listing-visuals`.

Depends on [What do Apple and Google require to list a free no-account phone game?](https://github.com/jusanherndon/Solitare/issues/5).
Look-and-play is locked on [How should the Klondike table look and play on a phone in portrait and landscape?](../klondike-solitaire-spec/issues/01-klondike-table-look-and-play.md).

Parked — owner is not ready to lock listing visuals yet.

## Question

What App Store listing visuals does v1 use: 1024×1024 app icon in the binary, and a 6.9″ iPhone screenshot set (1–10 images, JPEG/PNG, no alpha; portrait 1260×2736, 1290×2796, or 1320×2868) showing the Game in use?

React to the Flutter table prototype (`prototype/klondike-table-flutter`). Screenshots must show Tableau, Foundations, Stock, and Waste in play — not a splash only. Phones only; no iPad screenshot class. Play feature graphic is out of scope here.

## Comments

### jusanherndon — 2026-08-23T20:34:00Z

Listing visuals should come from the Flutter prototype after [#22](https://github.com/jusanherndon/Solitare/pull/22) won the comparison. Ticket still blocked by spec `01` until look-and-play is locked.

### cursor-agent — 2026-08-23T20:53:00Z

Started, then parked. Spec `01` is resolved so this ticket is unblocked. Three icon sketches exist in the chat; not locked. No screenshots yet. Status returned to open.

### cursor-agent — 2026-08-29T16:12:00Z

Throwaway listing-visuals prototype on branch `prototype/listing-visuals`.

**Run:** from `prototype/listing-visuals`, `python3 -m http.server 8082` → http://localhost:8082/?variant=A
Bottom bar / ← → cycles **A Ace on felt**, **B Corner crop**, **C Fan**.

**Screenshots** (placeholder cards, not Fomin/Atlas): `shots/portrait-play.png`, `shots/landscape-play.png`, `shots/portrait-deal.png` (opening deal — drop if it reads as splash). Recapture: `cd prototype/klondike-table-flutter && flutter test test/listing_shots_test.dart`.

Not shipped art; no “kids.” Apple 6.9″ pixel sizes are not yet produced from these placeholders.

### cursor-agent — 2026-08-29T16:16:00Z

Owner is not ready to lock or publish. Prototype stays on `prototype/listing-visuals` (not merged).

### cursor-agent — 2026-08-29T16:50:00Z

Moved onto [Post Klondike Solitaire to the App Store](../map.md) as the iOS slice of spec `12`. Play slice is `04` on the Play map.
