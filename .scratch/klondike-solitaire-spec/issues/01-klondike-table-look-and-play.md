# How should the Klondike table look and play on a phone in portrait and landscape?

Type: prototype
Status: open
GitHub: #6 — https://github.com/jusanherndon/Solitare/issues/6

## Question

How should the Klondike table look and play on a phone in portrait and landscape? Produce a cheap throwaway prototype the owner can react to: classic cards (placeholders are fine), Stock, Waste, four Foundations, seven Tableau piles, tap and drag, New Game. This is not the product; it exists so we can lock layout and feel for the spec.

## Comments

### jusanherndon — 2026-08-14T19:40:06Z

Started the throwaway Expo prototype on branch `prototype/klondike-table-layout`.

**Run:** `npm run prototype:table` (then `w` for web, or Expo Go on a phone). Rotate to compare portrait/landscape.

**Three layouts** (bottom switcher):
- **A — Classic top row** — Stock/Waste left, Foundations right, Tableau below
- **B — Thumb dock** — Foundations top, Tableau middle, Stock/Waste/New Game in a bottom thumb zone
- **C — Side rails** — Foundations left rail, draw controls right, Tableau center

Play: tap→tap or long-press drag; Stock draws one (USPC one-pass, no redeal); New Game reshuffles. Placeholder cards. React to layout/feel for the spec — not product polish.

### jusanherndon — 2026-08-14T19:46:10Z

Rewrote the throwaway prototype under ADR-0001 (minimize deps / vendor as needed):

- **No npm packages** — plain HTML/CSS/JS served with Python’s `http.server`
- Same three layouts (A/B/C), tap→tap + drag, New Game, portrait/landscape
- Pure Game reducer still isolated in `prototype/klondike-table/game/`

Run: `npm run prototype:table` → http://localhost:8081

### jusanherndon — 2026-08-14T19:52:42Z

Expo is now **vendored** for this prototype (ADR-0001):

- Editable sources: `vendor/expo`, `vendor/expo-status-bar`, `vendor/babel-preset-expo`
- App links them with `file:` deps — see `vendor/README.md` for setup
- Phone run: `npm run prototype:table` → Expo Go
- Zero-dep browser twin kept at `prototype/klondike-table-web/`

React / React Native remain normal npm peers (native binaries).

### jusanherndon — 2026-08-14T20:07:32Z

## First working prototype — ready for feedback

Committed and pushed on [`prototype/klondike-table-layout`](https://github.com/jusanherndon/Solitare/tree/prototype/klondike-table-layout) (`4438168`).

**What it is:** throwaway Expo app (phone + web, one codebase) so we can lock layout/feel for the spec. Not product polish.

**Run**
```bash
npm run bootstrap:vendor   # first time / after clone
npm run prototype:table    # opens web; scan QR with Expo Go for phone
```

**Layouts** (bottom switcher / ← →)
- **A — Classic top row** — Stock/Waste left, Foundations right, Tableau below
- **B — Thumb dock** — Foundations top; Stock/Waste/New Game in a bottom thumb zone
- **C — Side rails** — Foundations left, draw controls right, Tableau center

**Play:** tap → tap destination, or drag. Stock is draw-one, one pass (no redeal). New Game reshuffles. Rotate / resize for portrait vs landscape.

**Deps (ADR-0001):** Expo SDK sources live under `vendor/` (`file:` links) so they can be edited in-tree. See `vendor/README.md`.

React to density, Stock/Waste reachability, Foundation placement, and feel in both orientations — including “steal bits from A/B/C.” Leave notes here; this ticket stays open until we capture the answer.

### jusanherndon — 2026-08-14T20:13:29Z

**Feedback applied:** Foundations no longer show suit-specific empty zones (♠♥♦♣ labels). Empty slots are blank — drop any Ace onto any empty Foundation pile (rules already allowed that; the icons were misleading).

### jusanherndon — 2026-08-14T20:17:18Z

**Feedback applied:** Table scales with viewport — cards, suit text, and chrome grow on large monitors (e.g. 1440p) instead of staying phone-sized (~64px). Phones stay roughly the same density.

### jusanherndon — 2026-08-14T20:19:55Z

**Feedback applied:** Drag fixed — cards now follow the pointer and drop on release (was only selecting/highlighting because Pressable fought PanResponder). Tap still selects → tap destination.

### jusanherndon — 2026-08-14T20:23:29Z

**Feedback applied:** Empty Stock now recycles the Waste (face-down) when tapped, so you can keep drawing — computer-Klondike style (unlimited passes). Empty Stock shows ↻. Note: this diverges from the USPC printed “one pass, no redeal” cited in #4 / still open in #8.

### jusanherndon — 2026-08-14T20:27:00Z

**Feedback applied:** Added **Undo** (next to New Game). Reverses moves, draws, and Stock recycles; selection-only taps are not stacked. Disabled when there’s nothing to undo.

### jusanherndon — 2026-08-14T20:36:18Z

**Issue hygiene:** Closing #8 from this ticket’s Stock-recycle feedback — v1 = computer-Klondike conventions (unlimited Stock recycle + legal face-up subsequences). #4 remains the printed-rules citation only.

`02` stays open (Undo exists in the prototype; grilling still needs depth, resume, auto-move, and how tap/drag combine).

### jusanherndon — 2026-08-14T20:58:44Z

**Feedback applied** (since Undo):

- **No card selection highlight** — yellow borders removed; browser text-selection highlight blocked while dragging (`user-select` / `selectstart`).
- **Drag stays on top** — lifted cards render in a root overlay so they no longer slip behind other Tableau columns.
- **Clicks restored** — higher drag threshold; tiny accidental drags count as clicks again.
- **Double-click auto-move** — Foundation first (e.g. 2 → matching Ace), then any legal Tableau. Drag and tap→tap still work.
- **Layout locked to A** — Classic top row only. Variants B (Thumb dock) and C (Side rails) and the bottom switcher removed.

Run: `npm run prototype:table` (branch `prototype/klondike-table-layout`; local changes may still be uncommitted).

### jusanherndon — 2026-08-14T22:19:06Z

**Progress committed** on [`prototype/klondike-table-layout`](https://github.com/jusanherndon/Solitare/tree/prototype/klondike-table-layout) (`6a97c4b`).

### Layout / feel
- **Locked to A — Classic top row** (B/C and the variant switcher removed).
- **Phone vs web scaling split** — phones fill the screen with clearer stack peeks; web keeps the smaller ~0.5× layout so large monitors don’t blow up the table.

### Play
- Drag stays on top (root overlay); browser text-selection blocked while dragging.
- Double-click / double-tap **auto-move** (Foundation first, then Tableau); drag and tap→tap still work.
- **Undo** next to New Game; Stock recycle (computer-Klondike) unchanged — product choice recorded on #8.

### APK (sideload)
- `npm run prototype:table:apk` (EAS cloud; Expo login) — see `scriptsHelp` / `npm run prototype:table:apk:help`.
- Vendored Expo deps installed on the builder via `eas-build-pre/post-install`.

### Run
```bash
npm run bootstrap:vendor   # if needed
npm run prototype:table    # web / Expo Go
npm run prototype:table:apk
```

Ticket stays open for further layout/feel reactions.
