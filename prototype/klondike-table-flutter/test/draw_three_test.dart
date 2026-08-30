import 'package:flutter_test/flutter_test.dart';
import 'package:klondike_table/game/codec.dart';
import 'package:klondike_table/game/deal.dart';
import 'package:klondike_table/game/history.dart';
import 'package:klondike_table/game/reducer.dart';
import 'package:klondike_table/game/rules.dart';

import 'board.dart';

void main() {
  test('a draw-one Stock tap moves one card onto the Waste', () {
    final state = board(
      stock: [c('clubs', 4, faceUp: false), c('hearts', 9, faceUp: false)],
    );
    final next = reduce(state, const DrawAction());
    expect(next.waste, hasLength(1));
    expect(next.waste.single.suit, 'hearts');
    expect(next.waste.single.faceUp, isTrue);
    expect(next.stock, hasLength(1));
  });

  test('a draw-three Stock tap moves three cards onto the Waste', () {
    final state = board(
      drawType: DrawType.drawThree,
      stock: [for (var r = 1; r <= 5; r++) c('clubs', r, faceUp: false)],
    );
    final next = reduce(state, const DrawAction());
    expect(next.waste.map((card) => card.rank).toList(), [5, 4, 3]);
    expect(next.waste.every((card) => card.faceUp), isTrue);
    expect(next.stock, hasLength(2));
  });

  test('draw-three with two left in Stock draws those two', () {
    final state = board(
      drawType: DrawType.drawThree,
      stock: [c('spades', 2, faceUp: false), c('spades', 1, faceUp: false)],
    );
    final next = reduce(state, const DrawAction());
    expect(next.waste.map((card) => card.rank).toList(), [1, 2]);
    expect(next.stock, isEmpty);
  });

  test('only the Waste top is playable in draw-three', () {
    final state = board(
      drawType: DrawType.drawThree,
      waste: [c('clubs', 1), c('hearts', 5)],
      foundations: const [[], [], [], []],
    );
    final selected = applySelect(state, const PileRef.waste(), 0);
    expect(selected.selection!.cardIndex, state.waste.length - 1);
    expect(selected.selection!.from.area, PileArea.waste);
  });

  test('Undo of a draw-three Stock tap returns every card that tap moved', () {
    final opening = board(
      drawType: DrawType.drawThree,
      stock: [for (var r = 1; r <= 4; r++) c('diamonds', r, faceUp: false)],
    );
    var meta = GameMeta(present: opening, past: const []);
    meta = reduceMeta(meta, const GameMetaAction(DrawAction()));
    expect(meta.present.waste, hasLength(3));
    meta = reduceMeta(meta, const UndoMetaAction());
    expect(meta.present.waste, isEmpty);
    expect(meta.present.stock, hasLength(4));
    expect(meta.present.drawType, DrawType.drawThree);
  });

  test('recycle of draw-three Waste onto Stock reverses order face-down', () {
    final state = board(
      drawType: DrawType.drawThree,
      waste: [c('clubs', 1), c('clubs', 2), c('clubs', 3)],
    );
    final next = reduce(state, const DrawAction());
    expect(next.waste, isEmpty);
    expect(next.stock.map((card) => card.rank).toList(), [3, 2, 1]);
    expect(next.stock.every((card) => !card.faceUp), isTrue);
  });

  test('dealGame records the Game draw type', () {
    final one = dealGame(seed: 1);
    final three = dealGame(seed: 1, drawType: DrawType.drawThree);
    expect(one.drawType, DrawType.drawOne);
    expect(three.drawType, DrawType.drawThree);
    expect(one.stock.length, three.stock.length);
  });

  test('Resume codec round-trips draw-three', () {
    final meta = GameMeta(
      present: dealGame(seed: 7, drawType: DrawType.drawThree),
      past: const [],
    );
    final restored = decodeMeta(encodeMeta(meta));
    expect(restored.present.drawType, DrawType.drawThree);
    expect(restored.present.stock.length, meta.present.stock.length);
  });

  test('a selection does not drop the Game draw type', () {
    final state = board(drawType: DrawType.drawThree, waste: [c('clubs', 1)]);
    final next = reduce(state, const TapAction(PileRef.waste()));
    expect(next.drawType, DrawType.drawThree);
    expect(next.selection, isNotNull);
  });
}
