# Standard Klondike draw-one rules

**Ticket:** [What standard Klondike draw-one rules should the spec cite?](https://github.com/jusanherndon/Solitare/issues/4)
**Map:** [Map: Klondike Solitaire spec](https://github.com/jusanherndon/Solitare/issues/1)

## Question

What is the authoritative statement of standard Klondike (draw-one) rules this spec should cite? Cover deal, Tableau building, Foundation building, empty columns, Stock/Waste drawing and redeals, moving sequences, and what counts as a Win.

## Recommendation

**Cite the United States Playing Card Company (Bicycle) as the rules owner.** There is no governing body for Klondike; USPC is the publisher that has owned an American "Official Rules" Klondike text since the 1910s.

Two first-party texts together cover this app's draw-one Game:

1. **USPC *Official Rules of Card Games*, "Klondike"** — the printed statement that the Stock is run through **one card at a time**, and that **one pass ends the Game**. A public-domain scan of that entry is on the Internet Archive.[^uspc-scan] A matching transcription of the same USPC wording (copyrights through 1913) is also published independently.[^uspc-transcription]
2. **Bicycle's current how-to-play pages** — still first-party USPC/Bicycle text. The named **Klondike** page owns deal, Tableau, Foundation, empty columns, and moving face-up cards as a unit, but it now draws the Stock **in groups of three**.[^bicycle-klondike] The generic **Solitaire** page is the current first-party draw-one Stock/Waste wording and the explicit Win.[^bicycle-solitaire]

Pagat does not publish a Klondike rules page. It treats Klondike as a known sorting Game and describes only the seven-pile deal in a related patience.[^pagat-solitaire] [^pagat-double] Wikipedia is a pointer, not an authority.

Draw-three, Vegas/counter scoring, and unlimited Stock recycling are out of scope for this spec. Unlimited recycling is a later computer convention; it is not in the printed USPC Klondike entry.

## Who owns the rules

Klondike has no sport-style governing body. The text that has been sold as official American card-game rules is USPC's *Official Rules of Card Games* (later *Bicycle Official Rules of Card Games*). Bicycle still publishes Klondike and Solitaire how-to-play pages under that brand.

Pagat (John McLeod) is the usual first stop for traditional card-game rules, but its solitaire index says it does not collect traditional one-player rules and has no Klondike page.[^pagat-solitaire] It is not the source to cite for this Game.

## Deal

A standard 52-card pack, no jokers.[^bicycle-klondike] [^uspc-scan]

Deal **28 cards** into **seven Tableau piles**: one card in the first pile, two in the second, up to seven in the last. The top card of each pile is face up; the rest are face down.[^bicycle-klondike] [^uspc-scan] [^pagat-double]

The remaining **24 cards** are the face-down **Stock**. Foundations and Waste start empty.[^bicycle-solitaire]

USPC's older deal wording is the same layout described row by row (first card face up, six face down to its right, then the next face-up card under the first face-down, and so on until seven face-up cards and twenty-eight in the layout).[^uspc-scan]

## Tableau building

Build **down** in **descending rank**, **alternating color** (red on black, black on red). Example from Bicycle: a black five on a red six.[^bicycle-klondike] [^uspc-scan]

When a pile has no face-up card left, turn the top face-down card face up; it becomes available.[^bicycle-klondike] [^uspc-scan]

## Foundation building

The four **Aces** start the four **Foundations**. Each Foundation is built **up in suit** from Ace through King (two, then three, and so on as cards become available).[^bicycle-klondike] [^uspc-scan]

Bicycle's named Klondike page says each Ace **must** be played to a row above the piles as it becomes available.[^bicycle-klondike] USPC says any Aces showing are picked out and placed above the layout for Foundations.[^uspc-scan]

Rank for this Game is Ace low, King high.[^bicycle-solitaire] [^uspc-scan]

## Empty columns

Only a **King** may fill an empty Tableau pile (a "space" / "open space").[^bicycle-klondike] [^bicycle-solitaire] [^uspc-scan]

A King-led face-up sequence may fill that space, because face-up cards on a pile move as a unit (next section).

## Moving sequences

If more than one card is face up on a Tableau pile, **all such cards must be moved as a unit** — "all must be moved together or not at all."[^bicycle-klondike] [^uspc-scan]

That is the printed standard. Splitting a face-up build (moving only part of it) is a later, more lenient reading common in computer Klondike; it is not what USPC/Bicycle's Klondike text says.

## Stock, Waste, drawing, and redeals

**Draw-one (this app).** Turn cards from the Stock **one at a time**. The card showing may be played to the Tableau or a Foundation. If it is not played, it goes to the **Waste**; only the top Waste card is available.[^uspc-scan] [^bicycle-solitaire]

**Redeals.** In the printed USPC Klondike entry, **one pass through the pack ends it** — no recycling the Waste back into a new Stock.[^uspc-scan] Bicycle's current Solitaire page describes draw-one and does not grant a redeal.[^bicycle-solitaire]

Unlimited Stock recycling (flip the Waste face down, no shuffle, draw again without limit) is widely used in computer Klondike. It is not in the USPC Klondike entry, and it is not on Bicycle's current Klondike or Solitaire pages. Treat it as a house/computer convention, not as the cited standard.

**Draw-three (out of scope).** Bicycle's current page titled Klondike turns the Stock in **groups of three**; only the top of the three is playable, and the group then sits on the Waste.[^bicycle-klondike] That is first-party text for a different Stock rule. This spec is draw-one only.

## Win

A Game is a **Win** when the whole pack is built on the four Foundations, each suit Ace through King.[^bicycle-solitaire] [^bicycle-klondike]

The USPC Klondike entry frames the same layout as a counter Game (52 paid for the pack, 5 paid back per Foundation card) and does not use the word Win.[^uspc-scan] Bicycle's Solitaire page is the first-party statement of Win for this family of rules. Counter/Vegas scoring is out of scope.

## Cite-able rules summary

The spec can point at this block. Claims follow USPC *Official Rules* "Klondike" plus Bicycle's current Klondike and Solitaire pages, restricted to draw-one.

- **Pack.** One standard 52-card pack, no jokers.
- **Deal.** Seven Tableau piles of 1 through 7 cards (28 cards). Top card of each pile face up; the rest face down. Remaining 24 cards are the face-down Stock. Four Foundations and the Waste start empty.
- **Tableau.** Build down in rank, alternating color. Face-up cards on a pile move as one unit. An uncovered face-down card is turned face up. Only a King (or a King-led face-up unit) may fill an empty pile.
- **Foundation.** Aces start the four Foundations. Build each up in suit, Ace through King.
- **Stock and Waste.** Draw one card at a time from the Stock onto the Waste. The top Waste card may be played to the Tableau or a Foundation. One pass through the Stock; do not recycle the Waste.
- **Win.** Every card on the Foundations, Ace through King in each suit.

## Sources not used as authority

- **Pagat.** No Klondike rules page; useful only as confirmation of the seven-pile deal in Double Solitaire.[^pagat-solitaire] [^pagat-double]
- **Wikipedia, *Klondike (solitaire)*.** Secondary. It correctly points at USPC 1913 and *Bicycle Official Rules of Card Games* (Kansil, 1999, p. 303) and lists Stock variants (including unlimited draw-one) without owning any of them.
- **How-to blogs and play sites.** Paraphrases. Not cited for rules.

[^uspc-scan]: United States Playing Card Company, *The Official Rules of Card Games* ("Hoyle Up-to-date"), "Klondike," p. 223 in the Internet Archive scan (Digital Library of India item `2015.174022`). <https://archive.org/details/in.ernet.dli.2015.174022> — "The stock is run through one card at a time and any card showing can be used, either on the layout or foundations. When the pack has been run through once that ends it." Layout, alternating-color descending builds, unit moves, Kings-only spaces, and Ace-to-King suit Foundations are in the same entry.

[^uspc-transcription]: "Canfield or Klondike," transcription of USPC *Official Rules of Card Games* (copyrights 1897–1913), Playing Card Games. <https://www.playingcardgames.net/CardGames/Canfield-Or-Klondike.html> — same Stock sentence and layout rules as the scan. Early printings used the joint title; by 1913 USPC lists Klondike and Canfield as separate Games.

[^bicycle-klondike]: Bicycle / USPC, "Klondike." <https://bicyclecards.com/how-to-play/klondike> — pack, object, 28-card seven-pile deal, Ace-to-King suit Foundations, opposite-color Tableau builds, unit moves of face-up cards, turn up uncovered cards, Kings only in empty spaces. Stock rule on this page is draw-three, which this spec does not use.

[^bicycle-solitaire]: Bicycle / USPC, "Solitaire." <https://bicyclecards.com/how-to-play/solitaire> — names Tableau, Foundations, Stock, and Waste (Talon); 1-through-7 deal; draw-one from the Stock; Kings only in a space; Win is the whole pack on the Foundations Ace through King. Silent on redeals and does not state alternating color in the play examples.

[^pagat-solitaire]: John McLeod, "Solitaire Card Games," Pagat. <https://www.pagat.com/solitaire/card.html> — Pagat does not publish a traditional Klondike rules page; it classifies Klondike as a sorting Game.

[^pagat-double]: John McLeod, "Double Solitaire," Pagat. <https://www.pagat.com/patience/double.html> — "layout as for Klondike: 28 cards in 7 piles, each having the top card face up and the rest face down. The left hand pile has just one card, the second two, and so on, the right hand pile having seven cards."
