import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/Providers/user_provider.dart';
import 'package:app_learn_english/Providers/video_provider.dart';
import 'package:app_learn_english/homepage/pages/page_main_search.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/pages/page_res_channel.dart';
import 'package:app_learn_english/homepage/pages/page_sub_chanel_widget.dart';
import 'package:app_learn_english/homepage/pages/page_today_widget.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';

import 'package:app_learn_english/presentation/notification/screen/notification_screen.dart';
import 'package:app_learn_english/presentation/profile/profile.dart';
import 'package:app_learn_english/socket/provider/socket_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class DismissKeyboard extends StatelessWidget {
  final Widget child;

  DismissKeyboard({required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: child,
    );
  }
}

class HomeScreen extends StatefulWidget {
  final int totalNotification;

  HomeScreen({Key? key, required this.totalNotification}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DataUser dataUser = DataCache().getUserData();

  getTotalNotificationHome() async {
    await TalkAPIs().getTotalNotifiHome(context, userId: dataUser.uid);
  }

  @override
  void initState() {
    getTotalNotificationHome();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () {
      context.read<SocketProvider>().setIsShowLogin(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var socketProvider = context.watch<SocketProvider>();
    return DismissKeyboard(
      child: ScopedModelDescendant<DataUser>(
        builder: (context, child, userData) {
          return DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Scaffold(
              backgroundColor: themeProvider.mode == ThemeMode.dark
                  ? const Color.fromRGBO(45, 48, 57, 1)
                  : Colors.white,
              body: SafeArea(
                child: Column(
                  children: [
                    // HeaderApp(margin: MediaQuery.of(context).padding.top + 5),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top: 0),
                      decoration: BoxDecoration(
                        color: themeProvider.mode == ThemeMode.dark
                            ? const Color.fromRGBO(45, 48, 57, 1)
                            : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[200]!,
                            blurRadius: 2,
                            offset: Offset(0, 3), // Shadow position
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 6,
                                child: TabBar(
                                  isScrollable: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  tabs: <Widget>[
                                    Container(
                                      height: 55,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: AutoSizeText(
                                          S.of(context).Today,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 55,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: AutoSizeText(
                                          S.of(context).SubscribeChannel,
                                        ),
                                      ),
                                    ),
                                  ],
                                  indicatorSize: TabBarIndicatorSize.label,
                                  indicatorWeight: 2.5,
                                  indicatorColor: const Color(0xFF04D076),
                                  labelStyle: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize:
                                        MediaQuery.of(context).size.width <= 375
                                            ? 18
                                            : 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  labelColor: const Color(0xFF04D076),
                                  unselectedLabelColor: themeProvider.mode ==
                                          ThemeMode.dark
                                      ? const Color.fromRGBO(97, 100, 106, 1)
                                      : Colors.black,
                                  unselectedLabelStyle: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width <= 375
                                            ? 18
                                            : 20,
                                    overflow: TextOverflow.ellipsis,
                                    // decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  labelPadding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width <= 375
                                            ? 12
                                            : 15,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed: () {
                                    Provider.of<VideoProvider>(context,
                                            listen: false)
                                        .setdataTalk(null);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ScopedModel(
                                          model: userData,
                                          child: PageMainSearch(),
                                        ),
                                      ),
                                    );
                                  },
                                  icon: SvgPicture.asset(
                                    'assets/new_ui/home/ic_Search.svg',
                                    height: 30,
                                    color: themeProvider.mode == ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ScaleTap(
                                  onPressed: () {
                                    Provider.of<VideoProvider>(context,
                                            listen: false)
                                        .setdataTalk(null);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NotificationScreen(),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Lottie.asset(
                                        'assets/new_ui/animation_lottie/bell.json',
                                        height: 40,repeat: false
                                      ),
                                      Consumer<SocketProvider>(builder:
                                          (context, socketProvider, snapshot) {
                                        return Positioned(
                                          top: 0,
                                          right: 5,
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Center(
                                              child: Text(
                                                '${socketProvider.totalNoti}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontFamily: 'Roboto'),
                                              ),
                                            ),
                                          ),
                                        );
                                      })
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed: () {
                                    Provider.of<VideoProvider>(context,
                                            listen: false)
                                        .setdataTalk(null);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Profile(),
                                      ),
                                    );
                                  },
                                  icon: Consumer<UserProvider>(
                                    builder: (contextHeader, userProvider,
                                            chil) =>
                                        userProvider.avatarUser != null
                                            ? CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                  userProvider.avatarUser!,
                                                  scale: 1,
                                                ),
                                                backgroundColor: Colors.white,
                                                radius: 16,
                                              )
                                            : Image.asset(
                                                'assets/new_ui/more/ic_user_home.png',
                                                width: 50,
                                                fit: BoxFit.cover,
                                              ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Container(
                          //   height: 2,
                          //   width: MediaQuery.of(context).size.width,
                          //   color: themeProvider.mode == ThemeMode.dark
                          //       ? Color.fromRGBO(24, 26, 33, 1)
                          //       : ColorsUtils.Color_E4E4E4,
                          // ),
                          Divider(
                              thickness: 1,
                              color: themeProvider.mode == ThemeMode.dark
                                  ? Colors.grey.shade700
                                  : const Color(0xFFE4E4E4),
                              height: 1),
                        ],
                      ),
                    ),

                    Expanded(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          PageToday(),
                          PageResChannel(),
                          // ScopedModel(model: userData, child: PageMainSearch()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
