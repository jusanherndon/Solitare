/// Pick a shipped **winning deal** seed for the Settings draw type.
library;

import 'dart:math';

import 'rules.dart';
import 'winning_deal_pool.dart';

List<int> winningDealSeeds(DrawType drawType) => drawType == DrawType.drawThree
    ? drawThreeWinningDealSeeds
    : drawOneWinningDealSeeds;

int pickWinningDealSeed(DrawType drawType, [Random? random]) {
  final pool = winningDealSeeds(drawType);
  return pool[(random ?? Random()).nextInt(pool.length)];
}
