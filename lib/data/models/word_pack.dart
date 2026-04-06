import 'word_entry.dart';

class WordPack {
  const WordPack({
    required this.id,
    required this.nameEn,
    required this.nameNe,
    required this.entries,
  });

  final String id;
  final String nameEn;
  final String nameNe;
  final List<WordEntry> entries;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameEn': nameEn,
      'nameNe': nameNe,
      'entries': entries.map((entry) => entry.toJson()).toList(),
    };
  }

  factory WordPack.fromJson(Map<dynamic, dynamic> json) {
    final rawEntries = (json['entries'] as List<dynamic>)
        .cast<Map<dynamic, dynamic>>();

    return WordPack(
      id: json['id'] as String,
      nameEn: json['nameEn'] as String,
      nameNe: json['nameNe'] as String,
      entries: rawEntries.map(WordEntry.fromJson).toList(),
    );
  }
}
