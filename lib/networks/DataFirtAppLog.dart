class DataFirtAppLog {
  static final DataFirtAppLog _singleton = DataFirtAppLog._internal();
  factory DataFirtAppLog() {
    return _singleton;
  }
  DataFirtAppLog._internal();

  String? learn;
  String? language;
  String? level;
  int? target_key;
  String? hours;
  bool isFirt = false;
}
