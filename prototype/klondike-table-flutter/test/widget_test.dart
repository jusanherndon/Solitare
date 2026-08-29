import 'package:flutter_test/flutter_test.dart';

import 'package:klondike_table/main.dart';

void main() {
  testWidgets('Klondike table shows Undo and New Game', (tester) async {
    await tester.pumpWidget(const KlondikePrototypeApp());
    expect(find.text('Undo'), findsOneWidget);
    expect(find.text('New Game'), findsOneWidget);
  });
}
