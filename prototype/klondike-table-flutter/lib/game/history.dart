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
      if (state.past.isEmpty) return state;
      final past = [...state.past];
      final present = past.removeLast();
      return state.copyWith(present: present, past: past);
    case FinishMetaAction():
      return GameMeta(
        present: applyFinish(state.present),
        past: const [],
        finishContinued: state.finishContinued,
      );
    case FinishStepMetaAction():
      final next = applyFinishStep(state.present);
      return GameMeta(
        present: next.copyWith(won: isWin(next.foundations), selection: null),
        past: const [],
        finishContinued: state.finishContinued,
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
      );
      return state.copyWith(
        present: recorded,
        past: [...state.past, state.present],
      );
  }
}
