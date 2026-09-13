import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

const greyMatrix = <double>[
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0, 0, 0, 1, 0,
];

class GreyscaleScrim extends StatelessWidget {
  const GreyscaleScrim({super.key, this.dim = 0.35});

  final double dim;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: const ui.ColorFilter.matrix(greyMatrix),
      child: ColoredBox(color: Color.fromRGBO(0, 0, 0, dim)),
    );
  }
}

class DimScrim extends StatelessWidget {
  const DimScrim({super.key, this.amount = 0.45});

  final double amount;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: Color.fromRGBO(0, 0, 0, amount));
  }
}

enum ParticleKind { sparkleUp, cardRain, dustFall }

class ParticleField extends StatefulWidget {
  const ParticleField({
    super.key,
    required this.kind,
    this.color = const Color(0xFFFFD54F),
  });

  final ParticleKind kind;
  final Color color;

  @override
  State<ParticleField> createState() => _ParticleFieldState();
}

class _ParticleFieldState extends State<ParticleField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _tick;
  final _rng = math.Random(7);
  late final List<_Dot> _dots;

  @override
  void initState() {
    super.initState();
    _dots = List.generate(22, (_) => _Dot.rand(_rng));
    _tick = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _tick.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _tick,
        builder: (context, _) => CustomPaint(
          painter: _ParticlePainter(
            t: _tick.value,
            dots: _dots,
            kind: widget.kind,
            color: widget.color,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _Dot {
  _Dot(this.x, this.phase, this.size, this.speed);
  factory _Dot.rand(math.Random rng) => _Dot(
    rng.nextDouble(),
    rng.nextDouble(),
    2 + rng.nextDouble() * 6,
    0.55 + rng.nextDouble() * 0.7,
  );
  final double x;
  final double phase;
  final double size;
  final double speed;
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({
    required this.t,
    required this.dots,
    required this.kind,
    required this.color,
  });

  final double t;
  final List<_Dot> dots;
  final ParticleKind kind;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (final d in dots) {
      final u = (t * d.speed + d.phase) % 1;
      final dx = d.x * size.width;
      final dy = switch (kind) {
        ParticleKind.sparkleUp => size.height * (1 - u),
        ParticleKind.cardRain || ParticleKind.dustFall => size.height * u,
      };
      if (kind == ParticleKind.cardRain) {
        paint.color = d.phase > 0.5 ? const Color(0xFFF7F3EA) : color;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(dx, dy),
              width: d.size * 2.2,
              height: d.size * 3.1,
            ),
            const Radius.circular(2),
          ),
          paint,
        );
      } else {
        paint.color = color.withValues(
          alpha: kind == ParticleKind.dustFall ? 0.35 : 0.85,
        );
        canvas.drawCircle(Offset(dx, dy), d.size * 0.45, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => old.t != t;
}

class PulseGlow extends StatefulWidget {
  const PulseGlow({super.key, required this.color});

  final Color color;

  @override
  State<PulseGlow> createState() => _PulseGlowState();
}

class _PulseGlowState extends State<PulseGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _tick;

  @override
  void initState() {
    super.initState();
    _tick = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _tick.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _tick,
        builder: (context, _) => DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                widget.color.withValues(alpha: 0.18 + _tick.value * 0.22),
                const Color(0x00000000),
              ],
            ),
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}
