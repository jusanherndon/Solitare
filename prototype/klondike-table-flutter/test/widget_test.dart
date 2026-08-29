import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:klondike_table/main.dart';
import 'package:klondike_table/ui/chrome/chrome_nav.dart';

void main() {
  testWidgets('Start screen shows New Game and About', (tester) async {
    await tester.pumpWidget(const KlondikePrototypeApp());
    expect(find.text('Klondike Solitaire'), findsWidgets);
    expect(find.text('New Game'), findsOneWidget);
    expect(find.text('About'), findsWidgets);
    expect(find.text('Undo'), findsNothing);
  });

  testWidgets('preview chips and variants build without overflow', (
    tester,
  ) async {
    Future<void> walk() async {
      const previews = [
        ChromePreview.start,
        ChromePreview.about,
        ChromePreview.table,
        ChromePreview.win,
        ChromePreview.loss,
      ];
      for (var v = 0; v < 3; v++) {
        for (final p in previews) {
          await tester.tap(find.byKey(ValueKey('preview-$p')));
          await tester.pump();
        }
        await tester.tap(find.text('→'));
        await tester.pump();
      }
    }

    await tester.pumpWidget(const KlondikePrototypeApp());
    await walk();

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pump();
    await walk();
  });
}
