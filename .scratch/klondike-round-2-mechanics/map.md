# Map: Round 2 of making the app mechanics

Playtest comments from [What bugs or changes turn up when the owner runs the prototype on Android?](../klondike-solitaire-spec/issues/17-android-playtest.md) on [Klondike Solitaire spec](../klondike-solitaire-spec/map.md).

## Destination

The mechanic and table-chrome changes from that playtest locked in the spec and in `prototype/klondike-table-flutter` — enough that the owner can play them on a phone. This map does not list the app on a store.

## Notes

- Domain: Klondike. Read `CONTEXT.md`. Use `/grilling`, `/domain-modeling`, `/prototype`, `/research` as the ticket type requires.
- Playtest may still pull former out-of-scope items in. Do not treat the spec map’s old out-of-scope list as frozen.
- Draw-one remains the default; draw-three is a second type ([How does draw-three difficulty work?](issues/04-draw-three.md)). **Auto-move** is still double-tap (Foundation then Tableau); **Hint** and finishing a win onto the Foundations are different.
- Grilling or prototype first where the look or rules are unknown. Missed Auto-move and unresponsive chrome buttons are one **task** (reproduce and fix; may be timing). Other features wait for their decision tickets before a later implementation pass.
- Toolkit: Flutter, `prototype/klondike-table-flutter`. Store posting stays on the other two maps.

## Open tickets

Local files under `issues/`. First unblocked unclaimed ticket in number order is the frontier.

- `01` [How should Undo, New Game, and Start look?](issues/01-table-chrome-look.md) (`prototype`)
- `03` [When is a Game a loss?](issues/03-loss-check.md) (`grilling`, blocked by `05`)
- `05` [How does Hint work, and where does it sit?](issues/05-hint.md) (`grilling`)
- `06` [Why do Auto-move and chrome buttons sometimes miss a tap, and what should they do?](issues/06-auto-move-miss.md) (`task`)
- `07` [When all cards are face-up and a win is possible, how does the Game finish onto the Foundations?](issues/07-win-finish.md) (`grilling`)
- `08` [Fill and ship the draw-one winning-deal pool](issues/08-draw-one-winning-deal-pool.md) (`task`)
- `09` [Fill and ship the draw-three winning-deal pool](issues/09-draw-three-winning-deal-pool.md) (`task`, blocked by `08`)

## Decisions so far

- [What is a winning deal, and how do you start one?](issues/02-winning-deal.md) — Proven per draw type; **Winning deal** button next to **New Game** on start / win / loss only; two shipped pools (~100–200 each); **New Game** stays random.
- [How does draw-three difficulty work?](issues/04-draw-three.md) — Settings toggle **Draw three** (off = draw-one); fan of up to three, Waste top only; recycle shifts; same **loss** check as draw-one (no full-pass boolean).

## Not yet specified

- How the player picks Hint or finishing a win if those are options (table vs **Settings**, which now holds **Draw three**). **Winning deal** is already a dedicated button on start / win / loss.

## Out of scope

- Other Solitaire variants; accounts, ads, in-app purchases
- Score, timer, statistics, daily challenges, themes, sound
- Store listing, privacy hosting, enrollment — [Post Klondike Solitaire to the App Store](../klondike-app-store/map.md), [Post Klondike Solitaire to Google Play](../klondike-play-store/map.md)
- Launcher icon — [What launcher icon should the Android APK and iOS IPA use?](../klondike-solitaire-spec/issues/18-launcher-icon.md)
- iOS local prototype until a MacBook — [Can we build and install the Klondike table prototype on iOS locally?](../klondike-solitaire-spec/issues/07-ios-local-prototype-build.md)
- CI
