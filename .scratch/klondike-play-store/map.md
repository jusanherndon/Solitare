# Map: Post Klondike Solitaire to Google Play

Split from [Klondike Solitaire spec](../klondike-solitaire-spec/map.md).

## Destination

Klondike Solitaire listed and downloadable on Google Play as a free, no-account, no-ads English phone Game.

## Notes

- Domain: Klondike. Read `CONTEXT.md`. In-app features and look live on [Klondike Solitaire spec](../klondike-solitaire-spec/map.md) — do not invent Game rules or table chrome here.
- Privacy-policy tickets are **shared** with [Post Klondike Solitaire to the App Store](../klondike-app-store/map.md): one live URL. Claim and resolve both maps’ privacy tickets together; do not publish twice.
- Passion project; the owner is new to app development. Flutter (`prototype/klondike-table-flutter`). Store name: Klondike Solitaire. Local debug APKs are already possible; Play wants an **Android App Bundle**, not that APK. Flutter 3.47.2 already targets API 36; the remaining store-binary gap is **upload-key signing**, not an SDK bump.
- This map includes enrollment, hosting the privacy policy, listing assets, closed testing, and the store build. Task tickets do that work. Do not implement the Game here.
- Skills: `/research`, `/grilling`, `/prototype` as the ticket type requires.

## Decisions so far

- [What copy goes on the App Store and Play listings?](issues/03-store-listing-copy.md) — Play short: free draw-one Klondike, undo, resume, no ads/account. Full description matches v1 rules. Support `jherndon111@gmail.com` + privacy URL. Category Game/Card.
- [What do Apple and Google require to list a free no-account phone game?](https://github.com/jusanherndon/Solitare/issues/5) — Public privacy policy (listing + in-app), Data safety “no collection / no sharing,” IARC questionnaire, 512 icon + 1024×500 feature graphic + ≥2 screenshots; personal accounts created after 13 Nov 2023 need 12 closed testers for 14 days before production; new apps on or after 31 Aug 2026 must target API 36. Findings: `docs/research/store-listing-requirements.md`.
- [What privacy policy does Klondike Solitaire publish, and where is it hosted?](https://github.com/jusanherndon/Solitare/issues/9) — GitHub Pages at `https://jusanherndon.github.io/Solitare/privacy/`; Klondike Solitaire by Justin Herndon; no off-device personal data; About-screen link; contact jherndon111@gmail.com.
- [What exact Play Console closed-testing steps does a personal account need before production?](issues/08-play-closed-testing.md) — Closed track only (not internal/open); 12 testers must opt in via the Published link (list/group invite is not enough); 14-day clock is per tester from opt-in, opt-out restarts that person, replacing testers does not reset everyone; then Dashboard → Apply for production. Findings: `docs/research/play-closed-testing.md`.
- [How do we produce a Play Android App Bundle from this Flutter project?](issues/09-flutter-play-aab.md) — `flutter build appbundle` (release) → `build/app/outputs/bundle/release/`. Flutter 3.47.2 already targets API 36. You create an upload keystore; Play holds the app signing key. Prototype debug signing cannot ship. Findings: `docs/research/flutter-play-aab.md`.

## Not yet specified

- Exact IARC and Data safety form clicks at Console time (declare no collection / no sharing from the requirements research)
- Whether listing screenshots should wait on start/settings screens from the spec map
- CI for store builds

## Out of scope

- In-app features, table look, start/settings/About contents — [Klondike Solitaire spec](../klondike-solitaire-spec/map.md)
- Apple App Store listing, Apple Developer Program — [Post Klondike Solitaire to the App Store](../klondike-app-store/map.md)
- Other Solitaire variants; accounts, ads, IAP, draw-three, house rules
- Tablet / TV / Wear / Automotive storefronts and languages other than English
- Designed for Families badge unless [Does Play list Klondike Solitaire as including children?](issues/05-play-target-audience-children.md) opts into children as a target audience
