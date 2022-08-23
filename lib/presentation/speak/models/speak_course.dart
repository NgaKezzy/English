enum Level {
  Introduction,
  Primary,
  Intermediate,
  Advanced,
  Structure,
  SentencesStructure,
  Travel,
  Comunicate,
  Sample,
  News,
  Situation,
  Vocab,
  Practice,
}

enum Type {
  Level,
  Topic,
}

class SpeakCourse {
  final String id;
  final String title;
  final Type type;
  final Level level;
  final int totalLesson;

  const SpeakCourse({
    required this.type,
    required this.id,
    required this.title,
    required this.level,
    required this.totalLesson,
  });
}
