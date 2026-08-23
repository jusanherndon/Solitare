# Map: Klondike Solitaire spec

Migrated from: https://github.com/jusanherndon/Solitare/issues/1

## Destination

A written spec for Klondike Solitaire — a free, no-account, no-ads English game listed on the Apple App Store and Google Play — complete enough that a later session can implement it. Phones only, portrait and landscape. This map does not ship the app.

## Notes

- Domain: Klondike. Read `CONTEXT.md` before working a ticket. Use `/grilling`, `/domain-modeling`, `/research`, and `/prototype` as the ticket type requires.
- Passion project; the owner is new to app development. One shared codebase for both stores. Store name: Klondike Solitaire. Toolkit is Flutter (owner override of the #2 Expo research after comparing prototypes).
- Classic playing cards; prefer public-domain art. Tap and drag. Undo and resume. Draw-one, standard Klondike rules.
- Plan, don't do: produce decisions for the spec, not the implementation.

## Open tickets

Local files under `issues/`. GitHub numbers are the pre-migration issues (closed after this move).

- `04` [What icon, feature graphic, and screenshots does v1 use?](issues/04-listing-visuals.md) (`prototype`, was #11)
- `05` [Does Play list Klondike Solitaire as including children?](issues/05-play-target-audience-children.md) (`grilling`, was #12)
- `07` [Can we build and install the Klondike table prototype on iOS locally?](issues/07-ios-local-prototype-build.md) (`task`, was #14) — waiting on a MacBook
- `08` [Publish the Klondike Solitaire privacy policy on GitHub Pages](issues/08-publish-privacy-policy-pages.md) (`task`, was #15)
- `09` [What else does the About screen show besides the Privacy Policy link?](issues/09-about-screen-contents.md) (`grilling`, was #16)
- `10` [Update jusanherndon.github.io for the Klondike privacy policy link](issues/10-update-personal-github-pages.md) (`task`) — blocked by 08

## Decisions so far

<!-- the index — one line per closed ticket: enough to judge relevance, then zoom the link for the detail the ticket holds -->

- Prefer few npm dependencies; vendor specific code as needed — ADR-0001 (`docs/adr/0001-minimize-dependencies-and-vendor.md`).
- [How should the Klondike table look and play on a phone in portrait and landscape?](issues/01-klondike-table-look-and-play.md) — Layout A (classic top row) in both orientations; Flutter table is the source (`prototype/klondike-table-flutter`).
- [What are the v1 rules for Undo, resume, tap, and drag?](issues/02-undo-resume-tap-drag.md) — Tap→tap and drag; auto-move on double-tap only (Foundation then Tableau); unlimited Undo in the current Game; Resume restores an unfinished Game plus Undo stack.
- [What copy goes on the App Store and Play listings?](issues/03-store-listing-copy.md) — Play short: free draw-one Klondike, undo, resume, no ads/account. Full description matches v1 rules. Keywords: cards/patience/offline. Support `jherndon111@gmail.com` + privacy URL. Category Game/Card.
- [Can we build and install the Klondike table prototype on Android locally?](issues/06-android-local-prototype-build.md) — Yes: `flutter build apk` in `prototype/klondike-table-flutter` with Flutter + Android SDK. Owner demonstrated. iOS waits on a MacBook (`07`).
- [Which one-codebase toolkit should a beginner use to ship Klondike Solitaire?](https://github.com/jusanherndon/Solitare/issues/2) — Research recommended Expo (no local Mac for iOS). **Owner override after prototypes:** Flutter (`prototype/klondike-table-flutter`, [#22](https://github.com/jusanherndon/Solitare/pull/22)). Nicer to build with, faster to build, smaller APK; Expo table closed as worse to use and buggier ([#17](https://github.com/jusanherndon/Solitare/pull/17)). Official iOS still needs macOS + Xcode.
- [What standard Klondike draw-one rules should the spec cite?](https://github.com/jusanherndon/Solitare/issues/4) — USPC/Bicycle Official Rules: draw-one, one pass (no redeal); alternating-color Tableau; Ace-to-King Foundations.
- [Does v1 follow USPC Klondike strictly, or computer-Klondike conventions?](https://github.com/jusanherndon/Solitare/issues/8) — Computer-Klondike: unlimited Stock recycle + legal face-up subsequences (from `01` prototype feedback); #4 remains the printed citation.
- [What do Apple and Google require to list a free no-account phone game?](https://github.com/jusanherndon/Solitare/issues/5) — Both stores: public privacy policy (listing + in-app), no-data nutrition/Data safety, honest age/content questionnaires (expect Apple 4+), phone listing assets (Apple 6.9″ screenshots + 1024 icon; Play 512 icon + 1024×500 feature graphic + ≥2 screenshots); Play personal accounts need 12 testers for 14 days.
- [Which public-domain classic card assets can we ship on both stores?](https://github.com/jusanherndon/Solitare/issues/3) — Fomin English-pattern SVGs + Atlas card back (CC0 1.0); not Bicycle art or Bellot LGPL.
- [What privacy policy does Klondike Solitaire publish, and where is it hosted?](https://github.com/jusanherndon/Solitare/issues/9) — GitHub Pages at `https://jusanherndon.github.io/Solitare/privacy/`; Klondike Solitaire by Justin Herndon; no off-device personal data; About-screen link; contact jherndon111@gmail.com.

## Not yet specified


## Out of scope

- Other Solitaire variants (Spider, FreeCell, Pyramid, a multi-game suite)
- Accounts, ads, in-app purchases, draw-three, house rules
- Hints, score, timer, statistics, daily challenges, themes, sound
- Tablet layouts and languages other than English
- Developer-account enrollment, store uploads, CI, and building the app — those wait until the spec exists
