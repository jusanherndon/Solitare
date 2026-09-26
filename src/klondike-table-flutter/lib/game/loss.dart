/// Last-resort loss: no active Hint, no Stock/Waste play the player can turn up.
library;

import 'hint.dart';
import 'reducer.dart';
import 'rules.dart';

export 'reducer.dart' show cardCanPlayOnTable, stockOrWasteCanPlay;

bool isLoss(GameState state) =>
    !state.won && !hasActiveHint(state) && !stockOrWasteCanPlay(state);
