import 'package:app_learn_english/models/video_history/history_model.dart';
class VideoHistory {
  int error;
  String msg;
  List<History> listHistory;

  VideoHistory({
    required this.error,
    required this.msg,
    required this.listHistory,
  });

  factory VideoHistory.fromJson(Map<String, dynamic> json) {
    return VideoHistory(
      error:json['error'],
      msg: json['msg'].toString(),
      listHistory: json['historys'].map<History>((json) {
        return History.fromJson(json);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'error': this.error,
        'msg': this.msg,
        'historys': this.listHistory,
      };
}
