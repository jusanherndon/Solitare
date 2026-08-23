import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../game/rules.dart';

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
    final corner = math.min(
      (inner * 0.7).roundToDouble(),
      math.max(11.0, (width * 0.24).roundToDouble()),
    );
    final empty = math.min(inner, math.max(11.0, (width * 0.17).roundToDouble()));
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
                  child: Text(
                    emptyLabel!,
                    style: TextStyle(
                      color: const Color(0x73FFFFFF),
                      fontSize: empty,
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
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

    final color =
        isRed(card!.suit) ? const Color(0xFFC62828) : const Color(0xFF1A1A1A);
    final rank = rankLabel[card!.rank] ?? '?';
    final glyph = suitGlyph[card!.suit] ?? '';
    final remainH = height - pad * 2 - corner * 2 - 2;
    final center = remainH >= 18 && inner >= 18
        ? math.min((inner * 0.85).roundToDouble(), remainH)
        : 0.0;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rank,
            style: TextStyle(
              color: color,
              fontSize: corner,
              height: 1,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            glyph,
            style: TextStyle(
              color: color,
              fontSize: corner,
              height: 1,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          if (center >= 18)
            Expanded(
              child: Center(
                child: Text(
                  glyph,
                  style: TextStyle(
                    color: color,
                    fontSize: center,
                    height: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
    canvas.drawRRect(
      rrect,
      Paint()..color = const Color(0x1F000000),
    );
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
