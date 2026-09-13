import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klondike_table/game/rules.dart';
import 'package:klondike_table/ui/card_view.dart';

void main() {
  testWidgets('card face type stays put when the system text scaler grows', (
    tester,
  ) async {
    const card = PlayingCard(
      id: 'hearts-1',
      suit: 'hearts',
      rank: 1,
      faceUp: true,
    );

    Future<Size> rankSize(double scale) async {
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(
            size: const Size(400, 800),
            textScaler: TextScaler.linear(scale),
          ),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: CardView(card: card, size: CardSize(52, 73)),
            ),
          ),
        ),
      );
      return tester.getSize(find.text('A'));
    }

    final atDefault = await rankSize(1);
    final atDouble = await rankSize(2);
    expect(atDouble, atDefault);
  });
}
