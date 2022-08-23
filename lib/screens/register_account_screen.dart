import 'dart:convert';
import 'dart:io';

import 'package:app_learn_english/Providers/check_login.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
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
import 'package:app_learn_english/networks/SocialNetworks.dart';
import 'package:app_learn_english/networks/TargetAPIs.dart';
import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:app_learn_english/presentation/home/home.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/profile/widgets/email_field_icon.dart';

import 'package:app_learn_english/presentation/profile/widgets/password_field.dart';
import 'package:app_learn_english/presentation/profile/widgets/text_field_icon.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/screens/login_account_screen.dart';
import 'package:app_learn_english/socket/provider/socket_provider.dart';
import 'package:app_learn_english/socket/utils/parser_data.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_svg/svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../screens/forgot_password_screen.dart';
import 'package:flutter/material.dart';

class RegisterAccountScreen extends StatefulWidget {
  static const routeName = '/register-account';
  const RegisterAccountScreen({Key? key}) : super(key: key);

  @override
  State<RegisterAccountScreen> createState() => _RegisterAccountScreenState();
}

class _RegisterAccountScreenState extends State<RegisterAccountScreen> {
  void showForgotAccount(BuildContext context) {
    Navigator.of(context).pushNamed(ForgotAccountScreen.routeName);
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  // void showHomePage(BuildContext context) {
  //   Navigator.of(context).pushNamed(HomePage.routeName);
  // }

  void signinComplete(BuildContext context, DataUser userData) {
    DataOffline().saveDataFirtUse("isFirtUse", 1);
    TargetAPIs().getDataTarget(userData.uid).then((value) {
      DataCache().setUserTargetLogModel(value);
    });

    Provider.of<CheckLogin>(context, listen: false).setIsFirstUse(1);

    RoutersManager().setRoute("Loggedin");
    FunctionService().implProviderFunction();
    (context as Element).markNeedsBuild();

    Utils().showNotificationBottom(true, S.of(context).LoggedInSuccessfully);
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

  void loginComplete(
      BuildContext context, DataUser userData, String password) async {
    TargetAPIs().getDataTarget(userData.uid).then((value) {
      DataCache().setUserTargetLogModel(value);
    });
    DataCache().setTempPassWord(ParseDataSocket.generateMd5(password));
    DataOffline()
        .savePasswordMd5(password: ParseDataSocket.generateMd5(password));
    DataCache().setUserData(userData);

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
    if (userData.uid != 0) {
      Utils().showNotificationBottom(true, S.of(context).LoggedInSuccessfully);
    }
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

  final userNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeProvider.mode == ThemeMode.dark
            ? const Color.fromRGBO(45, 48, 57, 1)
            : Colors.white,
        title: Text(
          S.of(context).Register,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width <= 375 ? 20 : 22,
            fontWeight: FontWeight.w600,
            color: themeProvider.mode == ThemeMode.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: SvgPicture.asset(
            'assets/new_ui/more/Iconly-Arrow-Left.svg',
            fit: BoxFit.scaleDown,
            color: themeProvider.mode == ThemeMode.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
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
                  ? Colors.grey.shade700
                  : Color(0xFFE4E4E4),
              height: 1),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    color: themeProvider.mode == ThemeMode.dark
                        ? Color.fromRGBO(24, 26, 33, 1)
                        : Colors.white,
                    height: MediaQuery.of(context).size.height -
                        30 -
                        MediaQuery.of(context).padding.top,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width <= 375
                              ? 40
                              : 80,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                  child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    EmailFieldWidget(
                                      controller: emailCtrl,
                                      labelText: S.of(context).EmailAddress,
                                      icon: SvgPicture.asset(
                                        'assets/new_ui/more/Iconly-Light-Message.svg',
                                      ),
                                      isActive: false,
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    TextFieldWidget(
                                      controller: userNameCtrl,
                                      labelText: S.of(context).UserName,
                                      icon: SvgPicture.asset(
                                        'assets/new_ui/more/Iconly-Light-Profile.svg',
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    PasswordFieldWidget(
                                        controller: passwordCtrl,
                                        labelText: S.of(context).Password),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width <=
                                                  375
                                              ? 30
                                              : 50,
                                    ),
                                    Consumer<CheckLogin>(builder:
                                        (context, checkLoginProvider, wiget) {
                                      return ElevatedButton(
                                        onPressed: () async {
                                          if (checkLoginProvider
                                              .checkIpRegister) {
                                            String? deviceId =
                                                await PlatformDeviceId
                                                    .getDeviceId;
                                            String? token =
                                                await FirebaseMessaging.instance
                                                    .getToken();
                                            if (formKey.currentState!
                                                .validate()) {
                                              if (Validator().checkValidate(
                                                      Constants.TYPE_EMAIL,
                                                      context,
                                                      emailCtrl.text) &&
                                                  Validator().checkValidate(
                                                      Constants.TYPE_USERNAME,
                                                      context,
                                                      userNameCtrl.text) &&
                                                  Validator().checkValidate(
                                                      Constants.TYPE_PASSWORD,
                                                      context,
                                                      passwordCtrl.text)) {
                                                UserAPIs()
                                                    .userRegister(
                                                      username: userNameCtrl
                                                          .text
                                                          .trim(),
                                                      password: passwordCtrl
                                                          .text
                                                          .trim(),
                                                      email:
                                                          emailCtrl.text.trim(),
                                                      deviceID: deviceId != null
                                                          ? deviceId
                                                          : '',
                                                      token: token,
                                                    )
                                                    .then((value) => {
                                                          if (value != null)
                                                            {
                                                              if (value[
                                                                      'status'] ==
                                                                  1)
                                                                {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return new AlertDialog(
                                                                          title: new Text(S
                                                                              .of(context)
                                                                              .Notify),
                                                                          content: new Text(S
                                                                              .of(context)
                                                                              .SignUpSuccess),
                                                                          actions: <
                                                                              Widget>[
                                                                            Center(child: const PhoLoading())
                                                                          ],
                                                                        );
                                                                      }),
                                                                  Provider.of<CheckLogin>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .setIsFirstUse(
                                                                          1),
                                                                  UserAPIs()
                                                                      .userLogin(
                                                                    userNameCtrl
                                                                        .text,
                                                                    passwordCtrl
                                                                        .text,
                                                                    token,
                                                                  )
                                                                      .then(
                                                                          (value) {
                                                                    if (value !=
                                                                        null) {
                                                                      printRed(value
                                                                          .toJson()
                                                                          .toString());
                                                                      var staticsticalProvider = Provider.of<
                                                                              StaticsticalProvider>(
                                                                          context,
                                                                          listen:
                                                                              false);

                                                                      loginComplete(
                                                                          context,
                                                                          value,
                                                                          passwordCtrl
                                                                              .text
                                                                              .trim());
                                                                      staticsticalProvider
                                                                          .updateTotalTalk(
                                                                              value.totalTalkComplete);
                                                                      staticsticalProvider
                                                                          .updateTotalVideos(
                                                                              value.totalVideoComplete);
                                                                      staticsticalProvider
                                                                          .updateTotalVideosVip(
                                                                              value.totalVideoPlus);
                                                                    } else {
                                                                      activeDialog(
                                                                          context,
                                                                          S.of(context).LoginFailed);
                                                                    }
                                                                  }),
                                                                }
                                                              else if (value[
                                                                      'status'] ==
                                                                  -1)
                                                                {
                                                                  activeDialog(
                                                                    context,
                                                                    value['message']
                                                                        .toString(),
                                                                  )
                                                                }
                                                            }
                                                          else
                                                            {
                                                              activeDialog(
                                                                context,
                                                                value['message']
                                                                    .toString(),
                                                              )
                                                            }
                                                        });
                                              }
                                            }
                                            ;
                                          }
                                        },
                                        autofocus: true,
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          elevation: 0,
                                          shadowColor: Colors.white70,
                                        ),
                                        child: Consumer<CheckLogin>(
                                          builder: (context, checkLoginProvider,
                                              wiget) {
                                            return Ink(
                                              decoration: BoxDecoration(
                                                color: (checkLoginProvider
                                                        .checkIpRegister)
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
                                                  S.of(context).Register,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width <=
                                                                375
                                                            ? 20
                                                            : 22,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              )),
                              // Divider(
                              //   thickness: 2,
                              //   color: Colors.white,
                              //   height: 50,
                              // ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  SocialNetworks()
                                      .facebookSigin()
                                      .then((value) {
                                    if (value != null) {
                                      signinComplete(context, value);
                                      var staticsticalProvider =
                                          Provider.of<StaticsticalProvider>(
                                        context,
                                        listen: false,
                                      );
                                      staticsticalProvider.updateTotalTalk(
                                          DataCache()
                                              .getUserData()
                                              .totalTalkComplete);
                                      staticsticalProvider.updateTotalVideos(
                                          DataCache()
                                              .getUserData()
                                              .totalVideoComplete);
                                      staticsticalProvider.updateTotalVideosVip(
                                          DataCache()
                                              .getUserData()
                                              .totalVideoPlus);
                                    } else {
                                      activeDialog(context,
                                          S.of(context).RegistrationFailed);
                                    }
                                  });
                                },
                                child: SvgPicture.asset(
                                  'assets/new_ui/more/facebook.svg',
                                  height:
                                      MediaQuery.of(context).size.width <= 375
                                          ? 40
                                          : 55,
                                ),
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              InkWell(
                                onTap: () {
                                  SocialNetworks().googleSigin().then((value) {
                                    if (value != null) {
                                      signinComplete(context, value);
                                      var staticsticalProvider =
                                          Provider.of<StaticsticalProvider>(
                                        context,
                                        listen: false,
                                      );
                                      staticsticalProvider.updateTotalTalk(
                                          DataCache()
                                              .getUserData()
                                              .totalTalkComplete);
                                      staticsticalProvider.updateTotalVideos(
                                          DataCache()
                                              .getUserData()
                                              .totalVideoComplete);
                                      staticsticalProvider.updateTotalVideosVip(
                                          DataCache()
                                              .getUserData()
                                              .totalVideoPlus);
                                    } else {
                                      activeDialog(context,
                                          S.of(context).RegistrationFailed);
                                    }
                                  });
                                },
                                child: SvgPicture.asset(
                                  'assets/new_ui/more/google.svg',
                                  height:
                                      MediaQuery.of(context).size.width <= 375
                                          ? 40
                                          : 55,
                                ),
                              ),
                              Platform.isAndroid
                                  ? SizedBox()
                                  : SizedBox(width: 20),
                              Platform.isAndroid
                                  ? SizedBox()
                                  : InkWell(
                                      onTap: () async {
                                        final credential = await SignInWithApple
                                            .getAppleIDCredential(
                                          scopes: [
                                            AppleIDAuthorizationScopes.email,
                                            AppleIDAuthorizationScopes.fullName,
                                          ],
                                          state: 'success',
                                        );
                                        if (credential.state == 'success') {
                                          if (credential.givenName != null &&
                                              credential.email != null) {
                                            await SocialNetworks()
                                                .appleSignIn(
                                              credential: credential,
                                            )
                                                .then((value) {
                                              if (value != null) {
                                                signinComplete(context, value);
                                              } else {
                                                activeDialog(context,
                                                    S.of(context).LoginFailed);
                                              }
                                            });
                                          } else {
                                            await SocialNetworks()
                                                .appleLogin(
                                              credential: credential,
                                            )
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
                                                activeDialog(context,
                                                    S.of(context).LoginFailed);
                                              }
                                            });
                                          }
                                        }
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width <=
                                                    375
                                                ? 40
                                                : 48,
                                        height:
                                            MediaQuery.of(context).size.width <=
                                                    375
                                                ? 40
                                                : 48,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
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
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginAccountScreen(),
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
                              height: MediaQuery.of(context).size.width <= 375
                                  ? 60
                                  : 65,
                              alignment: Alignment.center,
                              child: Text(
                                S.of(context).Alreadyhaveanaccount +
                                    "? " +
                                    S.of(context).Login,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width <= 375
                              ? 80
                              : 110,
                        ),
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
  }
}
