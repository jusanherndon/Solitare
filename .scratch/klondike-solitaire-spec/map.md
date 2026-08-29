# Map: Klondike Solitaire spec

Migrated from: https://github.com/jusanherndon/Solitare/issues/1

Store listing, privacy hosting, and enrollment live on [Post Klondike Solitaire to the App Store](../klondike-app-store/map.md) and [Post Klondike Solitaire to Google Play](../klondike-play-store/map.md).

## Destination

A written spec for Klondike Solitaire — a free, no-account, no-ads English Game for phones — covering the features in the app and how it looks, complete enough that a later session can implement it. Phones only, portrait and landscape. This map does not ship the app or list it on a store.

## Notes

- Domain: Klondike. Read `CONTEXT.md` before working a ticket. Use `/grilling`, `/domain-modeling`, `/research`, and `/prototype` as the ticket type requires.
- Passion project; the owner is new to app development. One shared codebase for both stores. Store name: Klondike Solitaire. Toolkit is Flutter (owner override of the #2 Expo research after comparing prototypes).
- Classic playing cards; prefer public-domain art. Tap and drag. Undo and resume. Draw-one, standard Klondike rules.
- Plan, don't do: produce decisions for the spec, not the implementation. Store posting is the other two maps.

## Open tickets

Local files under `issues/`. GitHub numbers are the pre-migration issues (closed after this move).

- `07` [Can we build and install the Klondike table prototype on iOS locally?](issues/07-ios-local-prototype-build.md) (`task`, was #14) — waiting on a MacBook
- `17` [What bugs or changes turn up when the owner runs the prototype on Android?](issues/17-android-playtest.md) (`task`) — playtest log
- `18` [What launcher icon should the Android APK and iOS IPA use?](issues/18-launcher-icon.md) (`prototype`)

## Decisions so far

<!-- the index — one line per closed ticket: enough to judge relevance, then zoom the link for the detail the ticket holds -->

- Prefer few npm dependencies; vendor specific code as needed — ADR-0001 (`docs/adr/0001-minimize-dependencies-and-vendor.md`).
- [How should the Klondike table look and play on a phone in portrait and landscape?](issues/01-klondike-table-look-and-play.md) — Layout A (classic top row) in both orientations; Flutter table is the source (`prototype/klondike-table-flutter`).
- [What are the v1 rules for Undo, resume, tap, and drag?](issues/02-undo-resume-tap-drag.md) — Tap→tap and drag; auto-move on double-tap only (Foundation then Tableau); unlimited Undo in the current Game; Resume restores an unfinished Game plus Undo stack.
- [Can we build and install the Klondike table prototype on Android locally?](issues/06-android-local-prototype-build.md) — Yes: `flutter build apk` in `prototype/klondike-table-flutter` with Flutter + Android SDK. Owner demonstrated. iOS waits on a MacBook (`07`).
- [Which one-codebase toolkit should a beginner use to ship Klondike Solitaire?](https://github.com/jusanherndon/Solitare/issues/2) — Research recommended Expo (no local Mac for iOS). **Owner override after prototypes:** Flutter (`prototype/klondike-table-flutter`, [#22](https://github.com/jusanherndon/Solitare/pull/22)). Nicer to build with, faster to build, smaller APK; Expo table closed as worse to use and buggier ([#17](https://github.com/jusanherndon/Solitare/pull/17)). Official iOS still needs macOS + Xcode.
- [What standard Klondike draw-one rules should the spec cite?](https://github.com/jusanherndon/Solitare/issues/4) — USPC/Bicycle Official Rules: draw-one, one pass (no redeal); alternating-color Tableau; Ace-to-King Foundations.
- [Does v1 follow USPC Klondike strictly, or computer-Klondike conventions?](https://github.com/jusanherndon/Solitare/issues/8) — Computer-Klondike: unlimited Stock recycle + legal face-up subsequences (from `01` prototype feedback); #4 remains the printed citation.
- [Which public-domain classic card assets can we ship on both stores?](https://github.com/jusanherndon/Solitare/issues/3) — Fomin English-pattern SVGs + Atlas card back (CC0 1.0); not Bicycle art or Bellot LGPL.
- [Which Flutter analyzer, lint, and format tools should this repo use?](issues/13-flutter-lint-and-style-tools.md) — Official `flutter_lints` (declare the missing dev_dependency) + `dart format` at 80 cols + `flutter analyze` / `flutter test`. Extra lints: `unawaited_futures`, `discarded_futures`. Skip VGA, DCM, `custom_lint`, `pedantic`. CI later: analyze, format `--set-exit-if-changed`, test.
- [What else does the About screen show besides the Privacy Policy link?](issues/09-about-screen-contents.md) — Name, Justin Herndon, version, support `jherndon111@gmail.com`, source `github.com/jusanherndon/Solitare`, Privacy Policy URL (system browser), Flutter Licenses, Fomin/Atlas CC0 credit. No how-to-play or Kids copy. Reach it from the start screen (`11`).
- [What start screen does the app open to, and what does Settings contain?](issues/11-start-and-settings-screens.md) — Always the start screen (title Klondike Solitaire): New Game, Resume (hidden if nothing to resume), About. No Settings in v1. Table chrome: Undo, New Game, Start (Start keeps the Game). New Game confirms only when it would discard an unfinished Game.
- [When no legal move remains, what ending screen does v1 show?](issues/14-no-moves-ending-screen.md) — Cheap no-move check (no Tableau/Foundation play, Stock and Waste empty). Separate win and loss overlays; table visible behind; You won! / You lost. Win: Start + New Game. Loss: those plus Undo. Win and loss end the Game — no Resume.
- [How should the start, About, win, and loss screens look on a phone?](issues/15-chrome-screens-look.md) — Felt banner (variant A): felt + table chrome buttons; centered gold win card with sparkles; lower greyscale loss card with dust. Source: `prototype/klondike-table-flutter` on `prototype/chrome-screens-look`.
- [Write the v1 spec from the closed decisions?](issues/16-write-spec.md) — Compiled [spec.md](spec.md) from the closed tickets; implement from there.

## Not yet specified

## Out of scope

- Other Solitaire variants (Spider, FreeCell, Pyramid, a multi-game suite)
- Accounts, ads, in-app purchases, draw-three, house rules
- Hints, score, timer, statistics, daily challenges, themes, sound
- Settings screen — no v1 options; revisit in a later effort when a toggle exists
- Tablet layouts and languages other than English
- App Store and Play listing, privacy-policy hosting, developer-account enrollment, store uploads — [Post Klondike Solitaire to the App Store](../klondike-app-store/map.md) and [Post Klondike Solitaire to Google Play](../klondike-play-store/map.md)
- CI
