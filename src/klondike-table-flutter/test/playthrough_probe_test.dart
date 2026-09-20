import 'package:flutter_test/flutter_test.dart';
import 'package:klondike_table/game/finish.dart';
import 'package:klondike_table/game/hint.dart';
import 'package:klondike_table/game/history.dart';
import 'package:klondike_table/game/playthrough_probe.dart';
import 'package:klondike_table/game/rules.dart';

import 'board.dart';

List<PlayingCard> _run(String suit, int through) => [
  for (var r = 1; r <= through; r++) c(suit, r),
];

void main() {
  test('Finish overlay waits until every remaining card is face-up', () {
    final state = board(
      waste: [c('spades', 13)],
      foundations: [
        _run('spades', 12),
        _run('hearts', 12),
        _run('diamonds', 12),
        _run('clubs', 12),
      ],
      tableau: [
        [c('hearts', 13)],
        [c('diamonds', 13)],
        [c('clubs', 13)],
        [],
        [],
        [],
        [],
      ],
    );
    expect(canFinish(state), isTrue);
    expect(canPeelFinish(state), isTrue);
    expect(faceDownCount(state), 0);
  });

  test(
    'peel-Finish can win with face-down Tableau cards that flip onto Foundations',
    () {
      final state = board(
        foundations: [
          _run('spades', 10),
          _run('hearts', 13),
          _run('diamonds', 13),
          _run('clubs', 13),
        ],
        tableau: [
          [
            c('spades', 13, faceUp: false),
            c('spades', 12, faceUp: false),
            c('spades', 11),
          ],
          [],
          [],
          [],
          [],
          [],
          [],
        ],
      );
      expect(canFinish(state), isFalse);
      expect(canPeelFinish(state), isTrue);
      expect(faceDownCount(state), 2);
      expect(faceUpCount(state), 50);
    },
  );

  test('probe notices peel-Finish before the overlay would appear', () {
    final state = board(
      foundations: [
        _run('spades', 10),
        _run('hearts', 13),
        _run('diamonds', 13),
        _run('clubs', 13),
      ],
      tableau: [
        [
          c('spades', 13, faceUp: false),
          c('spades', 12, faceUp: false),
          c('spades', 11),
        ],
        [],
        [],
        [],
        [],
        [],
        [],
      ],
    );
    final report = probeOn(GameMeta(present: state, past: const []));
    expect(
      report.outcome,
      ProbeOutcome.win,
      reason: 'steps=${report.steps} notes=${report.notes}',
    );
    expect(report.peelFinishBeforeAllFaceUp, isTrue);
    expect(report.firstPeelFinish!.faceDown, 2);
    expect(report.firstFinish!.faceDown, 0);
  });

  test('probe records Finish once only Foundation plays remain', () {
    final state = board(
      waste: [c('spades', 13)],
      foundations: [
        _run('spades', 12),
        _run('hearts', 12),
        _run('diamonds', 12),
        _run('clubs', 12),
      ],
      tableau: [
        [c('hearts', 13)],
        [c('diamonds', 13)],
        [c('clubs', 13)],
        [],
        [],
        [],
        [],
      ],
    );
    final report = probeOn(GameMeta(present: state, past: const []));
    expect(report.outcome, ProbeOutcome.win);
    expect(report.firstFinish, isNotNull);
    expect(report.firstFinish!.faceDown, 0);
    expect(report.firstPeelFinish, isNotNull);
    expect(report.peelFinishBeforeAllFaceUp, isFalse);
  });

  test('probe records a last-resort loss', () {
    final state = board(
      tableau: [
        [c('hearts', 2)],
        [],
        [],
        [],
        [],
        [],
        [],
      ],
    );
    final report = probeOn(GameMeta(present: state, past: const []));
    expect(report.outcome, ProbeOutcome.loss);
  });

  test(
    'probe follows a loop-stopped new play when Stock and Waste are empty',
    () {
      final opening = board(
        tableau: [
          [c('hearts', 1)],
          [],
          [],
          [],
          [],
          [],
          [],
        ],
      );
      final state = opening.copyWith(
        seenFaceUp: {faceUpTableKey(opening)},
        hintLoopStops: [
          HintLoopStop(
            cardId: 'hearts-1',
            from: const PileRef.foundation(1),
            onto: const PileRef.tableau(0),
          ),
        ],
      );
      expect(hintCycle(state), isNotEmpty);
      final report = probeOn(GameMeta(present: state, past: const []));
      expect(report.outcome, ProbeOutcome.loss);
      expect(report.stuckNoLoss, isFalse);
    },
  );
}
