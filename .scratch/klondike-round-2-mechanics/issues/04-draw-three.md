# How does draw-three difficulty work?

Type: grilling
Status: resolved

From [What bugs or changes turn up when the owner runs the prototype on Android?](../../klondike-solitaire-spec/issues/17-android-playtest.md).
Related: [What is a winning deal, and how do you start one?](issues/02-winning-deal.md) locked two **winning deal** pools (draw-one and draw-three); draw-one remains. Filling the draw-three pool is [Fill and ship the draw-three winning-deal pool](issues/09-draw-three-winning-deal-pool.md). Implementation: [Implement draw-three in the Flutter prototype](issues/11-draw-three.md).

Draw-three is in scope for this effort. Draw-one stays (not replaced).

## Question

Owner wants a draw-three difficulty (three cards from the **Stock** per draw, not one).

Decide: Waste fan (how many face-up, which card is playable), recycle, and how the player picks the difficulty. Draw-one remains a choice — **Winning deal** needs both types. Settings holds the type. Draw-one **loss** “full pass” was dropped on [When is a Game a loss?](issues/03-loss-check.md) — both types share the same last-resort check.

## Comments

### agent — 2026-08-30

**Picking (locked):** Draw-three is a **Settings** option, not extra **start screen** buttons. Changing it applies only to the next **New Game** or **Winning deal**. The type is fixed when the deal starts. **Resume** restores that Game’s type even if Settings now says the other. Default remains draw-one until we lock the control itself.

**Settings (locked):** One **Settings** action on the **start screen** only. Table chrome stays **Undo**, **New Game**, **Start**. Win/loss overlays do not gain Settings; **New Game** / **Winning deal** there use the last saved type. To switch type after a win: **Start** → Settings → deal from the start screen.

**Waste (locked):** Each Stock tap moves up to three cards onto the Waste, face-up, fanned. Only the last drawn (Waste top) is playable; playing it exposes the next in the fan. Fewer than three left in Stock → draw those. Empty Stock recycles Waste onto Stock face-down, unlimited, same as draw-one.

**Recycle shift (locked):** Recycle is the same as draw-one (Waste onto Stock face-down, reversing order). A last draw of 1 or 2 is a short fan. Playing off the Waste and leftovers change the groups of three, so a buried card can become the top on a later pass. No cap on recycle count. If the remaining count stays a multiple of three and nothing is played from the Waste, the same tops can repeat.

**Loss (locked):** No separate draw-three full pass. The Stock-emptied-once boolean is dropped on [When is a Game a loss?](issues/03-loss-check.md) for both types. A buried draw-three card that could play on the current table still blocks **loss**.

**Settings screen (locked):** Dedicated screen from the **start screen** only; back to the start screen like **About**. One control: **Draw three**, off by default (draw-one). Persist on the phone, independent of **Resume**. No confirm on the toggle. **New Game** still confirms only when it would discard an unfinished Game. **Winning deal** uses this saved type for the pool. Nothing else on the screen yet. The table does not label the type beyond the Waste fan.

**Undo (locked):** A Stock tap is one draw. **Undo** returns every card that tap moved to the Waste back onto the Stock, face-down, in the order they left. Playing the Waste top is its own Undo. Recycle is one Undo. No partial undo of a three-card fan.

## Answer

**Draw-one** stays the default. **Draw-three** is a second type, not a replacement.

**Settings.** A dedicated screen, felt banner like **About** (no table behind), reached only from the **start screen**. Back to the start screen. One control: **Draw three**, off by default. Persist on the phone, independent of **Resume**. No confirm on the toggle. Table chrome stays **Undo**, **New Game**, **Start**. Win/loss overlays do not gain Settings. To switch type after a win: **Start** → Settings → deal from the start screen.

The saved type applies only to the next **New Game** or **Winning deal**. It is fixed when the deal starts. **Resume** restores that Game’s type even if Settings now says the other. **Winning deal** uses the saved type to pick the pool.

**Play.** Each Stock tap moves up to three cards onto the **Waste**, face-up, fanned. Only the last drawn (Waste top) is playable; playing it exposes the next in the fan. Fewer than three left in Stock → draw those. Empty Stock recycles Waste onto Stock face-down, unlimited, reversing order (same as draw-one). A last draw of 1 or 2 is a short fan. Playing off the Waste and leftovers **shift** the groups of three. No recycle cap. If the remaining count stays a multiple of three and nothing is played from the Waste, the same tops can repeat.

**Undo.** A Stock tap is one draw: **Undo** returns every card that tap moved, face-down, in the order they left. Playing the Waste top is its own Undo. Recycle is one Undo. No partial undo of a three-card fan.

**Loss.** Same last-resort check as draw-one on [When is a Game a loss?](issues/03-loss-check.md). No full-pass boolean. A buried draw-three card that could play on the current table still blocks the overlay.

Pool: [Fill and ship the draw-three winning-deal pool](issues/09-draw-three-winning-deal-pool.md).
