/// Variant B — Letterbox: cinematic bars, huge type, table as the window.
library;

import 'package:flutter/widgets.dart';

import 'about_copy.dart';
import 'chrome_nav.dart';
import 'fx.dart';

const _ink = Color(0xFF07070A);
const _gold = Color(0xFFFFD54F);

class VariantBStart extends StatelessWidget {
  const VariantBStart({super.key, required this.nav});
  final ChromeNav nav;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final wide = size.width > size.height;
    final title = const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'KLONDIKE',
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 44,
            fontWeight: FontWeight.w900,
            height: 0.95,
            letterSpacing: 2,
          ),
        ),
        Text(
          'SOLITAIRE',
          style: TextStyle(
            color: _gold,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: 8,
          ),
        ),
      ],
    );
    final links = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (nav.showResume) _TextLink('Resume', onTap: nav.onResume),
        _TextLink('About', onTap: nav.onAbout),
        const SizedBox(height: 12),
        _GoldSlab('NEW GAME', onTap: nav.onNewGame),
      ],
    );
    return ColoredBox(
      color: _ink,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          28,
          prototypePreviewH + MediaQuery.paddingOf(context).top + 20,
          28,
          nav.bottomInset + 8,
        ),
        child: wide
            ? Row(
                children: [
                  Expanded(child: title),
                  SizedBox(width: 240, child: links),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [const Spacer(), title, const Spacer(), links],
              ),
      ),
    );
  }
}

class VariantBAbout extends StatefulWidget {
  const VariantBAbout({super.key, required this.nav});
  final ChromeNav nav;

  @override
  State<VariantBAbout> createState() => _VariantBAboutState();
}

class _VariantBAboutState extends State<VariantBAbout> {
  bool _licenses = false;

  @override
  Widget build(BuildContext context) {
    final nav = widget.nav;
    return ColoredBox(
      color: _ink,
      child: Stack(
        children: [
          const Positioned(
            right: -12,
            bottom: 80,
            child: IgnorePointer(
              child: Text(
                'ABOUT',
                style: TextStyle(
                  color: Color(0x14FFFFFF),
                  fontSize: 96,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              28,
              prototypePreviewH + MediaQuery.paddingOf(context).top + 8,
              28,
              nav.bottomInset + 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: _TextLink(
                    'Close',
                    onTap: _licenses
                        ? () => setState(() => _licenses = false)
                        : nav.onBackToStart,
                  ),
                ),
                Expanded(
                  child: _licenses
                      ? const Center(
                          child: Text(
                            licensesStub,
                            style: TextStyle(
                              color: Color(0xCCFFFFFF),
                              fontSize: 18,
                              height: 1.4,
                            ),
                          ),
                        )
                      : ListView(
                          children: [
                            _item(aboutAppName, huge: true),
                            _item(aboutPublisher),
                            _item(aboutVersion),
                            _item(
                              'Support  $aboutSupport',
                              onTap: nav.onSupport,
                            ),
                            _item('Source', onTap: nav.onSource),
                            _item(aboutPrivacy, onTap: nav.onPrivacy),
                            _item(
                              aboutLicenses,
                              onTap: () => setState(() => _licenses = true),
                            ),
                            _item(aboutCardArt, small: true),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(
    String t, {
    bool huge = false,
    bool small = false,
    VoidCallback? onTap,
  }) {
    final child = Padding(
      padding: EdgeInsets.only(bottom: huge ? 20 : 18),
      child: Text(
        t,
        style: TextStyle(
          color: onTap != null ? _gold : const Color(0xFFECECEC),
          fontSize: huge
              ? 28
              : small
              ? 13
              : 20,
          fontWeight: huge ? FontWeight.w900 : FontWeight.w500,
          height: 1.25,
        ),
      ),
    );
    return onTap == null ? child : GestureDetector(onTap: onTap, child: child);
  }
}

class VariantBWin extends StatelessWidget {
  const VariantBWin({super.key, required this.nav});
  final ChromeNav nav;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final bar = h * 0.2;
    return Stack(
      children: [
        const ParticleField(kind: ParticleKind.cardRain),
        Column(
          children: [
            _Bar(
              height: bar,
              child: const Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: ColoredBox(
                    color: _gold,
                    child: SizedBox(width: 48, height: 2),
                  ),
                ),
              ),
            ),
            const Expanded(child: SizedBox.expand()),
            _Bar(
              height: bar + nav.bottomInset * 0.25,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, nav.bottomInset),
                child: Column(
                  children: [
                    const Text(
                      'YOU WON!',
                      style: TextStyle(
                        color: _gold,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _TextLink('Start', onTap: nav.onWinStart),
                        _TextLink('New Game', onTap: nav.onWinNewGame),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class VariantBLoss extends StatelessWidget {
  const VariantBLoss({super.key, required this.nav});
  final ChromeNav nav;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final bar = h * 0.22;
    return Stack(
      children: [
        const GreyscaleScrim(dim: 0.25),
        Column(
          children: [
            _Bar(
              height: bar,
              color: const Color(0xF2000000),
              child: const SizedBox.expand(),
            ),
            const Expanded(child: SizedBox.expand()),
            _Bar(
              height: bar + nav.bottomInset * 0.2,
              color: const Color(0xF2000000),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 12, 20, nav.bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'you lost.',
                      style: TextStyle(
                        color: Color(0xFF8A3030),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _TextLink('Start', onTap: nav.onLossStart),
                        _TextLink('Undo', onTap: nav.onLossUndo),
                        _TextLink('New Game', onTap: nav.onLossNewGame),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.height, required this.child, this.color = _ink});
  final double height;
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: SizedBox(height: height, width: double.infinity, child: child),
    );
  }
}

class _GoldSlab extends StatelessWidget {
  const _GoldSlab(this.label, {required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ColoredBox(
        color: _gold,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _ink,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class _TextLink extends StatelessWidget {
  const _TextLink(this.label, {required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFFE0E0E0),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
