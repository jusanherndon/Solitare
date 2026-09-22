/// Hint cycle: legal face-up plays. New plays only while any exist. Not Auto-move.
library;

import 'plays.dart';
import 'reducer.dart';
import 'rules.dart';

export 'plays.dart';

bool _isNew(GameState state, HintPlay play) {
  final next = applyDrop(state, play.onto, play.from, play.cardIndex);
  return !state.seenFaceUp.contains(faceUpTableKey(next));
}

PlayingCard? _playCard(GameState state, HintPlay play) {
  final pile = getPile(state, play.from);
  if (play.cardIndex < 0 || play.cardIndex >= pile.length) return null;
  return pile[play.cardIndex];
}

/// Reverse of a play while that card still sits where the play put it.
bool _blockedByLoopStop(GameState state, HintPlay play) {
  final moving = _playCard(state, play);
  if (moving == null) return false;
  for (final stop in state.hintLoopStops) {
    if (stop.cardId != moving.id) continue;
    if (stop.onto.area == PileArea.foundation &&
        play.from.area == PileArea.foundation) {
      return true;
    }
    if (stop.from.area == PileArea.foundation &&
        play.onto.area == PileArea.foundation) {
      return true;
    }
    if (play.from.sameAs(stop.onto) && play.onto.sameAs(stop.from)) {
      return true;
    }
  }
  return false;
}

/// New plays first. Repeats are omitted while any new play exists, so Hint
/// does not wrap between a useful play and undoing a Foundation pull.
/// Repeat Foundation pulls stay omitted even when they are the only plays.
/// Reverse of a play stays omitted while that card still sits where the play
/// put it. Draws do not bring it back. If every new play is such a reverse
/// and draw or recycle cannot help, Hint still shows those plays.
/// Last-resort Tableau-run rehomes and Foundation pulls (not Ace-downs)
/// come after every useful new play, and only when draw or recycle cannot
/// help, so **You lost.** does not fire while the player can still try them.
List<HintPlay> hintCycle(GameState state) {
  final news = <HintPlay>[];
  final stoppedNews = <HintPlay>[];
  final repeats = <HintPlay>[];
  for (final play in legalHintPlays(state)) {
    final stopped = _blockedByLoopStop(state, play);
    if (_isNew(state, play)) {
      if (stopped) {
        stoppedNews.add(play);
      } else {
        news.add(play);
      }
    } else if (play.from.area != PileArea.foundation) {
      if (!stopped) repeats.add(play);
    }
  }
  if (news.isNotEmpty) return news;
  final drawCannotHelp = !stockOrWasteCanPlay(state);
  if (stoppedNews.isNotEmpty && drawCannotHelp) {
    return stoppedNews;
  }
  if (drawCannotHelp) {
    final lastResort = <HintPlay>[];
    for (final play in lastResortHintPlays(state)) {
      if (_isNew(state, play)) lastResort.add(play);
    }
    if (lastResort.isNotEmpty) return lastResort;
  }
  return repeats;
}

/// Active Hint for loss: a new play Hint would actually show.
/// A reverse-stop does not count while Hint hides it.
/// Last-resort rehomes count once Hint would show them.
bool hasActiveHint(GameState state) {
  for (final play in hintCycle(state)) {
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
