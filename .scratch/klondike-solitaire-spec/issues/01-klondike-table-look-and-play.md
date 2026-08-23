# How should the Klondike table look and play on a phone in portrait and landscape?

Type: prototype
Status: resolved
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

### cursor-agent — 2026-08-23T14:20:00Z

Started a Flutter/Dart twin on branch `prototype_fultter` so we can compare the same table with a much smaller dependency surface (Flutter SDK only, no Expo/React Native vendor tree).

**Not runnable until you scaffold platforms.** From the repo root:

```bash
cd prototype/klondike-table-flutter
flutter create . --platforms=linux,web,android,ios --project-name klondike_table --org com.solitare
```

That only writes project files. APK later: `flutter build apk` (Android SDK). iOS later: `flutter build ios` (macOS + Xcode).

If `flutter create` adds `cupertino_icons` (or any other pub package) to `pubspec.yaml`, delete those extras.

Then:

```bash
flutter run -d linux
# or: flutter run -d chrome
```

Same locked layout A (classic top row), draw-one + Waste recycle, tap→tap, drag, double-click auto-move, Undo, New Game. Placeholder cards. Phone vs desktop sizing copied from the Expo table.

### jusanherndon — 2026-08-23T20:34:00Z

**Comparison decided — Flutter is the table prototype going forward.**

[#22](https://github.com/jusanherndon/Solitare/pull/22) (Flutter twin) merged. [#17](https://github.com/jusanherndon/Solitare/pull/17) (Expo table) closed: the Expo prototype is worse to use and buggier than the Flutter one.

Reasons: nicer to build with, took less time to build, smaller APK. This overrides the [#2](https://github.com/jusanherndon/Solitare/issues/2) Expo research recommendation for the spec.

**React to:** `prototype/klondike-table-flutter` (`flutter run` / `flutter build apk`). Layout A (classic top row) and play (draw-one + Waste recycle, tap→tap, drag, double-click auto-move, Undo, New Game) still locked. Ticket stays open until portrait/landscape look-and-play answers are captured.

## Answer

v1 uses **layout A — classic top row** in both portrait and landscape. Same arrangement when rotated; not a second layout.

**Table**
- Felt green. **Undo** and **New Game** top-right.
- Top row: Stock then Waste on the left, four Foundations on the right, with a gap between Waste and Foundations.
- Tableau: seven columns below. Face-down cards stack; face-up cards fan so the rank/suit peek.
- Empty Foundations are unlabeled dashed slots — any Ace may start any empty pile. Empty Waste is labeled; empty Stock shows a recycle glyph when the Waste can return.
- Placeholder cards for this prototype: cream face, navy back, rank + suit glyphs. Fomin/Atlas art is a later product choice (`#3`).

**Phone vs landscape vs desktop**
- On a phone the table fills the screen (safe-area padded). Cards grow with the short side, capped so seven columns still fit.
- Portrait fans the Tableau more so stacked cards stay readable. Landscape tightens the fan and uses the extra width; chrome stays top-right.
- Desktop/web (prototype only) caps card size so a large monitor does not blow up the table.

**Play locked with this table** (depth of Undo, resume-after-leave, and how tap/drag combine are still grilled on `02`)
- Tap a card, then tap a destination — or drag. Dragged cards follow the pointer in a root overlay so they stay above other piles. No selection highlight.
- Double-tap / double-click auto-moves: Foundation first, then any legal Tableau.
- Draw-one. Tap empty Stock to recycle the Waste (computer-Klondike; already recorded on `#8`).

Rejected: layout B (thumb dock), layout C (side rails), and the Expo table ([#17](https://github.com/jusanherndon/Solitare/pull/17)). Primary source: `prototype/klondike-table-flutter` ([#22](https://github.com/jusanherndon/Solitare/pull/22)).

