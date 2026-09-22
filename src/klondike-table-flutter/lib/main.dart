/// Felt-banner chrome + table, matching the v1 spec.
library;

import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'game/codec.dart';
import 'game/deal.dart';
import 'game/finish.dart';
import 'game/history.dart';
import 'game/loss.dart';
import 'game/resume_store.dart';
import 'game/rules.dart';
import 'game/settings_store.dart';
import 'game/winning_deal.dart';
import 'host.dart' as host;
import 'ui/chrome/chrome_nav.dart';
import 'ui/chrome/variant_a.dart';
import 'ui/klondike_table.dart';

void main() {
  runApp(KlondikePrototypeApp());
}

enum _Screen { start, about, settings, table, finish, finishing, win, loss }

class KlondikePrototypeApp extends StatelessWidget {
  KlondikePrototypeApp({
    super.key,
    ResumeStore? store,
    SettingsStore? settings,
    host.OpenUrl? openUrl,
    Random? winningDealRandom,
  }) : store = store ?? FileResumeStore(),
       settings = settings ?? FileSettingsStore(),
       openUrl = openUrl ?? host.openUrl,
       winningDealRandom = winningDealRandom ?? Random();

  final ResumeStore store;
  final SettingsStore settings;
  final host.OpenUrl openUrl;
  final Random winningDealRandom;

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
      home: KlondikeSession(
        store: store,
        settings: settings,
        openUrl: openUrl,
        winningDealRandom: winningDealRandom,
      ),
    );
  }
}

class KlondikeSession extends StatefulWidget {
  const KlondikeSession({
    super.key,
    required this.store,
    required this.settings,
    required this.openUrl,
    required this.winningDealRandom,
  });

  final ResumeStore store;
  final SettingsStore settings;
  final host.OpenUrl openUrl;
  final Random winningDealRandom;

  @override
  State<KlondikeSession> createState() => _KlondikeSessionState();
}

class _KlondikeSessionState extends State<KlondikeSession> {
  _Screen _screen = _Screen.start;
  GameMeta? _saved;
  GameMeta? _table;
  bool _confirm = false;
  bool _confirmWinning = false;
  bool _booted = false;
  bool _drawThree = false;
  bool _fastFinish = false;
  bool _leftHanded = false;
  bool _wasteOnLeft = false;
  bool _debug = false;
  String? _debugNotice;

  @override
  void initState() {
    super.initState();
    unawaited(_boot());
  }

  Future<void> _boot() async {
    final saved = await widget.store.load();
    final drawThree = await widget.settings.loadDrawThree();
    final fastFinish = await widget.settings.loadFastFinish();
    final leftHanded = await widget.settings.loadLeftHanded();
    final wasteOnLeft = await widget.settings.loadWasteOnLeft();
    final debug = await widget.settings.loadDebug();
    if (!mounted) return;
    setState(() {
      _saved = saved;
      _drawThree = drawThree;
      _fastFinish = fastFinish;
      _leftHanded = leftHanded;
      _wasteOnLeft = wasteOnLeft;
      _debug = debug;
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

  void _dealToTable({bool fromPool = false, int? seed}) {
    final drawType = _drawThree ? DrawType.drawThree : DrawType.drawOne;
    final used = fromPool
        ? pickWinningDealSeed(drawType, widget.winningDealRandom)
        : seed ?? DateTime.now().millisecondsSinceEpoch;
    final meta = initMeta(seed: used, drawType: drawType);
    setState(() {
      _table = meta;
      _screen = _Screen.table;
      _confirm = false;
      _confirmWinning = false;
      _debugNotice = null;
    });
    unawaited(_persistUnfinished(meta));
  }

  Future<void> _setDebugNotice(String notice) async {
    if (!mounted) return;
    setState(() => _debugNotice = notice);
  }

  Future<void> _copySeed() async {
    final seed = _table?.present.seed;
    if (seed == null) {
      await _setDebugNotice('No seed. Deal a Game first.');
      return;
    }
    await Clipboard.setData(ClipboardData(text: '$seed'));
    await _setDebugNotice('Copied seed $seed');
  }

  Future<void> _dealClipboardSeed() async {
    final data = await Clipboard.getData('text/plain');
    final seed = int.tryParse(data?.text?.trim() ?? '');
    if (seed == null) {
      await _setDebugNotice('Clipboard is not a seed.');
      return;
    }
    _dealToTable(seed: seed);
    await _setDebugNotice('Dealt seed $seed');
  }

  Future<void> _copyGame() async {
    final table = _table ?? _saved;
    if (table == null) {
      await _setDebugNotice('No Game to copy.');
      return;
    }
    await Clipboard.setData(ClipboardData(text: encodeMeta(table)));
    await _setDebugNotice('Copied Game snapshot');
  }

  Future<void> _loadGame() async {
    final data = await Clipboard.getData('text/plain');
    final raw = data?.text;
    if (raw == null || raw.trim().isEmpty) {
      await _setDebugNotice('Clipboard is empty.');
      return;
    }
    try {
      final meta = decodeMeta(raw);
      setState(() {
        _table = meta;
        _screen = _playScreen(meta);
        _confirm = false;
        _confirmWinning = false;
        _debugNotice = 'Loaded Game';
      });
      if (_screen == _Screen.win || _screen == _Screen.loss) {
        unawaited(_clearSaved());
        return;
      }
      unawaited(_persistUnfinished(meta));
    } on Object {
      await _setDebugNotice('Clipboard is not a Game snapshot.');
    }
  }

  bool _offersFinish(GameMeta meta) =>
      canFinish(meta.present) && !meta.finishContinued && !meta.present.won;

  _Screen _playScreen(GameMeta meta) {
    if (meta.present.won) return _Screen.win;
    if (_offersFinish(meta)) return _Screen.finish;
    if (isLoss(meta.present)) return _Screen.loss;
    return _Screen.table;
  }

  void _onAction(MetaAction action) {
    final current = _table;
    if (current == null) return;
    final next = reduceMeta(current, action);
    if (_screen == _Screen.finishing) {
      setState(() => _table = next);
      if (next.present.won) {
        setState(() => _screen = _Screen.win);
        unawaited(_clearSaved());
      }
      return;
    }
    final screen = _playScreen(next);
    setState(() {
      _table = next;
      _screen = screen;
    });
    if (screen == _Screen.win || screen == _Screen.loss) {
      unawaited(_clearSaved());
      return;
    }
    unawaited(_persistUnfinished(next));
  }

  void _requestDeal({required bool fromPool, required bool wouldDiscard}) {
    if (wouldDiscard) {
      setState(() {
        _confirm = true;
        _confirmWinning = fromPool;
      });
      return;
    }
    _dealToTable(fromPool: fromPool);
  }

  ChromeNav _nav(BuildContext context) {
    return ChromeNav(
      showResume: _saved != null,
      bottomInset: MediaQuery.paddingOf(context).bottom,
      onNewGame: () =>
          _requestDeal(fromPool: false, wouldDiscard: _saved != null),
      onWinningDeal: () =>
          _requestDeal(fromPool: true, wouldDiscard: _saved != null),
      onResume: () => setState(() {
        final saved = _saved;
        if (saved == null) return;
        _table = saved;
        _screen = _playScreen(saved);
      }),
      onAbout: () => setState(() => _screen = _Screen.about),
      onSettings: () => setState(() => _screen = _Screen.settings),
      drawThree: _drawThree,
      onToggleDrawThree: () {
        final next = !_drawThree;
        setState(() => _drawThree = next);
        unawaited(widget.settings.saveDrawThree(next));
      },
      fastFinish: _fastFinish,
      onToggleFastFinish: () {
        final next = !_fastFinish;
        setState(() => _fastFinish = next);
        unawaited(widget.settings.saveFastFinish(next));
      },
      leftHanded: _leftHanded,
      onToggleLeftHanded: () {
        final next = !_leftHanded;
        setState(() => _leftHanded = next);
        unawaited(widget.settings.saveLeftHanded(next));
      },
      wasteOnLeft: _wasteOnLeft,
      onToggleWasteOnLeft: () {
        final next = !_wasteOnLeft;
        setState(() => _wasteOnLeft = next);
        unawaited(widget.settings.saveWasteOnLeft(next));
      },
      debug: _debug,
      onToggleDebug: () {
        final next = !_debug;
        setState(() {
          _debug = next;
          _debugNotice = null;
        });
        unawaited(widget.settings.saveDebug(next));
      },
      debugLine: _table == null
          ? null
          : debugGameLine(_table!.present, undos: _table!.past.length),
      debugNotice: _debugNotice,
      onCopySeed: () {
        unawaited(_copySeed());
      },
      onDealClipboardSeed: () {
        unawaited(_dealClipboardSeed());
      },
      onCopyGame: () {
        unawaited(_copyGame());
      },
      onLoadGame: () {
        unawaited(_loadGame());
      },
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
      onWinWinningDeal: () => _dealToTable(fromPool: true),
      onLossStart: () {
        unawaited(_clearSaved());
        setState(() {
          _table = null;
          _screen = _Screen.start;
        });
      },
      onLossNewGame: _dealToTable,
      onLossWinningDeal: () => _dealToTable(fromPool: true),
      onLossUndo: () {
        _onAction(const UndoMetaAction());
      },
      confirmActionLabel: _confirmWinning ? 'Winning deal' : 'New Game',
      onConfirmDiscard: () => _dealToTable(fromPool: _confirmWinning),
      onCancelConfirm: () => setState(() {
        _confirm = false;
        _confirmWinning = false;
      }),
      onFinish: () => setState(() => _screen = _Screen.finishing),
      onContinueFinish: () => _onAction(const ContinueFinishMetaAction()),
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
              _screen != _Screen.about &&
              _screen != _Screen.settings)
            Stack(
              children: [
                KlondikeTable(
                  meta: table,
                  playEnabled: _screen == _Screen.table,
                  finishing: _screen == _Screen.finishing,
                  fastFinish: _fastFinish,
                  leftHanded: _leftHanded,
                  wasteOnLeft: _wasteOnLeft,
                  debug: _debug,
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
                  onRequestNewGame: () =>
                      _requestDeal(fromPool: false, wouldDiscard: true),
                ),
                if (_screen == _Screen.finish) VariantAFinish(nav: nav),
                if (_screen == _Screen.win) VariantAWin(nav: nav),
                if (_screen == _Screen.loss) VariantALoss(nav: nav),
              ],
            ),
          if (_screen == _Screen.start) VariantAStart(nav: nav),
          if (_screen == _Screen.about) VariantAAbout(nav: nav),
          if (_screen == _Screen.settings) VariantASettings(nav: nav),
          if (_confirm) VariantAConfirm(nav: nav),
        ],
      ),
    );
  }
}
