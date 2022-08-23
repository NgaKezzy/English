enum Classify {
  Normal,
  Vip,
}

class Conversations {
  final String id;
  final String nameConversion;
  final int totalProcess;
  final Classify classify;
  final List<Map<String, String>> conversationList;

  const Conversations({
    required this.id,
    required this.nameConversion,
    required this.totalProcess,
    required this.classify,
    required this.conversationList,
  });
}
