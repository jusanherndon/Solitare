/// Last-resort loss: no active Hint, no new Tableau-run shift, no Stock/Waste play.
library;

import 'hint.dart';
import 'reducer.dart';
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

String _stockWasteKey(GameState state) =>
    '${state.stock.map((c) => c.id).join(',')}|${state.waste.map((c) => c.id).join(',')}';

/// True when draw or recycle can turn up a Waste top that plays on this table.
bool stockOrWasteCanPlay(GameState state) {
  var cursor = state;
  final seen = <String>{};
  while (true) {
    if (!seen.add(_stockWasteKey(cursor))) return false;
    if (cursor.waste.isNotEmpty &&
        cardCanPlayOnTable(cursor.waste.last, state)) {
      return true;
    }
    if (cursor.stock.isEmpty && cursor.waste.isEmpty) return false;
    cursor = draw(cursor);
  }
}

bool isLoss(GameState state) =>
    !state.won &&
    !hasActiveHint(state) &&
    !hasNewBuiltRunShift(state) &&
    !stockOrWasteCanPlay(state);
