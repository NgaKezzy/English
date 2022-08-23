import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/model_local/SettingModel.dart';
import 'package:app_learn_english/models/CountryAll.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/DataFirtAppLog.dart';
import 'package:app_learn_english/networks/DataOffline.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/networks/location_services_api.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/startpage/widget/center_widget.dart';
import 'package:app_learn_english/startpage/widget/notice_widget.dart';
import 'package:app_learn_english/startpage/widget/top_widget_one.dart';
import 'package:app_learn_english/utils/color_utils.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'page_list_learn.dart';
import 'responsive_start_page.dart';

class PageListLanguage extends StatefulWidget {
  const PageListLanguage({Key? key}) : super(key: key);

  @override
  _PageListLanguage createState() => _PageListLanguage();
}

class _PageListLanguage extends State<PageListLanguage> {
  CountryModel getDefaultLang(String languageShortName) {
    CountryModel countryDefault = Utils().listCountryMain().firstWhere(
        (element) =>
            element.sortname.toLowerCase() == languageShortName.toLowerCase());
    if (countryDefault.sortname.toLowerCase() ==
        languageShortName.toLowerCase()) {
      countryDefault.sortname = languageShortName;
    }
    return countryDefault;
  }

  late SettingOffline settingData;

  bool _loadingLang = true;
  late CountryModel defaultLang;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_loadingLang) {
      var lang = await LocationServicesApi().getLanguageByIP();
      defaultLang = getDefaultLang(
        lang,
      );
      settingData = SettingOffline(
        switchMCHD: true,
        switchHDOT: false,
        switchTTGD: true,
        switchTBH: false,
        switchTTSK: false,
        switchCBHGR: false,
        switchNDMTKDK: false,
        language: defaultLang,
      );
    }
    var localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    Future.delayed(Duration(seconds: 0), () async {
      localeProvider.setLocale(Locale(defaultLang.sortname.toLowerCase()));
    });
    if (mounted) {
      setState(() {
        _loadingLang = false;
      });
    }
  }

  void showSettings(BuildContext ctx) async {
    (context as Element).markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      ColorsUtils.Color_53DAC0,
                      ColorsUtils.Color_1FBFAD,
                    ],
                  )),
                  child: Column(
                    children: [
                      TopWidgetOne(),
                      CenterWidget(
                        title: S.of(context).WhatIsYourNativeLanguage,
                        index: 1,
                      ),
                      _loadingLang
                          ? const Center(
                              // child: CircularProgressIndicator(),
                              child: const PhoLoading(),
                            )
                          : Expanded(
                              child: _BottomWidget(
                                settingData: settingData,
                                showSetting: showSettings,
                                codeLangFirst: defaultLang.sortname,
                              ),
                            ),
                      NoticeWidget(
                        title: S
                            .of(context)
                            .ThisPointHelpsMeToAdjustTheLessonContentToSuitYourSkillNeedToImprove,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}

class _BottomWidget extends StatelessWidget {
  _BottomWidget(
      {Key? key,
      required this.settingData,
      required this.showSetting,
      required this.codeLangFirst})
      : super(key: key);
  SettingOffline settingData;
  final Function showSetting;
  final String codeLangFirst;

  String getFlags({langKey: String}) {
    String srcFlags = "assets/flags/";
    if (langKey != null) {
      srcFlags += 'flag-' + langKey.toString().toLowerCase() + '.png';
    }
    return srcFlags;
  }

  List<CountryModel> setListCountry() {
    List<CountryModel> newListCountry = [];
    List<CountryModel> listCountry = Utils().listCountryMain();
    for (var item in listCountry) {
      if (item.sortname == codeLangFirst) {
        newListCountry.insert(0, item);
      } else {
        newListCountry.add(item);
      }
    }
    newListCountry.removeAt((newListCountry.length - 1));
    Utils().listCountryModel().forEach((CountryModel country) {
      newListCountry.add(country);
    });
    return newListCountry;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (var i = 0; i < setListCountry().length; i++)
              if (i != 16)
                _ListItemWidget(
                  icon: getFlags(langKey: setListCountry()[i].sortname),
                  country: setListCountry()[i],
                  settingData: settingData,
                  showSetting: showSetting,
                )
          ],
        ),
      ),
    );
  }
}

class _ListItemWidget extends StatelessWidget {
  _ListItemWidget({
    Key? key,
    required this.icon,
    required this.country,
    required this.settingData,
    required this.showSetting,
  });

  final String icon;
  CountryModel country;
  SettingOffline settingData;
  final Function showSetting;

  callApiFirstLang(String codeLang, LocaleProvider provider,
      BuildContext context, bool isNotLang, String codeLangEn) {
    Future<void> future =
        provider.setLocale(Locale(country.sortname.toLowerCase()));
    future.then((value) => {
          S.load(Locale(country.sortname.toLowerCase())).then((value) => {
                settingData.language = country,
                settingData.language.sortname = codeLang.toLowerCase(),
                settingData.language.name = country.name,
                DataOffline().saveDataOffline("MainSetting", settingData),
                Utils().showNotificationBottom(true, country.name),
              })
        });
    provider.setCodeLange(codeLang.toLowerCase());
    provider.setCodeLangeSub(
        (isNotLang == true) ? codeLangEn : codeLang.toLowerCase());
    DataOffline().saveLangeCode(country.sortname.toLowerCase());
    DataOffline().saveLangeCodeSub(
        (isNotLang == true) ? codeLangEn : codeLang.toLowerCase());
    DataFirtAppLog().language = country.sortname.toLowerCase();
    printBlue("LangCode:$codeLang");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PageListLearn()));
    showSetting(context);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(
              thickness: 2,
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          InkWell(
              onTap: () async {
                if (Utils().checkLanguage(country.sortname) == true) {
                  callApiFirstLang(country.sortname.toLowerCase(), provider,
                      context, true, country.sortname.toLowerCase());
                } else {
                  callApiFirstLang(country.sortname.toLowerCase(), provider,
                      context, false, country.sortname.toLowerCase());
                }
              },
              child: Container(
                height: ResponsiveWidget.isSmallScreen(context)
                    ? height / 12
                    : height / 7,
                child: Align(
                  alignment: Alignment.center,
                  child: ListTile(
                    leading: Image.asset(
                      icon,
                      scale: 1.3,
                    ),
                    title: Text(
                      country.name,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/new_ui/first_screen_app/ic_arrow.svg',
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      );
    });
  }
}
