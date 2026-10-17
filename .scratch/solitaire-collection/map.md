# Map: Solitaire Collection

The app stops being a Klondike-only listing and becomes a collection that can hold more than one variant. Spider is not this map.

## Destination

The shape of **Solitaire Collection** and the name on its single store listing are locked in [spec.md](../klondike-solitaire-spec/spec.md) and in the not-yet-published listing and privacy-policy tickets. The app opens on the **Collection screen**. **Klondike start** sits behind Klondike. The store title, the privacy-policy name, and the Collection screen title are **Solitaire Collection**. Privacy facts stay as they are. Klondike rules stay in the store description until another variant ships. This map does not build the Collection screen and does not build Spider.

## Notes

- Domain: Solitaire Collection. Read `CONTEXT.md`. Use `/grilling` and `/domain-modeling` on tickets.
- Plan, don't do. Building the **Collection screen** and **Klondike start** in `src/klondike-table-flutter` is a later map, and it has to land before either store listing is submitted.
- Each variant, including Spider, is its own later map.
- Store enrollment, closed testing, and upload stay on [Post Klondike Solitaire to the App Store](../klondike-app-store/map.md) and [Post Klondike Solitaire to Google Play](../klondike-play-store/map.md). Those maps list this app once, under **Solitaire Collection**.
- The reverse-DNS id stays on [What bundle ID and application ID does v1 use?](../klondike-play-store/issues/06-store-identifiers.md). It is for this app, not for a Klondike-only package.

## Open tickets

- `01` [Where does Start land, and how do you get back to the Collection screen?](issues/01-leave-klondike-start.md) (`grilling`)

## Decisions so far

<!-- the index — one line per closed ticket -->

## Not yet specified

- Look of the Collection screen (the later build map)
- What a variant map is allowed to add to the Collection screen once Klondike is no longer the only entry

## Out of scope

- Building the Collection screen and Klondike start in the Flutter tree — a later map, before either store listing is submitted
- Spider and every other variant — each its own map
- Store enrollment, closed testing, upload, screenshots, launcher art
- Privacy data practices — they stay “nothing leaves the phone”
- Rewriting the Klondike rules in the store description — they stay until a variant ships
