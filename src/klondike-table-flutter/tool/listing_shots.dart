// PROTOTYPE — recapture store screenshots from the current table.
// Not part of `flutter test`. Run:
//   cd src/klondike-table-flutter && flutter test tool/listing_shots.dart

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klondike_table/game/hint.dart';
import 'package:klondike_table/game/history.dart';
import 'package:klondike_table/game/reducer.dart';
import 'package:klondike_table/game/rules.dart';
import 'package:klondike_table/ui/klondike_table.dart';

const _portrait = Size(440, 956);
const _landscape = Size(956, 440);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('write listing screenshots', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await _loadRoboto(tester);
    final seed = _pickSeed();
    final opening = initMeta(seed: seed);
    final playing = _playInto(seed);
    // ignore: avoid_print
    print(
      'seed $seed  waste ${playing.present.waste.length}  '
      'foundations ${playing.present.foundations.fold<int>(0, (n, p) => n + p.length)}',
    );

    await _shot(
      tester,
      meta: playing,
      logical: _portrait,
      padding: const EdgeInsets.only(top: 59, bottom: 34),
      file: 'portrait-play.png',
    );
    await _shot(
      tester,
      meta: playing,
      logical: _landscape,
      padding: const EdgeInsets.only(left: 59, right: 59, bottom: 21),
      file: 'landscape-play.png',
    );
    await _shot(
      tester,
      meta: opening,
      logical: _portrait,
      padding: const EdgeInsets.only(top: 59, bottom: 34),
      file: 'portrait-deal.png',
    );
  });
}

Future<void> _loadRoboto(WidgetTester tester) async {
  Future<void> load(String path) async {
    final file = File(path);
    if (!file.existsSync()) {
      throw StateError('Need $path so screenshot text is not the test boxes.');
    }
    await ui.loadFontFromList(file.readAsBytesSync(), fontFamily: 'Roboto');
  }

  await tester.runAsync(() async {
    await load('/usr/share/fonts/TTF/DejaVuSans.ttf');
    await load('/usr/share/fonts/TTF/DejaVuSans-Bold.ttf');
  });
}

int _pickSeed() {
  for (var seed = 1; seed < 80; seed++) {
    final state = _playInto(seed).present;
    final foundations = state.foundations.fold<int>(0, (n, p) => n + p.length);
    final faceDown = state.tableau.fold<int>(
      0,
      (n, pile) => n + pile.where((card) => !card.faceUp).length,
    );
    if (state.waste.isNotEmpty &&
        foundations >= 1 &&
        faceDown >= 4 &&
        state.stock.isNotEmpty) {
      return seed;
    }
  }
  return 42;
}

GameMeta _playInto(int seed) {
  var meta = initMeta(seed: seed);
  for (var step = 0; step < 28; step++) {
    final hints = hintCycle(meta.present);
    final ontoFoundation = hints
        .where((play) => play.onto.area == PileArea.foundation)
        .toList();
    if (hints.isNotEmpty && (ontoFoundation.isNotEmpty || step % 3 != 0)) {
      final play = ontoFoundation.isNotEmpty
          ? ontoFoundation.first
          : hints.first;
      meta = reduceMeta(
        meta,
        GameMetaAction(
          DropAction(play.onto, from: play.from, cardIndex: play.cardIndex),
        ),
      );
    } else {
      meta = reduceMeta(meta, const GameMetaAction(DrawAction()));
    }
  }
  return meta;
}

Future<void> _shot(
  WidgetTester tester, {
  required GameMeta meta,
  required Size logical,
  required EdgeInsets padding,
  required String file,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = logical;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  const key = Key('listing-shot');
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    final message = details.exceptionAsString();
    if (message.contains('A RenderFlex overflowed')) return;
    previous?.call(details);
  };
  try {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: MediaQueryData(size: logical, padding: padding),
          child: RepaintBoundary(
            key: key,
            child: SizedBox(
              width: logical.width,
              height: logical.height,
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  color: Color(0xFFFFFFFF),
                ),
                child: KlondikeTable(
                  meta: meta,
                  onAction: (_) {},
                  onStart: () {},
                  onRequestNewGame: () {},
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  } finally {
    FlutterError.onError = previous;
  }
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(key));
  final bytes = await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 3);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return data!.buffer.asUint8List();
  });

  final out = Directory('../../prototype/listing-visuals/shots');
  out.createSync(recursive: true);
  File('${out.path}/$file').writeAsBytesSync(bytes!);
}
