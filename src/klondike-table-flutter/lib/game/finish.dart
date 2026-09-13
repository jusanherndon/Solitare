/// Finish overlay gate and Foundation-only complete.
library;

import 'reducer.dart';
import 'rules.dart';

bool _allFaceUp(GameState state) {
  if (state.stock.isNotEmpty) return false;
  for (final card in state.waste) {
    if (!card.faceUp) return false;
  }
  for (final pile in state.tableau) {
    for (final card in pile) {
      if (!card.faceUp) return false;
    }
  }
  return true;
}

GameState applyFinishStep(GameState state) {
  final play = nextFinishPlay(state);
  if (play == null) return state;
  final pile = getPile(state, play.from);
  return applyDrop(state, play.onto, play.from, pile.length - 1);
}

class FinishPlay {
  const FinishPlay({required this.from, required this.onto});
  final PileRef from;
  final PileRef onto;
}

/// Waste top, then Tableau left to right; Foundations left to right.
FinishPlay? nextFinishPlay(GameState state) {
  FinishPlay? tryFrom(PileRef from) {
    final pile = getPile(state, from);
    if (pile.isEmpty) return null;
    final moving = [pile.last];
    for (var i = 0; i < 4; i++) {
      final onto = PileRef.foundation(i);
      if (canMoveOnto(moving, onto, state)) {
        return FinishPlay(from: from, onto: onto);
      }
    }
    return null;
  }

  final waste = tryFrom(const PileRef.waste());
  if (waste != null) return waste;
  for (var i = 0; i < 7; i++) {
    final hit = tryFrom(PileRef.tableau(i));
    if (hit != null) return hit;
  }
  return null;
}

bool _noFoundationPlay(GameState before, GameState after) {
  if (before.waste.length != after.waste.length) return false;
  for (var i = 0; i < 4; i++) {
    if (before.foundations[i].length != after.foundations[i].length) {
      return false;
    }
  }
  return true;
}

bool canFinish(GameState state) {
  if (state.won) return false;
  if (!_allFaceUp(state)) return false;
  var next = state;
  for (var i = 0; i < 52; i++) {
    if (isWin(next.foundations)) return true;
    final stepped = applyFinishStep(next);
    if (_noFoundationPlay(next, stepped)) return false;
    next = stepped;
  }
  return isWin(next.foundations);
}

GameState applyFinish(GameState state) {
  var next = state;
  for (var i = 0; i < 52; i++) {
    if (isWin(next.foundations)) break;
    final stepped = applyFinishStep(next);
    if (identical(stepped, next)) break;
    next = stepped;
  }
  return next.copyWith(won: isWin(next.foundations), selection: null);
}
