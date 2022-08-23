import 'dart:convert';

import 'package:app_learn_english/Providers/check_login.dart';
import 'package:app_learn_english/Providers/user_provider.dart';
import 'package:app_learn_english/extentions/FunctionService.dart';
import 'package:app_learn_english/extentions/RoutersManager.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/DataOffline.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/networks/TargetAPIs.dart';
import 'package:app_learn_english/presentation/home/home.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/screens/login_account_screen.dart';
import 'package:app_learn_english/socket/provider/socket_provider.dart';
import 'package:app_learn_english/socket/utils/parser_data.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:app_learn_english/startpage/responsive_start_page.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/src/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopWidgetOne extends StatelessWidget {
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
    double height = MediaQuery.of(context).size.height;
    return Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            SizedBox(
              height: ResponsiveWidget.isSmallScreen(context)
                  ? height / 20
                  : height / 20,
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: ResponsiveWidget.isSmallScreen(context)
                        ? width / 40
                        : width / 40,
                  ),
                ),
                InkWell(
                  onTap: () => {
                    Provider.of<CheckLogin>(context, listen: false)
                        .setIsFirstUse(1),
                    DataOffline().saveDataFirtUse("isFirtUse", 1),
                    loginComplete(context, userFake, '')
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SvgPicture.asset(
                        'assets/new_ui/first_screen_app/ic_x.svg',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                )
              ],
            )
          ],
        ));
  }
}
