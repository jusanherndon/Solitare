/// PROTOTYPE — Klondike reducer. Pure; portable into the real app later.
library;

import 'deal.dart';
import 'plays.dart';
import 'rules.dart';

sealed class GameAction {
  const GameAction();
}

class NewGameAction extends GameAction {
  const NewGameAction([this.seed, this.drawType = DrawType.drawOne]);
  final int? seed;
  final DrawType drawType;
}

class DrawAction extends GameAction {
  const DrawAction();
}

class TapAction extends GameAction {
  const TapAction(this.pile, [this.cardIndex]);
  final PileRef pile;
  final int? cardIndex;
}

class DropAction extends GameAction {
  const DropAction(this.onto, {this.from, this.cardIndex});
  final PileRef onto;
  final PileRef? from;
  final int? cardIndex;
}

class AutoMoveAction extends GameAction {
  const AutoMoveAction(this.pile, [this.cardIndex]);
  final PileRef pile;
  final int? cardIndex;
}

class ClearSelectionAction extends GameAction {
  const ClearSelectionAction();
}

class _Board {
  _Board(GameState state)
    : stock = [...state.stock],
      waste = [...state.waste],
      foundations = [
        for (final p in state.foundations) [...p],
      ],
      tableau = [
        for (final p in state.tableau) [...p],
      ],
      selection = state.selection,
      won = state.won,
      drawType = state.drawType,
      seenFaceUp = state.seenFaceUp;

  List<PlayingCard> stock;
  List<PlayingCard> waste;
  List<List<PlayingCard>> foundations;
  List<List<PlayingCard>> tableau;
  Selection? selection;
  bool won;
  DrawType drawType;
  Set<String> seenFaceUp;

  GameState freeze() => GameState(
    stock: stock,
    waste: waste,
    foundations: foundations,
    tableau: tableau,
    selection: selection,
    won: won,
    drawType: drawType,
    seenFaceUp: seenFaceUp,
  );

  List<PlayingCard> pileOf(PileRef pile) {
    switch (pile.area) {
      case PileArea.stock:
        return stock;
      case PileArea.waste:
        return waste;
      case PileArea.foundation:
        return foundations[pile.index];
      case PileArea.tableau:
        return tableau[pile.index];
    }
  }

  void setPile(PileRef pile, List<PlayingCard> cards) {
    switch (pile.area) {
      case PileArea.stock:
        stock = cards;
      case PileArea.waste:
        waste = cards;
      case PileArea.foundation:
        foundations[pile.index] = cards;
      case PileArea.tableau:
        tableau[pile.index] = cards;
    }
  }
}

List<PlayingCard>? _takeSelection(_Board state, Selection sel) {
  final pile = state.pileOf(sel.from);
  if (sel.from.area == PileArea.stock) return null;
  if (sel.from.area == PileArea.waste || sel.from.area == PileArea.foundation) {
    if (pile.isEmpty) return null;
    return [pile.last];
  }
  if (!tableauRunIsLegal(pile, sel.cardIndex)) return null;
  return pile.sublist(sel.cardIndex);
}

void _removeSelection(_Board state, Selection sel, int count) {
  final pile = [...state.pileOf(sel.from)];
  if (sel.from.area == PileArea.waste || sel.from.area == PileArea.foundation) {
    pile.removeLast();
  } else if (sel.from.area == PileArea.tableau) {
    pile.removeRange(sel.cardIndex, sel.cardIndex + count);
    if (pile.isNotEmpty && !pile.last.faceUp) {
      pile[pile.length - 1] = pile.last.copyWith(faceUp: true);
    }
  }
  state.setPile(sel.from, pile);
}

bool _canDrop(List<PlayingCard> moving, PileRef onto, _Board state) {
  if (moving.isEmpty) return false;
  final head = moving.first;
  if (onto.area == PileArea.stock || onto.area == PileArea.waste) return false;
  if (onto.area == PileArea.foundation) {
    if (moving.length != 1) return false;
    return canStackOnFoundation(head, state.foundations[onto.index]);
  }
  final targetPile = state.tableau[onto.index];
  final target = targetPile.isEmpty ? null : targetPile.last;
  return canStackOnTableau(head, target);
}

GameState applyDrop(
  GameState state,
  PileRef onto, [
  PileRef? from,
  int? cardIndex,
]) {
  final next = _Board(state);
  if (from != null) {
    next.selection = Selection(from: from, cardIndex: cardIndex ?? 0);
  }
  final sel = next.selection;
  if (sel == null) return state;
  if (sel.from.sameAs(onto)) {
    next.selection = null;
    return next.freeze();
  }
  final moving = _takeSelection(next, sel);
  if (moving == null || !_canDrop(moving, onto, next)) {
    next.selection = null;
    return next.freeze();
  }
  _removeSelection(next, sel, moving.length);
  final dest = [...next.pileOf(onto)];
  dest.addAll([for (final c in moving) c.copyWith(faceUp: true)]);
  next.setPile(onto, dest);
  next.selection = null;
  next.won = isWin(next.foundations);
  return next.freeze();
}

GameState applySelect(GameState state, PileRef pile, int? cardIndex) {
  if (pile.area == PileArea.stock) return state;
  final cards = getPile(state, pile);
  if (cards.isEmpty) {
    return state.copyWith(selection: null);
  }
  if (pile.area == PileArea.waste || pile.area == PileArea.foundation) {
    return state.copyWith(
      selection: Selection(from: pile, cardIndex: cards.length - 1),
    );
  }
  final idx = cardIndex ?? cards.length - 1;
  if (idx < 0 || idx >= cards.length || !cards[idx].faceUp) return state;
  if (!tableauRunIsLegal(cards, idx)) return state;
  return state.copyWith(
    selection: Selection(from: pile, cardIndex: idx),
  );
}

GameState applyAutoMove(GameState state, PileRef from, int? cardIndex) {
  if (from.area == PileArea.stock) return state;
  final cards = getPile(state, from);
  if (cards.isEmpty) {
    return state.copyWith(selection: null);
  }

  late final int idx;
  if (from.area == PileArea.waste || from.area == PileArea.foundation) {
    idx = cards.length - 1;
  } else {
    idx = cardIndex ?? cards.length - 1;
    if (idx < 0 || idx >= cards.length || !cards[idx].faceUp) {
      return state.copyWith(selection: null);
    }
    if (!tableauRunIsLegal(cards, idx)) {
      return state.copyWith(selection: null);
    }
  }

  final play = autoMovePlay(state, from, idx);
  if (play == null) {
    return state.copyWith(selection: null);
  }
  return applyDrop(state, play.onto, from, idx);
}

GameState applyTap(GameState state, PileRef pile, int? cardIndex) {
  if (pile.area == PileArea.stock) return reduce(state, const DrawAction());
  if (state.selection != null && state.selection!.from.sameAs(pile)) {
    final cards = getPile(state, pile);
    final idx = pile.area == PileArea.waste || pile.area == PileArea.foundation
        ? cards.length - 1
        : cardIndex ?? cards.length - 1;
    if (idx == state.selection!.cardIndex) {
      return state.copyWith(selection: null);
    }
    return applySelect(state, pile, cardIndex);
  }
  if (state.selection != null) return applyDrop(state, pile);
  return applySelect(state, pile, cardIndex);
}

GameState draw(GameState state) {
  final next = _Board(state);
  next.selection = null;
  if (next.stock.isEmpty) {
    if (next.waste.isEmpty) return next.freeze();
    next.stock = [
      for (final c in next.waste.reversed) c.copyWith(faceUp: false),
    ];
    next.waste = [];
    return next.freeze();
  }
  final n = state.drawType == DrawType.drawThree ? 3 : 1;
  final take = n < next.stock.length ? n : next.stock.length;
  final drawn = <PlayingCard>[];
  for (var i = 0; i < take; i++) {
    drawn.add(next.stock.removeLast().copyWith(faceUp: true));
  }
  next.waste = [...next.waste, ...drawn];
  return next.freeze();
}

GameState reduce(GameState state, GameAction action) {
  switch (action) {
    case NewGameAction(:final seed, :final drawType):
      return dealGame(
        seed: seed ?? DateTime.now().millisecondsSinceEpoch,
        drawType: drawType,
      );
    case DrawAction():
      return draw(state);
    case TapAction(:final pile, :final cardIndex):
      return applyTap(state, pile, cardIndex);
    case DropAction(:final onto, :final from, :final cardIndex):
      return applyDrop(state, onto, from, cardIndex);
    case AutoMoveAction(:final pile, :final cardIndex):
      return applyAutoMove(state, pile, cardIndex);
    case ClearSelectionAction():
      return state.copyWith(selection: null);
  }
}

Set<String> selectedCardIds(GameState state) {
  final ids = <String>{};
  final sel = state.selection;
  if (sel == null) return ids;
  final cards = _takeSelection(_Board(state), sel);
  if (cards == null) return ids;
  for (final c in cards) {
    ids.add(c.id);
  }
  return ids;
}
