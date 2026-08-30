# Map: Round 2 of making the app mechanics

Playtest comments from [What bugs or changes turn up when the owner runs the prototype on Android?](../klondike-solitaire-spec/issues/17-android-playtest.md) on [Klondike Solitaire spec](../klondike-solitaire-spec/map.md).

## Destination

The mechanic and table-chrome changes from that playtest locked in the spec and in `prototype/klondike-table-flutter` — enough that the owner can play them on a phone. This map does not list the app on a store.

## Notes

- Domain: Klondike. Read `CONTEXT.md`. Use `/grilling`, `/domain-modeling`, `/prototype`, `/research` as the ticket type requires.
- Playtest may still pull former out-of-scope items in. Do not treat the spec map’s old out-of-scope list as frozen.
- Draw-one remains the default; draw-three is a second type ([How does draw-three difficulty work?](issues/04-draw-three.md)). **Auto-move** is still double-tap (Foundation then Tableau); **Hint** is table chrome ([How does Hint work, and where does it sit?](issues/05-hint.md)); **Finish** is a mid-Game overlay ([When all cards are face-up and a win is possible, how does the Game finish onto the Foundations?](issues/07-win-finish.md)).
- Grilling or prototype first where the look or rules are unknown. Missed Auto-move and unresponsive chrome buttons are one **task** (reproduce and fix; may be timing). Implementation of resolved grilling: [Implement draw-three in the Flutter prototype](issues/11-draw-three.md), [Implement the Winning deal button](issues/12-winning-deal-button.md), [Implement Hint on the table](issues/13-hint.md), [Implement the last-resort loss check](issues/14-loss-check.md), [Implement the Finish overlay](issues/15-finish.md). [What bugs or changes turn up when the owner playtests round 2 on Android?](issues/10-round-2-playtest.md) waits until those and the other open work are done.
- Toolkit: Flutter, `prototype/klondike-table-flutter`. Store posting stays on the other two maps.

## Open tickets

Local files under `issues/`. First unblocked unclaimed ticket in number order is the frontier.

- `01` [How should Undo, New Game, and Start look?](issues/01-table-chrome-look.md) (`prototype`)
- `06` [Why do Auto-move and chrome buttons sometimes miss a tap, and what should they do?](issues/06-auto-move-miss.md) (`task`)
- `10` [What bugs or changes turn up when the owner playtests round 2 on Android?](issues/10-round-2-playtest.md) (`task`, blocked by `01`, `06`)

## Decisions so far

- [Implement the Winning deal button](issues/12-winning-deal-button.md) — **Winning deal** next to **New Game** on start / win / loss; random seed from the Settings pool; same confirm as **New Game**.

- [Fill and ship the draw-three winning-deal pool](issues/09-draw-three-winning-deal-pool.md) — 150 draw-three seeds in `winning_deal_pool.dart`; same hint-follow bot, not copied from draw-one.
- [Fill and ship the draw-one winning-deal pool](issues/08-draw-one-winning-deal-pool.md) — 150 draw-one seeds in `winning_deal_pool.dart`; bot follows new Hint then Stock.

- [Implement the Finish overlay](issues/15-finish.md) — Overlay when Foundation-only win is ready; **Finish** completes; **Continue** hides it for the rest of the Game.
- [Implement the last-resort loss check](issues/14-loss-check.md) — No active Hint and no Stock/Waste play on the current table; repeats do not block; seen tables follow Undo and Resume.
- [Implement Hint on the table](issues/13-hint.md) — Table chrome **Hint**; ghost cycle new-then-repeats; dim when empty.
- [Implement draw-three in the Flutter prototype](issues/11-draw-three.md) — Settings **Draw three**; Waste fan; type locked at deal; **Resume** restores it.

- [What is a winning deal, and how do you start one?](issues/02-winning-deal.md) — Proven per draw type; **Winning deal** button next to **New Game** on start / win / loss only; two shipped pools (~100–200 each); **New Game** stays random.
- [How does draw-three difficulty work?](issues/04-draw-three.md) — Settings toggle **Draw three** (off = draw-one); fan of up to three, Waste top only; recycle shifts; same **loss** check as draw-one (no full-pass boolean).
- [How does Hint work, and where does it sit?](issues/05-hint.md) — Table chrome **Hint** (with Undo / New Game / Start); ghost of face-up plays, new then repeats; dim when empty.
- [When is a Game a loss?](issues/03-loss-check.md) — Last resort: no active Hint and no Stock/Waste card that can play on the current table; repeats do not block; no full-pass boolean.
- [When all cards are face-up and a win is possible, how does the Game finish onto the Foundations?](issues/07-win-finish.md) — **Finish** overlay when a Foundation-only win is ready; **Continue** hides it for the rest of the Game.

## Not yet specified

- (none toward this destination — remaining work is prototype, task, and implementation)

## Out of scope

- Other Solitaire variants; accounts, ads, in-app purchases
- Score, timer, statistics, daily challenges, themes, sound
- Store listing, privacy hosting, enrollment — [Post Klondike Solitaire to the App Store](../klondike-app-store/map.md), [Post Klondike Solitaire to Google Play](../klondike-play-store/map.md)
- Launcher icon — [What launcher icon should the Android APK and iOS IPA use?](../klondike-solitaire-spec/issues/18-launcher-icon.md)
- iOS local prototype until a MacBook — [Can we build and install the Klondike table prototype on iOS locally?](../klondike-solitaire-spec/issues/07-ios-local-prototype-build.md)
- CI
