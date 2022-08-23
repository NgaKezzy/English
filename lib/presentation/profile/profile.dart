import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';

import 'package:app_learn_english/model_local/SettingModel.dart';
import 'package:app_learn_english/models/CountryAll.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/DataOffline.dart';

import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';

import 'package:app_learn_english/presentation/profile/widgets/user_info_widget.dart';
import 'package:app_learn_english/presentation/profile/widgets/user_statement.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/screens/lecturers_screen.dart';
import 'package:app_learn_english/startpage/widget/utils_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

import 'SettingScreen.dart';

class Profile extends StatefulWidget {
  static const routeName = '/profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int heart = 5;
  DataUser userData = DataCache().getUserData();

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Consumer<LocaleProvider>(
      builder: (context, provider, snapshot) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: themeProvider.mode == ThemeMode.dark
                ? Color.fromRGBO(45, 48, 57, 1)
                : Colors.white,
            automaticallyImplyLeading: false,
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
            leadingWidth: 50,
            title: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      S.of(context).Profile,
                      style: TextStyle(
                        color: themeProvider.mode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // actions: [
            //   SizedBox(width: 20),
            //   Container(
            //     padding: EdgeInsets.only(right: 16),
            //     child: InkWell(
            //       onTap: () {
            //         showSetting(context, userData);
            //       },
            //       child: SvgPicture.asset(
            //         'assets/new_ui/more/Iconly-Light-Setting.svg',
            //         color: themeProvider.mode == ThemeMode.dark
            //             ? Colors.white
            //             : Colors.black,
            //         height: 28,
            //       ),
            //     ),
            //   )
            // ],
          ),
          body: Column(
            children: [
              Divider(
                  thickness: 1,
                  color: themeProvider.mode == ThemeMode.dark
                      ? Colors.grey.shade700
                      : Color(0xFFE4E4E4),
                  height: 1),
              Expanded(
                child: Scaffold(
                  backgroundColor: themeProvider.mode == ThemeMode.dark
                      ? const Color.fromRGBO(24, 26, 33, 1)
                      : const Color.fromRGBO(236, 236, 236, 1),
                  body: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: UserInfoWidget(userData: userData),
                            ),
                            // button đăng ký giảng viên
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // Container(
                            //   padding:
                            //       const EdgeInsets.symmetric(horizontal: 17),
                            //   width: MediaQuery.of(context).size.width,
                            //   height: 55,
                            //   child: ElevatedButton(
                            //     style: ElevatedButton.styleFrom(
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(15),
                            //       ),
                            //     ),
                            //     onPressed: () {
                            //       Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) =>
                            //                 const Lecturers()),
                            //       );
                            //     },
                            //     child: Text("Đăng ký tài khoản giảng viên",
                            //         style: TextStyle(fontSize: 18)),
                            //   ),
                            // ),
                            const SizedBox(height: 10),

                            UtilsWidget().viewVipUpgradeVip(context),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: UserStatementWidget(userData: userData),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            // Achievements(),
                            FutureBuilder(
                                future: DataOffline()
                                    .getDataSetting(keyData: "MainSetting"),
                                builder: (context, AsyncSnapshot settingData) {
                                  if (settingData.hasError) {
                                    SettingOffline settingData =
                                        new SettingOffline(
                                            switchMCHD: true,
                                            switchHDOT: false,
                                            switchTTGD: true,
                                            switchTBH: false,
                                            switchTTSK: false,
                                            switchCBHGR: false,
                                            switchNDMTKDK: false,
                                            language: new CountryModel(
                                                id: 2,
                                                sortname: "en",
                                                name: "Tiếng Anh",
                                                status: 0));
                                    DataOffline().saveDataOffline(
                                        "MainSetting", settingData);
                                    // gọi giao diện setting ở đây(trường hợp data mặc định)
                                    return SettingView(
                                      dataUser: userData,
                                      settingData: settingData,
                                    );
                                  }
                                  if (settingData.hasData) {
                                    // gọi giao diện setting khi đã có data từ local từ trước
                                    return SettingView(
                                        dataUser: userData,
                                        settingData: settingData.data);
                                  } else {
                                    // return Platform.isAndroid
                                    //     ? CircularProgressIndicator()
                                    //     : CupertinoActivityIndicator();
                                    return const PhoLoading();
                                  }
                                })
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
