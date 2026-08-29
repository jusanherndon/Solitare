import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'chrome_nav.dart';

class PrototypeSwitcher extends StatelessWidget {
  const PrototypeSwitcher({
    super.key,
    required this.variant,
    required this.preview,
    required this.onVariant,
    required this.onPreview,
  });

  final ChromeVariant variant;
  final ChromePreview preview;
  final ValueChanged<ChromeVariant> onVariant;
  final ValueChanged<ChromePreview> onPreview;

  void _step(int delta) {
    const all = ChromeVariant.values;
    final i = (variant.index + delta) % all.length;
    onVariant(all[i < 0 ? i + all.length : i]);
  }

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.of(context).padding;
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          _step(-1);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          _step(1);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Stack(
        children: [
          Positioned(
            top: insets.top + 4,
            left: 8,
            right: 8,
            child: _PreviewChips(preview: preview, onPreview: onPreview),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: insets.bottom + 8,
            child: _VariantBar(
              variant: variant,
              onPrev: () => _step(-1),
              onNext: () => _step(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewChips extends StatelessWidget {
  const _PreviewChips({required this.preview, required this.onPreview});

  final ChromePreview preview;
  final ValueChanged<ChromePreview> onPreview;

  @override
  Widget build(BuildContext context) {
    const labels = {
      ChromePreview.start: 'Start',
      ChromePreview.about: 'About',
      ChromePreview.table: 'Table',
      ChromePreview.win: 'Win',
      ChromePreview.loss: 'Loss',
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xF2111111),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFFFE082), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          children: [
            for (final p in ChromePreview.values)
              Expanded(
                child: GestureDetector(
                  key: ValueKey('preview-$p'),
                  onTap: () => onPreview(p),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      labels[p]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: p == preview
                            ? const Color(0xFFFFE082)
                            : const Color(0xCCFFFFFF),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _VariantBar extends StatelessWidget {
  const _VariantBar({
    required this.variant,
    required this.onPrev,
    required this.onNext,
  });

  final ChromeVariant variant;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xF2111111),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFFFE082), width: 1.5),
        boxShadow: const [BoxShadow(color: Color(0x80000000), blurRadius: 12)],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            _Arrow(label: '←', onTap: onPrev),
            Expanded(
              child: Text(
                variantNames[variant]!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            _Arrow(label: '→', onTap: onNext),
          ],
        ),
      ),
    );
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFFFFE082),
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
