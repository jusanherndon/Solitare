/// Board sizing — phone fills the screen.
library;

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

const cardRatio = 1.4;
const refCardW = 64.0;

class Insets {
  const Insets({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });
  final double top;
  final double bottom;
  final double left;
  final double right;
}

class BoardMetrics {
  const BoardMetrics({
    required this.width,
    required this.height,
    required this.landscape,
    required this.uiScale,
    required this.boardMax,
    required this.gap,
    required this.pad,
    required this.cardW,
    required this.cardH,
    required this.topCardW,
    required this.topCardH,
    required this.fan,
    required this.insets,
    required this.touch,
  });

  final double width;
  final double height;
  final bool landscape;
  final double uiScale;
  final double boardMax;
  final double gap;
  final double pad;
  final double cardW;
  final double cardH;
  final double topCardW;
  final double topCardH;
  final double fan;
  final Insets insets;
  final bool touch;
}

bool coarsePointer() {
  return defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;
}

BoardMetrics computeBoardMetrics({
  required Size size,
  required EdgeInsets padding,
  required double fontScale,
  required bool touch,
}) {
  final width = size.width;
  final height = size.height;
  final insets = Insets(
    top: padding.top,
    bottom: padding.bottom,
    left: padding.left,
    right: padding.right,
  );
  final landscape = width > height;
  final short = math.min(width, height);

  final fanRatio = landscape ? (touch ? 0.3 : 0.34) : (touch ? 0.45 : 0.36);
  final minCard = touch ? 32.0 : 28.0;
  final maxCard = touch
      ? 100.0
      : (math.min(84.0, math.max(68.0, short * 0.055))).roundToDouble();

  final pad = touch ? 8.0 : 20.0;
  final gap = touch ? 6.0 : 10.0;
  final chromeH =
      insets.top +
      insets.bottom +
      8 +
      12 +
      (48 * math.min(fontScale, 1.3)).round() +
      10 +
      (landscape ? 12 : 16) +
      (touch ? 56 : 32);

  final availW = math.max(0.0, width - insets.left - insets.right - pad * 2);
  final availH = math.max(0.0, height - chromeH);

  double fanFor(double w) {
    final inner = math.max(8.0, w - math.max(3.0, w * 0.05) * 2);
    final label = math.min(
      (inner * 0.7).roundToDouble(),
      math.max(11.0, (w * 0.24).roundToDouble()),
    );
    final inset = math.max(3.0, (w * 0.05).roundToDouble());
    final readable = label * 2 + inset + 6;
    return math.max(readable, (w * cardRatio * fanRatio).roundToDouble());
  }

  double heightFor(double w) {
    final h = w * cardRatio;
    return h + h + fanFor(w) * 6;
  }

  var cardW = ((availW - gap * 6) / 7).floorToDouble();
  cardW = math.min(cardW, maxCard);
  while (cardW > minCard && heightFor(cardW) > availH) {
    cardW -= 1;
  }
  cardW = cardW.clamp(minCard, maxCard);

  final cardH = cardW * cardRatio;
  final maxFan = ((availH - cardH - cardH) / 6).floorToDouble();
  final fan = math.max(
    8.0,
    math.min(fanFor(cardW), maxFan > 0 ? maxFan : fanFor(cardW)),
  );
  final boardMax = 7 * cardW + 6 * gap + pad * 2;
  final chromeScale = math.max(
    0.9,
    math.min(touch ? 1.15 : 1.05, cardW / refCardW),
  );
  final uiScale = chromeScale * fontScale;

  return BoardMetrics(
    width: width,
    height: height,
    landscape: landscape,
    uiScale: uiScale,
    boardMax: boardMax,
    gap: gap,
    pad: pad,
    cardW: cardW,
    cardH: cardH,
    topCardW: cardW,
    topCardH: cardH,
    fan: fan,
    insets: insets,
    touch: touch,
  );
}
