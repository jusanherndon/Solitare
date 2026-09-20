/// Probe Hint, Loss, and Finish while following Hint. Not shipped to the table.
library;

import 'finish.dart';
import 'hint.dart';
import 'history.dart';
import 'loss.dart';
import 'reducer.dart';
import 'rules.dart';

enum ProbeOutcome {
  /// Foundations complete.
  win,

  /// Last-resort **You lost.**
  loss,

  /// Followed Hint (or draw/recycle) back to a seen table. A player loop.
  hintLoop,

  /// Dimmed Hint, nothing to draw, not a **loss** — chrome is stuck.
  stuck,

  /// Hit [maxSteps] without a terminal overlay.
  maxSteps,
}

class VisibilitySnapshot {
  const VisibilitySnapshot({
    required this.step,
    required this.faceDown,
    required this.faceUp,
    required this.stock,
    required this.offFoundation,
  });

  final int step;
  final int faceDown;
  final int faceUp;
  final int stock;
  final int offFoundation;
}

class ProbeReport {
  ProbeReport({
    required this.seed,
    required this.drawType,
    required this.outcome,
    required this.steps,
    this.firstFinish,
    this.firstPeelFinish,
    this.dimmedWhileActive = false,
    this.stuckNoLoss = false,
    this.lossWhileNewTablePlay = false,
    this.lossWhileAnyTablePlay = false,
    this.peelFinishBeforeAllFaceUp = false,
    this.allFaceUpNeedsTableau = false,
    this.pingPongHints = false,
    this.unreachableStockPlay = false,
    this.terminal,
    List<String>? notes,
  }) : notes = notes ?? [];

  final int seed;
  final DrawType drawType;
  final ProbeOutcome outcome;
  final int steps;
  final VisibilitySnapshot? firstFinish;
  final VisibilitySnapshot? firstPeelFinish;
  final bool dimmedWhileActive;
  final bool stuckNoLoss;
  final bool lossWhileNewTablePlay;
  final bool lossWhileAnyTablePlay;
  final bool peelFinishBeforeAllFaceUp;
  final bool allFaceUpNeedsTableau;
  final bool pingPongHints;
  final bool unreachableStockPlay;
  final GameState? terminal;
  final List<String> notes;
}

String cardLabel(PlayingCard card) {
  final rank = rankLabel[card.rank] ?? '${card.rank}';
  final suit = suitGlyph[card.suit] ?? card.suit;
  return card.faceUp ? '$rank$suit' : '##';
}

String dumpTable(GameState state) {
  String pile(List<PlayingCard> cards) =>
      cards.isEmpty ? '—' : cards.map(cardLabel).join(' ');
  final buf = StringBuffer()
    ..writeln(
      'stock=${state.stock.length} waste=${pile(state.waste)} '
      'loopStops=${state.hintLoopStops.length}',
    )
    ..writeln(
      'foundations: ${[for (final p in state.foundations) pile(p)].join(' | ')}',
    );
  for (var i = 0; i < 7; i++) {
    buf.writeln('T$i: ${pile(state.tableau[i])}');
  }
  return buf.toString().trimRight();
}

int faceDownCount(GameState state) {
  var n = 0;
  for (final card in state.stock) {
    if (!card.faceUp) n++;
  }
  for (final card in state.waste) {
    if (!card.faceUp) n++;
  }
  for (final pile in state.tableau) {
    for (final card in pile) {
      if (!card.faceUp) n++;
    }
  }
  return n;
}

int faceUpCount(GameState state) => 52 - faceDownCount(state);

int offFoundationCount(GameState state) {
  var n = 0;
  for (final pile in state.foundations) {
    n += pile.length;
  }
  return 52 - n;
}

VisibilitySnapshot visibilityAt(GameState state, int step) =>
    VisibilitySnapshot(
      step: step,
      faceDown: faceDownCount(state),
      faceUp: faceUpCount(state),
      stock: state.stock.length,
      offFoundation: offFoundationCount(state),
    );

/// Stock empty, Foundation-only peeling (flips as it goes) reaches a win.
/// Same as [canFinish] without the all-face-up gate.
bool canPeelFinish(GameState state) {
  if (state.won) return false;
  if (state.stock.isNotEmpty) return false;
  var next = state;
  for (var i = 0; i < 52; i++) {
    if (isWin(next.foundations)) return true;
    final stepped = applyFinishStep(next);
    if (identical(stepped, next)) return false;
    next = stepped;
  }
  return isWin(next.foundations);
}

/// Every legal Waste / Foundation / Tableau play, including ones Hint skips.
List<HintPlay> legalTablePlays(GameState state) {
  final plays = <HintPlay>[];

  void consider(PileRef from, int cardIndex) {
    final pile = getPile(state, from);
    final List<PlayingCard> moving;
    if (from.area == PileArea.waste || from.area == PileArea.foundation) {
      if (pile.isEmpty) return;
      moving = [pile.last];
    } else {
      if (!tableauRunIsLegal(pile, cardIndex)) return;
      moving = pile.sublist(cardIndex);
    }
    if (moving.isEmpty) return;
    for (var i = 0; i < 4; i++) {
      final onto = PileRef.foundation(i);
      if (from.sameAs(onto)) continue;
      if (canMoveOnto(moving, onto, state)) {
        plays.add(HintPlay(from: from, cardIndex: cardIndex, onto: onto));
      }
    }
    for (var i = 0; i < 7; i++) {
      final onto = PileRef.tableau(i);
      if (from.sameAs(onto)) continue;
      if (canMoveOnto(moving, onto, state)) {
        plays.add(HintPlay(from: from, cardIndex: cardIndex, onto: onto));
      }
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

bool _playIsNew(GameState state, HintPlay play) {
  final next = applyDrop(state, play.onto, play.from, play.cardIndex);
  return !state.seenFaceUp.contains(faceUpTableKey(next));
}

bool _allTableauFaceUp(GameState state) {
  for (final pile in state.tableau) {
    for (final card in pile) {
      if (!card.faceUp) return false;
    }
  }
  return true;
}

String _playKey(HintPlay play) =>
    '${play.from.area.name}${play.from.index}:${play.cardIndex}->'
    '${play.onto.area.name}${play.onto.index}';

String describePlay(GameState state, HintPlay play) {
  final pile = getPile(state, play.from);
  if (play.cardIndex < 0 || play.cardIndex >= pile.length) {
    return _playKey(play);
  }
  final card = pile[play.cardIndex];
  final rank = rankLabel[card.rank] ?? '${card.rank}';
  final suit = suitGlyph[card.suit] ?? card.suit;
  return '$rank$suit ${play.from.area.name}${play.from.index} → '
      '${play.onto.area.name}${play.onto.index}';
}

/// Follow the first **new** Hint, else tap Stock. Record Hint / Loss / Finish.
ProbeReport probeGame(
  int seed, {
  DrawType drawType = DrawType.drawOne,
  int maxSteps = 8000,
}) {
  return probeOn(
    initMeta(seed: seed, drawType: drawType),
    seed: seed,
    maxSteps: maxSteps,
  );
}

ProbeReport probeOn(GameMeta meta, {int seed = 0, int maxSteps = 8000}) {
  var current = meta;
  final seen = <String>{};
  final notes = <String>[];
  final recentPlays = <String>[];
  VisibilitySnapshot? firstFinish;
  VisibilitySnapshot? firstPeelFinish;
  var dimmedWhileActive = false;
  var stuckNoLoss = false;
  var lossWhileNewTablePlay = false;
  var lossWhileAnyTablePlay = false;
  var peelFinishBeforeAllFaceUp = false;
  var allFaceUpNeedsTableau = false;
  var pingPongHints = false;
  var unreachableStockPlay = false;
  var steps = 0;

  ProbeReport finishUp(ProbeOutcome outcome, GameState state) {
    if (isLoss(state)) {
      final tablePlays = legalTablePlays(state);
      if (tablePlays.isNotEmpty) {
        lossWhileAnyTablePlay = true;
        if (tablePlays.any((play) => _playIsNew(state, play))) {
          lossWhileNewTablePlay = true;
          final hinted = legalHintPlays(state).toSet();
          final skipped = [
            for (final play in tablePlays)
              if (_playIsNew(state, play) && !hinted.contains(play))
                describePlay(state, play),
          ];
          notes.add(
            'loss while a non-Hint table play still leaves an unseen '
            'face-up table: ${skipped.take(5).join('; ')}',
          );
        } else {
          notes.add('loss while only repeat table plays remain');
        }
      }
    }
    return ProbeReport(
      seed: seed,
      drawType: current.present.drawType,
      outcome: outcome,
      steps: steps,
      firstFinish: firstFinish,
      firstPeelFinish: firstPeelFinish,
      dimmedWhileActive: dimmedWhileActive,
      stuckNoLoss: stuckNoLoss,
      lossWhileNewTablePlay: lossWhileNewTablePlay,
      lossWhileAnyTablePlay: lossWhileAnyTablePlay,
      peelFinishBeforeAllFaceUp: peelFinishBeforeAllFaceUp,
      allFaceUpNeedsTableau: allFaceUpNeedsTableau,
      pingPongHints: pingPongHints,
      unreachableStockPlay: unreachableStockPlay,
      terminal: state,
      notes: notes,
    );
  }

  for (; steps < maxSteps; steps++) {
    final state = current.present;
    if (state.won) {
      return finishUp(ProbeOutcome.win, state);
    }

    final cycle = hintCycle(state);
    final active = hasActiveHint(state);
    final canDraw = state.stock.isNotEmpty || state.waste.isNotEmpty;

    if (firstPeelFinish == null && canPeelFinish(state)) {
      firstPeelFinish = visibilityAt(state, steps);
      if (firstPeelFinish.faceDown > 0) {
        peelFinishBeforeAllFaceUp = true;
        notes.add(
          'peel-Finish ready with ${firstPeelFinish.faceDown} still face-down '
          '(${firstPeelFinish.faceUp} face-up)',
        );
      }
    }
    if (firstFinish == null && canFinish(state)) {
      firstFinish = visibilityAt(state, steps);
      notes.add(
        'Finish overlay at step $steps, '
        '${firstFinish.faceDown} face-down, '
        '${firstFinish.offFoundation} off Foundations',
      );
      if (active && cycle.isEmpty) {
        dimmedWhileActive = true;
        notes.add('Finish offered while Hint is dimmed (loop-stop)');
      }
      current = reduceMeta(current, const FinishMetaAction());
      continue;
    }
    if (state.stock.isEmpty &&
        _allTableauFaceUp(state) &&
        !canFinish(state) &&
        !state.won) {
      allFaceUpNeedsTableau = true;
    }

    if (active && cycle.isEmpty) {
      if (!dimmedWhileActive) {
        notes.add('Hint dimmed while an active Hint still blocks a loss');
      }
      dimmedWhileActive = true;
    }
    if (!active && cycle.isEmpty && !canDraw && !isLoss(state)) {
      if (!stuckNoLoss) {
        notes.add('no Hint, empty Stock and Waste, but not a loss');
      }
      stuckNoLoss = true;
    }
    if (active && cycle.isEmpty && !canDraw) {
      stuckNoLoss = true;
      notes.add(
        'dimmed Hint and empty Stock/Waste; loop-stop hid the only new play',
      );
      return finishUp(ProbeOutcome.stuck, state);
    }

    if (isLoss(state)) {
      return finishUp(ProbeOutcome.loss, state);
    }
    if (!seen.add(boardKey(state))) {
      if (!active && stockOrWasteCanPlay(state)) {
        unreachableStockPlay = true;
        notes.add(
          'table repeated while a Stock/Waste card can play but is not Hint-reachable',
        );
      }
      notes.add('hint-follow loop at step $steps');
      return finishUp(ProbeOutcome.hintLoop, state);
    }

    if (active && cycle.isNotEmpty) {
      final play = cycle.first;
      final preview = applyDrop(state, play.onto, play.from, play.cardIndex);
      if (!state.seenFaceUp.contains(faceUpTableKey(preview))) {
        final key = _playKey(play);
        recentPlays.add(key);
        if (recentPlays.length > 4) {
          recentPlays.removeAt(0);
        }
        if (recentPlays.length == 4 &&
            recentPlays[0] == recentPlays[2] &&
            recentPlays[1] == recentPlays[3] &&
            recentPlays[0] != recentPlays[1]) {
          pingPongHints = true;
          notes.add('Hint ping-pong ${_playKey(play)}');
        }
        current = reduceMeta(
          current,
          GameMetaAction(
            DropAction(play.onto, from: play.from, cardIndex: play.cardIndex),
          ),
        );
        continue;
      }
    }

    if (canDraw) {
      current = reduceMeta(current, const GameMetaAction(DrawAction()));
      continue;
    }

    stuckNoLoss = true;
    notes.add('no new Hint and nothing to draw, but not a loss');
    return finishUp(ProbeOutcome.stuck, state);
  }
  return finishUp(ProbeOutcome.maxSteps, current.present);
}
