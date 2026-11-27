# What App Store icon and 6.9″ screenshots does v1 use?

Type: prototype
Status: resolved
GitHub: #11 — https://github.com/jusanherndon/Solitare/issues/11

Moved from [Klondike Solitaire spec](../klondike-solitaire-spec/map.md) `12` (iOS slice). Play assets live on [What Play icon, feature graphic, and screenshots does v1 use?](../klondike-play-store/issues/04-play-listing-visuals.md). Rebuilt in `listing-visuals` from the current table. The Ace on felt mark is also the Android and iOS launcher icon.

Depends on [What do Apple and Google require to list a free no-account phone game?](https://github.com/jusanherndon/Solitare/issues/5).
Look-and-play is locked on [How should the Klondike table look and play on a phone in portrait and landscape?](../klondike-solitaire-spec/issues/01-klondike-table-look-and-play.md).
The mark in the IPA / on the home screen is [What launcher icon should the Android APK and iOS IPA use?](../klondike-solitaire-spec/issues/18-launcher-icon.md) — this ticket keeps 6.9″ screenshots and store-listing use of that same 1024 art.

## Question

What App Store listing visuals does v1 use: 1024×1024 app icon in the binary, and a 6.9″ iPhone screenshot set (1–10 images, JPEG/PNG, no alpha; portrait 1260×2736, 1290×2796, or 1320×2868) showing the Game in use?

The home-screen name is **Solitaire Collection**. Screenshots show Klondike in play. Do not show Spider or a variant that is not in the build.

React to the Flutter table prototype (`src/klondike-table-flutter`). Screenshots must show Tableau, Foundations, Stock, and Waste in play — not a splash only. Phones only; no iPad screenshot class. Play feature graphic is out of scope here.

## Answer

**A — Ace on felt.** The 1024 mark is `listing-visuals/icons/a-ace-on-felt.svg`. The same art, full-bleed, is the launcher icon in the Android mipmaps, the iOS AppIcon set (including the 1024), and the web icons. The store name on that mock is **Solitaire Collection**.

Keep all three 6.9″ screenshots from the current thumb-dock table:

- `listing-visuals/shots/portrait-play.png` — 1320×2868, mid-Game
- `listing-visuals/shots/landscape-play.png` — 2868×1320, mid-Game
- `listing-visuals/shots/portrait-deal.png` — 1320×2868, opening deal

They show Stock, Waste, Foundations, Tableau, and the thumb dock. Putting that mark into the IPA is [What launcher icon should the Android APK and iOS IPA use?](../klondike-solitaire-spec/issues/18-launcher-icon.md). The Play feature graphic stays on the Play ticket.

## Comments

### jusanherndon — 2026-08-23T20:34:00Z

Listing visuals should come from the Flutter prototype after [#22](https://github.com/jusanherndon/Solitare/pull/22) won the comparison. Ticket still blocked by spec `01` until look-and-play is locked.

### cursor-agent — 2026-08-23T20:53:00Z

Started, then parked. Spec `01` is resolved so this ticket is unblocked. Three icon sketches exist in the chat; not locked. No screenshots yet. Status returned to open.

### cursor-agent — 2026-08-29T16:12:00Z

Throwaway listing-visuals prototype on branch `prototype/listing-visuals`.

**Run:** from `prototype/listing-visuals`, `python3 -m http.server 8082` → http://localhost:8082/?variant=A
Bottom bar / ← → cycles **A Ace on felt**, **B Corner crop**, **C Fan**.

**Screenshots** (placeholder cards, not Fomin/Atlas): `shots/portrait-play.png`, `shots/landscape-play.png`, `shots/portrait-deal.png` (opening deal — drop if it reads as splash). Recapture: `cd src/klondike-table-flutter && flutter test test/listing_shots_test.dart`.

Not shipped art; no “kids.” Apple 6.9″ pixel sizes are not yet produced from these placeholders.

### cursor-agent — 2026-08-29T16:16:00Z

Owner is not ready to lock or publish. Prototype stays on `prototype/listing-visuals` (not merged).

### cursor-agent — 2026-11-27

Owner deleted `prototype/listing-visuals` locally and on origin (`579b3b1`). The parked icon families and placeholder screenshots are gone. Remake from the current Flutter table, with the store name **Solitaire Collection**.

### cursor-agent — 2026-08-29T16:50:00Z

Moved onto [Post Klondike Solitaire to the App Store](../map.md) as the iOS slice of spec `12`. Play slice is `04` on the Play map.
