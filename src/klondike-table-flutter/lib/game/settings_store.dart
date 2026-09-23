import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

abstract class SettingsStore {
  Future<bool> loadDrawThree();
  Future<void> saveDrawThree(bool drawThree);
  Future<bool> loadFastFinish();
  Future<void> saveFastFinish(bool fastFinish);
  Future<bool> loadLeftHanded();
  Future<void> saveLeftHanded(bool leftHanded);
  Future<bool> loadWasteOnLeft();
  Future<void> saveWasteOnLeft(bool wasteOnLeft);
  Future<bool> loadDebug();
  Future<void> saveDebug(bool debug);
}

class MemorySettingsStore implements SettingsStore {
  MemorySettingsStore({
    bool drawThree = false,
    bool fastFinish = false,
    bool leftHanded = false,
    bool wasteOnLeft = false,
    bool debug = false,
  }) : _drawThree = drawThree,
       _fastFinish = fastFinish,
       _leftHanded = leftHanded,
       _wasteOnLeft = wasteOnLeft,
       _debug = debug;

  bool _drawThree;
  bool _fastFinish;
  bool _leftHanded;
  bool _wasteOnLeft;
  bool _debug;

  @override
  Future<bool> loadDrawThree() async => _drawThree;

  @override
  Future<void> saveDrawThree(bool drawThree) async => _drawThree = drawThree;

  @override
  Future<bool> loadFastFinish() async => _fastFinish;

  @override
  Future<void> saveFastFinish(bool fastFinish) async =>
      _fastFinish = fastFinish;

  @override
  Future<bool> loadLeftHanded() async => _leftHanded;

  @override
  Future<void> saveLeftHanded(bool leftHanded) async =>
      _leftHanded = leftHanded;

  @override
  Future<bool> loadWasteOnLeft() async => _wasteOnLeft;

  @override
  Future<void> saveWasteOnLeft(bool wasteOnLeft) async =>
      _wasteOnLeft = wasteOnLeft;

  @override
  Future<bool> loadDebug() async => _debug;

  @override
  Future<void> saveDebug(bool debug) async => _debug = debug;
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
    const defaults = {
      'drawThree': false,
      'fastFinish': false,
      'leftHanded': false,
      'wasteOnLeft': false,
      'debug': false,
    };
    final file = await _file();
    if (!file.existsSync()) return Map<String, bool>.from(defaults);
    try {
      final decoded = jsonDecode(file.readAsStringSync());
      if (decoded is! Map) return Map<String, bool>.from(defaults);
      return {for (final e in defaults.entries) e.key: decoded[e.key] == true};
    } on Object {
      return Map<String, bool>.from(defaults);
    }
  }

  Future<void> _save(Map<String, bool> values) async {
    final file = await _file();
    await file.writeAsString(
      jsonEncode({
        'drawThree': values['drawThree'] ?? false,
        'fastFinish': values['fastFinish'] ?? false,
        'leftHanded': values['leftHanded'] ?? false,
        'wasteOnLeft': values['wasteOnLeft'] ?? false,
        'debug': values['debug'] ?? false,
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

  @override
  Future<bool> loadLeftHanded() async => (await _load())['leftHanded']!;

  @override
  Future<void> saveLeftHanded(bool leftHanded) async {
    final values = await _load();
    values['leftHanded'] = leftHanded;
    await _save(values);
  }

  @override
  Future<bool> loadWasteOnLeft() async => (await _load())['wasteOnLeft']!;

  @override
  Future<void> saveWasteOnLeft(bool wasteOnLeft) async {
    final values = await _load();
    values['wasteOnLeft'] = wasteOnLeft;
    await _save(values);
  }

  @override
  Future<bool> loadDebug() async => (await _load())['debug']!;

  @override
  Future<void> saveDebug(bool debug) async {
    final values = await _load();
    values['debug'] = debug;
    await _save(values);
  }
}
