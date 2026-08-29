# Klondike Solitaire — v1 spec

A free, no-account, no-ads English Game for phones. One shared Flutter codebase for both stores. Store name: **Klondike Solitaire**.

This file is the implementable spec. Decisions live in the tickets this map closed; this document compiles them. Vocabulary is `CONTEXT.md`. Do not reopen those tickets while implementing.

**Look sources.** Table: `prototype/klondike-table-flutter` ([How should the Klondike table look and play on a phone in portrait and landscape?](issues/01-klondike-table-look-and-play.md)). Chrome screens: same tree, **A — Felt banner**, on branch `prototype/chrome-screens-look` ([How should the start, About, win, and loss screens look on a phone?](issues/15-chrome-screens-look.md)). The prototype is throwaway, not the product app.

Store listing, privacy hosting, and enrollment are [Post Klondike Solitaire to the App Store](../klondike-app-store/map.md) and [Post Klondike Solitaire to Google Play](../klondike-play-store/map.md).

## Product

- Phones only. Portrait and landscape. English only.
- No accounts, ads, or in-app purchases.
- Publisher: Justin Herndon.
- Support: `jherndon111@gmail.com` (same address as the privacy policy and store listings).

## Out of scope

- Other Solitaire variants; draw-three; house rules
- Hints, score, timer, statistics, daily challenges, themes, sound
- Settings
- Tablets; languages other than English
- Store listing, privacy-policy hosting, enrollment, store uploads
- CI

## Rules

Cite USPC / Bicycle Official Rules for printed Klondike (draw-one, alternating-color Tableau, Ace-to-King Foundations). **Play is computer-Klondike**, not a one-pass printed deal: unlimited Stock recycle, and legal face-up Tableau subsequences may move together.

**Opening.** Standard Klondike: seven Tableau piles of 1–7 cards, top card of each face-up; remaining cards face-down in the Stock. Four empty Foundations. Empty Waste.

**Tableau.** Build down in alternating color. A King may start an empty pile. Face-down cards stay stacked; the top face-down card turns face-up when exposed.

**Foundations.** Four piles. An Ace may start any empty Foundation. Build up in suit, Ace through King.

**Stock and Waste.** Draw-one: a tap on the Stock turns one card onto the Waste, face-up. Tap an empty Stock to recycle the Waste onto the Stock face-down (unlimited). Empty Waste is labeled. Empty Stock shows a recycle glyph when the Waste can return.

**Win.** All 52 cards sit on the Foundations, Ace through King of each suit.

**Loss.** Not a win, and no legal play remains: no Tableau move, no Foundation move, Stock empty, Waste empty. Do not detect futile Stock cycles in v1.

After each successful move, draw, Stock recycle, or auto-move, check for no legal play. That shape is a win or a loss.

Sources: [What standard Klondike draw-one rules should the spec cite?](https://github.com/jusanherndon/Solitare/issues/4), [Does v1 follow USPC Klondike strictly, or computer-Klondike conventions?](https://github.com/jusanherndon/Solitare/issues/8), [When no legal move remains, what ending screen does v1 show?](issues/14-no-moves-ending-screen.md).

## Interaction

Both tap and drag are first-class. Tap a card, then tap a legal destination; or drag and drop. A tiny slip is a tap, not a drag. An illegal drop snaps back. Tapping an illegal destination, or tapping the same card again, clears the pick and does nothing else. A drag may start from a card already tapped. Drawing from the Stock is a tap on the Stock, not a drag. No selection highlight. Dragged cards follow the pointer in a root overlay so they stay above other piles.

**Auto-move** only on double-tap / double-click: Foundation first if legal, otherwise a legal Tableau pile. Cards never fly to a Foundation on their own.

**Undo** is unlimited in the current Game: every successful move, draw, Stock recycle, and auto-move, back to the opening Tableau. Selection-only taps do not stack. New Game cannot be undone; it starts a fresh Undo stack.

**Resume** restores an unfinished Game (Stock, Waste, Foundations, Tableau, face-up state) and the Undo stack from the start screen. Do not restore a tap-selection or an in-progress drag. Persist on-device. A win or a loss ends the Game — Resume does not apply.

Source: [What are the v1 rules for Undo, resume, tap, and drag?](issues/02-undo-resume-tap-drag.md), superseded on launch by the start screen below.

## Screens and chrome

v1 always opens on a dedicated **start screen**. An unfinished Game does not skip it. Resume is a start-screen action, not an automatic launch.

**Start screen.** Title **Klondike Solitaire**. Actions: **New Game**, **Resume**, **About**. Resume is hidden unless an unfinished Game exists (first launch, and after a win or a loss). No table behind this screen. Back from About returns here. No Settings screen and no Settings button.

**About** (this inventory, in this order):

1. **Klondike Solitaire**
2. **Justin Herndon**
3. **Version** — the version the binary reports
4. **Support:** `jherndon111@gmail.com` — tappable, opens mail
5. **Source** — opens `https://github.com/jusanherndon/Solitare` in the system browser
6. **Privacy Policy** — opens `https://jusanherndon.github.io/Solitare/privacy/` in the system browser
7. **Licenses** — Flutter’s standard open-source license list
8. **Card art:** Dmitry Fomin, English-pattern faces and Atlas back, CC0 1.0

Nothing else on this screen: no personal site, no how-to-play, no rate-the-app, no “For Kids” / “For Children.”

**Table chrome.** **Undo**, **New Game**, and **Start**, top-right. **Start** goes to the start screen with no confirm; the unfinished Game and Undo stack stay. Resume is how they return.

**New Game.** Confirms only when an unfinished Game would be discarded — from the table, or from the start screen while Resume is showing. No confirm on first launch or after a win or a loss. A confirmed New Game deals fresh and starts a new Undo stack.

**Win overlay.** Headline **You won!** Actions: **Start** and **New Game**. No Undo.

**Loss overlay.** Headline **You lost.** Actions: **Start**, **New Game**, and **Undo** (back to the table, last move reversed). Undo is the only way back into that Game.

From a win or a loss, **Start** goes to the start screen (Resume hidden). **New Game** deals fresh with no confirm.

Sources: [What start screen does the app open to, and what does Settings contain?](issues/11-start-and-settings-screens.md), [What else does the About screen show besides the Privacy Policy link?](issues/09-about-screen-contents.md), [When no legal move remains, what ending screen does v1 show?](issues/14-no-moves-ending-screen.md).

## Look

Felt green (`#1F6B45`). Chrome buttons match the table: rounded, dark fill, light border; a filled / primary button uses a deeper green fill and gold border.

**Table — layout A, classic top row**, in both portrait and landscape (same arrangement when rotated, not a second layout).

- Top row: Stock then Waste on the left, four Foundations on the right, with a gap between Waste and Foundations.
- Tableau: seven columns below.
- Empty Foundations are unlabeled dashed slots. Empty Waste is labeled.
- On a phone the table fills the screen (safe-area padded). Cards grow with the short side, capped so seven columns still fit. Portrait fans the Tableau more; landscape tightens the fan. Chrome stays top-right.

**Cards.** Ship Dmitry Fomin’s English-pattern SVG faces and Atlas card back, CC0 1.0 — not Bicycle art, not a Rider Back, not Bellot LGPL. Jokers are not used. Prefer the blue-and-brown Atlas back ([research](../../docs/research/public-domain-card-assets.md)).

**Start (felt banner).** Cream title. Stacked chrome buttons: **New Game** (filled), **Resume** when visible, **About**. Portrait: title and buttons stacked in the middle of the felt. Landscape: title on the left, the same button stack on the right. No table behind.

**About (felt banner).** Cream body type, gold underlined tappable rows. A **Start** chrome button top-left. No table behind.

**Win overlay.** Table visible around a centered dark rounded card with a gold border. **You won!** in gold. **Start**, then filled **New Game**. Dim the table (~40%). Gold sparkles rise through the open felt.

**Loss overlay.** Table visible but greyscale and dimmer (~50%). A darker card slightly below center, red-tinted border, **You lost.** in muted grey. Grey dust falls. Filled **Undo** first, then **Start**, then **New Game**.

**New Game confirm.** Same felt-banner card and chrome buttons. Warn that the unfinished Game will be discarded.

Rejected table layouts: thumb dock, side rails, Expo table. Rejected chrome: letterbox, bottom sheet.

## Engineering

- **Toolkit:** Flutter. One codebase for Android and iOS. Owner override of the Expo research after comparing prototypes.
- **Dependencies:** prefer few; vendor specific code as needed (ADR-0001). `flutter_lints` as a **dev** dependency is the official exception and does not ship in the APK.
- **Analyzer / format / test:** `package:flutter_lints/flutter.yaml`; extra lints `unawaited_futures` and `discarded_futures`; `dart format` at 80 columns; `flutter analyze`; `flutter test`. Skip VGA, DCM, `custom_lint`, `pedantic`. Later CI (not this map): analyze, `dart format --set-exit-if-changed`, test.
- **Local Android prototype:** `cd prototype/klondike-table-flutter && flutter build apk` (Flutter SDK + Android SDK). iOS local prototype waits on a MacBook ([Can we build and install the Klondike table prototype on iOS locally?](issues/07-ios-local-prototype-build.md)).

Sources: [Which one-codebase toolkit should a beginner use to ship Klondike Solitaire?](https://github.com/jusanherndon/Solitare/issues/2), [Which Flutter analyzer, lint, and format tools should this repo use?](issues/13-flutter-lint-and-style-tools.md), [Can we build and install the Klondike table prototype on Android locally?](issues/06-android-local-prototype-build.md).
