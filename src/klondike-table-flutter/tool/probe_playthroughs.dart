// ignore_for_file: avoid_print

/// Grind Games with the Hint-follow probe. Not shipped to the table.
///
/// ```
/// dart run tool/probe_playthroughs.dart --games 500
/// dart run tool/probe_playthroughs.dart --three --games 500
/// dart run tool/probe_playthroughs.dart --seed 42
/// ```
library;

import 'dart:io';

import 'package:klondike_table/game/playthrough_probe.dart';
import 'package:klondike_table/game/rules.dart';

void main(List<String> args) {
  final drawType = args.contains('--three')
      ? DrawType.drawThree
      : DrawType.drawOne;
  final seedIndex = args.indexOf('--seed');
  final gamesIndex = args.indexOf('--games');
  final startIndex = args.indexOf('--start');
  final examplesIndex = args.indexOf('--examples');

  final singleSeed = seedIndex >= 0 && seedIndex + 1 < args.length
      ? int.parse(args[seedIndex + 1])
      : null;
  final games = gamesIndex >= 0 && gamesIndex + 1 < args.length
      ? int.parse(args[gamesIndex + 1])
      : 200;
  final start = startIndex >= 0 && startIndex + 1 < args.length
      ? int.parse(args[startIndex + 1])
      : 1;
  final exampleCap = examplesIndex >= 0 && examplesIndex + 1 < args.length
      ? int.parse(args[examplesIndex + 1])
      : 8;

  if (singleSeed != null) {
    _printReport(probeGame(singleSeed, drawType: drawType));
    return;
  }

  final summary = _Summary(drawType: drawType, exampleCap: exampleCap);
  for (var i = 0; i < games; i++) {
    final seed = start + i;
    summary.add(probeGame(seed, drawType: drawType));
    if ((i + 1) % 50 == 0) {
      stderr.writeln('probed ${i + 1}/$games');
    }
  }
  stdout.write(summary.render());
}

void _printReport(ProbeReport report) {
  stdout.writeln(
    '${report.drawType.name} seed=${report.seed} ${report.outcome.name} '
    'steps=${report.steps}',
  );
  if (report.firstFinish != null) {
    stdout.writeln('  Finish: ${_snap(report.firstFinish!)}');
  }
  if (report.firstPeelFinish != null) {
    stdout.writeln('  peel-Finish: ${_snap(report.firstPeelFinish!)}');
  }
  final flags = <String>[
    if (report.dimmedWhileActive) 'dimmedWhileActive',
    if (report.stuckNoLoss) 'stuckNoLoss',
    if (report.lossWhileNewTablePlay) 'lossWhileNewTablePlay',
    if (report.lossWhileAnyTablePlay) 'lossWhileAnyTablePlay',
    if (report.lossWhileStillWinnable) 'lossWhileStillWinnable',
    if (report.peelFinishBeforeAllFaceUp) 'peelFinishBeforeAllFaceUp',
    if (report.allFaceUpNeedsTableau) 'allFaceUpNeedsTableau',
    if (report.pingPongHints) 'pingPongHints',
    if (report.unreachableStockPlay) 'unreachableStockPlay',
  ];
  if (flags.isNotEmpty) stdout.writeln('  flags: ${flags.join(', ')}');
  if (report.remainingPlayKinds.isNotEmpty) {
    stdout.writeln('  remainingPlayKinds: ${report.remainingPlayKinds}');
  }
  if (report.rescuePlay != null) {
    stdout.writeln('  rescuePlay: ${report.rescuePlay}');
  }
  for (final note in report.notes) {
    stdout.writeln('  - $note');
  }
  if (report.terminal != null) {
    stdout.writeln(dumpTable(report.terminal!));
  }
}

String _snap(VisibilitySnapshot s) =>
    'step=${s.step} face-down=${s.faceDown} face-up=${s.faceUp} '
    'stock=${s.stock} off-foundations=${s.offFoundation}';

class _Summary {
  _Summary({required this.drawType, required this.exampleCap});

  final DrawType drawType;
  final int exampleCap;
  final outcomes = <ProbeOutcome, int>{};
  final peelFaceDown = <int, int>{};
  final finishOffFoundation = <int>[];
  var dimmedWhileActive = 0;
  var stuckNoLoss = 0;
  var lossWhileNewTablePlay = 0;
  var lossWhileAnyTablePlay = 0;
  var lossWhileStillWinnable = 0;
  final remainingPlayKinds = <String, int>{};
  var genuineLoss = 0;
  var peelFinishBeforeAllFaceUp = 0;
  var allFaceUpNeedsTableau = 0;
  var pingPongHints = 0;
  var unreachableStockPlay = 0;
  var finishOffered = 0;
  var peelOffered = 0;
  var minPeelFaceUp = 52;
  var maxPeelFaceDown = 0;
  int? minPeelFaceUpSeed;
  int? maxPeelFaceDownSeed;
  final examples = <String, List<ProbeReport>>{};
  var n = 0;

  void add(ProbeReport report) {
    n++;
    outcomes[report.outcome] = (outcomes[report.outcome] ?? 0) + 1;
    if (report.dimmedWhileActive) {
      dimmedWhileActive++;
      _keep('dimmedWhileActive', report);
    }
    if (report.stuckNoLoss) {
      stuckNoLoss++;
      _keep('stuckNoLoss', report);
    }
    if (report.lossWhileNewTablePlay) {
      lossWhileNewTablePlay++;
      _keep('lossWhileNewTablePlay', report);
    }
    if (report.lossWhileAnyTablePlay) {
      lossWhileAnyTablePlay++;
      _keep('lossWhileAnyTablePlay', report);
    }
    if (report.lossWhileStillWinnable) {
      lossWhileStillWinnable++;
      _keep('lossWhileStillWinnable', report);
    }
    if (report.outcome == ProbeOutcome.loss && !report.lossWhileStillWinnable) {
      genuineLoss++;
    }
    report.remainingPlayKinds.forEach((kind, count) {
      remainingPlayKinds[kind] = (remainingPlayKinds[kind] ?? 0) + count;
    });
    if (report.peelFinishBeforeAllFaceUp) {
      peelFinishBeforeAllFaceUp++;
      _keep('peelFinishBeforeAllFaceUp', report);
    }
    if (report.allFaceUpNeedsTableau) {
      allFaceUpNeedsTableau++;
      _keep('allFaceUpNeedsTableau', report);
    }
    if (report.pingPongHints) {
      pingPongHints++;
      _keep('pingPongHints', report);
    }
    if (report.unreachableStockPlay) {
      unreachableStockPlay++;
      _keep('unreachableStockPlay', report);
    }
    if (report.outcome == ProbeOutcome.hintLoop) {
      _keep('hintLoop', report);
    }
    if (report.firstFinish != null) {
      finishOffered++;
      finishOffFoundation.add(report.firstFinish!.offFoundation);
    }
    if (report.firstPeelFinish != null) {
      peelOffered++;
      final down = report.firstPeelFinish!.faceDown;
      peelFaceDown[down] = (peelFaceDown[down] ?? 0) + 1;
      final faceUp = report.firstPeelFinish!.faceUp;
      if (faceUp < minPeelFaceUp) {
        minPeelFaceUp = faceUp;
        minPeelFaceUpSeed = report.seed;
      }
      if (down > maxPeelFaceDown) {
        maxPeelFaceDown = down;
        maxPeelFaceDownSeed = report.seed;
      }
      if (down > 0) _keep('peelFinishBeforeAllFaceUp', report);
    }
  }

  void _keep(String key, ProbeReport report) {
    final list = examples.putIfAbsent(key, () => []);
    if (list.length < exampleCap) list.add(report);
  }

  String render() {
    final buf = StringBuffer()
      ..writeln('## ${drawType.name}  n=$n')
      ..writeln()
      ..writeln('### Outcomes');
    for (final outcome in ProbeOutcome.values) {
      buf.writeln('- ${outcome.name}: ${outcomes[outcome] ?? 0}');
    }
    buf
      ..writeln()
      ..writeln('### Hint / Loss / Finish flags')
      ..writeln(
        '- dimmed Hint while active Hint blocks loss: $dimmedWhileActive',
      )
      ..writeln('- stuck (no overlay): $stuckNoLoss')
      ..writeln('- Hint ping-pong: $pingPongHints')
      ..writeln('- hint-follow loop: ${outcomes[ProbeOutcome.hintLoop] ?? 0}')
      ..writeln(
        '- unreachable Stock/Waste play (draw-cycle loop): $unreachableStockPlay',
      )
      ..writeln('- loss while a new table play remains: $lossWhileNewTablePlay')
      ..writeln('- loss while any table play remains: $lossWhileAnyTablePlay')
      ..writeln(
        '- auto-lose but a remaining play still wins (premature): '
        '$lossWhileStillWinnable',
      )
      ..writeln(
        '- auto-lose with no remaining winning line (genuine): $genuineLoss',
      );
    if (remainingPlayKinds.isNotEmpty) {
      buf.writeln('- remaining play kinds at auto-lose (play counts):');
      final kinds = remainingPlayKinds.keys.toList()..sort();
      for (final kind in kinds) {
        buf.writeln('  - $kind: ${remainingPlayKinds[kind]}');
      }
    }
    buf
      ..writeln('- Finish overlay offered: $finishOffered')
      ..writeln('- peel-Finish possible: $peelOffered')
      ..writeln(
        '- peel-Finish with face-down cards still buried: $peelFinishBeforeAllFaceUp',
      )
      ..writeln(
        '- all face-up, empty Stock, but Finish false (needs Tableau): '
        '$allFaceUpNeedsTableau',
      );
    if (peelOffered > 0) {
      buf
        ..writeln()
        ..writeln('### Earliest peel-Finish visibility')
        ..writeln(
          '- fewest face-up cards when a Foundation-only peel still wins: '
          '$minPeelFaceUp / 52 (seed=$minPeelFaceUpSeed)',
        )
        ..writeln(
          '- most face-down cards still buried at that moment: '
          '$maxPeelFaceDown (seed=$maxPeelFaceDownSeed)',
        )
        ..writeln('- face-down histogram (count → games):');
      final downs = peelFaceDown.keys.toList()..sort();
      for (final d in downs) {
        buf.writeln('  - $d face-down: ${peelFaceDown[d]}');
      }
    }
    if (finishOffFoundation.isNotEmpty) {
      finishOffFoundation.sort();
      buf
        ..writeln()
        ..writeln('### Current Finish overlay')
        ..writeln(
          '- cards still off Foundations when overlay appears: '
          'min=${finishOffFoundation.first} '
          'median=${finishOffFoundation[finishOffFoundation.length ~/ 2]} '
          'max=${finishOffFoundation.last}',
        );
    }
    if (examples.isNotEmpty) {
      buf
        ..writeln()
        ..writeln('### Example seeds');
      for (final key in examples.keys) {
        buf.writeln('- $key:');
        for (final report in examples[key]!) {
          buf.writeln(
            '  - seed=${report.seed} ${report.outcome.name} '
            'steps=${report.steps}'
            '${report.rescuePlay == null ? '' : ' rescue=${report.rescuePlay}'}'
            '${report.notes.isEmpty ? '' : ' — ${report.notes.first}'}',
          );
        }
      }
    }
    return buf.toString();
  }
}
