/// Shared useful plays for Hint and Auto-move.
library;

import 'rules.dart';

class HintPlay {
  const HintPlay({
    required this.from,
    required this.cardIndex,
    required this.onto,
  });

  final PileRef from;
  final int cardIndex;
  final PileRef onto;

  @override
  bool operator ==(Object other) =>
      other is HintPlay &&
      from == other.from &&
      cardIndex == other.cardIndex &&
      onto == other.onto;

  @override
  int get hashCode => Object.hash(from, cardIndex, onto);
}

List<PlayingCard> _moving(GameState state, PileRef from, int cardIndex) {
  final pile = getPile(state, from);
  if (from.area == PileArea.waste || from.area == PileArea.foundation) {
    if (pile.isEmpty) return const [];
    return [pile.last];
  }
  if (!tableauRunIsLegal(pile, cardIndex)) return const [];
  return pile.sublist(cardIndex);
}

/// Face-up sources only. Draw and recycle are not plays. Waste top only.
List<HintPlay> legalHintPlays(GameState state) {
  final plays = <HintPlay>[];

  void consider(PileRef from, int cardIndex) {
    final moving = _moving(state, from, cardIndex);
    if (moving.isEmpty) return;
    for (var i = 0; i < 4; i++) {
      final onto = PileRef.foundation(i);
      if (from.sameAs(onto)) continue;
      if (from.area == PileArea.foundation) continue;
      if (canMoveOnto(moving, onto, state)) {
        plays.add(HintPlay(from: from, cardIndex: cardIndex, onto: onto));
      }
    }
    for (var i = 0; i < 7; i++) {
      final onto = PileRef.tableau(i);
      if (from.sameAs(onto)) continue;
      if (!canMoveOnto(moving, onto, state)) continue;
      if (from.area == PileArea.foundation &&
          !_foundationPullHelps(state, moving.first, onto)) {
        continue;
      }
      if (_skipBuiltTableauShift(state, from, cardIndex)) continue;
      plays.add(HintPlay(from: from, cardIndex: cardIndex, onto: onto));
    }
  }

  if (state.waste.isNotEmpty) {
    consider(const PileRef.waste(), state.waste.length - 1);
  }
  for (var i = 0; i < 4; i++) {
    final pile = state.foundations[i];
    if (pile.isEmpty) continue;
    consider(PileRef.foundation(i), pile.length - 1);
  }
  for (var i = 0; i < 7; i++) {
    final pile = state.tableau[i];
    for (var idx = pile.length - 1; idx >= 0; idx--) {
      if (!tableauRunIsLegal(pile, idx)) continue;
      consider(PileRef.tableau(i), idx);
    }
  }
  return plays;
}

/// First useful play for this source. Foundation destinations before Tableau.
/// Last-resort rehomes are Hint/loss only — Auto-move does not break a built run.
HintPlay? autoMovePlay(GameState state, PileRef from, int cardIndex) {
  for (final play in legalHintPlays(state)) {
    if (play.from.sameAs(from) && play.cardIndex == cardIndex) return play;
  }
  return null;
}

bool _canPlayOnFoundation(PlayingCard card, GameState state) {
  for (var i = 0; i < 4; i++) {
    if (canStackOnFoundation(card, state.foundations[i])) return true;
  }
  return false;
}

/// Skip Tableau-to-Tableau of a run already stacked, unless it frees a
/// Foundation play. A King already on an empty pile hopping to another
/// empty pile does not help.
bool _skipBuiltTableauShift(GameState state, PileRef from, int cardIndex) {
  if (from.area != PileArea.tableau) return false;
  final pile = state.tableau[from.index];
  if (cardIndex == 0) {
    return pile.isNotEmpty && pile.first.rank == 13;
  }
  if (cardIndex >= pile.length) return false;
  final parent = pile[cardIndex - 1];
  if (!parent.faceUp) return false;
  if (!canStackOnTableau(pile[cardIndex], parent)) return false;
  return !_canPlayOnFoundation(parent, state);
}

/// Pull a Foundation card onto Tableau only if a waiting Waste or Tableau
/// card can then play onto it (a 3 comes down to give a 2 a home).
bool _foundationPullHelps(GameState state, PlayingCard pulled, PileRef onto) {
  bool waiting(PlayingCard card) => canStackOnTableau(card, pulled);

  if (state.waste.isNotEmpty && waiting(state.waste.last)) return true;
  for (var i = 0; i < 7; i++) {
    if (onto.index == i) continue;
    final pile = state.tableau[i];
    if (pile.isEmpty) continue;
    final top = pile.last;
    if (!waiting(top)) continue;
    if (pile.length >= 2) {
      final parent = pile[pile.length - 2];
      if (parent.faceUp &&
          canStackOnTableau(top, parent) &&
          !_canPlayOnFoundation(parent, state)) {
        continue;
      }
    }
    return true;
  }
  return false;
}

int _movingLength(GameState state, HintPlay play) =>
    _moving(state, play.from, play.cardIndex).length;

int _kingHomeRank(GameState state, HintPlay play) {
  final moving = _moving(state, play.from, play.cardIndex);
  if (moving.isEmpty) return 9;
  if (play.onto.area != PileArea.tableau) return 8;
  final dest = state.tableau[play.onto.index];
  if (dest.isEmpty && moving.first.rank == 13) return 0;
  if (dest.isNotEmpty && dest.last.rank == 13) return 1;
  return 5;
}

/// Plays Hint otherwise hides that can still change the table: Tableau-run
/// rehomes (not King-empty hops) and a Foundation card other than an Ace
/// onto Tableau.
List<HintPlay> lastResortHintPlays(GameState state) {
  final plays = <HintPlay>[];

  for (var i = 0; i < 4; i++) {
    final pile = state.foundations[i];
    if (pile.isEmpty) continue;
    final card = pile.last;
    if (card.rank == 1) continue;
    final from = PileRef.foundation(i);
    final moving = [card];
    for (var t = 0; t < 7; t++) {
      final onto = PileRef.tableau(t);
      if (!canMoveOnto(moving, onto, state)) continue;
      if (_foundationPullHelps(state, card, onto)) continue;
      plays.add(HintPlay(from: from, cardIndex: pile.length - 1, onto: onto));
    }
  }

  for (var i = 0; i < 7; i++) {
    final pile = state.tableau[i];
    for (var idx = pile.length - 1; idx >= 1; idx--) {
      if (!tableauRunIsLegal(pile, idx)) continue;
      final from = PileRef.tableau(i);
      if (!_skipBuiltTableauShift(state, from, idx)) continue;
      final moving = _moving(state, from, idx);
      if (moving.isEmpty) continue;
      for (var t = 0; t < 7; t++) {
        if (t == i) continue;
        final onto = PileRef.tableau(t);
        if (!canMoveOnto(moving, onto, state)) continue;
        plays.add(HintPlay(from: from, cardIndex: idx, onto: onto));
      }
    }
  }

  plays.sort((a, b) {
    final king = _kingHomeRank(state, a).compareTo(_kingHomeRank(state, b));
    if (king != 0) return king;
    final len = _movingLength(state, b).compareTo(_movingLength(state, a));
    if (len != 0) return len;
    final fromCmp = a.from.index.compareTo(b.from.index);
    if (fromCmp != 0) return fromCmp;
    return a.onto.index.compareTo(b.onto.index);
  });
  return plays;
}
