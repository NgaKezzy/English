import 'dart:convert';
import 'dart:io';

import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/Providers/user_provider.dart';
import 'package:app_learn_english/TargetView/TargetScreen.dart';
import 'package:app_learn_english/extentions/RoutersManager.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/provider/statistical_provider.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/models/UserTargetLogModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/DataOffline.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/networks/SocialNetworks.dart';
import 'package:app_learn_english/networks/TargetAPIs.dart';
import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:app_learn_english/presentation/Vip/Vip_widget.dart';
import 'package:app_learn_english/presentation/profile/edit_profile.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/screens/login_account_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'heart_widget.dart';

class UserInfoWidget extends StatefulWidget {
  DataUser userData;
  UserInfoWidget({Key? key, required this.userData}) : super(key: key);
  @override
  _UserInfoWidgetState createState() =>
      _UserInfoWidgetState(userData: userData);
}

class MyClipper extends CustomClipper<Rect> {
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, 90, 90);
    // return Rect.f
  }

  bool shouldReclip(oldClipper) {
    return true;
  }
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  // final profileController = Get.put(ProfileController());
  DataUser userData;
  bool isChangeAvatar = false;
  File? image;
  late int _userLever;
  bool _isLoading = true;
  DataUser userFake = DataCache().getUserData();
  @override
  void didChangeDependencies() async {
    TargetAPIs().getDataTarget(DataCache().getUserData().uid).then((value) {
      DataCache().setUserTargetLogModel(value);
    });
    if (userFake.uid != 0) {
      UserAPIs()
          .fetchDataUser(DataCache().getUserData().uid.toString())
          .then((value) {
        setState(() {
          _userLever = value.level;
          _isLoading = false;
        });
      });
    } else {
      _isLoading = false;
    }
    super.didChangeDependencies();
  }

  Map paserData(String data) {
    printCyan(data);
    Map res = new Map();
    List<String> strs = data.split(",");
    if (strs.length > 0) {
      String strStatus = strs[0];
      String strAvatar = strs[1];
      printYellow(strStatus);
      printYellow(strAvatar);
      List<String> strsStatus = strStatus.split(":");
      if (strsStatus.length > 0) {
        if (int.parse(strsStatus[1]) == 1) {
          res["status"] = int.parse(strsStatus[1]);
          List<String> strsVavatar = strAvatar.split(":");
          if (strsVavatar.length > 0) {
            res["avatar"] = strsVavatar[1].replaceAll(new RegExp('}|"'), "");
            printGreen(strsVavatar[1].replaceAll(new RegExp('}|"'), ""));
          }
        }
      }
    }

    return res;
  }

  void logOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.clear().then((value) => {
          SocialNetworks().facebookLogout(),
          SocialNetworks().googleLogout(),
          DataOffline().clearCache(),
          RoutersManager().clearRoute(),
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

  var avatarURL = 'https://${Session().BASE_URL}/' +
      "images/user_avatars/" +
      DataCache().getUserData().avatar;

  _UserInfoWidgetState({Key? key, required this.userData});

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    printRed(avatarURL);
    return _isLoading
        ? const SizedBox()
        : Container(
            decoration: BoxDecoration(
              color: themeProvider.mode == ThemeMode.dark
                  ? Color.fromRGBO(42, 44, 50, 1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                width: 0.5,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: userFake.uid == 0 ? null : 100,
                      width: userFake.uid == 0 ? null : 100,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Stack(
                        children: <Widget>[
                          Consumer<UserProvider>(
                            builder: (contextUrl, userProvider, chil) => Center(
                              child: userProvider.avatarUser == null
                                  ? Align(
                                      alignment: Alignment.centerLeft,
                                      child: ClipRRect(
                                        child: Container(
                                          child: Image.asset(
                                            'assets/new_ui/more/ic_splash.png',
                                            fit: BoxFit.cover,
                                            height: 70,
                                            width: 70,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    )
                                  : ClipRRect(
                                      child: Image.network(
                                        userProvider.avatarUser!,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(50)),
                            ),
                          ),
                          userFake.uid == 0
                              ? const SizedBox()
                              : Positioned(
                                  bottom: 5,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () async {
                                      final image =
                                          await ImagePicker().pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 100,
                                      );
                                      if (image == null) return;
                                      final imageTemporary = File(image.path);
                                      printRed('customImageFile: ' +
                                          imageTemporary.toString());
                                      int status = 0;
                                      Map? res;
                                      http.StreamedResponse? response =
                                          await UserAPIs()
                                              .uploadAvatar(imageTemporary);
                                      if (response != null) {
                                        response.stream
                                            .transform(utf8.decoder)
                                            .listen((value) async {
                                          res = paserData(value);
                                          status =
                                              int.parse('${res!["status"]}');
                                          if (status == 1) {
                                            DataCache()
                                                .updateAvatar(res!['avatar']);
                                            print('Đây là sau khi upload');
                                            context
                                                .read<UserProvider>()
                                                .setAvatarUser(
                                                  'https://img.phoenglish.com/' +
                                                      "images/user_avatars/" +
                                                      DataCache()
                                                          .getUserData()
                                                          .avatar,
                                                );
                                          }
                                        });
                                      }
                                    },
                                    child: SvgPicture.asset(
                                      'assets/new_ui/more/ic_camera.svg',
                                      height: 30,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: userFake.uid == 0 ? 10 : 5,
                    ),
                    userFake.uid == 0
                        ? TextButton(
                            onPressed: () async {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => LoginAccountScreen()),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      S.of(context).CreateProfile,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            themeProvider.mode == ThemeMode.dark
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    RotatedBox(
                                      quarterTurns: 2,
                                      child: SvgPicture.asset(
                                        'assets/new_ui/more/Iconly-Arrow-Left.svg',
                                        color:
                                            themeProvider.mode == ThemeMode.dark
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  S.of(context).Createlearningprogress,
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width <= 375
                                            ? 10
                                            : 12,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Row(
                                  children: [
                                    Text(
                                      userData.username,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: false,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            themeProvider.mode == ThemeMode.dark
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    userData.isVip == 1 || userData.isVip == 2
                                        ? Row(
                                            children: [
                                              Container(
                                                  child: Image.asset(
                                                'assets/Profile/icon_profile_VIP_active.png',
                                                height: 20,
                                              )),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              InkWell(
                                                child: SvgPicture.asset(
                                                  'assets/new_ui/more/ic_edit.svg',
                                                  height: 21,
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditProfile(
                                                              dataUser:
                                                                  userFake),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          )
                                        : InkWell(
                                            child: SvgPicture.asset(
                                                'assets/new_ui/more/ic_edit.svg'),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProfile(
                                                          dataUser: userFake),
                                                ),
                                              );
                                            },
                                          ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  S.of(context).JoinedSince +
                                      ":" +
                                      _userLever.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: themeProvider.mode == ThemeMode.dark
                                        ? const Color.fromRGBO(106, 107, 111, 1)
                                        : const Color.fromRGBO(85, 85, 85, 1),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                HeartWidget(),
                              ]),
                    Spacer(),
                    // SizedBox(width: 50),
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 55),
                    //   child: InkWell(
                    //     child: SvgPicture.asset('assets/new_ui/more/ic_edit.svg'),
                    //     onTap: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => EditProfile(dataUser: userFake),
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                  ],
                ),
                if (userFake.uid == 0) const SizedBox(height: 15),
                userFake.uid != 0
                    ? const SizedBox()
                    : ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => LoginAccountScreen()),
                          );
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
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFF04D076),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.width <= 375
                                ? 60
                                : 65,
                            alignment: Alignment.center,
                            child: Text(
                              S.of(context).Login,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width <= 375
                                        ? 18
                                        : 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  height: userFake.uid == 0 ? 20 : 10,
                ),
                (userFake.uid != 0)
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => TargetScreen()),
                          );
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
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromRGBO(0, 182, 88, 1),
                                Color.fromRGBO(0, 207, 106, 1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.width <= 375
                                ? 60
                                : 65,
                            alignment: Alignment.center,
                            child: Text(
                              S.of(context).muc_tieu,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width <= 375
                                        ? 18
                                        : 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox()
              ],
            ),
          );
  }
}
