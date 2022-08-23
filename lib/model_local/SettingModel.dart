import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/CountryAll.dart';
import 'package:scoped_model/scoped_model.dart';

class SettingOffline extends Model {
  bool switchMCHD;
  bool switchHDOT;
  bool switchTTGD;
  bool switchTBH;
  bool switchTTSK;
  bool switchCBHGR;
  bool switchNDMTKDK;
  CountryModel language;

  SettingOffline({
    required this.switchMCHD,
    required this.switchHDOT,
    required this.switchTTGD,
    required this.switchTBH,
    required this.switchTTSK,
    required this.switchCBHGR,
    required this.switchNDMTKDK,
    required this.language,
  });

  factory SettingOffline.fromJson(Map<String, dynamic> json) {
    printYellow(json.toString());
    return SettingOffline(
      switchMCHD: json['switchMCHD'],
      switchHDOT: json['switchHDOT'],
      switchTTGD: json['switchTTGD'],
      switchTBH: json['switchTBH'],
      switchTTSK: json['switchTTSK'],
      switchCBHGR: json['switchCBHGR'],
      switchNDMTKDK: json['switchNDMTKDK'],
      language: CountryModel.fromJson(json['language']),
    );
  }
  Map<String, dynamic> toJson() => {
        'switchMCHD': this.switchMCHD,
        'switchHDOT': this.switchHDOT,
        'switchTTGD': this.switchTTGD,
        'switchTBH': this.switchTBH,
        'switchTTSK': this.switchTTSK,
        'switchCBHGR': this.switchCBHGR,
        'switchNDMTKDK': this.switchNDMTKDK,
        'language': this.language,
      };
}
