import 'dart:io';

import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/model_local/SettingModel.dart';
import 'package:app_learn_english/models/CountryAll.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/networks/location_services_api.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/profile/widgets/itemLanguage.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/utils/color_utils.dart';
import 'package:app_learn_english/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Languages extends StatefulWidget {
  final SettingOffline settingData;
  Languages({Key? key, required this.settingData}) : super(key: key);

  @override
  _PageSearch createState() => _PageSearch(settingData: settingData);
}

class _PageSearch extends State<Languages> {
  SettingOffline settingData;
  _PageSearch({Key? key, required this.settingData});
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
  }

  List<CountryModel> countryList = [];
  @override
  void didChangeDependencies() async {
    if (_isLoading) {
      String code = await LocationServicesApi().getLanguageByIP();

      Utils().listCountryMain().forEach(
          (CountryModel country) {
            if (country.sortname.toLowerCase() == code.toLowerCase()) {
              countryList.insert(0,country);
            }else{
              countryList.add(country);
            }
          },
        );

        Utils().listCountryModel().forEach((CountryModel country) {
            countryList.add(country);
        }
        );

      setState(() {
        _isLoading = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Consumer<LocaleProvider>(
      builder: (context, provider, snapshot) {
        return _isLoading
            ? Scaffold(
                body: Align(
                  alignment: Alignment.center,
                  child: PhoLoading(),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  title: Text(
                    S.of(context).Language,
                    style: TextStyle(
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                  backgroundColor: themeProvider.mode == ThemeMode.dark
                      ? Color.fromRGBO(45, 48, 57, 1)
                      : Colors.white,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: SvgPicture.asset(
                      'assets/new_ui/more/Iconly-Arrow-Left.svg',
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                body: SafeArea(
                  child: Column(
                    children: [
                      Divider(
                          thickness: 1,
                          color: themeProvider.mode == ThemeMode.dark
                              ? Colors.grey.shade700
                              : Color(0xFFE4E4E4),
                          height: 1),
                      Expanded(
                        child: Container(
                          width: width,
                          height: height,
                          child: ListView(
                            children: [
                              DataCache().getLanguageData() != null
                                  ? Container(
                                      width: width,
                                      height: height * 9 / 10,
                                      decoration: BoxDecoration(
                                        color:
                                            themeProvider.mode == ThemeMode.dark
                                                ? Color.fromRGBO(45, 48, 57, 1)
                                                : Colors.white,
                                      ),
                                      child: ListView(
                                        physics: BouncingScrollPhysics(),
                                        children: <Widget>[
                                          // dùng danh sách ngôn ngữ để render item
                                          for (var i = 0;
                                              i < countryList.length;
                                              i++)
                                            if (i != 16)
                                              (i==20)?_viewInsertListLang():ItemLanguageView(
                                                // language: languageItem,
                                                language: countryList[i],
                                                settingData: settingData,
                                              )

                                        ],
                                      ),
                                    )
                                  // : Platform.isAndroid
                                  //     ? CircularProgressIndicator()
                                  //     : CupertinoActivityIndicator(),
                                  : const PhoLoading(),
                              // FromLanguage(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }

  ///View chèn list lang
Widget _viewInsertListLang(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      decoration: BoxDecoration(
        color: ColorsUtils.Color_333745.withOpacity(0.1),
        border: Border(
          bottom:BorderSide( //                   <--- left side
            color:Colors.grey.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15,),
            Text('Subtitle translation only',style: TextStyle(color: Colors.black,fontSize: 20,fontFamily: 'Roboto'),),
            SizedBox(height: 5,),
            Row(
              children: [
              Row(
              children: [
                Text('by',style: TextStyle(color: ColorsUtils.Color_333745,fontSize: 18,fontFamily: 'Roboto'),),
                SizedBox(width: 5,),
                SvgPicture.asset(
                  'assets/new_ui/more/ic_google_translate_logo.svg',
                  height: 20,
                ),
              ],
              ),
              SizedBox(width: 5,),
              Text('Google translate',style: TextStyle(color:ColorsUtils.Color_333745,fontSize: 18 ,fontFamily: 'Roboto'),)
            ],)
          ],
        ),
      ),
    );
}
}
