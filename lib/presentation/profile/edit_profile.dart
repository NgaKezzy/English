import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/extentions/RoutersManager.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/provider/statistical_provider.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/DataOffline.dart';
import 'package:app_learn_english/networks/SocialNetworks.dart';
import 'package:app_learn_english/presentation/Vip/Vip_widget.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/screens/login_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/src/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'changeName.dart';
import 'changeNickName.dart';
import 'changePassword.dart';
import 'confirmEmail.dart';

class EditProfile extends StatelessWidget {
  DataUser dataUser;
  EditProfile({Key? key, required this.dataUser}) : super(key: key);
  DataUser userFake = DataCache().getUserData();

  void showChangeName(BuildContext context, DataUser dataUser) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ScopedModel<DataUser>(model: dataUser, child: changeName())),
    ).then((value) => {(context as Element).markNeedsBuild()});
  }

  void logOut(BuildContext context) async {
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

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: themeProvider.mode == ThemeMode.dark
            ? Color.fromRGBO(45, 48, 57, 1)
            : Colors.white,
        title: Text(
          S.of(context).EditProfile,
          style: TextStyle(
            color: themeProvider.mode == ThemeMode.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
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
      body: Container(
          decoration: BoxDecoration(
            color: themeProvider.mode == ThemeMode.dark
                ? Color.fromRGBO(42, 44, 50, 1)
                : Colors.white,
            // borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: dataUser.uid != 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16),
                    //   child: Text(
                    //     S.of(context).EditProfile,
                    //     style: TextStyle(
                    //       fontSize: 18,
                    //       color: themeProvider.mode == ThemeMode.dark
                    //           ? Colors.white
                    //           : Colors.black,
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 22),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20),
                    //   child: Text(
                    //     S.of(context).Account,
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.w400,
                    //       fontSize: 18,
                    //       color: const Color.fromRGBO(136, 136, 136, 1),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 5),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20),
                    //   child: Card(
                    //     elevation: 0,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.all(
                    //         Radius.circular(5),
                    //       ),
                    //       side: BorderSide(
                    //         width: 1,
                    //         color: Colors.grey.withOpacity(0.5),
                    //       ),
                    //     ),
                    //     child: Container(
                    //       height: 65,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.all(
                    //           Radius.circular(5),
                    //         ),
                    //         color: themeProvider.mode == ThemeMode.dark
                    //             ? Color.fromRGBO(24, 26, 33, 1)
                    //             : Colors.white,
                    //       ),
                    //       child: Row(
                    //         children: [
                    //           const SizedBox(
                    //             width: 16,
                    //           ),
                    //           Text(
                    //             dataUser.username,
                    //             overflow: TextOverflow.ellipsis,
                    //             maxLines: 1,
                    //             softWrap: false,
                    //             style: TextStyle(
                    //               fontWeight: FontWeight.w600,
                    //               fontSize: 18,
                    //             ),
                    //           ),
                    //           Spacer(),
                    //           TextButton(
                    //             onPressed: () {
                    //               userFake.uid == 0
                    //                   ? logOut(context)
                    //                   : showChangeName(context, dataUser);
                    //             },
                    //             child: Text(
                    //               S.of(context).Change,
                    //               style: TextStyle(
                    //                 fontWeight: FontWeight.normal,
                    //                 fontSize: 16,
                    //                 color:
                    //                     const Color.fromRGBO(129, 119, 237, 1),
                    //               ),
                    //             ),
                    //           ),
                    //           const SizedBox(
                    //             width: 16,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        S.of(context).Name,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: const Color.fromRGBO(136, 136, 136, 1),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            side: BorderSide(
                              width: 1,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          child: Container(
                            height: 65,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              color: themeProvider.mode == ThemeMode.dark
                                  ? Color.fromRGBO(24, 26, 33, 1)
                                  : Colors.white,
                            ),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  dataUser.fullname,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                                Spacer(),
                                TextButton(
                                  onPressed: () {
                                    userFake.uid == 0
                                        ? logOut(context)
                                        : showChangeNickName(context, dataUser);
                                  },
                                  child: Text(
                                    S.of(context).Change,
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: const Color.fromRGBO(
                                          129, 119, 237, 1),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        S.of(context).Email,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: const Color.fromRGBO(136, 136, 136, 1),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          side: BorderSide(
                            width: 1,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ),
                        child: Container(
                          height: 65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: themeProvider.mode == ThemeMode.dark
                                ? Color.fromRGBO(24, 26, 33, 1)
                                : Colors.white,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 16,
                              ),
                              Text(
                                dataUser.email,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              Spacer(),
                              TextButton(
                                onPressed: () {
                                  userFake.uid == 0
                                      ? logOut(context)
                                      : showConfirmMail(context, dataUser);
                                },
                                child: Text(
                                  S.of(context).Confirm,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color:
                                        const Color.fromRGBO(122, 111, 236, 1),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        S.of(context).Password,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: const Color.fromRGBO(136, 136, 136, 1),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          side: BorderSide(
                            width: 1,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ),
                        child: Container(
                          height: 65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            color: themeProvider.mode == ThemeMode.dark
                                ? Color.fromRGBO(24, 26, 33, 1)
                                : Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 16,
                              ),
                              Text(
                                '********',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              Spacer(),
                              TextButton(
                                onPressed: () {
                                  userFake.uid == 0
                                      ? logOut(context)
                                      : showChangePassword(context, dataUser);
                                },
                                child: Text(
                                  S.of(context).Change,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color:
                                        const Color.fromRGBO(129, 119, 237, 1),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : Align(
                  alignment: Alignment.center,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SvgPicture.asset(
                            'assets/new_ui/home/ic_user.svg',
                            height: 120,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            S.of(context).GuestMode,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                            onPressed: () {
                              logOut(context);
                            },
                            child: Text(
                              S.of(context).CreateProfile,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 10,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Color.fromRGBO(24, 26, 33, 1)
                                : Color.fromRGBO(236, 236, 236, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
    );
  }
}
