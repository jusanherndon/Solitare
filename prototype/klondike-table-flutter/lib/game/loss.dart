/// Last-resort loss: no active Hint, no Stock/Waste play on the current table.
library;

import 'hint.dart';
import 'rules.dart';

bool cardCanPlayOnTable(PlayingCard card, GameState state) {
  for (var i = 0; i < 4; i++) {
    if (canStackOnFoundation(card, state.foundations[i])) return true;
  }
  for (var i = 0; i < 7; i++) {
    final pile = state.tableau[i];
    final target = pile.isEmpty ? null : pile.last;
    if (canStackOnTableau(card, target)) return true;
  }
  return false;
}

bool stockOrWasteCanPlay(GameState state) {
  for (final card in state.waste) {
    if (cardCanPlayOnTable(card, state)) return true;
  }
  for (final card in state.stock) {
    if (cardCanPlayOnTable(card, state)) return true;
  }
  return false;
}

bool isLoss(GameState state) =>
    !state.won && !hasActiveHint(state) && !stockOrWasteCanPlay(state);
