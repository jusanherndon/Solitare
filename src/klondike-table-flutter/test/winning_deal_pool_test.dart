import 'package:flutter_test/flutter_test.dart';
import 'package:klondike_table/game/hint_bot.dart';
import 'package:klondike_table/game/rules.dart';
import 'package:klondike_table/game/winning_deal_pool.dart';

void main() {
  test('draw-one pool is 100–200 unique seeds', () {
    expect(drawOneWinningDealSeeds, hasLength(inInclusiveRange(100, 200)));
    expect(
      drawOneWinningDealSeeds.toSet(),
      hasLength(drawOneWinningDealSeeds.length),
    );
  });

  test('draw-three pool is 100–200 unique seeds, separate from draw-one', () {
    expect(drawThreeWinningDealSeeds, hasLength(inInclusiveRange(100, 200)));
    expect(
      drawThreeWinningDealSeeds.toSet(),
      hasLength(drawThreeWinningDealSeeds.length),
    );
    expect(
      drawThreeWinningDealSeeds,
      isNot(orderedEquals(drawOneWinningDealSeeds)),
    );
  });

  test('hint bot still wins every draw-one pool seed', () {
    for (final seed in drawOneWinningDealSeeds) {
      expect(
        followHints(seed),
        HintBotResult.win,
        reason: 'draw-one seed $seed',
      );
    }
  });

  test('hint bot still wins every draw-three pool seed', () {
    for (final seed in drawThreeWinningDealSeeds) {
      expect(
        followHints(seed, drawType: DrawType.drawThree),
        HintBotResult.win,
        reason: 'draw-three seed $seed',
      );
    }
  });
}
