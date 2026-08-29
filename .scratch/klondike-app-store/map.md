# Map: Post Klondike Solitaire to the App Store

Split from [Klondike Solitaire spec](../klondike-solitaire-spec/map.md).

## Destination

Klondike Solitaire listed and downloadable on the Apple App Store as a free, no-account, no-ads English phone Game.

## Notes

- Domain: Klondike. Read `CONTEXT.md`. In-app features and look live on [Klondike Solitaire spec](../klondike-solitaire-spec/map.md) — do not invent Game rules or table chrome here.
- Privacy-policy tickets are **shared** with [Post Klondike Solitaire to Google Play](../klondike-play-store/map.md): one live URL. Claim and resolve both maps’ privacy tickets together; do not publish twice.
- Passion project; the owner is new to app development. Flutter (`prototype/klondike-table-flutter`). Store name: Klondike Solitaire. Official iOS still needs macOS + Xcode.
- This map includes enrollment, hosting the privacy policy, listing assets, and the store build. Task tickets do that work. Do not implement the Game here.
- Skills: `/research`, `/grilling`, `/prototype` as the ticket type requires.

## Decisions so far

- [What copy goes on the App Store and Play listings?](issues/03-store-listing-copy.md) — Play short: free draw-one Klondike, undo, resume, no ads/account. Full description matches v1 rules. Keywords: cards/patience/offline. Support `jherndon111@gmail.com` + privacy URL. Category Game/Card.
- [What do Apple and Google require to list a free no-account phone game?](https://github.com/jusanherndon/Solitare/issues/5) — Public privacy policy (listing + in-app), App Privacy “we do not collect data,” honest age questionnaire (expect 4+, not Kids Category), 6.9″ screenshots + 1024 icon in the binary; individual enrollment 99 USD/year. Findings: `docs/research/store-listing-requirements.md`.
- [What privacy policy does Klondike Solitaire publish, and where is it hosted?](https://github.com/jusanherndon/Solitare/issues/9) — GitHub Pages at `https://jusanherndon.github.io/Solitare/privacy/`; Klondike Solitaire by Justin Herndon; no off-device personal data; About-screen link; contact jherndon111@gmail.com.
- [How do we produce a store-signed iOS build from this Flutter project?](issues/07-flutter-ios-store-build.md) — Automatic signing + `flutter build ipa` → `build/ios/ipa/*.ipa` → Transporter. HTTPS-only: `ITSAppUsesNonExemptEncryption` = NO. Findings: `docs/research/flutter-ios-store-build.md`.

## Not yet specified

- App Review contact phone
- Exact age-rating checkboxes at App Store Connect time (expect 4+ from the requirements research)
- Digital Services Act trader vs non-trader for EU; whether to offer China/Korea/Vietnam storefronts
- Whether listing screenshots should wait on start/settings screens from the spec map
- CI for store builds

## Out of scope

- In-app features, table look, start/settings/About contents — [Klondike Solitaire spec](../klondike-solitaire-spec/map.md)
- Google Play listing, Play Console, testers gate — [Post Klondike Solitaire to Google Play](../klondike-play-store/map.md)
- Other Solitaire variants; accounts, ads, IAP, draw-three, house rules
- Tablet/iPad storefronts and languages other than English
- Apple Kids Category / “For Kids” wording unless [Does Play list Klondike Solitaire as including children?](../klondike-play-store/issues/05-play-target-audience-children.md) later forces a spec change
