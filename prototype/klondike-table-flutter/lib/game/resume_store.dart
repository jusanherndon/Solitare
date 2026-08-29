import 'dart:io';

import 'package:flutter/services.dart';

import 'codec.dart';
import 'history.dart';

abstract class ResumeStore {
  Future<GameMeta?> load();
  Future<void> save(GameMeta meta);
  Future<void> clear();
}

class MemoryResumeStore implements ResumeStore {
  GameMeta? _meta;

  @override
  Future<GameMeta?> load() async => _meta;

  @override
  Future<void> save(GameMeta meta) async => _meta = meta;

  @override
  Future<void> clear() async => _meta = null;
}

class FileResumeStore implements ResumeStore {
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
    return File('${dir.path}/resume.json');
  }

  @override
  Future<GameMeta?> load() async {
    final file = await _file();
    if (!file.existsSync()) return null;
    try {
      return decodeMeta(file.readAsStringSync());
    } on Object {
      return null;
    }
  }

  @override
  Future<void> save(GameMeta meta) async {
    final file = await _file();
    await file.writeAsString(encodeMeta(meta));
  }

  @override
  Future<void> clear() async {
    final file = await _file();
    if (file.existsSync()) await file.delete();
  }
}
