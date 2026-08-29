/// Felt banner chrome — spec look A.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'about_copy.dart';
import 'chrome_nav.dart';
import 'fx.dart';

const _felt = Color(0xFF1F6B45);
const _cream = Color(0xFFF7F3EA);

class VariantAStart extends StatelessWidget {
  const VariantAStart({super.key, required this.nav});
  final ChromeNav nav;

  @override
  Widget build(BuildContext context) {
    final wide =
        MediaQuery.sizeOf(context).width > MediaQuery.sizeOf(context).height;
    final title = Text(
      aboutAppName,
      textAlign: wide ? TextAlign.left : TextAlign.center,
      style: const TextStyle(
        color: _cream,
        fontSize: 32,
        fontWeight: FontWeight.w800,
        height: 1.1,
      ),
    );
    final actions = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BannerBtn('New Game', filled: true, onTap: nav.onNewGame),
        if (nav.showResume) ...[
          const SizedBox(height: 10),
          _BannerBtn('Resume', onTap: nav.onResume),
        ],
        const SizedBox(height: 10),
        _BannerBtn('About', onTap: nav.onAbout),
      ],
    );
    return ColoredBox(
      color: _felt,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          28,
          MediaQuery.paddingOf(context).top + 24,
          28,
          nav.bottomInset + 16,
        ),
        child: wide
            ? Row(
                children: [
                  Expanded(child: title),
                  const SizedBox(width: 24),
                  SizedBox(width: 220, child: actions),
                ],
              )
            : Column(
                children: [
                  const Spacer(),
                  title,
                  const Spacer(),
                  actions,
                  const Spacer(),
                ],
              ),
      ),
    );
  }
}

class VariantAAbout extends StatefulWidget {
  const VariantAAbout({super.key, required this.nav});
  final ChromeNav nav;

  @override
  State<VariantAAbout> createState() => _VariantAAboutState();
}

class _VariantAAboutState extends State<VariantAAbout> {
  bool _licenses = false;

  @override
  Widget build(BuildContext context) {
    final nav = widget.nav;
    return ColoredBox(
      color: _felt,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          MediaQuery.paddingOf(context).top + 12,
          24,
          nav.bottomInset + 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _BannerBtn(
                  _licenses ? 'Back' : 'Start',
                  onTap: () {
                    if (_licenses) {
                      setState(() => _licenses = false);
                    } else {
                      nav.onBackToStart();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 18),
            Expanded(
              child: _licenses
                  ? const _LicenseBody()
                  : ListView(
                      children: [
                        _line(aboutAppName, big: true),
                        _line(aboutPublisher),
                        _line(aboutVersion),
                        _tap('Support: $aboutSupport', nav.onSupport),
                        _tap('Source', nav.onSource),
                        _tap(aboutPrivacy, nav.onPrivacy),
                        _tap(
                          aboutLicenses,
                          () => setState(() => _licenses = true),
                        ),
                        _line(aboutCardArt),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _line(String t, {bool big = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      t,
      style: TextStyle(
        color: _cream,
        fontSize: big ? 22 : 16,
        fontWeight: big ? FontWeight.w800 : FontWeight.w600,
      ),
    ),
  );

  Widget _tap(String t, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        t,
        style: const TextStyle(
          color: Color(0xFFFFE082),
          fontSize: 16,
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.underline,
          decorationColor: Color(0xFFFFE082),
        ),
      ),
    ),
  );
}

class VariantAWin extends StatelessWidget {
  const VariantAWin({super.key, required this.nav});
  final ChromeNav nav;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const DimScrim(amount: 0.4),
        const ParticleField(kind: ParticleKind.sparkleUp),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xE0121A14),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFFD54F)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'You won!',
                      style: TextStyle(
                        color: Color(0xFFFFD54F),
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _BannerBtn('Start', onTap: nav.onWinStart),
                    const SizedBox(height: 8),
                    _BannerBtn(
                      'New Game',
                      filled: true,
                      onTap: nav.onWinNewGame,
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

class VariantALoss extends StatelessWidget {
  const VariantALoss({super.key, required this.nav});
  final ChromeNav nav;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const GreyscaleScrim(dim: 0.5),
        const ParticleField(
          kind: ParticleKind.dustFall,
          color: Color(0xFF9E9E9E),
        ),
        Align(
          alignment: const Alignment(0, 0.25),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Padding(
              padding: EdgeInsets.only(bottom: nav.bottomInset),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xF20A0A0A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF5D1F1F)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'You lost.',
                        style: TextStyle(
                          color: Color(0xFFBDBDBD),
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _BannerBtn('Undo', filled: true, onTap: nav.onLossUndo),
                      const SizedBox(height: 8),
                      _BannerBtn('Start', onTap: nav.onLossStart),
                      const SizedBox(height: 8),
                      _BannerBtn('New Game', onTap: nav.onLossNewGame),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BannerBtn extends StatelessWidget {
  const _BannerBtn(this.label, {required this.onTap, this.filled = false});
  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF143D28) : const Color(0x59000000),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: filled ? const Color(0xFFFFD54F) : const Color(0x40FFFFFF),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class VariantAConfirm extends StatelessWidget {
  const VariantAConfirm({super.key, required this.nav});
  final ChromeNav nav;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const DimScrim(amount: 0.45),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xE0121A14),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0x40FFFFFF)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'This unfinished Game will be discarded.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFF7F3EA),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _BannerBtn(
                      'New Game',
                      filled: true,
                      onTap: nav.onConfirmDiscard,
                    ),
                    const SizedBox(height: 8),
                    _BannerBtn('Cancel', onTap: nav.onCancelConfirm),
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

class _LicenseBody extends StatelessWidget {
  const _LicenseBody();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LicenseEntry>>(
      future: LicenseRegistry.licenses.toList(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(
            child: Text(
              'Loading…',
              style: TextStyle(color: _cream, fontSize: 16),
            ),
          );
        }
        final entries = snap.data!;
        return ListView(
          children: [
            for (final e in entries) ...[
              Text(
                e.packages.join(', '),
                style: const TextStyle(
                  color: _cream,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              for (final p in e.paragraphs)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    p.text,
                    style: const TextStyle(
                      color: Color(0xCCF7F3EA),
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ],
        );
      },
    );
  }
}
