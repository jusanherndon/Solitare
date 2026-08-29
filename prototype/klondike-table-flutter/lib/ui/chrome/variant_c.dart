/// Variant C — Bottom sheet: table (or card fan) stays the hero.
library;

import 'package:flutter/widgets.dart';

import '../card_view.dart';
import '../../game/rules.dart';
import 'about_copy.dart';
import 'chrome_nav.dart';
import 'fx.dart';

const _felt = Color(0xFF1F6B45);
const _sheet = Color(0xFFF4EFE4);
const _ink = Color(0xFF1A1A1A);

class VariantCStart extends StatelessWidget {
  const VariantCStart({super.key, required this.nav});
  final ChromeNav nav;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final wide = size.width > size.height;
    final fan = _CardFan(width: wide ? size.width * 0.42 : size.width * 0.7);
    final sheet = _Sheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _Handle(),
          Text(
            aboutAppName,
            style: const TextStyle(
              color: _ink,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          _Row('New Game', onTap: nav.onNewGame, emphasis: true),
          if (nav.showResume) _Row('Resume', onTap: nav.onResume),
          _Row('About', onTap: nav.onAbout),
          SizedBox(height: nav.bottomInset > 24 ? 4 : 8),
        ],
      ),
    );
    return ColoredBox(
      color: _felt,
      child: Padding(
        padding: EdgeInsets.only(
          top: prototypePreviewH + MediaQuery.paddingOf(context).top,
          bottom: nav.bottomInset,
        ),
        child: wide
            ? Row(
                children: [
                  Expanded(child: Center(child: fan)),
                  SizedBox(width: 300, child: sheet),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: Center(child: fan)),
                  sheet,
                ],
              ),
      ),
    );
  }
}

class VariantCAbout extends StatefulWidget {
  const VariantCAbout({super.key, required this.nav});
  final ChromeNav nav;

  @override
  State<VariantCAbout> createState() => _VariantCAboutState();
}

class _VariantCAboutState extends State<VariantCAbout> {
  bool _licenses = false;

  @override
  Widget build(BuildContext context) {
    final nav = widget.nav;
    return ColoredBox(
      color: _felt,
      child: Padding(
        padding: EdgeInsets.only(
          top: prototypePreviewH + MediaQuery.paddingOf(context).top + 8,
          bottom: nav.bottomInset,
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.78,
            width: double.infinity,
            child: _Sheet(
              child: Column(
                children: [
                  const _Handle(),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _licenses
                            ? () => setState(() => _licenses = false)
                            : nav.onBackToStart,
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
                          child: Text(
                            '‹ Start',
                            style: TextStyle(
                              color: Color(0xFF3D6B4A),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: _licenses
                        ? const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              licensesStub,
                              style: TextStyle(color: _ink, fontSize: 16),
                            ),
                          )
                        : ListView(
                            children: [
                              _Row(aboutAppName, emphasis: true),
                              _Row(aboutPublisher),
                              _Row(aboutVersion),
                              _Row(
                                'Support: $aboutSupport',
                                onTap: nav.onSupport,
                              ),
                              _Row('Source', onTap: nav.onSource),
                              _Row(aboutPrivacy, onTap: nav.onPrivacy),
                              _Row(
                                aboutLicenses,
                                onTap: () => setState(() => _licenses = true),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  8,
                                  16,
                                  16,
                                ),
                                child: Text(
                                  aboutCardArt,
                                  style: const TextStyle(
                                    color: Color(0xFF5A5A5A),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VariantCWin extends StatelessWidget {
  const VariantCWin({super.key, required this.nav});
  final ChromeNav nav;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const DimScrim(amount: 0.12),
        const PulseGlow(color: Color(0xFFFFD54F)),
        const ParticleField(kind: ParticleKind.sparkleUp),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: nav.bottomInset),
            child: _Sheet(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _Handle(),
                    const Text(
                      'You won!',
                      style: TextStyle(
                        color: Color(0xFF8A6A00),
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _Row(
                            'Start',
                            onTap: nav.onWinStart,
                            boxed: true,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _Row(
                            'New Game',
                            onTap: nav.onWinNewGame,
                            boxed: true,
                            emphasis: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class VariantCLoss extends StatelessWidget {
  const VariantCLoss({super.key, required this.nav});
  final ChromeNav nav;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const GreyscaleScrim(dim: 0.4),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: nav.bottomInset),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _Handle(color: Color(0xFF6A6A6A)),
                    const Text(
                      'You lost.',
                      style: TextStyle(
                        color: Color(0xFFCFCFCF),
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _Row(
                      'Undo',
                      onTap: nav.onLossUndo,
                      boxed: true,
                      emphasis: true,
                      dark: true,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _Row(
                            'Start',
                            onTap: nav.onLossStart,
                            boxed: true,
                            dark: true,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _Row(
                            'New Game',
                            onTap: nav.onLossNewGame,
                            boxed: true,
                            dark: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CardFan extends StatelessWidget {
  const _CardFan({required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    final w = width.clamp(120.0, 220.0);
    final card = CardSize(w * 0.45, w * 0.45 * 1.4);
    const cards = [
      PlayingCard(id: 'a', suit: 'spades', rank: 13, faceUp: true),
      PlayingCard(id: 'b', suit: 'hearts', rank: 1, faceUp: true),
      PlayingCard(id: 'c', suit: 'clubs', rank: 12, faceUp: true),
    ];
    return SizedBox(
      width: w,
      height: card.height + 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: -0.28,
            child: CardView(card: cards[0], size: card),
          ),
          Transform.translate(
            offset: Offset(w * 0.18, 8),
            child: Transform.rotate(
              angle: 0.3,
              child: CardView(card: cards[2], size: card),
            ),
          ),
          CardView(card: cards[1], size: card),
        ],
      ),
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: _sheet,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: child,
    );
  }
}

class _Handle extends StatelessWidget {
  const _Handle({this.color = const Color(0xFFC8C0B4)});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
          child: const SizedBox(width: 36, height: 4),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(
    this.label, {
    this.onTap,
    this.emphasis = false,
    this.boxed = false,
    this.dark = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool emphasis;
  final bool boxed;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      textAlign: boxed ? TextAlign.center : TextAlign.left,
      style: TextStyle(
        color: dark
            ? (emphasis ? const Color(0xFFFFD54F) : const Color(0xFFECECEC))
            : (emphasis ? const Color(0xFF1F6B45) : _ink),
        fontSize: 16,
        fontWeight: emphasis ? FontWeight.w800 : FontWeight.w600,
      ),
    );
    final inner = boxed
        ? DecoratedBox(
            decoration: BoxDecoration(
              color: dark
                  ? (emphasis
                        ? const Color(0xFF3A3A3A)
                        : const Color(0xFF1F1F1F))
                  : (emphasis
                        ? const Color(0xFFDCE8E0)
                        : const Color(0x00000000)),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: dark ? const Color(0xFF555555) : const Color(0xFFD9D0C4),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: text,
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: text,
          );
    if (onTap == null) return inner;
    return GestureDetector(onTap: onTap, child: inner);
  }
}
