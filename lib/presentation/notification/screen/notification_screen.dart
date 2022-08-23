import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/presentation/notification/api/notification_get.dart';
import 'package:app_learn_english/presentation/notification/models/notifications.dart';
import 'package:app_learn_english/presentation/notification/widgets/notification_item.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';

import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/src/provider.dart';

class NotificationScreen extends StatefulWidget {
  static const routeName = '/notification';

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isLoading = true;
  DataUser infoUser = DataCache().getUserData();
  late List<Notifications> listNotify;

  @override
  void didChangeDependencies() async {
    printGreen(infoUser.toString());
    if (_isLoading) {
      String lang = context.read<LocaleProvider>().locale!.languageCode;
      print('Đây là lang $lang');
      listNotify = await getInfomationNotify.getNotify(infoUser.uid, 1, lang);
    }
    setState(() {
      _isLoading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.mode == ThemeMode.dark
            ? Color.fromRGBO(45, 48, 57, 1)
            : Colors.white,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            S.of(context).NotifyAll,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: themeProvider.mode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
              fontSize: 20,
            ),
          ),
        ),
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: SvgPicture.asset(
            'assets/new_ui/more/Iconly-Arrow-Left.svg',
            fit: BoxFit.scaleDown,
            height: MediaQuery.of(context).size.width <= 375 ? 25 : 30,
            color: themeProvider.mode == ThemeMode.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
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
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      // gradient: LinearGradient(
                      //   begin: Alignment.topCenter,
                      //   end: Alignment.bottomCenter,
                      //   colors: [
                      //     Colors.blue.shade700,
                      //     Colors.tealAccent.shade400,
                      //   ],
                      // ),
                      color: themeProvider.mode == ThemeMode.dark
                          ? Color.fromRGBO(24, 26, 33, 1)
                          : Color.fromRGBO(255, 255, 255, 1),
                    ),
                    // Image.asset(
                    //   'assets/images/background.png',
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height -
                              (MediaQuery.of(context).padding.top + 10) -
                              40 -
                              60,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: themeProvider.mode == ThemeMode.dark
                                    ? Color.fromRGBO(24, 26, 33, 1)
                                    : Color.fromRGBO(255, 255, 255, 0.4),
                                border: Border.all(
                                    color: themeProvider.mode == ThemeMode.dark
                                        ? Color.fromRGBO(24, 26, 33, 1)
                                        : Colors.white),
                              ),
                              child: _isLoading
                                  ? const Center(child: PhoLoading())
                                  : (listNotify.length == 0
                                      ? Center(
                                          child: Text(
                                            S
                                                .of(context)
                                                .HavenReceivedAnyNotificationsYet,
                                          ),
                                        )
                                      : NotificationItem(
                                          listNotify: listNotify,
                                          dataUser: infoUser,
                                        )),
                            ),
                          ),
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
