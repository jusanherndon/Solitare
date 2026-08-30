/// Hint cycle: legal face-up plays, new then repeats. Not Auto-move.
library;

import 'plays.dart';
import 'reducer.dart';
import 'rules.dart';

export 'plays.dart';

bool _isNew(GameState state, HintPlay play) {
  final next = applyDrop(state, play.onto, play.from, play.cardIndex);
  return !state.seenFaceUp.contains(faceUpTableKey(next));
}

/// New plays first, repeats last. Empty when nothing legal is face-up.
List<HintPlay> hintCycle(GameState state) {
  final news = <HintPlay>[];
  final repeats = <HintPlay>[];
  for (final play in legalHintPlays(state)) {
    if (_isNew(state, play)) {
      news.add(play);
    } else {
      repeats.add(play);
    }
  }
  return [...news, ...repeats];
}

/// Active Hint for loss: a play that would leave an unseen face-up table.
bool hasActiveHint(GameState state) {
  for (final play in legalHintPlays(state)) {
    if (_isNew(state, play)) return true;
  }
  return false;
}

class HintCursor {
  HintCursor(this.plays);
  final List<HintPlay> plays;
  int index = 0;

  bool get isEmpty => plays.isEmpty;

  HintPlay? get current => plays.isEmpty ? null : plays[index];

  void advance() {
    if (plays.isEmpty) return;
    index = (index + 1) % plays.length;
  }
}
