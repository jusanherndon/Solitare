// ignore_for_file: avoid_print

/// Fill shipped winning-deal seed lists by following Hint.
library;

import 'dart:io';

import 'package:klondike_table/game/hint_bot.dart';
import 'package:klondike_table/game/rules.dart';

const _target = 150;
const _poolPath = 'lib/game/winning_deal_pool.dart';

void main(List<String> args) {
  final only = args.contains('--three')
      ? DrawType.drawThree
      : args.contains('--one')
      ? DrawType.drawOne
      : null;
  final existing = _readExisting();
  final one = [...existing.$1];
  final three = [...existing.$2];

  if (only == null || only == DrawType.drawOne) {
    _fill(DrawType.drawOne, one);
  }
  if (only == null || only == DrawType.drawThree) {
    _fill(DrawType.drawThree, three);
  }
  _write(one, three);
}

(List<int>, List<int>) _readExisting() {
  final file = File(_poolPath);
  if (!file.existsSync()) return ([], []);
  final text = file.readAsStringSync();
  return (
    _parseList(text, 'drawOneWinningDealSeeds'),
    _parseList(text, 'drawThreeWinningDealSeeds'),
  );
}

List<int> _parseList(String text, String name) {
  final start = text.indexOf('$name = <int>[');
  if (start < 0) return [];
  final open = text.indexOf('[', start);
  final close = text.indexOf('];', open);
  if (open < 0 || close < 0) return [];
  final body = text.substring(open + 1, close);
  return [
    for (final raw in body.split(','))
      if (int.tryParse(raw.trim()) != null) int.parse(raw.trim()),
  ];
}

void _fill(DrawType drawType, List<int> kept) {
  final label = drawType == DrawType.drawOne ? 'draw-one' : 'draw-three';
  kept.removeWhere((seed) {
    final ok = followHints(seed, drawType: drawType) == HintBotResult.win;
    if (!ok) stdout.writeln('$label drop seed=$seed');
    return !ok;
  });
  final seen = kept.toSet();
  var seed = kept.isEmpty ? 1 : (kept.reduce((a, b) => a > b ? a : b) + 1);
  var tried = 0;
  stdout.writeln('$label: have ${kept.length}, target $_target');
  while (kept.length < _target) {
    tried++;
    if (followHints(seed, drawType: drawType) == HintBotResult.win &&
        seen.add(seed)) {
      kept.add(seed);
      stdout.writeln(
        '$label win ${kept.length}/$_target seed=$seed after $tried tries',
      );
    }
    seed++;
    if (tried % 200 == 0) {
      stdout.writeln('$label tried $tried, kept ${kept.length}, seed=$seed');
    }
  }
}

void _write(List<int> one, List<int> three) {
  final buf = StringBuffer()
    ..writeln('/// Openings the hint-follow bot finished. Filled by')
    ..writeln('/// `tool/fill_winning_deals.dart`.')
    ..writeln('library;')
    ..writeln()
    ..writeln('const drawOneWinningDealSeeds = <int>[');
  for (final seed in one) {
    buf.writeln('  $seed,');
  }
  buf
    ..writeln('];')
    ..writeln()
    ..writeln('const drawThreeWinningDealSeeds = <int>[');
  for (final seed in three) {
    buf.writeln('  $seed,');
  }
  buf.writeln('];');
  File(_poolPath).writeAsStringSync(buf.toString());
  stdout.writeln(
    'wrote $_poolPath (${one.length} draw-one, ${three.length} draw-three)',
  );
}
