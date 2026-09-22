/// Undo history around the pure Klondike reducer. Selection-only changes are skipped.
library;

import 'deal.dart';
import 'finish.dart';
import 'reducer.dart';
import 'rules.dart';

class GameMeta {
  const GameMeta({
    required this.present,
    required this.past,
    this.finishContinued = false,
  });
  final GameState present;
  final List<GameState> past;
  final bool finishContinued;

  GameMeta copyWith({
    GameState? present,
    List<GameState>? past,
    bool? finishContinued,
  }) => GameMeta(
    present: present ?? this.present,
    past: past ?? this.past,
    finishContinued: finishContinued ?? this.finishContinued,
  );
}

Map<String, PileRef> _faceUpHomes(GameState state) {
  final homes = <String, PileRef>{};
  for (final c in state.waste) {
    homes[c.id] = const PileRef.waste();
  }
  for (var i = 0; i < 4; i++) {
    for (final c in state.foundations[i]) {
      homes[c.id] = PileRef.foundation(i);
    }
  }
  for (var i = 0; i < 7; i++) {
    for (final c in state.tableau[i]) {
      homes[c.id] = PileRef.tableau(i);
    }
  }
  return homes;
}

List<HintLoopStop> _nextLoopStops(GameState before, GameState after) {
  final beforeHomes = _faceUpHomes(before);
  final afterHomes = _faceUpHomes(after);
  final next = <String, HintLoopStop>{};
  for (final stop in before.hintLoopStops) {
    final home = afterHomes[stop.cardId];
    if (home == null || !home.sameAs(stop.onto)) continue;
    next[stop.cardId] = stop;
  }
  for (final id in afterHomes.keys) {
    final from = beforeHomes[id];
    final onto = afterHomes[id];
    if (from == null || onto == null) continue;
    if (from.sameAs(onto)) continue;
    next[id] = HintLoopStop(cardId: id, from: from, onto: onto);
  }
  return next.values.toList();
}

String boardKey(GameState state) {
  Object card(PlayingCard c) => [c.id, c.suit, c.rank, c.faceUp];
  return [
    state.stock.map(card).toList(),
    state.waste.map(card).toList(),
    [for (final p in state.foundations) p.map(card).toList()],
    [for (final p in state.tableau) p.map(card).toList()],
    state.won,
  ].toString();
}

GameMeta initMeta({int seed = 42, DrawType drawType = DrawType.drawOne}) =>
    GameMeta(
      present: dealGame(seed: seed, drawType: drawType),
      past: const [],
    );

sealed class MetaAction {
  const MetaAction();
}

class UndoMetaAction extends MetaAction {
  const UndoMetaAction();
}

class GameMetaAction extends MetaAction {
  const GameMetaAction(this.action);
  final GameAction action;
}

class FinishMetaAction extends MetaAction {
  const FinishMetaAction();
}

class FinishStepMetaAction extends MetaAction {
  const FinishStepMetaAction();
}

class ContinueFinishMetaAction extends MetaAction {
  const ContinueFinishMetaAction();
}

GameMeta reduceMeta(GameMeta state, MetaAction action) {
  switch (action) {
    case UndoMetaAction():
      if (state.present.won || state.past.isEmpty) return state;
      final past = [...state.past];
      final present = past.removeLast();
      return state.copyWith(present: present, past: past);
    case FinishMetaAction():
      var meta = state;
      for (var i = 0; i < 52; i++) {
        if (meta.present.won) break;
        final stepped = applyFinishStep(meta.present);
        final next = stepped.copyWith(
          won: isWin(stepped.foundations),
          selection: null,
        );
        if (boardKey(next) == boardKey(meta.present)) break;
        meta = meta.copyWith(present: next, past: [...meta.past, meta.present]);
      }
      return meta;
    case FinishStepMetaAction():
      final stepped = applyFinishStep(state.present);
      final next = stepped.copyWith(
        won: isWin(stepped.foundations),
        selection: null,
      );
      if (boardKey(next) == boardKey(state.present)) {
        return state.copyWith(present: next);
      }
      return state.copyWith(
        present: next,
        past: [...state.past, state.present],
      );
    case ContinueFinishMetaAction():
      return state.copyWith(finishContinued: true);
    case GameMetaAction(:final action):
      if (action is NewGameAction) {
        return GameMeta(present: reduce(state.present, action), past: const []);
      }
      final next = reduce(state.present, action);
      if (boardKey(next) == boardKey(state.present)) {
        return identical(next, state.present)
            ? state
            : state.copyWith(present: next);
      }
      final recorded = next.copyWith(
        seenFaceUp: {...state.present.seenFaceUp, faceUpTableKey(next)},
        hintLoopStops: _nextLoopStops(state.present, next),
      );
      return state.copyWith(
        present: recorded,
        past: [...state.past, state.present],
      );
  }
}
