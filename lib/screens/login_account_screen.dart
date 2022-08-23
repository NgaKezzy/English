import 'dart:convert';
import 'dart:io';

import 'package:app_learn_english/Providers/check_login.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/Providers/user_provider.dart';
import 'package:app_learn_english/extentions/FunctionService.dart';
import 'package:app_learn_english/extentions/RoutersManager.dart';
import 'package:app_learn_english/extentions/ValidatorExtention.dart';
import 'package:app_learn_english/extentions/constants.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/provider/statistical_provider.dart';
import 'package:app_learn_english/logError/LogCustom.dart';

import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/DataOffline.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/networks/SocialNetworks.dart';

import 'package:app_learn_english/networks/TargetAPIs.dart';
import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:app_learn_english/presentation/home/home.dart';
import 'package:app_learn_english/presentation/profile/AppInfo/PrivacyPolicy.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';

import 'package:app_learn_english/presentation/profile/widgets/password_field.dart';
import 'package:app_learn_english/presentation/profile/widgets/text_field_icon.dart';
import 'package:app_learn_english/screens/register_account_screen.dart';
import 'package:app_learn_english/socket/provider/socket_provider.dart';
import 'package:app_learn_english/socket/utils/parser_data.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/forgot_password_screen.dart';

class LoginAccountScreen extends StatefulWidget {
  const LoginAccountScreen({Key? key}) : super(key: key);

  @override
  State<LoginAccountScreen> createState() => _LoginAccountScreenState();
}

class _LoginAccountScreenState extends State<LoginAccountScreen> {
  // static const routeName = '/login-account';

  void showForgotAccount(BuildContext context) {
    Navigator.of(context).pushNamed(ForgotAccountScreen.routeName);
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  void loginComplete(
      BuildContext context, DataUser userData, String password) async {
    TargetAPIs().getDataTarget(userData.uid).then((value) {
      DataCache().setUserTargetLogModel(value);
    });
    DataCache().setTempPassWord(ParseDataSocket.generateMd5(password));
    DataOffline()
        .savePasswordMd5(password: ParseDataSocket.generateMd5(password));
    DataCache().setUserData(userData);
    if (userData.avatar.isNotEmpty) {
      context.read<UserProvider>().setAvatarUser(
          'https://${Session().BASE_URL}/images/user_avatars/${userData.avatar}');
    } else {
      context.read<UserProvider>().setAvatarUser(null);
    }

    DataOffline().saveDataFirtUse("isFirtUse", 1);

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', jsonEncode(userData.toJson()));
    prefs.setString('passMd5', jsonEncode(generateMd5(password)));
    prefs.setString('login', "");
    Map<String, dynamic> dataUserLocal =
        await DataOffline().getDataLocal(keyData: "userData");
    Provider.of<CheckLogin>(context, listen: false).setUserData(dataUserLocal);
    RoutersManager().setRoute("Loggedin");

    FunctionService().implProviderFunction();
    (context as Element).markNeedsBuild();
    // if (userData.uid != 0) {
    //   Utils().showNotificationBottom(true, S.of(context).LoggedInSuccessfully);
    // }
    context.read<SocketProvider>().setIsLogoutCheck(true);
    Provider.of<LocaleProvider>(context, listen: false).reloadWithLogin();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ScopedModel<DataUser>(
          model: userData,
          child: HomePage(),
        ),
      ),
      (route) => false,
    );
  }

  void signinComplete(BuildContext context, DataUser userData) {
    DataOffline().saveDataFirtUse("isFirtUse", 1);
    TargetAPIs().getDataTarget(userData.uid).then((value) {
      DataCache().setUserTargetLogModel(value);
    });

    Provider.of<CheckLogin>(context, listen: false).setIsFirstUse(1);
    context.read<UserProvider>().setAvatarUser(userData.avatar);
    RoutersManager().setRoute("Loggedin");
    FunctionService().implProviderFunction();
    (context as Element).markNeedsBuild();

    context.read<SocketProvider>().setIsLogoutCheck(true);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ScopedModel<DataUser>(
          model: userData,
          child: HomePage(),
        ),
      ),
      (route) => false,
    );
  }

  DataUser userFake = DataUser(
      uid: 0,
      username: '',
      fullname: '',
      email: '',
      sex: 1,
      country: '',
      langnative: 'EL',
      avatar: '',
      activeEmail: 1,
      totalExp: 0,
      totalNewWord: 0,
      totalVideoComplete: 0,
      totalTalkComplete: 0,
      totalVideoPlus: 0,
      createdtime: '',
      updatetime: '',
      lastDateLogin: '',
      isVip: 0,
      createVipTime: '',
      connectFacebook: 0,
      connectGoogle: 0,
      listCateFollow: [],
      level: 1,
      gold: 0,
      heart: 0);

  final userNameCtrl = TextEditingController();

  final passwordCtrl = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    print("Rebuild:${1}");
    return GestureDetector(
      onTap: () {
        print("HideKeyBoard");
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: themeProvider.mode == ThemeMode.dark
              ? const Color.fromRGBO(45, 48, 57, 1)
              : Colors.white,
          title: Text(
            S.of(context).Login,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width <= 375 ? 20 : 22,
              fontWeight: FontWeight.w600,
              color: themeProvider.mode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          leading: SvgPicture.asset(
            'assets/new_ui/more/Iconly-Arrow-Left.svg',
            fit: BoxFit.scaleDown,
            height: MediaQuery.of(context).size.width <= 375 ? 25 : 30,
            color: themeProvider.mode == ThemeMode.dark
                ? Colors.white
                : Colors.black,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: InkWell(
                onTap: () => {
                  Provider.of<CheckLogin>(context, listen: false)
                      .setIsFirstUse(1),
                  DataOffline().saveDataFirtUse("isFirtUse", 1),
                  loginComplete(context, userFake, ''),
                },
                child: Container(
                  height: 30,
                  width: 30,
                  child: Icon(
                    Icons.close,
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    size: MediaQuery.of(context).size.width <= 375 ? 20 : 25,
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: themeProvider.mode == ThemeMode.dark
            ? Color.fromRGBO(24, 26, 33, 1)
            : Colors.white,
        body: Column(
          children: [
            Divider(
                thickness: 1,
                color: themeProvider.mode == ThemeMode.dark
                    ? Colors.grey.shade800
                    : Color(0xFFE4E4E4),
                height: 1),
            Expanded(
              child: Consumer<LocaleProvider>(
                builder: (context, checkerTouter, snapshot) {
                  return Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).viewPadding.top -
                        AppBar().preferredSize.height -
                        10,
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.width <= 375
                                    ? 20
                                    : 100,
                              ),
                              Container(
                                child: Form(
                                  key: formKey,
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              S.of(context).JoinPhoEnglish,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              S.of(context).SafelyStoreAcademic,
                                              style: TextStyle(fontSize: 16),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        TextFieldWidget(
                                          controller: userNameCtrl,
                                          labelText: S.of(context).UserName +
                                              ", Email",
                                          icon: SvgPicture.asset(
                                            'assets/new_ui/more/Iconly-Light-Profile.svg',
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        PasswordFieldWidget(
                                          controller: passwordCtrl,
                                          labelText: S.of(context).Password,
                                        ),
                                        const SizedBox(height: 20),
                                        Consumer<CheckLogin>(builder: (context,
                                            checkLoginProvider, wiget) {
                                          return ElevatedButton(
                                            onPressed: () async {
                                              if (checkLoginProvider.checkIp) {
                                                String? token =
                                                    await FirebaseMessaging
                                                        .instance
                                                        .getToken();
                                                if (Validator().checkValidate(
                                                        Constants.TYPE_USERNAME,
                                                        context,
                                                        userNameCtrl.text) &&
                                                    Validator().checkValidate(
                                                        Constants.TYPE_PASSWORD,
                                                        context,
                                                        passwordCtrl.text)) {
                                                  Provider.of<CheckLogin>(
                                                          context,
                                                          listen: false)
                                                      .setIsFirstUse(1);
                                                  UserAPIs()
                                                      .userLogin(
                                                    userNameCtrl.text,
                                                    passwordCtrl.text,
                                                    token,
                                                  )
                                                      .then(
                                                    (value) {
                                                      if (value != null) {
                                                        printRed(value
                                                            .toJson()
                                                            .toString());
                                                        var staticsticalProvider =
                                                            Provider.of<
                                                                    StaticsticalProvider>(
                                                                context,
                                                                listen: false);

                                                        loginComplete(
                                                            context,
                                                            value,
                                                            passwordCtrl.text
                                                                .trim());
                                                        staticsticalProvider
                                                            .updateTotalTalk(value
                                                                .totalTalkComplete);
                                                        staticsticalProvider
                                                            .updateTotalVideos(value
                                                                .totalVideoComplete);
                                                        staticsticalProvider
                                                            .updateTotalVideosVip(
                                                                value
                                                                    .totalVideoPlus);
                                                      } else {
                                                        activeDialog(
                                                            context,
                                                            S
                                                                .of(context)
                                                                .LoginFailed);
                                                      }
                                                    },
                                                  );
                                                }
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              elevation: 0,
                                            ),
                                            child: Consumer<CheckLogin>(builder:
                                                (context, checkLoginProvider,
                                                    wiget) {
                                              return Ink(
                                                decoration: BoxDecoration(
                                                  color: (checkLoginProvider
                                                          .checkIp)
                                                      ? Color(0xFF04D076)
                                                      : Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Container(
                                                  width: double.infinity,
                                                  height: MediaQuery.of(context)
                                                              .size
                                                              .width <=
                                                          375
                                                      ? 60
                                                      : 65,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    S.of(context).Login,
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width <=
                                                                  375
                                                              ? 20
                                                              : 22,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.width <= 375
                                    ? 15
                                    : 25,
                              ),

                              // Divider(
                              //   thickness: 1,
                              //   color: Colors.grey.withOpacity(0.4),
                              // ),
                              SizedBox(
                                height: MediaQuery.of(context).size.width <= 375
                                    ? 10
                                    : 20,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        try {
                                          SocialNetworks()
                                              .facebookSigin()
                                              .then((value) {
                                            if (value != null) {
                                              signinComplete(context, value);

                                              var staticsticalProvider =
                                                  Provider.of<
                                                      StaticsticalProvider>(
                                                context,
                                                listen: false,
                                              );

                                              staticsticalProvider
                                                  .updateTotalTalk(DataCache()
                                                      .getUserData()
                                                      .totalTalkComplete);

                                              staticsticalProvider
                                                  .updateTotalVideos(DataCache()
                                                      .getUserData()
                                                      .totalVideoComplete);

                                              staticsticalProvider
                                                  .updateTotalVideosVip(
                                                      DataCache()
                                                          .getUserData()
                                                          .totalVideoPlus);
                                            } else {
                                              activeDialog(context,
                                                  S.of(context).LoginFailed);
                                            }
                                          });
                                        } catch (error) {}
                                      },
                                      child: SvgPicture.asset(
                                        'assets/new_ui/more/facebook.svg',
                                        height:
                                            MediaQuery.of(context).size.width <=
                                                    375
                                                ? 40
                                                : 55,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        SocialNetworks()
                                            .googleSigin()
                                            .then((value) {
                                          if (value != null) {
                                            signinComplete(context, value);

                                            var staticsticalProvider = Provider
                                                .of<StaticsticalProvider>(
                                              context,
                                              listen: false,
                                            );
                                            staticsticalProvider
                                                .updateTotalTalk(DataCache()
                                                    .getUserData()
                                                    .totalTalkComplete);
                                            staticsticalProvider
                                                .updateTotalVideos(DataCache()
                                                    .getUserData()
                                                    .totalVideoComplete);
                                            staticsticalProvider
                                                .updateTotalVideosVip(
                                                    DataCache()
                                                        .getUserData()
                                                        .totalVideoPlus);
                                          } else {
                                            activeDialog(context,
                                                S.of(context).LoginFailed);
                                          }
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        'assets/new_ui/more/google.svg',
                                        height:
                                            MediaQuery.of(context).size.width <=
                                                    375
                                                ? 40
                                                : 55,
                                      ),
                                    ),
                                    Platform.isAndroid
                                        ? const SizedBox()
                                        : const SizedBox(width: 20),
                                    Platform.isAndroid
                                        ? const SizedBox()
                                        : InkWell(
                                            onTap: () async {
                                              final credential =
                                                  await SignInWithApple
                                                      .getAppleIDCredential(
                                                scopes: [
                                                  AppleIDAuthorizationScopes
                                                      .email,
                                                  AppleIDAuthorizationScopes
                                                      .fullName,
                                                ],
                                                state: 'success',
                                              );
                                              if (credential.state ==
                                                  'success') {
                                                if (credential.givenName !=
                                                        null &&
                                                    credential.email != null) {
                                                  await SocialNetworks()
                                                      .appleSignIn(
                                                    credential: credential,
                                                  )
                                                      .then((value) {
                                                    if (value != null) {
                                                      signinComplete(
                                                          context, value);
                                                    } else {
                                                      activeDialog(
                                                          context,
                                                          S
                                                              .of(context)
                                                              .LoginFailed);
                                                    }
                                                  });
                                                } else {
                                                  await SocialNetworks()
                                                      .appleLogin(
                                                    credential: credential,
                                                  )
                                                      .then((value) {
                                                    if (value != null) {
                                                      signinComplete(
                                                          context, value);
                                                      var staticsticalProvider =
                                                          Provider.of<
                                                              StaticsticalProvider>(
                                                        context,
                                                        listen: false,
                                                      );
                                                      staticsticalProvider
                                                          .updateTotalTalk(
                                                              DataCache()
                                                                  .getUserData()
                                                                  .totalTalkComplete);
                                                      staticsticalProvider
                                                          .updateTotalVideos(
                                                              DataCache()
                                                                  .getUserData()
                                                                  .totalVideoComplete);
                                                      staticsticalProvider
                                                          .updateTotalVideosVip(
                                                              DataCache()
                                                                  .getUserData()
                                                                  .totalVideoPlus);
                                                    } else {
                                                      activeDialog(
                                                          context,
                                                          S
                                                              .of(context)
                                                              .LoginFailed);
                                                    }
                                                  });
                                                }
                                              }
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width <=
                                                      375
                                                  ? 40
                                                  : 54,
                                              height: MediaQuery.of(context)
                                                          .size
                                                          .width <=
                                                      375
                                                  ? 40
                                                  : 54,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: SizedBox(
                                                width: 25,
                                                height: 25,
                                                child: Image.asset(
                                                  'assets/images/apple-circle.png',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.width <= 375
                                    ? 20
                                    : 25,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        RegisterAccountScreen(),
                                  ));
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
                                    color: Color(0xFF04D076),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    height:
                                        MediaQuery.of(context).size.width <= 375
                                            ? 60
                                            : 65,
                                    alignment: Alignment.center,
                                    child: Text(
                                      S.of(context).Donothaveanaccount +
                                          "? " +
                                          S.of(context).Register,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width <=
                                                    375
                                                ? 18
                                                : 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      child: Center(
                                        child: Text(
                                          S.of(context).ForgotPassword,
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width <=
                                                    375
                                                ? 18
                                                : 20,
                                            color: themeProvider.mode ==
                                                    ThemeMode.dark
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      onTap: () => showForgotAccount(context),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                S.of(context).Byloggingin,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width <= 375
                                          ? 13
                                          : 14,
                                  color: Colors.grey[600],
                                  height: 1.5,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PrivacyPolicy(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    S.of(context).PrivacyPolicy,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    launch('https://phoenglish.com/eula');
                                  },
                                  child: Text(
                                    S.of(context).TermsOfUse,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
