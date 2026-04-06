import 'dart:math';

import 'package:hive/hive.dart';

import '../models/word_entry.dart';
import '../models/word_pack.dart';

class LocalWordPackRepository {
  LocalWordPackRepository(this._box);

  static const boxName = 'word_packs_box';
  final Box<Map> _box;

  Future<void> seedDefaultsIfEmpty() async {
    if (_box.isNotEmpty) return;

    for (final pack in defaultPacks) {
      await _box.put(pack.id, pack.toJson());
    }
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

final defaultPacks = <WordPack>[
  const WordPack(
    id: 'food',
    nameEn: 'Food',
    nameNe: 'खाना',
    entries: [
      WordEntry(
        word: 'Momo',
        wordDevanagari: 'मोमो',
        category: 'Food',
        guptacharHint: 'Something you can eat',
        didYouKnow: 'Fun mode word.',
      ),
      WordEntry(
        word: 'Chatpate',
        wordDevanagari: 'चट्पटे',
        category: 'Food',
        guptacharHint: 'Often shared with friends',
        didYouKnow: 'Fun mode word.',
      ),
      WordEntry(
        word: 'Sel Roti',
        wordDevanagari: 'सेल रोटी',
        category: 'Food',
        guptacharHint: 'Popular during occasions',
        didYouKnow: 'Fun mode word.',
      ),
    ],
  ),
  const WordPack(
    id: 'places',
    nameEn: 'Places',
    nameNe: 'स्थानहरू',
    entries: [
      WordEntry(
        word: 'Thamel',
        wordDevanagari: 'ठमेल',
        category: 'Places',
        guptacharHint: 'A crowded place',
        didYouKnow: 'Fun mode word.',
      ),
      WordEntry(
        word: 'Pokhara',
        wordDevanagari: 'पोखरा',
        category: 'Places',
        guptacharHint: 'A travel favorite',
        didYouKnow: 'Fun mode word.',
      ),
      WordEntry(
        word: 'Pashupatinath',
        wordDevanagari: 'पशुपतिनाथ',
        category: 'Places',
        guptacharHint: 'A well-known location',
        didYouKnow: 'Fun mode word.',
      ),
    ],
  ),
  const WordPack(
    id: 'legends',
    nameEn: 'Legends',
    nameNe: 'किंवदन्ती',
    entries: [
      WordEntry(
        word: 'Yeti',
        wordDevanagari: 'येति',
        category: 'Legends',
        guptacharHint: 'Something mysterious',
        didYouKnow: 'Fun mode word.',
      ),
      WordEntry(
        word: 'Kichkandi',
        wordDevanagari: 'किचकण्डी',
        category: 'Legends',
        guptacharHint: 'A story many have heard',
        didYouKnow: 'Fun mode word.',
      ),
      WordEntry(
        word: 'Boksi',
        wordDevanagari: 'बोक्सी',
        category: 'Legends',
        guptacharHint: 'A character from folklore',
        didYouKnow: 'Fun mode word.',
      ),
    ],
  ),
];
