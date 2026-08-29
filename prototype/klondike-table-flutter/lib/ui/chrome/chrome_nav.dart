import 'package:flutter/widgets.dart';

enum ChromeVariant { a, b, c }

enum ChromePreview { start, about, table, win, loss }

const variantNames = {
  ChromeVariant.a: 'A — Felt banner',
  ChromeVariant.b: 'B — Letterbox',
  ChromeVariant.c: 'C — Bottom sheet',
};

/// Space reserved for the prototype switcher (not part of the design).
const prototypeBarH = 56.0;
const prototypePreviewH = 44.0;

class ChromeNav {
  const ChromeNav({
    required this.showResume,
    required this.bottomInset,
    required this.onNewGame,
    required this.onResume,
    required this.onAbout,
    required this.onBackToStart,
    required this.onSupport,
    required this.onSource,
    required this.onPrivacy,
    required this.onWinStart,
    required this.onWinNewGame,
    required this.onLossStart,
    required this.onLossNewGame,
    required this.onLossUndo,
  });

  final bool showResume;
  final double bottomInset;
  final VoidCallback onNewGame;
  final VoidCallback onResume;
  final VoidCallback onAbout;
  final VoidCallback onBackToStart;
  final VoidCallback onSupport;
  final VoidCallback onSource;
  final VoidCallback onPrivacy;
  final VoidCallback onWinStart;
  final VoidCallback onWinNewGame;
  final VoidCallback onLossStart;
  final VoidCallback onLossNewGame;
  final VoidCallback onLossUndo;
}
