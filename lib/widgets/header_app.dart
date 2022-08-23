import 'package:app_learn_english/Providers/user_provider.dart';
import 'package:app_learn_english/Providers/video_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/pages/page_main_search.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/presentation/Vip/Vip_widget.dart';
import 'package:app_learn_english/presentation/notification/screen/notification_screen.dart';
import 'package:app_learn_english/presentation/profile/profile.dart';
import 'package:app_learn_english/quiz/list_game/list_game.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class HeaderApp extends StatelessWidget {
  final double margin;
  final DataUser userData = DataCache().getUserData();

  HeaderApp({Key? key, required this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            top: margin,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icon_logo/icon-app.png',
                width: 100,
              ),
              SizedBox(
                width: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Provider.of<VideoProvider>(context, listen: false)
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
                      child: const Icon(
                        Icons.search_outlined,
                        size: 30,
                        color: Colors.blue,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Provider.of<VideoProvider>(context, listen: false)
                            .setdataTalk(null);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NotificationScreen(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        size: 30,
                        color: Colors.blue,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => List_game()));
                      },
                      child: Image(
                        image: AssetImage('assets/images/ic_game.png'),
                        width: 25,
                        height: 25,
                        color: null,
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Provider.of<VideoProvider>(context, listen: false)
                            .setdataTalk(null);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profile(),
                          ),
                        );
                      },
                      child: Consumer<UserProvider>(
                        builder: (contextHeader, userProvider, chil) =>
                            userProvider.avatarUser != null
                                ? Container(
                                    width: 26,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                        width: 0.5,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image.network(
                                        userProvider.avatarUser!,
                                        width: 25,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Image.asset(
                                    'assets/linh_vat/linhvat2.png',
                                    width: 25,
                                    fit: BoxFit.cover,
                                  ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        DataCache().getUserData().isVip != 1
            ? Stack(
                children: [
                  Container(
                    child: Image.asset(
                      'assets/icon_logo/background-upgrade-to-vip.png',
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: MediaQuery.of(context).size.width * 128 / 720,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Provider.of<VideoProvider>(context,
                                        listen: false)
                                    .setdataTalk(null);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return VipWidget();
                                    },
                                  ),
                                );
                              },
                              child: Text(
                                S.of(context).VIPUpgrade.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color.fromRGBO(
                                    248,
                                    208,
                                    86,
                                    1,
                                  ),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      15.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              S.of(context).Usefeaturesnow,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
            : const SizedBox(),
      ],
    );
  }
}
