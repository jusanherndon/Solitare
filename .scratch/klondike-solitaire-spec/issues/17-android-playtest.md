# What bugs or changes turn up when the owner runs the prototype on Android?

Type: task
Status: resolved

Depends on [Can we build and install the Klondike table prototype on Android locally?](issues/06-android-local-prototype-build.md). Related: [How should the start, About, win, and loss screens look on a phone?](issues/15-chrome-screens-look.md), [spec.md](../spec.md).

## Question

The owner runs the Flutter prototype on an Android phone and records bugs and desired changes here.

This is a capture ticket, not an implementation ticket. Play the table and the felt-banner chrome (start, About, win, loss) in portrait and landscape. Write each finding under **Comments** — what you saw, what you want instead. A later session can graduate those notes into spec patches or build work.

Run `prototype/klondike-table-flutter` (`flutter run` on a connected device, or `flutter build apk` and sideload). Felt-banner chrome is in this tree (start, About, table, win, loss). There is no variant switcher.

Do not treat this as store QA. iOS is [Can we build and install the Klondike table prototype on iOS locally?](issues/07-ios-local-prototype-build.md).

## Done when

- The owner has played on Android (portrait and landscape).
- Bugs and wanted changes are written in Comments on this ticket.
- A follow-up session has either patched the spec, filed follow-on work, or recorded that nothing needs to change.

## Comments

### jusanherndon — 2026-08-29T16:04:00Z

Table chrome **Undo**, **New Game**, and **Start** look too simplistic. Want them different later; not sure how yet. Do not lock a new look on this note — graduate a prototype/grilling ticket when there is something to react to.

### jusanherndon — 2026-08-29T17:26:00Z

Want a winning-deal option: New Game (or a mode) deals so a **win** is possible — cards aligned such that the Game can be finished.

### jusanherndon — 2026-08-29T17:26:01Z

Want a more comprehensive **loss** check. Only consider face-up / visible cards plus the **Stock**: if none of those have a legal Tableau or Foundation play (and nothing left to draw from the Stock), that is a loss. Do not wait until Stock and Waste are both empty.

The check must **not** run until the Stock has been gone through completely (every card drawn at least once / one full pass). Track that with a boolean on the Game; the comprehensive loss check is off while it is false.

### jusanherndon — 2026-08-29T17:26:02Z

Want a draw-three difficulty option (draw three from the Stock, not draw-one). Draw-one stays; this would be an added difficulty, not a replacement until grilled.

### jusanherndon — 2026-08-29T17:29:00Z

Draw-three is **in scope** for this spec. Playtesting is turning up features and changes; items that were listed as out of scope may come back in. Do not treat the old out-of-scope list as frozen.

### jusanherndon — 2026-08-29T17:32:00Z

Want a **Hint** button on the table. Each tap plays an animation of a legal play and cycles to the next, without making the move. This is not **Auto-move** (double-tap still plays).

### jusanherndon — 2026-08-29T17:34:00Z

**Auto-move** (double-tap) sometimes does not send the card to a legal play. May need a tweak. Capture as a bug, not a rules change, until reproduced.

### jusanherndon — 2026-08-29T17:37:00Z

Once every card is face-up and a **win** is possible, want the Game to finish itself onto the Foundations (cards move without further taps). Optional. This is not **Auto-move** (double-tap still one card). Not specified yet whether it is always on or a toggle.

## Answer

Playtest notes captured. Follow-on work is [Round 2 of making the app mechanics](../../klondike-round-2-mechanics/map.md): one ticket per feature/bug comment (scoping note about out-of-scope is Notes on that map, not a ticket). This ticket does not implement those changes.
