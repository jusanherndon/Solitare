# Klondike Solitaire — v1 spec

A free, no-account, no-ads English Game for phones. One shared Flutter codebase for both stores. Store name: **Klondike Solitaire**.

This file is the implementable spec. Decisions live in the tickets this map closed; this document compiles them. Vocabulary is `CONTEXT.md`. Do not reopen those tickets while implementing.

**Look sources.** Table: `prototype/klondike-table-flutter` ([How should the Klondike table look and play on a phone in portrait and landscape?](issues/01-klondike-table-look-and-play.md)). Table chrome: same tree, **B — Thumb dock** ([How should Undo, New Game, and Start look?](../klondike-round-2-mechanics/issues/01-table-chrome-look.md)). Chrome screens: same tree, **A — Felt banner**, on branch `prototype/chrome-screens-look` ([How should the start, About, win, and loss screens look on a phone?](issues/15-chrome-screens-look.md)). The prototype is throwaway, not the product app.

Store listing, privacy hosting, and enrollment are [Post Klondike Solitaire to the App Store](../klondike-app-store/map.md) and [Post Klondike Solitaire to Google Play](../klondike-play-store/map.md). Playtest mechanic changes: [Round 2 of making the app mechanics](../klondike-round-2-mechanics/map.md).

## Product

- Phones only. Portrait and landscape. English only.
- No accounts, ads, or in-app purchases.
- Publisher: Justin Herndon.
- Support: `jherndon111@gmail.com` (same address as the privacy policy and store listings).

## Out of scope

- Other Solitaire variants; house rules
- Score, timer, statistics, daily challenges, themes, sound
- Tablets; languages other than English
- Store listing, privacy-policy hosting, enrollment, store uploads
- CI

## Rules

Cite USPC / Bicycle Official Rules for printed Klondike (draw-one, alternating-color Tableau, Ace-to-King Foundations). **Play is computer-Klondike**, not a one-pass printed deal: unlimited Stock recycle, and legal face-up Tableau subsequences may move together.

**Opening.** Standard Klondike: seven Tableau piles of 1–7 cards, top card of each face-up; remaining cards face-down in the Stock. Four empty Foundations. Empty Waste.

**Tableau.** Build down in alternating color. A King may start an empty pile. Face-down cards stay stacked; the top face-down card turns face-up when exposed.

**Foundations.** Four piles. An Ace may start any empty Foundation. Build up in suit, Ace through King.

**Stock and Waste.** The Game’s draw type is fixed at the deal (**draw-one** or **draw-three**).

Draw-one: a tap on the Stock turns one card onto the Waste, face-up.

Draw-three: a tap on the Stock turns up to three cards onto the Waste, face-up, fanned. Only the last drawn (Waste top) is playable; playing it exposes the next in the fan. If fewer than three remain in the Stock, draw those.

Tap an empty Stock to recycle the Waste onto the Stock face-down (unlimited, reversing order). In draw-three, leftovers and cards played off the Waste **shift** the groups of three on later passes. Empty Waste is labeled. Empty Stock shows a recycle glyph when the Waste can return.

**Win.** All 52 cards sit on the Foundations, Ace through King of each suit.

**Winning deal.** An opening that can be finished under the draw type of the Game being started. Draw-one and draw-three each have a shipped pool of about 100–200 openings (not much more), filled ahead of time by a bot (keep on **win**, skip otherwise). A draw-one proof is not a draw-three **winning deal**. **New Game** is still a random shuffle. **Winning deal** picks at random from the pool for the type in **Settings**.

**Loss.** Not a win, and both of these hold: no **active Hint** (no legal face-up play to an unseen face-up table — repeats do not count), and no Stock or Waste card that could legally play onto the **current** Tableau or a Foundation, including face-down Stock and buried draw-three cards. Dimmed **Hint** is not itself a loss. Prefer a missed overlay over a premature **You lost.**

After each successful Tableau or Foundation play, draw, Stock recycle, Auto-move, or Undo, check for a win first, then **Finish** if its gate holds and they have not **Continue**d this Game, then a loss. A Hint tap does not trigger these checks. Seen face-up tables persist with the unfinished Game and the Undo stack.

**Finish.** Not Auto-move, not Hint, not a Settings toggle. The overlay appears only when Stock is empty, every card is face-up, and a sequence of legal Foundation plays from the Waste top and Tableau tops reaches a **win**. If that gate is false, no overlay — **loss** still uses its own check. Empty Stock plus all face-up is not itself a loss.

Sources: [What standard Klondike draw-one rules should the spec cite?](https://github.com/jusanherndon/Solitare/issues/4), [Does v1 follow USPC Klondike strictly, or computer-Klondike conventions?](https://github.com/jusanherndon/Solitare/issues/8), [When no legal move remains, what ending screen does v1 show?](issues/14-no-moves-ending-screen.md), [What is a winning deal, and how do you start one?](../klondike-round-2-mechanics/issues/02-winning-deal.md), [How does draw-three difficulty work?](../klondike-round-2-mechanics/issues/04-draw-three.md), [How does Hint work, and where does it sit?](../klondike-round-2-mechanics/issues/05-hint.md), [When is a Game a loss?](../klondike-round-2-mechanics/issues/03-loss-check.md), [When all cards are face-up and a win is possible, how does the Game finish onto the Foundations?](../klondike-round-2-mechanics/issues/07-win-finish.md).

## Interaction

Both tap and drag are first-class. Tap a card, then tap a legal destination; or drag and drop. A tiny slip is a tap, not a drag. An illegal drop snaps back. Tapping an illegal destination, or tapping the same card again, clears the pick and does nothing else. A drag may start from a card already tapped. Drawing from the Stock is a tap on the Stock, not a drag. No selection highlight. Dragged cards follow the pointer in a root overlay so they stay above other piles.

**Auto-move** only on double-tap / double-click: Foundation first if legal, otherwise a Tableau pile that **Hint** would show for that card. Not Foundation onto Foundation. Not a Foundation Ace onto Tableau. Not a built Tableau run onto another pile unless that frees a Foundation play. Cards never fly to a Foundation on their own except after **Finish**.

**Hint** is a table-chrome button, not Auto-move. Each tap animates a ghost of one legal play from a face-up playable card (Waste top, a Foundation top, or a face-up Tableau sequence) onto a legal Tableau pile or Foundation, then fades. Real cards stay. The Game does not change; Undo is not stacked. Hint does not inspect face-down Tableau cards or the Stock. Draw and recycle are not Hints. In draw-three, only the Waste top is a source.

The Hint cycle is rebuilt after a Tableau or Foundation play, Auto-move, Undo, a Stock draw, or a recycle, then restarted at the first **new** Hint (a play that would leave an unseen face-up table). A Hint tap does not rebuild. New plays first, repeats last. Within each group: Foundation destinations before Tableau; sources Waste, then Foundations left to right, then Tableau left to right; shortest legal run first. Each source-and-destination pair is one step. Wrap after the last step.

Tapping Hint during the ghost cancels it and does not start the next; the cycle still advances. Any table tap, drag, Stock, Auto-move, Undo, New Game, or Start also cancels. Empty list: dim Hint, ignore the tap, do not open **You lost.** A **loss** treats only new plays as **active Hints**.

**Undo** is unlimited in the current Game: every successful move, draw, Stock recycle, and auto-move, back to the opening Tableau. A Stock tap is one draw — in draw-three, Undo returns every card that tap moved, not one card of the fan. Selection-only taps do not stack. New Game cannot be undone; it starts a fresh Undo stack. **Finish** (the action) cannot be undone.

**Resume** restores an unfinished Game (Stock, Waste, Foundations, Tableau, face-up state, draw type, seen face-up tables, **Finish** overlay or the Continue opted-out flag) and the Undo stack from the start screen. Do not restore a tap-selection, an in-progress drag, or an in-progress Finish animation. Persist on-device. A win or a loss ends the Game — Resume does not apply. The restored Game keeps the type it started with even if **Settings** now says the other.

Source: [What are the v1 rules for Undo, resume, tap, and drag?](issues/02-undo-resume-tap-drag.md), superseded on launch by the start screen below; [How does Hint work, and where does it sit?](../klondike-round-2-mechanics/issues/05-hint.md); [When all cards are face-up and a win is possible, how does the Game finish onto the Foundations?](../klondike-round-2-mechanics/issues/07-win-finish.md).

## Screens and chrome

v1 always opens on a dedicated **start screen**. An unfinished Game does not skip it. Resume is a start-screen action, not an automatic launch.

**Start screen.** Title **Klondike Solitaire**. Actions: **New Game**, **Winning deal**, **Resume**, **Settings**, **About**. Resume is hidden unless an unfinished Game exists (first launch, and after a win or a loss). No table behind this screen. Back from About or Settings returns here.

**Settings.** Felt banner like About (no table behind). A **Start** chrome button top-left. One control: **Draw three**, off by default (**draw-one**). Persist on the phone, independent of Resume. No confirm on the toggle. Applies only to the next **New Game** or **Winning deal**; the type is fixed when the deal starts. Nothing else on this screen yet.

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

**Table chrome.** **Hint**, **Undo**, **New Game**, and **Start**, that order, in a bottom thumb dock — four large gold-bordered tiles. Not top-right. **Start** goes to the start screen with no confirm; the unfinished Game and Undo stack stay. Resume is how they return. Hint is dimmed when it has nothing to show.

**New Game.** Confirms only when an unfinished Game would be discarded — from the table, or from the start screen while Resume is showing. No confirm on first launch or after a win or a loss. A confirmed New Game deals a fresh random shuffle under the type in **Settings** and starts a new Undo stack.

**Winning deal.** Same confirm as **New Game**. Hidden on the table during play. On the start screen, win overlay, and loss overlay, the button sits immediately next to **New Game**. After confirm (or with no confirm), deal from the pool for the type in **Settings** and start a new Undo stack. Cannot be undone back into the previous Game.

**Win overlay.** Headline **You won!** Actions: **Start**, **New Game**, and **Winning deal**. No Undo.

**Finish overlay.** Headline **You can finish.** (wording may change in a look pass). Actions: filled **Finish**, then **Continue**. No Start, New Game, Winning deal, or Undo. Table stays visible behind, dimmed like the win overlay, still in color. **Finish** moves remaining cards onto the Foundations (Waste top, then Tableau left to right; Foundations left to right), then the win overlay; cannot stop or Undo. **Continue** returns to the table and hides this overlay for the rest of the Game.

**Loss overlay.** Headline **You lost.** Actions: **Start**, **New Game**, **Winning deal**, and **Undo** (back to the table, last move reversed). Undo is the only way back into that Game.

From a win or a loss, **Start** goes to the start screen (Resume hidden). **New Game** and **Winning deal** deal with no confirm.

Sources: [What start screen does the app open to, and what does Settings contain?](issues/11-start-and-settings-screens.md), [What else does the About screen show besides the Privacy Policy link?](issues/09-about-screen-contents.md), [When no legal move remains, what ending screen does v1 show?](issues/14-no-moves-ending-screen.md), [What is a winning deal, and how do you start one?](../klondike-round-2-mechanics/issues/02-winning-deal.md), [How does draw-three difficulty work?](../klondike-round-2-mechanics/issues/04-draw-three.md), [How does Hint work, and where does it sit?](../klondike-round-2-mechanics/issues/05-hint.md), [How should Undo, New Game, and Start look?](../klondike-round-2-mechanics/issues/01-table-chrome-look.md), [When is a Game a loss?](../klondike-round-2-mechanics/issues/03-loss-check.md), [When all cards are face-up and a win is possible, how does the Game finish onto the Foundations?](../klondike-round-2-mechanics/issues/07-win-finish.md).

## Look

Felt green (`#1F6B45`). Table chrome is a bottom thumb dock: large tiles, deep green fill, gold border. Screen chrome (start, About, overlays) uses rounded dark fill and a light border; a filled / primary button uses a deeper green fill and gold border.

**Table — layout A, classic top row**, in both portrait and landscape (same arrangement when rotated, not a second layout).

- Top row: Stock then Waste on the left, four Foundations on the right, with a gap between Waste and Foundations.
- Tableau: seven columns below.
- Empty Foundations are unlabeled dashed slots. Empty Waste is labeled. In draw-three the Waste fans up to three face-up cards; only the top is playable.
- On a phone the table fills the screen (safe-area padded). Cards grow with the short side, capped so seven columns still fit. Portrait fans the Tableau more; landscape tightens the fan. Rank and suit type is larger than the first table prototype. Chrome is a bottom thumb dock: **Hint**, **Undo**, **New Game**, **Start**.

**Cards.** Ship Dmitry Fomin’s English-pattern SVG faces and Atlas card back, CC0 1.0 — not Bicycle art, not a Rider Back, not Bellot LGPL. Jokers are not used. Prefer the blue-and-brown Atlas back ([research](../../docs/research/public-domain-card-assets.md)).

**Start (felt banner).** Cream title. Stacked chrome buttons: **New Game** (filled), **Winning deal** next to it, **Resume** when visible, **Settings**, **About**. Portrait: title and buttons stacked in the middle of the felt. Landscape: title on the left, the same button stack on the right. No table behind.

**About (felt banner).** Cream body type, gold underlined tappable rows. A **Start** chrome button top-left. No table behind.

**Settings (felt banner).** Same as About: cream body, **Start** chrome button top-left, no table behind. One **Draw three** toggle.

**Win overlay.** Table visible around a centered dark rounded card with a gold border. **You won!** in gold. **Start**, then filled **New Game**, then **Winning deal** next to **New Game**. Dim the table (~40%). Gold sparkles rise through the open felt.

**Finish overlay.** Same family as the win overlay: table visible, dim (~40%), still in color, not greyscale. Centered dark rounded card with a gold border. **You can finish.** (wording may change in a look pass). Filled **Finish**, then **Continue**.

**Loss overlay.** Table visible but greyscale and dimmer (~50%). A darker card slightly below center, red-tinted border, **You lost.** in muted grey. Grey dust falls. Filled **Undo** first, then **Start**, then **New Game**, then **Winning deal** next to **New Game**.

**New Game confirm.** Same felt-banner card and chrome buttons. Warn that the unfinished Game will be discarded. **Winning deal** uses this same confirm when **Resume** is showing.

Rejected table layouts: pile thumb dock (Stock/Waste at the bottom), side rails, Expo table. Rejected chrome screens: letterbox, bottom sheet. Rejected table chrome: top-right felt pills, billboard strip, split play/leave, 2×2 island, Hint-first stack.

## Engineering

- **Toolkit:** Flutter. One codebase for Android and iOS. Owner override of the Expo research after comparing prototypes.
- **Dependencies:** prefer few; vendor specific code as needed (ADR-0001). `flutter_lints` as a **dev** dependency is the official exception and does not ship in the APK.
- **Analyzer / format / test:** `package:flutter_lints/flutter.yaml`; extra lints `unawaited_futures` and `discarded_futures`; `dart format` at 80 columns; `flutter analyze`; `flutter test`. Skip VGA, DCM, `custom_lint`, `pedantic`. Later CI (not this map): analyze, `dart format --set-exit-if-changed`, test.
- **Local Android prototype:** `cd prototype/klondike-table-flutter && flutter build apk` (Flutter SDK + Android SDK). iOS local prototype waits on a MacBook ([Can we build and install the Klondike table prototype on iOS locally?](issues/07-ios-local-prototype-build.md)).

Sources: [Which one-codebase toolkit should a beginner use to ship Klondike Solitaire?](https://github.com/jusanherndon/Solitare/issues/2), [Which Flutter analyzer, lint, and format tools should this repo use?](issues/13-flutter-lint-and-style-tools.md), [Can we build and install the Klondike table prototype on Android locally?](issues/06-android-local-prototype-build.md).
