import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../game/rules.dart';

/// iOS suit glyphs sit small in the em square compared with Android.
double _suitSize(double size) {
  if (defaultTargetPlatform != TargetPlatform.iOS) return size;
  return math.max(1, (size * 1.2).roundToDouble());
}

Widget _faceText(
  String text, {
  required Color color,
  required double fontSize,
  FontWeight weight = FontWeight.w700,
  double letterSpacing = 0,
}) {
  return Text(
    text,
    textScaler: TextScaler.noScaling,
    style: TextStyle(
      color: color,
      fontSize: fontSize,
      height: 1,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      leadingDistribution: TextLeadingDistribution.even,
    ),
  );
}

class CardSize {
  const CardSize(this.width, this.height);
  final double width;
  final double height;
}

class CardView extends StatelessWidget {
  const CardView({
    super.key,
    this.card,
    required this.size,
    this.emptyLabel,
    this.selected = false,
  });

  final PlayingCard? card;
  final CardSize size;
  final String? emptyLabel;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final width = size.width;
    final height = size.height;
    final pad = math.max(3.0, width * 0.05);
    final inner = math.max(8.0, width - pad * 2);
    final innerH = math.max(8.0, height - pad * 2);
    var cornerRank = math.min(
      (inner * 0.7).roundToDouble(),
      math.max(22.0, (width * 0.42).roundToDouble()),
    );
    var cornerSuit = math.max(11.0, (cornerRank * 0.45).roundToDouble());
    final needed = cornerRank + cornerSuit + 2;
    if (needed > innerH) {
      final fit = innerH / needed;
      cornerRank = (cornerRank * fit).floorToDouble();
      cornerSuit = (cornerSuit * fit).floorToDouble();
    }
    final empty = math.min(
      innerH,
      math.max(11.0, (width * 0.17).roundToDouble()),
    );
    final radius = math.max(6.0, (width * 0.1).roundToDouble());

    if (card == null) {
      return CustomPaint(
        painter: _DashedSlotPainter(radius: radius),
        child: SizedBox(
          width: width,
          height: height,
          child: emptyLabel == null || emptyLabel!.isEmpty
              ? null
              : Center(
                  child: _faceText(
                    emptyLabel!,
                    color: const Color(0x73FFFFFF),
                    fontSize: empty,
                    weight: FontWeight.w600,
                  ),
                ),
        ),
      );
    }

    if (!card!.faceUp) {
      return Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(pad),
        decoration: BoxDecoration(
          color: const Color(0xFF1E3A5F),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: const Color(0x59FFFFFF)),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFF2A5080),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: const Color(0x33FFFFFF)),
          ),
        ),
      );
    }

    final color = isRed(card!.suit)
        ? const Color(0xFFC62828)
        : const Color(0xFF1A1A1A);
    final rank = rankLabel[card!.rank] ?? '?';
    final glyph = suitGlyph[card!.suit] ?? '';
    final center = math
        .max(16.0, math.min(inner * 0.48, height * 0.28))
        .roundToDouble();

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F3EA),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0xFFCFC6B4)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _faceText(
                rank,
                color: color,
                fontSize: cornerRank,
                letterSpacing: -0.5,
              ),
              _faceText(
                glyph,
                color: color,
                fontSize: _suitSize(cornerSuit),
                letterSpacing: -0.5,
              ),
            ],
          ),
          Align(
            alignment: const Alignment(0, 0.45),
            child: _faceText(
              glyph,
              color: color,
              fontSize: _suitSize(center),
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedSlotPainter extends CustomPainter {
  _DashedSlotPainter({required this.radius});
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0.75, 0.75, size.width - 1.5, size.height - 1.5),
      Radius.circular(radius),
    );
    canvas.drawRRect(rrect, Paint()..color = const Color(0x1F000000));
    final path = Path()..addRRect(rrect);
    final dashed = _dash(path, 5, 4);
    canvas.drawPath(
      dashed,
      Paint()
        ..color = const Color(0x47FFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  Path _dash(Path source, double dash, double gap) {
    final out = Path();
    for (final metric in source.computeMetrics()) {
      var dist = 0.0;
      var draw = true;
      while (dist < metric.length) {
        final next = math.min(metric.length, dist + (draw ? dash : gap));
        if (draw) {
          out.addPath(metric.extractPath(dist, next), Offset.zero);
        }
        dist = next;
        draw = !draw;
      }
    }
    return out;
  }

  @override
  bool shouldRepaint(covariant _DashedSlotPainter oldDelegate) =>
      oldDelegate.radius != radius;
}
