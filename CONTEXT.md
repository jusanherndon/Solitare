# Klondike Solitaire

A free, no-account, on-device Klondike Game for phones. This glossary is the language for the spec.

## Language

**Game**:
One deal of Klondike: Stock, Waste, four Foundations, and seven Tableau piles, from the opening layout until New Game, a win, or a loss.
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
Restoring an unfinished Game, including the Undo stack, from the start screen. Selection and in-progress drag are not part of Resume. A win or a loss is not unfinished — Resume does not apply.
_Avoid_: save, checkpoint, continue (as the feature name)

**Start screen**:
The dedicated screen the app opens to, not the Klondike table.
_Avoid_: home screen, home, menu, title screen

**Settings**:
The screen reached from the start screen that holds options for the next deal. Not on the table.
_Avoid_: options, preferences, settings menu

**Draw-one**:
A Game type whose Stock tap turns one card onto the Waste.
_Avoid_: draw 1, single draw

**Draw-three**:
A Game type whose Stock tap turns up to three cards onto the Waste, fanned face-up. Only the Waste top is playable.
_Avoid_: draw 3, 3-card draw, hard mode (as the type name)

**Auto-move**:
A double-tap or double-click that sends a card to a Foundation if legal, otherwise to a legal Tableau pile. Cards do not fly by themselves.
_Avoid_: hint, autocomplete, auto-complete

**Win**:
A Game with all four Foundations complete, Ace through King of each suit.
_Avoid_: victory, clear

**Winning deal**:
An opening layout from which at least one sequence of legal plays reaches a win under a given draw type (draw-one or draw-three). A layout that can be finished draw-one is not thereby a winning deal for draw-three. The player can still lose.
_Avoid_: guaranteed win (as in the player cannot lose), solvable seed, winning Game

**Loss**:
A Game with no legal play that is not a win: no Tableau move, no Foundation move, Stock empty, Waste empty.
_Avoid_: stuck, fail, game over (as the outcome name)
