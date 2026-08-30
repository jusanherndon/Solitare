import 'package:flutter/widgets.dart';

class ChromeNav {
  const ChromeNav({
    required this.showResume,
    required this.bottomInset,
    required this.onNewGame,
    required this.onWinningDeal,
    required this.onResume,
    required this.onAbout,
    required this.onSettings,
    required this.drawThree,
    required this.onToggleDrawThree,
    required this.onBackToStart,
    required this.onSupport,
    required this.onSource,
    required this.onPrivacy,
    required this.onWinStart,
    required this.onWinNewGame,
    required this.onWinWinningDeal,
    required this.onLossStart,
    required this.onLossNewGame,
    required this.onLossWinningDeal,
    required this.onLossUndo,
    required this.confirmActionLabel,
    required this.onConfirmDiscard,
    required this.onCancelConfirm,
    required this.onFinish,
    required this.onContinueFinish,
  });

  final bool showResume;
  final double bottomInset;
  final VoidCallback onNewGame;
  final VoidCallback onWinningDeal;
  final VoidCallback onResume;
  final VoidCallback onAbout;
  final VoidCallback onSettings;
  final bool drawThree;
  final VoidCallback onToggleDrawThree;
  final VoidCallback onBackToStart;
  final VoidCallback onSupport;
  final VoidCallback onSource;
  final VoidCallback onPrivacy;
  final VoidCallback onWinStart;
  final VoidCallback onWinNewGame;
  final VoidCallback onWinWinningDeal;
  final VoidCallback onLossStart;
  final VoidCallback onLossNewGame;
  final VoidCallback onLossWinningDeal;
  final VoidCallback onLossUndo;
  final String confirmActionLabel;
  final VoidCallback onConfirmDiscard;
  final VoidCallback onCancelConfirm;
  final VoidCallback onFinish;
  final VoidCallback onContinueFinish;
}
