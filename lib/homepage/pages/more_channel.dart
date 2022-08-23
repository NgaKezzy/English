import 'dart:io';

import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/pages/screen_list_all_channel.dart';
import 'package:app_learn_english/homepage/pages/screen_list_channel.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class MoreChannel extends StatefulWidget {
  final List<Category> listCategory;
  final Function showSetting;
  MoreChannel({Key? key, required this.listCategory, required this.showSetting})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MoreChannelState(
        listCategory: listCategory, showSetting: showSetting);
  }
}

class _MoreChannelState extends State<MoreChannel> {
  List<Category> listCategory;
  final Function showSetting;
  _MoreChannelState(
      {Key? key, required this.listCategory, required this.showSetting});
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      return listCategory.length > 0
          ? _MoreChannelView(
              userData: userData,
              listCategory: listCategory,
              showSetting: showSetting,
            )
          : FutureBuilder(
              future: TalkAPIs().getListCategory(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return activeDialog(context, S.of(context).ErrorLoadData);
                }

                return snapshot.hasData
                    ? _MoreChannelView(
                        userData: userData,
                        listCategory: snapshot.data,
                        showSetting: showSetting,
                      )
                    : Scaffold(body: ScopedModelDescendant<DataUser>(
                        builder: (context, bhild, userData) {
                        double width = MediaQuery.of(context).size.width;
                        double height = MediaQuery.of(context).size.height;
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: height * 1,
                          width: width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.blue.shade700,
                                Colors.tealAccent.shade400,
                              ],
                            ),
                          ),
                          child: Center(
                            // child: Platform.isAndroid
                            // ? CircularProgressIndicator()
                            // : CupertinoActivityIndicator(),
                            child: const PhoLoading(),
                          ),
                        );
                      }));
              },
            );
    });
  }
}

class _MoreChannelView extends StatelessWidget {
  Widget _buildTab(String title) {
    return Tab(
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey.withOpacity(0.2),
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(title),
        ),
      ),
    );
  }

  final Function showSetting;
  final DataUser userData;
  final List<Category> listCategory;
  _MoreChannelView(
      {Key? key,
      required this.userData,
      required this.listCategory,
      required this.showSetting})
      : super(key: key);
  List<Category> getAllListCahnnel({listCat: List}) {
    List<Category> listChannel = [];
    for (Category cat in listCat) {
      for (Category channel in cat.listChannel) {
        listChannel.add(channel);
      }
    }
    return listChannel;
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
      return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: themeProvider.mode == ThemeMode.dark
                ? Color.fromRGBO(45, 48, 57, 1)
                : Colors.white,
            automaticallyImplyLeading: false,
            title: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => {
                      Navigator.pop(context),
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: themeProvider.mode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      S.of(context).Channel,
                      style: TextStyle(
                        color: themeProvider.mode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: ScopedModelDescendant<DataUser>(
            builder: (context, bhild, userData) {
              return Container(
                  // padding: EdgeInsets.symmetric(horizontal: 10),
                  height: height * 1,
                  width: width,
                  decoration: BoxDecoration(
                    // image: DecorationImage(
                    //     image: AssetImage('assets/images/background.png'),
                    //     fit: BoxFit.fill)
                    color: themeProvider.mode == ThemeMode.dark
                        ? Color.fromRGBO(25, 27, 34, 1)
                        : Colors.white,
                  ),
                  child: Column(
                    children: [
                      Divider(
                          thickness: 1,
                          color: themeProvider.mode == ThemeMode.dark
                              ? Colors.grey.shade700
                              : Color(0xFFE4E4E4),
                          height: 1),
                      SizedBox(
                        height: 15,
                      ),
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: DefaultTabController(
                          length: listCategory.length + 1,
                          initialIndex: 0,
                          child: Column(
                            children: [
                              TabBar(
                                isScrollable: true,
                                tabs: [
                                  _buildTab(S.of(context).Allchannels),
                                  for (var category in listCategory)
                                    _buildTab(category.getNameByLanguage(
                                        provider.locale!.languageCode)),
                                ],
                                labelColor: themeProvider.mode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black,
                                indicator: BoxDecoration(),
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                                unselectedLabelColor:
                                    themeProvider.mode == ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black,
                                unselectedLabelStyle: TextStyle(fontSize: 18),
                                indicatorSize: TabBarIndicatorSize.label,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Expanded(
                                child: TabBarView(children: [
                                  ListAllChannelScreen(
                                    listChannel: getAllListCahnnel(
                                        listCat: listCategory),
                                    showSetting: showSetting,
                                  ),
                                  for (var category in listCategory)
                                    ListChannelScreen(
                                      category: category,
                                      showSetting: showSetting,
                                    ),
                                ]),
                              )
                            ],
                          ),
                        ),
                      ))
                    ],
                  ));
            },
          ));
    });
  }
}
