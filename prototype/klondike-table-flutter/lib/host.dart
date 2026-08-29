import 'dart:io';

import 'package:flutter/services.dart';

const supportMailto = 'mailto:jherndon111@gmail.com';
const sourceUrl = 'https://github.com/jusanherndon/Solitare';
const privacyUrl = 'https://jusanherndon.github.io/Solitare/privacy/';

typedef OpenUrl = Future<void> Function(String url);

Future<void> openUrl(String url) async {
  if (Platform.isLinux) {
    await Process.run('xdg-open', [url]);
    return;
  }
  const ch = MethodChannel('klondike/host');
  await ch.invokeMethod<void>('open', url);
}
