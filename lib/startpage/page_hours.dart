import 'dart:convert';

import 'package:app_learn_english/Providers/check_login.dart';

import 'package:app_learn_english/Providers/user_provider.dart';
import 'package:app_learn_english/extentions/FunctionService.dart';
import 'package:app_learn_english/extentions/RoutersManager.dart';
import 'package:app_learn_english/generated/l10n.dart';

import 'package:app_learn_english/models/UserModel.dart';

import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/DataFirtAppLog.dart';
import 'package:app_learn_english/networks/DataOffline.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/networks/TargetAPIs.dart';
import 'package:app_learn_english/presentation/home/home.dart';

import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/screens/login_account_screen.dart';

import 'package:app_learn_english/socket/provider/socket_provider.dart';
import 'package:app_learn_english/socket/utils/parser_data.dart';
import 'package:app_learn_english/utils/color_utils.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'responsive_start_page.dart';

class PageHours extends StatefulWidget {
  late final bool isFirst;

  PageHours({Key? key, required this.isFirst}) : super(key: key);

  @override
  _PageHoursState createState() => _PageHoursState();
}

class _PageHoursState extends State<PageHours> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        ColorsUtils.Color_FFC69A,
                        ColorsUtils.Color_F3606A,
                      ],
                    )),
                    child: Column(
                      children: [
                        widget.isFirst ? _TopEnd() : buildClose(),
                        _Notice(),
                        SizedBox(
                          height: 30,
                        ),
                        Expanded(
                            child: Column(
                          children: [
                            ListHours(),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        )),
                        _ButtonWidget(
                          isFirst: widget.isFirst,
                        ),
                        SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildClose() {
    return Container(
      alignment: Alignment.topRight,
      margin: EdgeInsets.only(top: 15, right: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: IconButton(
            iconSize: 30,
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
    );
  }
}

class _TopEnd extends StatelessWidget {

   _TopEnd({Key? key}) : super(key: key);


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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.topRight,
      margin: EdgeInsets.only(top: 20, right: 10),
      child: Column(
        children: [
          TextButton(
            child: Text(
              S.of(context).Skip,
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveWidget.isSmallScreen(context)
                    ? width / 25
                    : width / 40,
                decoration: TextDecoration.underline,
              ),
            ),
            onPressed: () {
              Provider.of<CheckLogin>(context, listen: false)
                  .setIsFirstUse(1);
              DataOffline().saveDataFirtUse("isFirtUse", 1);
              loginComplete(context, userFake, '');
            },
          ),
        ],
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        'assets/new_ui/first_screen_app/list_notification.png'),
                    fit: BoxFit.fill)),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            S.of(context).WhenDoYouWantToStudy,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                decoration: TextDecoration.none),
          ),
          Text(
            S.of(context).WeWillRemindYouToStudyEveryDay,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.6),
                decoration: TextDecoration.none,
                fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

class ListHours extends StatelessWidget {
  final items = [
    '01:00',
    '02:00',
    '03:00',
    '04:00',
    '05:00',
    '06:00',
    '07:00',
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
    '19:00',
    '20:00',
    '21:00',
    '22:00',
    '23:00',
    '24:00',
  ];

  ListHours({Key? key}) : super(key: key);
  int index = 0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return CupertinoPageScaffold(
      backgroundColor: Colors.black.withOpacity(0),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: ResponsiveWidget.isSmallScreen(context)
                ? height / 4
                : height / 2.5,
            child: CupertinoPicker(
              looping: true,
              itemExtent: 64,
              selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                background: CupertinoColors.white.withOpacity(0.3),
              ),
              children: List.generate(items.length, (index) {
                final item = items[index];
                final isSelected = this.index == index;
                final color = isSelected
                    ? CupertinoColors.activeBlue
                    : CupertinoColors.black;
                return Center(
                  child: Text(
                    item,
                    style: TextStyle(fontSize: 32, color: color),
                  ),
                );
              }),
              onSelectedItemChanged: (index) {
                DataFirtAppLog().hours = items[index];
              },
            ),
          ),
        ],
      )),
    );
  }
}

class _ButtonWidget extends StatelessWidget {
  final bool isFirst;

  _ButtonWidget({Key? key, required this.isFirst}) : super(key: key);
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
    prefs.setString(
        'passMd5', jsonEncode(ParseDataSocket.generateMd5(password)));
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // DateTime currentDate = DateTime.now();
    // TimeOfDay _startTime = TimeOfDay(
    //     hour: int.parse((DataFirtAppLog().hours!.isEmpty)?"":DataFirtAppLog().hours!.split(":")[0]),
    //     minute: int.parse(DataFirtAppLog().hours!.split(":")[1]));
    // final today = DateTime(
    //     currentDate.year, currentDate.month, currentDate.day);

    return InkWell(
      onTap: () {
        if (isFirst) {
          Provider.of<CheckLogin>(context, listen: false).setIsFirstUse(1);
          DataOffline().saveDataFirtUse("isFirtUse", 1);
          loginComplete(context, userFake, '');
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        height: 50,
        width: width,
        margin: EdgeInsets.symmetric(horizontal: 50),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.of(context).TimeSetting,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
