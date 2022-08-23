import 'package:app_learn_english/models/config/inapp.dart';

class ConfigApp {
  int? isLocalNoti;
  int? isNativeAds;
  String? vAndroid;
  String? vIos;
  String? fb;
  String? linkUpdate;
  String? tokenMd5;
  String? urlApi;
  String? urlImg;
  String? androidApp;
  String? iosApp;
  List<Inapps>? inapps;
  String? lang;

  ConfigApp({
    required this.isLocalNoti,
    required this.isNativeAds,
    required this.vAndroid,
    required this.vIos,
    required this.fb,
    required this.linkUpdate,
    required this.tokenMd5,
    required this.urlApi,
    required this.urlImg,
    required this.androidApp,
    required this.iosApp,
    required this.inapps,
    required this.lang,
  });

  factory ConfigApp.fromJson(Map<String, dynamic> json) {
    // List<Inapps> inapps = [];
    // if (json['inapps']) {
    //   for (var i = 0; i < json['inapps'].length; i++) {

    //   }
    //   inapps.add(Inapps.fromJson(json['inapps']));
    // }
    return ConfigApp(
      isLocalNoti: json['isLocalNoti'],
      isNativeAds: json['isNativeAds'],
      vAndroid: json['vAndroid'],
      vIos: json['vIos'],
      fb: json['fb'],
      linkUpdate: json['linkUpdate'],
      tokenMd5: json['tokenMd5'],
      urlApi: json['url_api'],
      urlImg: json['url_img'],
      androidApp: json['android_app'],
      iosApp: json['ios_app'],
      inapps: [
        for (var i = 0; i < json['inapps'].length; i++)
          Inapps.fromJson(json['inapps'][i]),
      ],
      lang: json['lang'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isLocalNoti'] = this.isLocalNoti;
    data['isNativeAds'] = this.isNativeAds;
    data['vAndroid'] = this.vAndroid;
    data['vIos'] = this.vIos;
    data['fb'] = this.fb;
    data['linkUpdate'] = this.linkUpdate;
    data['tokenMd5'] = this.tokenMd5;
    data['url_api'] = this.urlApi;
    data['url_img'] = this.urlImg;
    data['android_app'] = this.androidApp;
    data['ios_app'] = this.iosApp;
    data['inapps'] = this.inapps;
    data['lang'] = this.lang;
    return data;
  }
}
