class WordEntry {
  const WordEntry({
    required this.word,
    required this.category,
    required this.guptacharHint,
    this.wordDevanagari,
  });

  final String word;
  final String category;
  final String guptacharHint;
  final String? wordDevanagari;

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'category': category,
      'guptacharHint': guptacharHint,
      'wordDevanagari': wordDevanagari,
    };
  }

  factory WordEntry.fromJson(Map<dynamic, dynamic> json) {
    return WordEntry(
      word: json['word'] as String,
      category: json['category'] as String,
      guptacharHint: json['guptacharHint'] as String,
      wordDevanagari: json['wordDevanagari'] as String?,
    );
  }
}
