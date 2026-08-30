import 'dart:io';

import 'package:flutter/services.dart';

abstract class SettingsStore {
  Future<bool> loadDrawThree();
  Future<void> saveDrawThree(bool drawThree);
}

class MemorySettingsStore implements SettingsStore {
  bool _drawThree = false;

  @override
  Future<bool> loadDrawThree() async => _drawThree;

  @override
  Future<void> saveDrawThree(bool drawThree) async => _drawThree = drawThree;
}

class FileSettingsStore implements SettingsStore {
  Future<File> _file() async {
    late final Directory dir;
    if (Platform.isAndroid || Platform.isIOS) {
      const ch = MethodChannel('klondike/host');
      final path = await ch.invokeMethod<String>('filesDir');
      dir = Directory(path!);
    } else {
      final home = Platform.environment['HOME'] ?? Directory.systemTemp.path;
      dir = Directory('$home/.local/share/klondike_table');
    }
    await dir.create(recursive: true);
    return File('${dir.path}/settings.json');
  }

  @override
  Future<bool> loadDrawThree() async {
    final file = await _file();
    if (!file.existsSync()) return false;
    try {
      return file.readAsStringSync().contains('"drawThree":true');
    } on Object {
      return false;
    }
  }

  @override
  Future<void> saveDrawThree(bool drawThree) async {
    final file = await _file();
    await file.writeAsString('{"drawThree":$drawThree}');
  }
}
