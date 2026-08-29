/// Three variants of start / About / win / loss chrome, switchable via a
/// floating bar, on the existing Flutter table prototype.
library;

import 'dart:async';

import 'package:flutter/widgets.dart';

import 'ui/chrome/about_copy.dart';
import 'ui/chrome/chrome_nav.dart';
import 'ui/chrome/prototype_switcher.dart';
import 'ui/chrome/variant_a.dart';
import 'ui/chrome/variant_b.dart';
import 'ui/chrome/variant_c.dart';
import 'ui/klondike_table.dart';

void main() {
  runApp(const KlondikePrototypeApp());
}

class KlondikePrototypeApp extends StatelessWidget {
  const KlondikePrototypeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: const Color(0xFF1F6B45),
      debugShowCheckedModeBanner: false,
      pageRouteBuilder: <T>(settings, builder) {
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        );
      },
      home: const ChromePrototype(),
    );
  }
}

class ChromePrototype extends StatefulWidget {
  const ChromePrototype({super.key});

  @override
  State<ChromePrototype> createState() => _ChromePrototypeState();
}

class _ChromePrototypeState extends State<ChromePrototype> {
  ChromeVariant _variant = ChromeVariant.a;
  ChromePreview _preview = ChromePreview.start;
  bool _unfinished = false;
  String? _flash;
  Timer? _flashTimer;
  final _table = GlobalKey<KlondikeTableState>();

  @override
  void dispose() {
    _flashTimer?.cancel();
    super.dispose();
  }

  void _say(String msg) {
    _flashTimer?.cancel();
    setState(() => _flash = msg);
    _flashTimer = Timer(const Duration(milliseconds: 1600), () {
      if (mounted) setState(() => _flash = null);
    });
  }

  double _bottomInset(BuildContext context) =>
      MediaQuery.paddingOf(context).bottom + prototypeBarH + 8;

  ChromeNav _nav(BuildContext context) {
    return ChromeNav(
      showResume: _unfinished,
      bottomInset: _bottomInset(context),
      onNewGame: () {
        _table.currentState?.dealNewGame();
        setState(() {
          _unfinished = true;
          _preview = ChromePreview.table;
        });
      },
      onResume: () => setState(() => _preview = ChromePreview.table),
      onAbout: () => setState(() => _preview = ChromePreview.about),
      onBackToStart: () => setState(() => _preview = ChromePreview.start),
      onSupport: () => _say('opens mail — $aboutSupport'),
      onSource: () => _say('opens browser — GitHub'),
      onPrivacy: () => _say('opens browser — Privacy Policy'),
      onWinStart: () => setState(() {
        _unfinished = false;
        _preview = ChromePreview.start;
      }),
      onWinNewGame: () {
        _table.currentState?.dealNewGame();
        setState(() {
          _unfinished = true;
          _preview = ChromePreview.table;
        });
      },
      onLossStart: () => setState(() {
        _unfinished = false;
        _preview = ChromePreview.start;
      }),
      onLossNewGame: () {
        _table.currentState?.dealNewGame();
        setState(() {
          _unfinished = true;
          _preview = ChromePreview.table;
        });
      },
      onLossUndo: () {
        _table.currentState?.undoLast();
        setState(() {
          _unfinished = true;
          _preview = ChromePreview.table;
        });
      },
    );
  }

  Widget _start(ChromeNav nav) {
    return switch (_variant) {
      ChromeVariant.a => VariantAStart(nav: nav),
      ChromeVariant.b => VariantBStart(nav: nav),
      ChromeVariant.c => VariantCStart(nav: nav),
    };
  }

  Widget _about(ChromeNav nav) {
    return switch (_variant) {
      ChromeVariant.a => VariantAAbout(nav: nav),
      ChromeVariant.b => VariantBAbout(nav: nav),
      ChromeVariant.c => VariantCAbout(nav: nav),
    };
  }

  Widget _win(ChromeNav nav) {
    return switch (_variant) {
      ChromeVariant.a => VariantAWin(nav: nav),
      ChromeVariant.b => VariantBWin(nav: nav),
      ChromeVariant.c => VariantCWin(nav: nav),
    };
  }

  Widget _loss(ChromeNav nav) {
    return switch (_variant) {
      ChromeVariant.a => VariantALoss(nav: nav),
      ChromeVariant.b => VariantBLoss(nav: nav),
      ChromeVariant.c => VariantCLoss(nav: nav),
    };
  }

  @override
  Widget build(BuildContext context) {
    final nav = _nav(context);
    final media = MediaQuery.of(context);
    final tableQuery = media.copyWith(
      padding: media.padding.copyWith(
        top: media.padding.top + prototypePreviewH + 8,
        bottom: media.padding.bottom + prototypeBarH + 8,
      ),
    );

    return ColoredBox(
      color: const Color(0xFF1F6B45),
      child: Stack(
        children: [
          Offstage(
            offstage:
                _preview == ChromePreview.start ||
                _preview == ChromePreview.about,
            child: MediaQuery(
              data: tableQuery,
              child: Stack(
                children: [
                  KlondikeTable(
                    key: _table,
                    playEnabled: _preview == ChromePreview.table,
                    onStart: () => setState(() {
                      _unfinished = true;
                      _preview = ChromePreview.start;
                    }),
                    onWon: () => setState(() {
                      _unfinished = false;
                      _preview = ChromePreview.win;
                    }),
                  ),
                  if (_preview == ChromePreview.win) _win(nav),
                  if (_preview == ChromePreview.loss) _loss(nav),
                ],
              ),
            ),
          ),
          if (_preview == ChromePreview.start) _start(nav),
          if (_preview == ChromePreview.about) _about(nav),
          if (_flash != null)
            Positioned(
              left: 24,
              right: 24,
              bottom: _bottomInset(context) + 8,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xF2111111),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    _flash!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          PrototypeSwitcher(
            variant: _variant,
            preview: _preview,
            onVariant: (v) => setState(() => _variant = v),
            onPreview: (p) => setState(() => _preview = p),
          ),
        ],
      ),
    );
  }
}
