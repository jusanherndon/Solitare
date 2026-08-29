/// Felt-banner chrome + table, matching the v1 spec.
library;

import 'dart:async';

import 'package:flutter/widgets.dart';

import 'game/history.dart';
import 'game/resume_store.dart';
import 'game/rules.dart';
import 'host.dart' as host;
import 'ui/chrome/chrome_nav.dart';
import 'ui/chrome/variant_a.dart';
import 'ui/klondike_table.dart';

void main() {
  runApp(KlondikePrototypeApp());
}

enum _Screen { start, about, table, win, loss }

class KlondikePrototypeApp extends StatelessWidget {
  KlondikePrototypeApp({super.key, ResumeStore? store, host.OpenUrl? openUrl})
    : store = store ?? FileResumeStore(),
      openUrl = openUrl ?? host.openUrl;

  final ResumeStore store;
  final host.OpenUrl openUrl;

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
      home: KlondikeSession(store: store, openUrl: openUrl),
    );
  }
}

class KlondikeSession extends StatefulWidget {
  const KlondikeSession({
    super.key,
    required this.store,
    required this.openUrl,
  });

  final ResumeStore store;
  final host.OpenUrl openUrl;

  @override
  State<KlondikeSession> createState() => _KlondikeSessionState();
}

class _KlondikeSessionState extends State<KlondikeSession> {
  _Screen _screen = _Screen.start;
  GameMeta? _saved;
  GameMeta? _table;
  bool _confirm = false;
  bool _booted = false;

  @override
  void initState() {
    super.initState();
    unawaited(_boot());
  }

  Future<void> _boot() async {
    final saved = await widget.store.load();
    if (!mounted) return;
    setState(() {
      _saved = saved;
      _booted = true;
    });
  }

  Future<void> _persistUnfinished(GameMeta meta) async {
    _saved = meta;
    await widget.store.save(meta);
  }

  Future<void> _clearSaved() async {
    _saved = null;
    await widget.store.clear();
  }

  void _dealToTable() {
    final meta = initMeta(DateTime.now().millisecondsSinceEpoch);
    setState(() {
      _table = meta;
      _screen = _Screen.table;
      _confirm = false;
    });
    unawaited(_persistUnfinished(meta));
  }

  void _onAction(MetaAction action) {
    final current = _table;
    if (current == null) return;
    final next = reduceMeta(current, action);
    setState(() => _table = next);
    if (next.present.won) {
      unawaited(_clearSaved());
      setState(() => _screen = _Screen.win);
      return;
    }
    if (isLoss(next.present)) {
      unawaited(_clearSaved());
      setState(() => _screen = _Screen.loss);
      return;
    }
    unawaited(_persistUnfinished(next));
  }

  void _requestNewGame({required bool wouldDiscard}) {
    if (wouldDiscard) {
      setState(() => _confirm = true);
      return;
    }
    _dealToTable();
  }

  ChromeNav _nav(BuildContext context) {
    return ChromeNav(
      showResume: _saved != null,
      bottomInset: MediaQuery.paddingOf(context).bottom,
      onNewGame: () => _requestNewGame(wouldDiscard: _saved != null),
      onResume: () => setState(() {
        _table = _saved;
        _screen = _Screen.table;
      }),
      onAbout: () => setState(() => _screen = _Screen.about),
      onBackToStart: () => setState(() => _screen = _Screen.start),
      onSupport: () {
        unawaited(widget.openUrl(host.supportMailto));
      },
      onSource: () {
        unawaited(widget.openUrl(host.sourceUrl));
      },
      onPrivacy: () {
        unawaited(widget.openUrl(host.privacyUrl));
      },
      onWinStart: () {
        unawaited(_clearSaved());
        setState(() {
          _table = null;
          _screen = _Screen.start;
        });
      },
      onWinNewGame: _dealToTable,
      onLossStart: () {
        unawaited(_clearSaved());
        setState(() {
          _table = null;
          _screen = _Screen.start;
        });
      },
      onLossNewGame: _dealToTable,
      onLossUndo: () {
        final current = _table;
        if (current == null) return;
        final next = reduceMeta(current, const UndoMetaAction());
        setState(() {
          _table = next;
          _screen = isLoss(next.present) ? _Screen.loss : _Screen.table;
        });
        if (!isLoss(next.present)) {
          unawaited(_persistUnfinished(next));
        }
      },
      onConfirmDiscard: _dealToTable,
      onCancelConfirm: () => setState(() => _confirm = false),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_booted) {
      return const ColoredBox(color: Color(0xFF1F6B45));
    }
    final nav = _nav(context);
    final table = _table;
    return ColoredBox(
      color: const Color(0xFF1F6B45),
      child: Stack(
        children: [
          if (table != null &&
              _screen != _Screen.start &&
              _screen != _Screen.about)
            Stack(
              children: [
                KlondikeTable(
                  meta: table,
                  playEnabled: _screen == _Screen.table,
                  onAction: _onAction,
                  onStart: () {
                    final m = _table;
                    if (m == null) return;
                    unawaited(_persistUnfinished(m));
                    setState(() {
                      _confirm = false;
                      _screen = _Screen.start;
                    });
                  },
                  onRequestNewGame: () => _requestNewGame(wouldDiscard: true),
                ),
                if (_screen == _Screen.win) VariantAWin(nav: nav),
                if (_screen == _Screen.loss) VariantALoss(nav: nav),
              ],
            ),
          if (_screen == _Screen.start) VariantAStart(nav: nav),
          if (_screen == _Screen.about) VariantAAbout(nav: nav),
          if (_confirm) VariantAConfirm(nav: nav),
        ],
      ),
    );
  }
}
