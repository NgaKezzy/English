import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/model_local/SettingModel.dart';
import 'package:app_learn_english/models/CountryAll.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/DataOffline.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';

class ItemLanguageView extends StatelessWidget {
  CountryModel language;
  SettingOffline settingData;

  ItemLanguageView(
      {Key? key, required this.language, required this.settingData});

  String getFlags({langKey: String}) {
    String srcFlags = "assets/flags/";
    if (langKey != null) {
      srcFlags += 'flag-' + langKey.toString().toLowerCase() + '.png';
    }

    return srcFlags;
  }

  callApiReset(String codeLang, LocaleProvider provider, bool isNotLang,
      String codeLangEn) {
    DataUser userData = DataCache().getUserData();
    TalkAPIs()
        .fetchDataHome2(
            uid: userData.uid,
            langugeCode:
                (isNotLang == true) ? codeLangEn : codeLang.toLowerCase())
        .then((value) => {
              Restart.restartApp(webOrigin: '/home-page'),
            });

    Future<void> future = provider.setLocale(Locale(codeLang.toLowerCase()));
    future.then((void value) => {
          S.load(Locale(codeLang.toLowerCase())).then((value) => {
                Utils().showNotificationBottom(true, language.name),
                settingData.language = language,
                settingData.language.sortname = codeLang.toLowerCase(),
                settingData.language.name = language.name,
                DataOffline().saveDataOffline("MainSetting", settingData)
              }),
          DataOffline().saveLangeCodeSub(
              (isNotLang == true) ? codeLangEn : codeLang.toLowerCase()),
          provider.setCodeLange(codeLang.toLowerCase()),
          provider.setCodeLangeSub(
              (isNotLang == true) ? codeLangEn : codeLang.toLowerCase())
        });
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();

    return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
      return InkWell(
        onTap: () async {
          // if(Utils().checkLanguage(language.sortname)==true){
          //   callApiReset("en",provider,true,language.sortname.toLowerCase());
          // }else{
          callApiReset(language.sortname.toLowerCase(), provider, false,
              language.sortname.toLowerCase());
          // }
        },
        child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  //                   <--- left side
                  color: Colors.grey.withOpacity(0.5),
                  width: 1,
                ),
              ),
            ),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    getFlags(langKey: language.sortname),
                    height: 30,
                    width: 60,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    language.name.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                  (checkLanguge(context) == S.of(context).CurrentLang)
                      ? Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 40,
                        )
                      : SizedBox(),
                ],
              ),
            )),
      );
    });
  }

  String checkLanguge(context) {
    switch (language.name) {
      case "Tiếng Anh":
        return S.of(context).English;

      case "Việt Nam":
        return S.of(context).Vietnamese;

      case "Trung Quốc":
        return S.of(context).China;

      case "Nhật Bản":
        return S.of(context).Japan;

      case "Ấn Độ":
        return S.of(context).India;

      case "Tây Ban Nha":
        return S.of(context).Spain;

      case "Nga":
        return S.of(context).Russia;
      default:
        return '';
    }
  }
}
