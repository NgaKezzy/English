import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/networks/DataCache.dart';

import 'package:app_learn_english/presentation/profile/widgets/item_achievementFake.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';

import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class Achievements extends StatefulWidget {
  const Achievements({Key? key}) : super(key: key);

  @override
  _AchievementsState createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          children: [
            FutureBuilder(
              future: DataCache().getDataAchievement(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    if (snapshot.data.length > 0) {
                      printYellow(snapshot.data.length.toString());
                      return Container(
                          width: width,
                          decoration: BoxDecoration(
                            color: themeProvider.mode == ThemeMode.dark
                                ? Color.fromRGBO(42, 44, 50, 1)
                                : Colors.white,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const SizedBox(
                              //   height: 30,
                              // ),
                              // Text(
                              //   S.of(context).PersonalAchievemntes,
                              //   style: TextStyle(
                              //     fontSize: 22,
                              //     fontWeight: FontWeight.w600,
                              //     color: themeProvider.mode == ThemeMode.dark
                              //         ? Colors.white
                              //         : Colors.black,
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 20,
                              // ),
                              // for (var achievement in snapshot.data)
                              //   ItemAchievement(achievement: achievement)
                            ],
                          ));
                    } else {
                      return const SizedBox();
                    }
                  } else {
                    return Center(
                      // child: Platform.isAndroid
                      //     ? CircularProgressIndicator()
                      //     : CupertinoActivityIndicator(),
                      child: const PhoLoading(),
                    );
                  }
                } else {
                  printRed("ERRE");
                  return Container(
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            S.of(context).PersonalAchievemntes,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.grey.withOpacity(0.4),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          for (var i = 1; i <= 6; i++) ItemAchievementFake(i: i)
                        ],
                      ));
                }
              },
            )
          ],
        ),
      ],
    );
  }
}
