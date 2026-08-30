/// Follow Hint until a win, or skip. Not shipped to the table.
library;

import 'hint.dart';
import 'history.dart';
import 'loss.dart';
import 'reducer.dart';
import 'rules.dart';

enum HintBotResult { win, skip }

/// Play the first **new** Hint, else tap Stock. Looping or a **loss** is a skip.
HintBotResult followHints(
  int seed, {
  DrawType drawType = DrawType.drawOne,
  int maxSteps = 8000,
}) {
  return followHintsOn(
    initMeta(seed: seed, drawType: drawType),
    maxSteps: maxSteps,
  );
}

HintBotResult followHintsOn(GameMeta meta, {int maxSteps = 8000}) {
  var current = meta;
  final seen = <String>{};
  for (var i = 0; i < maxSteps; i++) {
    final state = current.present;
    if (state.won) return HintBotResult.win;
    if (isLoss(state)) return HintBotResult.skip;
    if (!seen.add(boardKey(state))) return HintBotResult.skip;

    if (hasActiveHint(state)) {
      final play = hintCycle(state).first;
      current = reduceMeta(
        current,
        GameMetaAction(
          DropAction(play.onto, from: play.from, cardIndex: play.cardIndex),
        ),
      );
      continue;
    }

    if (state.stock.isNotEmpty || state.waste.isNotEmpty) {
      current = reduceMeta(current, const GameMetaAction(DrawAction()));
      continue;
    }

    return HintBotResult.skip;
  }
  return HintBotResult.skip;
}
