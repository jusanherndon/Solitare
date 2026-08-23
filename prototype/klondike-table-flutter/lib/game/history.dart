/// Undo history around the pure Klondike reducer. Selection-only changes are skipped.

import 'deal.dart';
import 'reducer.dart';
import 'rules.dart';

class GameMeta {
  const GameMeta({required this.present, required this.past});
  final GameState present;
  final List<GameState> past;
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

GameMeta initMeta([int seed = 42]) =>
    GameMeta(present: dealGame(seed), past: const []);

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

GameMeta reduceMeta(GameMeta state, MetaAction action) {
  switch (action) {
    case UndoMetaAction():
      if (state.past.isEmpty) return state;
      final past = [...state.past];
      final present = past.removeLast();
      return GameMeta(present: present, past: past);
    case GameMetaAction(:final action):
      if (action is NewGameAction) {
        return GameMeta(present: reduce(state.present, action), past: const []);
      }
      final next = reduce(state.present, action);
      if (boardKey(next) == boardKey(state.present)) {
        return identical(next, state.present)
            ? state
            : GameMeta(present: next, past: state.past);
      }
      return GameMeta(present: next, past: [...state.past, state.present]);
  }
}
