import 'dart:io';

import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/widgets/item_channel.dart';
import 'package:app_learn_english/homepage/widgets/item_more_chanel_2.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/startpage/responsive_start_page.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class SubChanelNoData extends StatefulWidget {
  final Function showSetting;

  SubChanelNoData({Key? key, required this.showSetting}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _SubChanelNoData(showSetting: showSetting);
  }
}

class _SubChanelNoData extends State<SubChanelNoData> {
  final Function showSetting;
  _SubChanelNoData({Key? key, required this.showSetting});
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      return DataCache().getListCategory() != null
          ? _SubChanelNoDataView(
              userData: userData,
              listCategory: DataCache().getListCategory(),
              showSetting: showSetting,
            )
          : FutureBuilder(
              future: TalkAPIs().getListCategory(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return activeDialog(context, S.of(context).ErrorLoadData);
                }

                return snapshot.hasData
                    ? _SubChanelNoDataView(
                        userData: userData,
                        listCategory: snapshot.data,
                        showSetting: showSetting,
                      )
                    : Center(
                        // child: Platform.isAndroid
                        //     ? const CircularProgressIndicator()
                        //     : const CupertinoActivityIndicator(),
                        child: const PhoLoading(),
                      );
              },
            );
    });
  }
}

class _SubChanelNoDataView extends StatelessWidget {
  final DataUser userData;
  final List<Category> listCategory;
  final Function showSetting;
  _SubChanelNoDataView(
      {Key? key,
      required this.userData,
      required this.listCategory,
      required this.showSetting})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
      return Container(
          height: height * 1,
          width: width,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            // image: DecorationImage(
            //     image: AssetImage('assets/images/background.png'),
            //     fit: BoxFit.cover),
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [
            //     Colors.blue.shade700,
            //     Colors.tealAccent.shade400,
            //   ],
            // ),
            color: themeProvider.mode == ThemeMode.dark
                ? const Color.fromRGBO(24, 26, 33, 1)
                : Colors.white,
          ),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
                  height: 135,
                  width: width,
                  decoration: BoxDecoration(
                    color: themeProvider.mode == ThemeMode.dark
                        ? const Color.fromRGBO(59, 61, 66, 1)
                        : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).SubscribedChannel,
                        style: TextStyle(
                          color: themeProvider.mode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                          height: 80,
                          width: width,
                          child: Column(
                            children: [
                              ItemMoreSubViewNoData(
                                userData: userData,
                                listCategory: listCategory,
                                showSetting: showSetting,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                S
                                    .of(context)
                                    .YouHaveNotSubscribedToAnyChannelYet,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: themeProvider.mode == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          )),
                    ],
                  )),
              const SizedBox(height: 10),
              for (var category in listCategory)
                category.listChannel.length > 0
                    ? Card(
                        color: themeProvider.mode == ThemeMode.dark
                            ? const Color.fromRGBO(59, 61, 66, 1)
                            : Colors.white.withOpacity(0.2),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      const SizedBox(height: 10),
                                      Container(
                                        width: ResponsiveWidget.isSmallScreen(
                                                context)
                                            ? width / 1.1
                                            : width / 1.1,
                                        child: Text(
                                          category.getNameByLanguage(provider
                                                          .locale!
                                                          .languageCode) ==
                                                      'null' ||
                                                  category.getNameByLanguage(
                                                          provider.locale!
                                                              .languageCode) ==
                                                      '' ||
                                                  category.getNameByLanguage(
                                                          provider.locale!
                                                              .languageCode) ==
                                                      null
                                              ? category.name
                                              : category.getNameByLanguage(
                                                  provider
                                                      .locale!.languageCode),
                                          style: TextStyle(
                                            color: themeProvider.mode ==
                                                    ThemeMode.dark
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                ResponsiveWidget.isSmallScreen(
                                                        context)
                                                    ? width / 22
                                                    : width / 55,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      for (var channel in category.listChannel)
                                        ItemChannelView(
                                          channel: channel,
                                          showSetting: showSetting,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
              const SizedBox(height: 10)
            ],
          ));
    });
  }
}
