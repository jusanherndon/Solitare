import 'package:flutter/widgets.dart';

import 'ui/klondike_table.dart';

void main() {
  runApp(const KlondikePrototypeApp());
}

class KlondikePrototypeApp extends StatelessWidget {
  const KlondikePrototypeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: const Color(0xFF1F6B45),
      debugShowCheckedModeBanner: false,
      pageRouteBuilder: <T>(settings, builder) {
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        );
      },
      home: const KlondikeTable(),
    );
  }
}
