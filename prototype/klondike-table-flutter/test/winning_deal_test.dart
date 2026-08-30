import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:klondike_table/game/rules.dart';
import 'package:klondike_table/game/winning_deal.dart';
import 'package:klondike_table/game/winning_deal_pool.dart';

void main() {
  test('pickWinningDealSeed draws a random seed from the matching pool', () {
    expect(
      pickWinningDealSeed(DrawType.drawOne, Random(0)),
      isIn(drawOneWinningDealSeeds),
    );
    expect(
      pickWinningDealSeed(DrawType.drawThree, Random(0)),
      isIn(drawThreeWinningDealSeeds),
    );
  });

  test('pickWinningDealSeed is not stuck on the first pool seed', () {
    final seeds = {
      for (var i = 0; i < 30; i++)
        pickWinningDealSeed(DrawType.drawOne, Random(i)),
    };
    expect(seeds, isNot(equals({drawOneWinningDealSeeds.first})));
    expect(seeds.length, greaterThan(1));
  });
}
