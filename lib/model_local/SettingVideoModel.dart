import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:scoped_model/scoped_model.dart';

class VideoSetting extends Model {
  int subtitle;
  bool autoplay;
  bool loop;
  bool loopMainSentence;
  bool isDrill;

  VideoSetting({
    required this.subtitle,
    required this.autoplay,
    required this.loop,
    required this.loopMainSentence,
    required this.isDrill,
  });
  factory VideoSetting.fromJson(Map<String, dynamic> json) {
    printYellow(json.toString());
    return VideoSetting(
      subtitle: json['subtitle'],
      autoplay: json['autoplay'],
      loop: json['loop'],
      loopMainSentence: json['loopMainSentence'],
      isDrill: json['isDrill'],
    );
  }
  Map toJson() => {
        'subtitle': this.subtitle,
        'autoplay': this.autoplay,
        'loop': this.loop,
        'loopMainSentence': this.loopMainSentence,
        'isDrill': this.isDrill,
      };
}
