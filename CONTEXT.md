# Klondike Solitaire

A free, no-account, on-device Klondike Game for phones. This glossary is the language for the spec.

## Language

**Game**:
One deal of Klondike: Stock, Waste, four Foundations, and seven Tableau piles, from the opening layout until New Game or a win.
_Avoid_: round, session, match

**Stock**:
The face-down draw pile.
_Avoid_: deck, draw pile

**Waste**:
The face-up pile that receives cards drawn from the Stock.
_Avoid_: discard, talon

**Foundation**:
One of four build piles, Ace through King of a single suit.
_Avoid_: home, suit pile

**Tableau**:
The seven columns where cards build down in alternating color.
_Avoid_: cascade, column (as the pile name)

**Undo**:
Reversal of the last successful move, draw, Stock recycle, or auto-move in the current Game. Selection-only taps are not Undo.
_Avoid_: rewind, back

**Resume**:
Restoring an unfinished Game, including the Undo stack, when the app launches again. Selection and in-progress drag are not part of Resume.
_Avoid_: save, checkpoint, continue (as the feature name)

**Auto-move**:
A double-tap or double-click that sends a card to a Foundation if legal, otherwise to a legal Tableau pile. Cards do not fly by themselves.
_Avoid_: hint, autocomplete, auto-complete
