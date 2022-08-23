import 'dart:io';

import 'package:app_learn_english/Providers/home_provider.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/Providers/user_provider.dart';
import 'package:app_learn_english/extentions/RoutersManager.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/provider/statistical_provider.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/model_local/SettingModel.dart';

import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/DataOffline.dart';
import 'package:app_learn_english/networks/SocialNetworks.dart';
import 'package:app_learn_english/presentation/Vip/Vip_widget.dart';
import 'package:app_learn_english/presentation/profile/AppInfo/FAQ.dart';
import 'package:app_learn_english/presentation/profile/AppInfo/OpenSourceCopyright.dart';
import 'package:app_learn_english/presentation/profile/AppInfo/PrivacyPolicy.dart';
import 'package:app_learn_english/presentation/profile/Setting_Notification.dart';
import 'package:app_learn_english/presentation/profile/changeNickName.dart';
import 'package:app_learn_english/presentation/profile/changePassword.dart';
import 'package:app_learn_english/presentation/profile/changelanguage.dart';
import 'package:app_learn_english/presentation/profile/confirmEmail.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';

import 'package:app_learn_english/screens/login_account_screen.dart';
import 'package:app_learn_english/socket/provider/socket_provider.dart';
import 'package:app_learn_english/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'changeName.dart';
import 'package:launch_review/launch_review.dart';

class SettingView extends StatelessWidget {
  DataUser dataUser;
  SettingOffline settingData;

  SettingView({Key? key, required this.dataUser, required this.settingData})
      : super(key: key);

  void showChangeName(BuildContext context, DataUser dataUser) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ScopedModel<DataUser>(model: dataUser, child: changeName())),
    ).then((value) => {(context as Element).markNeedsBuild()});
  }

  DataUser userFake = DataCache().getUserData();

  void logOut(BuildContext context) async {
    context.read<UserProvider>().setAvatarUser(null);
    final prefs = await SharedPreferences.getInstance();
    prefs.clear().then((value) => {
          printYellow("CLEAR OK "),
          SocialNetworks().facebookLogout(),
          SocialNetworks().googleLogout(),
          DataOffline().clearCache(),
          RoutersManager().clearRoute(),
          DataCache().setUserData(null),
          Provider.of<LocaleProvider>(context, listen: false)
              .reloadWithLogout(),
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => LoginAccountScreen(),
            ),
            (route) => false,
          ),
        });
    var staticsticalProvider = Provider.of<StaticsticalProvider>(
      context,
      listen: false,
    );
    staticsticalProvider.clear();
    print('Đây là count: ${prefs.getInt('Heart_Global')}');
  }

  void showChangeNickName(BuildContext context, DataUser dataUser) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ScopedModel<DataUser>(model: dataUser, child: changeNickName())),
    ).then((value) => {(context as Element).markNeedsBuild()});
  }

  void showChangePassword(BuildContext context, DataUser dataUser) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ScopedModel<DataUser>(model: dataUser, child: changePassword())),
    ).then((value) => {(context as Element).markNeedsBuild()});
  }

  void showConfirmMail(BuildContext context, DataUser dataUser) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ScopedModel<DataUser>(model: dataUser, child: confirmEmail())),
    ).then((value) => {(context as Element).markNeedsBuild()});
  }

  void showScreenVip(BuildContext context, DataUser dataUser) async {
    Navigator.pushNamed(context, VipWidget.routeName);
  }

  ///View change background
  Widget _buildChangeBackground(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                S.of(context).DarkMode,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          ToggleSwitch(
            cornerRadius: 20.0,
            activeBgColors: [
              [const Color.fromRGBO(193, 189, 198, 1)],
              [const Color.fromRGBO(109, 39, 129, 1)]
            ],
            fontSize: 11,
            minHeight: 32,
            minWidth: 37,
            animate: true,
            activeFgColor: Colors.white,
            inactiveFgColor: Colors.white,
            initialLabelIndex:
                Provider.of<ThemeProvider>(context, listen: false).mode ==
                        ThemeMode.dark
                    ? 1
                    : 0,
            totalSwitches: 2,
            icons: [Icons.light_mode_sharp, Icons.nightlight_rounded],
            radiusStyle: true,
            onToggle: (index) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              HapticFeedback.mediumImpact();
              Provider.of<ThemeProvider>(context, listen: false)
                  .toggleMode(prefs);
              prefs.setBool(
                  'isDarkMode',
                  Provider.of<ThemeProvider>(context, listen: false).mode ==
                          ThemeMode.dark
                      ? true
                      : false);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var configApp = context.read<HomeProvider>().configApp;
    var themeProvider = context.watch<ThemeProvider>();
    var localProvider = context.watch<LocaleProvider>();
    bool switchFacebook = (DataCache().getUserData() != null
        ? DataCache().getUserData().connectFacebook == 1
        : false);
    bool switchGoogle = (DataCache().getUserData() != null
        ? DataCache().getUserData().connectGoogle == 1
        : false);

    return Container(
      decoration: BoxDecoration(
        color: themeProvider.mode == ThemeMode.dark
            ? Color.fromRGBO(42, 44, 50, 1)
            : Colors.white,
      ),
      child: Column(
        // physics: const BouncingScrollPhysics(),
        children: [
          _buildChangeBackground(context),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 10,
            color: themeProvider.mode == ThemeMode.dark
                ? Color.fromRGBO(24, 26, 33, 1)
                : Color.fromRGBO(236, 236, 236, 1),
          ),
          // const SizedBox(),
          // if (dataUser.uid != 0)
          //   Container(
          //     height: 10,
          //     width: MediaQuery.of(context).size.width,
          //     color: themeProvider.mode == ThemeMode.dark
          //         ? Color.fromRGBO(24, 26, 33, 1)
          //         : Color.fromRGBO(236, 236, 236, 1),
          //   ),
          // if (dataUser.uid != 0) SizedBox(height: 20),
          // dataUser.uid != 0
          //     ? Container(
          //         padding: const EdgeInsets.symmetric(horizontal: 16),
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               S.of(context).LinkedLogin,
          //               style: TextStyle(
          //                 fontSize: 20,
          //                 color: themeProvider.mode == ThemeMode.dark
          //                     ? Colors.white
          //                     : Colors.black,
          //                 fontWeight: FontWeight.w600,
          //               ),
          //             ),
          //             const SizedBox(height: 15),
          //             Row(
          //               children: [
          //                 SvgPicture.asset(
          //                   'assets/new_ui/more/facebook.svg',
          //                   height: 55,
          //                 ),
          //                 const SizedBox(
          //                   width: 10,
          //                 ),
          //                 Text(
          //                   'Facebook',
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.normal,
          //                     fontSize: 18,
          //                   ),
          //                 ),
          //                 Spacer(),
          //                 ToggleSwitch(
          //                   cornerRadius: 20.0,
          //                   activeBgColors: [
          //                     [const Color.fromRGBO(193, 189, 198, 1)],
          //                     [const Color.fromRGBO(83, 180, 81, 1)]
          //                   ],
          //                   fontSize: 11,
          //                   minHeight: 35,
          //                   minWidth: 40,
          //                   animate: true,
          //                   activeFgColor: Colors.white,
          //                   inactiveBgColor:
          //                       const Color.fromRGBO(226, 226, 226, 1),
          //                   inactiveFgColor: Colors.white,
          //                   initialLabelIndex: switchFacebook ? 1 : 0,
          //                   totalSwitches: 2,
          //                   labels: switchFacebook ? ['', 'ON'] : ['OFF', ''],
          //                   radiusStyle: true,
          //                   onToggle: (index) {
          //                     if (DataCache().getUserData().connectFacebook ==
          //                         0) {
          //                       SocialNetworks()
          //                           .facebookConnect()
          //                           .then((value) => {
          //                                 if (value == 1)
          //                                   {
          //                                     switchFacebook = true,
          //                                     (context as Element)
          //                                         .markNeedsBuild(),
          //                                     activeDialog(
          //                                         context,
          //                                         S
          //                                             .of(context)
          //                                             .AccountLinkSuccessful)
          //                                   }
          //                                 else if (value == -1)
          //                                   {
          //                                     switchFacebook = false,
          //                                     (context as Element)
          //                                         .markNeedsBuild(),
          //                                     activeDialog(
          //                                         context,
          //                                         S
          //                                             .of(context)
          //                                             .ThisAccountMayAlready)
          //                                   }
          //                                 else
          //                                   {
          //                                     switchFacebook = false,
          //                                     (context as Element)
          //                                         .markNeedsBuild(),
          //                                     activeDialog(
          //                                         context,
          //                                         S
          //                                             .of(context)
          //                                             .CanNotLinkToThisAccount)
          //                                   },
          //                               });
          //                     } else {
          //                       showDialog(
          //                           context: context,
          //                           builder: (BuildContext context) {
          //                             return new AlertDialog(
          //                               title: new Text(S.of(context).Notify),
          //                               content: new Text(
          //                                   S.of(context).UnlinkSocial),
          //                               actions: <Widget>[
          //                                 TextButton(
          //                                   onPressed: () {
          //                                     logOut(context);
          //                                   },
          //                                   child: Text(S.of(context).Confirm,
          //                                       style: TextStyle(fontSize: 18)),
          //                                 ),
          //                               ],
          //                             );
          //                           });
          //                     }
          //                   },
          //                 ),
          //               ],
          //             ),
          //             Divider(
          //               thickness: 1,
          //               color: Colors.grey.withOpacity(0.5),
          //             ),
          //             Row(
          //               children: [
          //                 SvgPicture.asset(
          //                   'assets/new_ui/more/google.svg',
          //                   height: 55,
          //                 ),
          //                 const SizedBox(
          //                   width: 10,
          //                 ),
          //                 Text(
          //                   'Google',
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.normal,
          //                     fontSize: 18,
          //                   ),
          //                 ),
          //                 Spacer(),
          //                 ToggleSwitch(
          //                   cornerRadius: 20.0,
          //                   activeBgColors: [
          //                     [const Color.fromRGBO(193, 189, 198, 1)],
          //                     [const Color.fromRGBO(83, 180, 81, 1)]
          //                   ],
          //                   fontSize: 11,
          //                   minHeight: 35,
          //                   minWidth: 40,
          //                   animate: true,
          //                   activeFgColor: Colors.white,
          //                   inactiveBgColor:
          //                       const Color.fromRGBO(226, 226, 226, 1),
          //                   inactiveFgColor: Colors.white,
          //                   initialLabelIndex: switchGoogle ? 1 : 0,
          //                   totalSwitches: 2,
          //                   labels: switchGoogle ? ['', 'ON'] : ['OFF', ''],
          //                   radiusStyle: true,
          //                   onToggle: (index) {
          //                     if (DataCache().getUserData().connectGoogle ==
          //                         0) {
          //                       SocialNetworks().googleConnect().then((value) =>
          //                           {
          //                             if (value == 1)
          //                               {
          //                                 showDialog(
          //                                     context: context,
          //                                     builder: (BuildContext context) {
          //                                       return new AlertDialog(
          //                                         title: new Text(
          //                                             S.of(context).Notify),
          //                                         content: new Text(S
          //                                             .of(context)
          //                                             .AccountLinkSuccessful),
          //                                         actions: <Widget>[
          //                                           TextButton(
          //                                             onPressed: () {
          //                                               switchGoogle = true;
          //                                               (context as Element)
          //                                                   .markNeedsBuild();
          //                                             },
          //                                             child: Text(
          //                                                 S.of(context).Confirm,
          //                                                 style: TextStyle(
          //                                                     fontSize: 18)),
          //                                           ),
          //                                         ],
          //                                       );
          //                                     })
          //                               }
          //                             else if (value == -1)
          //                               {
          //                                 showDialog(
          //                                     context: context,
          //                                     builder: (BuildContext context) {
          //                                       return new AlertDialog(
          //                                         title: new Text(
          //                                             S.of(context).Notify),
          //                                         content: new Text(S
          //                                             .of(context)
          //                                             .ThisAccountMayAlready),
          //                                         actions: <Widget>[
          //                                           TextButton(
          //                                             onPressed: () {
          //                                               switchGoogle = false;
          //                                               (context as Element)
          //                                                   .markNeedsBuild();
          //                                             },
          //                                             child: Text(
          //                                                 S.of(context).Confirm,
          //                                                 style: TextStyle(
          //                                                     fontSize: 18)),
          //                                           ),
          //                                         ],
          //                                       );
          //                                     })
          //                               }
          //                             else
          //                               {
          //                                 showDialog(
          //                                     context: context,
          //                                     builder: (BuildContext context) {
          //                                       return new AlertDialog(
          //                                         title: new Text(
          //                                             S.of(context).Notify),
          //                                         content: new Text(S
          //                                             .of(context)
          //                                             .CanNotLinkToThisAccount),
          //                                         actions: <Widget>[
          //                                           TextButton(
          //                                             onPressed: () {
          //                                               switchGoogle = false;
          //                                               (context as Element)
          //                                                   .markNeedsBuild();
          //                                             },
          //                                             child: Text(
          //                                                 S.of(context).Confirm,
          //                                                 style: TextStyle(
          //                                                     fontSize: 18)),
          //                                           ),
          //                                         ],
          //                                       );
          //                                     })
          //                               },
          //                           });
          //                     } else {
          //                       showDialog(
          //                           context: context,
          //                           builder: (BuildContext context) {
          //                             return new AlertDialog(
          //                               title: new Text(S.of(context).Notify),
          //                               content: new Text(
          //                                   S.of(context).UnlinkSocial),
          //                               actions: <Widget>[
          //                                 TextButton(
          //                                   onPressed: () {
          //                                     logOut(context);
          //                                   },
          //                                   child: Text(S.of(context).Confirm,
          //                                       style: TextStyle(fontSize: 18)),
          //                                 ),
          //                               ],
          //                             );
          //                           });
          //                     }
          //                   },
          //                 ),
          //               ],
          //             ),
          //           ],
          //         ),
          //       )
          //     : const SizedBox(),

          if (dataUser.uid != 0)
            const SizedBox(
              height: 20,
            ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).Language,
                  style: TextStyle(
                    fontSize: 20,
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Utils.nameCountry((localProvider.codeLangeSub != null)
                          ? localProvider.codeLangeSub!
                          : localProvider.locale!.languageCode),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[600],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Languages(settingData: settingData),
                          ),
                        );
                      },
                      child: Text(
                        S.of(context).Change,
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromRGBO(122, 111, 236, 1),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 10,
            color: themeProvider.mode == ThemeMode.dark
                ? Color.fromRGBO(24, 26, 33, 1)
                : Color.fromRGBO(236, 236, 236, 1),
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'VIP',
                  style: TextStyle(
                    fontSize: 20,
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      S.of(context).PaidRecovery,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        showScreenVip(context, dataUser);
                      },
                      child: Text(
                        S.of(context).Restore,
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromRGBO(122, 111, 236, 1),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   height: 60,
                //   child: Text(
                //     S.of(context).NotificationSettings,
                //     style: TextStyle(
                //       fontSize: 18,
                //       color: Colors.black,
                //       fontWeight: FontWeight.w800,
                //     ),
                //   ),
                // ),
                Container(
                  child: ScopedModel(
                    model: settingData,
                    child: NotificatonScreen(),
                  ),
                ),
              ],
            ), // truyền data setting sang
          ),
          // const SizedBox(
          //   height: 5,
          // ),
          Container(
            height: 10,
            width: MediaQuery.of(context).size.width,
            color: themeProvider.mode == ThemeMode.dark
                ? Color.fromRGBO(24, 26, 33, 1)
                : Color.fromRGBO(236, 236, 236, 1),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).Support,
                  style: TextStyle(
                    fontSize: 20,
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: () {
                    launch(
                        'mailto:lovepho.english@gmail.com?subject=[Pho English] Báo cáo lỗi Title&body=This is Body of Email');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset('assets/new_ui/more/message.svg'),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              S.of(context).ErrorReportOrSuggestion,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                color: themeProvider.mode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        RotatedBox(
                          quarterTurns: 2,
                          child: SvgPicture.asset(
                            'assets/new_ui/more/Iconly-Arrow-Left.svg',
                            height: 30,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                InkWell(
                  onTap: () {
                    LaunchReview.launch(
                      androidAppId: "com.lovepho",
                      iOSAppId: "com.lovepho",
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset("assets/new_ui/more/star.svg"),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              S.of(context).Rate5StarsToSupportTheTeam,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                color: themeProvider.mode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        RotatedBox(
                          quarterTurns: 2,
                          child: SvgPicture.asset(
                            'assets/new_ui/more/Iconly-Arrow-Left.svg',
                            height: 30,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                InkWell(
                  onTap: () {
                    print('Đây là config app $configApp');
                    if (configApp != null) {
                      launch(configApp.fb!);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset('assets/new_ui/more/facebook.svg'),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              S.of(context).FacebookPage,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                color: themeProvider.mode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        RotatedBox(
                          quarterTurns: 2,
                          child: SvgPicture.asset(
                            'assets/new_ui/more/Iconly-Arrow-Left.svg',
                            height: 30,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                InkWell(
                  onTap: () {
                    // Platform.isAndroid
                    //     ? Share.share(
                    //         'https://www.facebook.com/sharer/sharer.php?u=https://play.google.com/store/apps/details?id=com.lovepho')
                    //     : Share.share(
                    //         'https://www.facebook.com/sharer/sharer.php?u=https://apps.apple.com/us/app/lovepho/idcom.lovepho');
                    Platform.isAndroid
                        ? Share.share(
                            'https://www.facebook.com/sharer/sharer.php?u=https://play.google.com/store/apps/details?id=${configApp!.androidApp}')
                        : Share.share(
                            'https://www.facebook.com/sharer/sharer.php?u=https://apps.apple.com/us/app/lovepho/id${configApp!.iosApp}');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset('assets/new_ui/more/friend.svg'),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              S.of(context).RecommendToFriends,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                color: themeProvider.mode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        RotatedBox(
                          quarterTurns: 2,
                          child: SvgPicture.asset(
                            'assets/new_ui/more/Iconly-Arrow-Left.svg',
                            height: 30,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 10,
            width: MediaQuery.of(context).size.width,
            color: themeProvider.mode == ThemeMode.dark
                ? Color.fromRGBO(24, 26, 33, 1)
                : Color.fromRGBO(236, 236, 236, 1),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).ApplicationInformation,
                  style: TextStyle(
                    fontSize: 20,
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FAQ()));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'FAQ',
                          style: TextStyle(
                            fontSize: 18,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        RotatedBox(
                          quarterTurns: 2,
                          child: SvgPicture.asset(
                            'assets/new_ui/more/Iconly-Arrow-Left.svg',
                            height: 30,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).Cache,
                          style: TextStyle(
                            fontSize: 18,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        RotatedBox(
                          quarterTurns: 2,
                          child: SvgPicture.asset(
                            'assets/new_ui/more/Iconly-Arrow-Left.svg',
                            height: 30,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).Version,
                          style: TextStyle(
                            fontSize: 18,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          '1.1',
                          style: TextStyle(
                            fontSize: 16,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrivacyPolicy(),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).PrivacyPolicy,
                          style: TextStyle(
                            fontSize: 18,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        RotatedBox(
                          quarterTurns: 2,
                          child: SvgPicture.asset(
                            'assets/new_ui/more/Iconly-Arrow-Left.svg',
                            height: 30,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                InkWell(
                  onTap: () {
                    launch('https://phoenglish.com/eula');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).TermsOfUse,
                          style: TextStyle(
                            fontSize: 18,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        RotatedBox(
                          quarterTurns: 2,
                          child: SvgPicture.asset(
                            'assets/new_ui/more/Iconly-Arrow-Left.svg',
                            height: 30,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OpenSourceCopyright(),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).OpenSourceCopyright,
                          style: TextStyle(
                            fontSize: 18,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        RotatedBox(
                          quarterTurns: 2,
                          child: SvgPicture.asset(
                            'assets/new_ui/more/Iconly-Arrow-Left.svg',
                            height: 30,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                InkWell(
                  onTap: () {
                    _buildDialog(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).DeleteAccount,
                          style: TextStyle(
                            fontSize: 18,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        RotatedBox(
                          quarterTurns: 2,
                          child: SvgPicture.asset(
                            'assets/new_ui/more/Iconly-Arrow-Left.svg',
                            height: 30,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            color: themeProvider.mode == ThemeMode.dark
                ? const Color.fromRGBO(24, 26, 33, 1)
                : const Color.fromRGBO(236, 236, 236, 1),
            child: ElevatedButton(
              onPressed: () async {
                logOut(context);
                var socketProvider = context.read<SocketProvider>();
                socketProvider.socketChannel!.sink.close();
                socketProvider.setSocketChanel(null);
                socketProvider.setOpenSocket(false);
                socketProvider.setIsShowing(false);
                socketProvider.setIsLogoutCheck(false);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: userFake.uid == 0
                        ? [
                            Color.fromRGBO(108, 168, 67, 1),
                            Color.fromRGBO(179, 220, 115, 1),
                          ]
                        : [
                            Color.fromRGBO(236, 82, 110, 1),
                            Color.fromRGBO(236, 89, 60, 1),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  width: double.infinity,
                  height: 65,
                  alignment: Alignment.center,
                  child: Text(
                    userFake.uid == 0
                        ? S.of(context).Login
                        : S.of(context).LogOut,
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    // );
  }

  _buildDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height / 3,
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).ThisRequest,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        var user = DataCache().getUserData();
                        var pass = DataCache().tempPassWord;
                        if (pass.isNotEmpty) {
                          launch(
                              'https://phoenglish.com/deleteAccount?uid=22&${user.username}&$pass');
                        } else {
                          Fluttertoast.showToast(msg: 'Error');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          // gradient: const LinearGradient(
                          //   colors: [
                          //     Color.fromRGBO(108, 168, 67, 1),
                          //     Color.fromRGBO(179, 220, 115, 1),
                          //   ],
                          // ),
                          color: Color(0xFF04D076),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.width <= 375
                              ? 60
                              : 65,
                          alignment: Alignment.center,
                          child: Text(
                            S.of(context).Accept,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          // gradient: const LinearGradient(
                          //   colors: [
                          //     Color.fromRGBO(108, 168, 67, 1),
                          //     Color.fromRGBO(179, 220, 115, 1),
                          //   ],
                          // ),
                          color: Color(0xFFE9C145),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.width <= 375
                              ? 60
                              : 65,
                          alignment: Alignment.center,
                          child: Text(
                            S.of(context).Escape,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
