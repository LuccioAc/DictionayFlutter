class Word {
  final int idword;
  final String word;
  final String? meaning;

  Word({required this.idword, required this.word, this.meaning});

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      idword: json['idword'] ?? 0,
      word: json['word'],
      meaning: json['meaning'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "word": word,
      "meaning": meaning,
    };
  }
}
