# Hint, Loss, and Finish playthroughs

**Bot:** `src/klondike-table-flutter/tool/probe_playthroughs.dart`  
**Library:** `lib/game/playthrough_probe.dart` (follows the first **new** Hint, else taps Stock; taps **Finish** when the overlay would appear)  
**Run:**

```bash
cd src/klondike-table-flutter
dart run tool/probe_playthroughs.dart --games 2000
dart run tool/probe_playthroughs.dart --three --games 2000
dart run tool/probe_playthroughs.dart --seed 17
```

**Sample:** 2000 draw-one deals (seeds 1–2000) and 2000 draw-three deals, 2026-09-19. The bot is greedy Hint-follow, not a perfect solver — numbers are “what a Hint-using player plus the overlays would hit,” not true solvability.

Sources: `lib/game/hint.dart`, `lib/game/loss.dart`, `lib/game/finish.dart`, spec in `.scratch/klondike-solitaire-spec/spec.md`, glossary in `CONTEXT.md`.

---

## How the three systems interact

After each successful play, draw, recycle, Auto-move, or Undo, the table checks **win**, then **Finish**, then **loss** (`main.dart` `_playScreen`).

| System | Gate today |
| --- | --- |
| **Hint** | Legal face-up plays, with usefulness filters and a 5-move reverse loop-stop. Dim when the *shown* list is empty. |
| **Loss** (`You lost.`) | Not a win, no **active Hint** (a *new* play Hint would show — reverse-stop does not count while hidden), and no Stock/Waste card that draw or recycle can turn up as the Waste top and play on the current table. A buried draw-three card the stride never turns up does not block a loss. |
| **Finish** (`You can finish.`) | Stock empty, **every** card face-up, and Foundation-only plays from Waste top then Tableau tops reach a win. |

Loop-stop used to be **Hint display only**; loss treated the reverse as an active Hint. Loss now ignores a reverse while Hint hides it, so dimmed Hint plus no reachable Stock/Waste play can open **You lost.**

---

## Hint problems

### 1. Dimmed Hint while a loss is still blocked (very common)

Draw-one: **968 / 2000** games (48%) had Hint dimmed while `hasActiveHint` was still true. Draw-three: **484 / 2000**.

The 5-move reverse loop-stop empties `hintCycle`, so the button dims, but loss still sees the hidden new play. The player gets no ghost and no **You lost.**

**Worst case — no overlay at all.** Draw-one **23** games, draw-three **7**. Empty Stock and Waste, dimmed Hint, not a loss.

Replay **draw-one seed 17**: Stock and Waste empty, 4♣ covering a face-down card, 5♥ sitting on a Foundation with 4♣ waiting for it. Pulling 5♥ down is the active Hint. Loop-stop hid it (12 stops on the table). Chrome is dead unless the player already knows to pull the 5.

### 2. Hint-follow loops

Draw-one: **49 / 2000** (2.5%) returned to a seen table without a win or loss. Examples: seeds **8, 33, 197, 247**.

Typical shape: loop-stop dims Hint, the bot (and a Hint-follower) draws/recycles or takes the next shown play, and the face-up table repeats. Seed 8 still had 2 Stock cards and face-down Tableau when it looped.

Draw-three: **1685 / 2000** (84%) looped. Almost all of those (**1631**) were “a Stock/Waste card *can* play, but draw-three never makes it the Waste top.” The bot recycled through a seen fan. A human would also spin the Stock forever. Loss used to peek buried cards, so **You lost.** never opened. Loss now walks draw and recycle: a card only blocks a loss if it can become the Waste top. Those 1631 Games should now be losses.

### 3. Hint ping-pong

Draw-one: **10 / 2000** (example seed **233**: Waste top onto Tableau, then the reverse pair). Loop-stop lasts 5 player moves; a two-play cycle can still alternate once the window slides. Draw-three: none in this sample. Not always fatal (233 still won).

### 4. Filters vs loops (already shipped, still leaking)

Owner tweaks already drop Foundation Ace onto Tableau, King-empty hops, unhelpful Foundation pulls, and reverse-of-last-play. The bot still finds loops because:

- loop-stop hides the *useful* play, not only the reverse
- new plays after the window re-open the reverse
- draw-three buried cards were “active” for loss but never a Hint (Hint does not inspect Stock); loss now only counts cards the stride can turn up

---

## Loss / `You lost.` problems

### 5. Overlay while the player can still drag (almost every loss)

Draw-one: **1281 / 1283** losses still had a legal table play that would leave an *unseen* face-up table. Draw-three: **132 / 132**.

Those plays are ones **Hint refuses**, so they are not active Hints, so loss fires. The overlay then blocks the table except Undo / Start / New Game / Winning deal.

What the remaining plays actually are (seed 1, 3, …):

- **Breaking a built cascade** — seed **1**: 5♥-4♠-3♦ off K♥ onto 6♠. Hint skips it (`_skipBuiltTableauShift`) because 6♣ is already a legal parent and cannot go to Foundation yet. A human can still drag it.
- **King already on an empty pile hopping to another empty pile** — same seed, K♥ / K♣ onto T4. Spec: do not Hint this. Relocating the pile does not uncover anything.
- **Foundation Ace back onto a 2** — seed **3**: A♦ down onto T5. Owner: do not Hint a Foundation Ace onto Tableau. Putting it back down is the old Hint loop.
- **Foundation onto Foundation** — empty Foundation still accepts an Ace that already sits on another Foundation. Hint skips this; the reducer would allow the drag.

So **You lost.** is last-resort relative to *Hint’s useful list*, not relative to every legal drag. That matches the spec text (“no active Hint”) and fights the other spec line (“prefer a missed overlay over a premature **You lost.**”). Seed 1 is the premature case worth grilling: the 5♥ shift might still unlock the table, and the overlay has already ended the Game.

### 6. Stuck with no loss (see Hint #1)

23 draw-one + 7 draw-three games never opened **You lost.** even though the player had nothing Hint would show and nothing to draw. Loop-stop is the wedge.

### 7. Draw-three: buried playable card, no overlay, no progress

1631 games in the 2026-09-19 sample. Loss peeked every Stock/Waste card, so **You lost.** never opened. Owner later locked the opposite: walk draw and recycle, and if no Waste top that pass can play, it is a **loss**. Implemented in `lib/game/loss.dart`.

---

## Finish / `You can finish.` problems

### 8. How few cards need to be visible?

Two different questions:

**A. Does the engine know a win is possible?**  
It knows the whole deal from the shuffle. A solver can know from the opening **7** face-up cards (the **winning deal** pool already uses Hint-follow for that, not Finish). That is not what the overlay is for.

**B. When is a win *forced* with only Foundation plays left?**  
That is Finish. Today the gate also demands **52 / 52 face-up** and empty Stock.

The probe also asks: empty Stock, same Foundation-only peel as Finish, but **allow face-down Tableau cards to flip as they become tops**. If those hidden cards are exactly the next Foundation ranks, the win is already forced.

Draw-one, among games that reached that peel:

| Face-down still buried | Games |
| --- | --- |
| 0 (same as today’s overlay) | 525 |
| 1 | 60 |
| 2 | 37 |
| 3 | 17 |
| 4 | 7 |
| 5 | 1 |
| 6 | 1 |

- **Fewest face-up when a peel still wins: 46 / 52** (6 still face-down) — **seed 21**. Overlay waited until step 109, all face-up, 15 still off Foundations. Peel was ready at step 87, 26 off Foundations.
- **Most buried at peel: 6**, same seed.
- **123 / 645** Hint-follow wins (19%) could have offered Finish *before* every card was visible.
- Overlay, when it did appear, still had **1–43** cards left to fly (median 12). So even the current gate is “Foundation-only,” not “almost won.”

Draw-three peel: earliest **48 / 52** face-up (4 face-down, seed 652); 53 games earlier than the overlay.

**Practical floor from this bot:** Finish could appear with **6 Tableau cards still face-down** (draw-one sample) without giving away hidden identities beyond “if you keep putting tops on Foundations, they will keep flipping in order.” Going below that needs either a deeper search (Tableau plays, not just peel) or treating hidden cards as unknown — which collapses back to “all face-up.”

### 9. All face-up, empty Stock, Finish still false

Draw-one **58**, draw-three **59**. A Tableau-to-Tableau play is still required (built-run shift, King to an empty pile, etc.). Spec is explicit: no overlay. Several of these later won (seed 2, 18, 26) after Hint showed the Tableau play — Finish then appeared. The miss is “I can see every card and I can still win, but the banner is silent until the last Foundation-only position.”

### 10. Peel ready, overlay never comes

Draw-one peel-possible **648** vs overlay **645**. Three games had a forced Foundation peel with face-down cards, then looped or lost before every card flipped. If Finish used peel instead of all-face-up, those three would have been offered a win.

### 11. Finish is the escape hatch for dimmed Hint

On constructed tables (and seed 17-style endgames), loop-stop can dim Hint on the last Foundation plays. Current Finish still opens because `canFinish` ignores loop-stop. **Do not tighten Finish to “Hint still has a play”** — that would strand those games with no overlay. If anything, Finish should open *earlier* (peel) so it covers the dimmed-Hint endgame.

---

## Replay seeds (draw-one)

| Seed | What to look at |
| --- | --- |
| **17** | Stuck: dimmed Hint, empty Stock/Waste, no **You lost.**, 4♣ waiting on a pulled 5♥ |
| **1** | **You lost.** while 5♥-4♠-3♦ can still drop onto 6♠ |
| **8** | Hint-follow loop with Stock left and face-down Tableau |
| **21** | Peel-Finish at 6 face-down / 46 face-up; overlay 22 steps later |
| **34** | Peel-Finish at 2 face-down (cleaner than 21) |
| **233** | Hint ping-pong Waste → Tableau |

---

## What to change (not locked)

Priority if the goal is “these three screens feel right”:

1. **Stuck chrome** — done: if Hint is dimmed and Stock/Waste cannot produce a play *the player can actually make*, show **You lost.** even when loop-stop is hiding a reverse.
2. **Finish peel gate** — drop “every card face-up”; keep empty Stock + Foundation-only peel that flips as it goes. Observed safe earlier point: **6** still face-down. Overlay copy can stay **You can finish.**
3. **Loss vs remaining drags** — decide whether breaking a built cascade (seed 1) should delay **You lost.** King hops and Foundation Ace-down probably should not.
4. **Draw-three loss** — done: walk draw and recycle; a buried card the stride never turns up is a **loss**.

Leave **winning deal** as the “engine knows a win from 7 face-up cards” path. Do not merge that into Finish.
