import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

abstract class SettingsStore {
  Future<bool> loadDrawThree();
  Future<void> saveDrawThree(bool drawThree);
  Future<bool> loadFastFinish();
  Future<void> saveFastFinish(bool fastFinish);
}

class MemorySettingsStore implements SettingsStore {
  MemorySettingsStore({bool drawThree = false, bool fastFinish = false})
    : _drawThree = drawThree,
      _fastFinish = fastFinish;

  bool _drawThree;
  bool _fastFinish;

  @override
  Future<bool> loadDrawThree() async => _drawThree;

  @override
  Future<void> saveDrawThree(bool drawThree) async => _drawThree = drawThree;

  @override
  Future<bool> loadFastFinish() async => _fastFinish;

  @override
  Future<void> saveFastFinish(bool fastFinish) async => _fastFinish = fastFinish;
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

  Future<Map<String, bool>> _load() async {
    final file = await _file();
    if (!file.existsSync()) {
      return {'drawThree': false, 'fastFinish': false};
    }
    try {
      final decoded = jsonDecode(file.readAsStringSync());
      if (decoded is! Map) {
        return {'drawThree': false, 'fastFinish': false};
      }
      return {
        'drawThree': decoded['drawThree'] == true,
        'fastFinish': decoded['fastFinish'] == true,
      };
    } on Object {
      return {'drawThree': false, 'fastFinish': false};
    }
  }

  Future<void> _save(Map<String, bool> values) async {
    final file = await _file();
    await file.writeAsString(
      jsonEncode({
        'drawThree': values['drawThree'] ?? false,
        'fastFinish': values['fastFinish'] ?? false,
      }),
    );
  }

  @override
  Future<bool> loadDrawThree() async => (await _load())['drawThree']!;

  @override
  Future<void> saveDrawThree(bool drawThree) async {
    final values = await _load();
    values['drawThree'] = drawThree;
    await _save(values);
  }

  @override
  Future<bool> loadFastFinish() async => (await _load())['fastFinish']!;

  @override
  Future<void> saveFastFinish(bool fastFinish) async {
    final values = await _load();
    values['fastFinish'] = fastFinish;
    await _save(values);
  }
}
