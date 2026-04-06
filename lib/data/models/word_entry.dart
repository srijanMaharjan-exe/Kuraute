class WordEntry {
  const WordEntry({
    required this.word,
    required this.category,
    required this.guptacharHint,
    required this.didYouKnow,
    this.wordDevanagari,
  });

  final String word;
  final String category;
  final String guptacharHint;
  final String didYouKnow;
  final String? wordDevanagari;

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'category': category,
      'guptacharHint': guptacharHint,
      'didYouKnow': didYouKnow,
      'wordDevanagari': wordDevanagari,
    };
  }

  factory WordEntry.fromJson(Map<dynamic, dynamic> json) {
    return WordEntry(
      word: json['word'] as String,
      category: json['category'] as String,
      guptacharHint: json['guptacharHint'] as String,
      didYouKnow: json['didYouKnow'] as String,
      wordDevanagari: json['wordDevanagari'] as String?,
    );
  }
}
