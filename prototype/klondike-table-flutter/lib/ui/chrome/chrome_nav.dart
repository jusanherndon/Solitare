import 'package:flutter/widgets.dart';

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
    required this.onConfirmDiscard,
    required this.onCancelConfirm,
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
  final VoidCallback onConfirmDiscard;
  final VoidCallback onCancelConfirm;
}
