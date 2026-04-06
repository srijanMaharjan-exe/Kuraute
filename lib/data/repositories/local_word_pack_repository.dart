import 'dart:math';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:flutter/services.dart';

import '../models/word_entry.dart';
import '../models/word_pack.dart';

class LocalWordPackRepository {
  LocalWordPackRepository(this._box);

  static const boxName = 'word_packs_box';
  static const defaultPacksAssetPath = 'assets/word_packs.json';
  final Box<Map> _box;

  Future<void> seedDefaultsIfEmpty() async {
    if (_box.isNotEmpty) return;

    final packs = await loadDefaultPacks();
    for (final pack in packs) {
      await _box.put(pack.id, pack.toJson());
    }
  }

  Future<List<WordPack>> loadDefaultPacks() async {
    final rawJson = await rootBundle.loadString(defaultPacksAssetPath);
    final decoded = jsonDecode(rawJson) as List<dynamic>;
    return decoded
        .cast<Map<dynamic, dynamic>>()
        .map(WordPack.fromJson)
        .toList(growable: false);
  }

  List<WordPack> getAllPacks() {
    return _box.values
        .map((raw) => WordPack.fromJson(Map<dynamic, dynamic>.from(raw)))
        .toList(growable: false);
  }

  WordEntry pickRandomWord({required String packId, Random? random}) {
    final raw = _box.get(packId);
    if (raw == null) {
      throw StateError('Pack not found: $packId');
    }

    final pack = WordPack.fromJson(Map<dynamic, dynamic>.from(raw));
    if (pack.entries.isEmpty) {
      throw StateError('Pack has no entries: $packId');
    }

    final rng = random ?? Random();
    return pack.entries[rng.nextInt(pack.entries.length)];
  }

  WordEntry pickRandomWordFromPacks({
    required List<String> packIds,
    Random? random,
  }) {
    final selected = packIds.isEmpty ? const <String>['food'] : packIds;
    final allEntries = <WordEntry>[];

    for (final packId in selected) {
      final raw = _box.get(packId);
      if (raw == null) continue;
      final pack = WordPack.fromJson(Map<dynamic, dynamic>.from(raw));
      allEntries.addAll(pack.entries);
    }

    if (allEntries.isEmpty) {
      throw StateError('No words available for selected categories.');
    }

    final rng = random ?? Random();
    return allEntries[rng.nextInt(allEntries.length)];
  }
}
