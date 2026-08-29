// PROTOTYPE — capture store-listing screenshots from the Flutter table.
// Run: flutter test test/listing_shots_test.dart
// Writes PNGs to prototype/listing-visuals/shots/

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klondike_table/game/history.dart';
import 'package:klondike_table/game/reducer.dart';
import 'package:klondike_table/game/rules.dart';
import 'package:klondike_table/ui/klondike_table.dart';

GameMeta listingPlayMeta() {
  var m = initMeta(42);
  for (var i = 0; i < 8; i++) {
    m = reduceMeta(m, const GameMetaAction(DrawAction()));
  }
  for (var t = 0; t < 7; t++) {
    final pile = m.present.tableau[t];
    if (pile.isEmpty) continue;
    m = reduceMeta(
      m,
      GameMetaAction(AutoMoveAction(PileRef.tableau(t), pile.length - 1)),
    );
  }
  if (m.present.waste.isNotEmpty) {
    m = reduceMeta(
      m,
      GameMetaAction(
        AutoMoveAction(const PileRef.waste(), m.present.waste.length - 1),
      ),
    );
  }
  return m;
}

void main() {
  setUpAll(() async {
    Future<ByteData> bytes(String path) async {
      final data = await File(path).readAsBytes();
      return ByteData.sublistView(Uint8List.fromList(data));
    }

    Future<void> load(String family, List<String> paths) async {
      final loader = FontLoader(family);
      for (final path in paths) {
        loader.addFont(bytes(path));
      }
      await loader.load();
    }

    await load('DejaVu Sans', [
      '/usr/share/fonts/TTF/DejaVuSans.ttf',
      '/usr/share/fonts/TTF/DejaVuSans-Bold.ttf',
    ]);
    await load('Noto Sans Symbols', [
      '/usr/share/fonts/noto/NotoSansSymbols-Regular.ttf',
    ]);
    await load('Noto Sans Symbols 2', [
      '/usr/share/fonts/noto/NotoSansSymbols2-Regular.ttf',
    ]);
  });

  testWidgets('write listing screenshots', (tester) async {
    final out = Directory('../listing-visuals/shots');
    out.createSync(recursive: true);

    await _capture(
      tester: tester,
      size: const Size(1080, 1920),
      padding: const EdgeInsets.fromLTRB(0, 64, 0, 48),
      meta: listingPlayMeta(),
      file: File('${out.path}/portrait-play.png'),
    );
    await _capture(
      tester: tester,
      size: const Size(1920, 1080),
      padding: const EdgeInsets.fromLTRB(64, 0, 64, 32),
      meta: listingPlayMeta(),
      file: File('${out.path}/landscape-play.png'),
    );
    await _capture(
      tester: tester,
      size: const Size(1080, 1920),
      padding: const EdgeInsets.fromLTRB(0, 64, 0, 48),
      meta: initMeta(42),
      file: File('${out.path}/portrait-deal.png'),
    );
  }, timeout: const Timeout(Duration(minutes: 1)));
}

Future<void> _capture({
  required WidgetTester tester,
  required Size size,
  required EdgeInsets padding,
  required GameMeta meta,
  required File file,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  await tester.binding.setSurfaceSize(size);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final key = GlobalKey();
  await tester.pumpWidget(
    WidgetsApp(
      color: const Color(0xFF1F6B45),
      debugShowCheckedModeBanner: false,
      pageRouteBuilder: <T>(settings, builder) {
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, __) => builder(context),
        );
      },
      home: MediaQuery(
        data: MediaQueryData(
          size: size,
          padding: padding,
          devicePixelRatio: 1,
        ),
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: RepaintBoundary(
            key: key,
            child: DefaultTextStyle(
              style: const TextStyle(
                fontFamily: 'DejaVu Sans',
                fontFamilyFallback: [
                  'Noto Sans Symbols',
                  'Noto Sans Symbols 2',
                ],
              ),
              child: KlondikeTable(
                initialMeta: meta,
                showPrototypeHint: false,
                forcePhoneMetrics: true,
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 16));
  tester.takeException();

  final boundary =
      key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 1);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    file.writeAsBytesSync(bytes!.buffer.asUint8List());
    // ignore: avoid_print
    print('wrote ${file.path} ${file.lengthSync()} bytes');
  });
}
