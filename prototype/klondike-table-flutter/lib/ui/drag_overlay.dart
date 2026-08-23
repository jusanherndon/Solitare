import 'package:flutter/widgets.dart';

import '../game/rules.dart';
import 'card_view.dart';

class DragVisual {
  const DragVisual({
    required this.cards,
    required this.origin,
    required this.delta,
    required this.size,
    required this.fanOffset,
  });

  final List<PlayingCard> cards;
  final Offset origin;
  final Offset delta;
  final CardSize size;
  final double fanOffset;

  DragVisual copyWith({Offset? delta}) => DragVisual(
        cards: cards,
        origin: origin,
        delta: delta ?? this.delta,
        size: size,
        fanOffset: fanOffset,
      );
}

class DragController extends ChangeNotifier {
  DragVisual? visual;

  void setVisual(DragVisual? next) {
    visual = next;
    notifyListeners();
  }

  void updateOffset(Offset delta) {
    final current = visual;
    if (current == null) return;
    visual = current.copyWith(delta: delta);
    notifyListeners();
  }
}

class DragOverlay extends StatelessWidget {
  const DragOverlay({super.key, required this.controller});
  final DragController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final visual = controller.visual;
        if (visual == null) return const SizedBox.shrink();
        return IgnorePointer(
          child: Stack(
            children: [
              for (var i = 0; i < visual.cards.length; i++)
                Positioned(
                  left: visual.origin.dx + visual.delta.dx,
                  top: visual.origin.dy +
                      visual.delta.dy +
                      i * visual.fanOffset,
                  child: CardView(card: visual.cards[i], size: visual.size),
                ),
            ],
          ),
        );
      },
    );
  }
}

class HitRegistry {
  final _boxes = <PileRef, RenderBox>{};

  void register(PileRef pile, RenderBox? box) {
    if (box == null) {
      _boxes.remove(pile);
    } else {
      _boxes[pile] = box;
    }
  }

  PileRef? hitTest(Offset global) {
    PileRef? best;
    var bestArea = double.infinity;
    for (final entry in _boxes.entries) {
      final box = entry.value;
      if (!box.hasSize || !box.attached) continue;
      final origin = box.localToGlobal(Offset.zero);
      final rect = origin & box.size;
      if (rect.contains(global)) {
        final area = rect.width * rect.height;
        if (area < bestArea) {
          bestArea = area;
          best = entry.key;
        }
      }
    }
    return best;
  }
}
