import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/extentions/constants.dart';
import 'package:app_learn_english/models/AchievementModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:flutter/material.dart';

import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class ItemAchievement extends StatelessWidget {
  UserAchievement achievement;
  ItemAchievement({Key? key, required this.achievement});

  String getIcon({typeItem: int}) {
    String srcFlags = "assets/new_ui/more/";
    switch (typeItem) {
      case Constants.ACHI_CHANGE_AVATAR:
        srcFlags += "ic_ananh.png";
        break;
      case Constants.ACHI_TARGET_COMPLETE:
        srcFlags += "ic_chamchi.png";
        break;
      case Constants.ACHI_VIDEO_COMPLETE:
        srcFlags += "ic_chienbinh.png";
        break;
      case Constants.ACHI_TALK_COMPLETE:
        srcFlags += "ic_thienxa.png";
        break;
      case Constants.ACHI_NEWWORD_COMPLETE:
        srcFlags += "ic_hocgia.png";
        break;
      case Constants.ACHI_LEARN_LAST_WEEK:
        srcFlags += "ic_dungsi.png";
        break;
    }
    print(srcFlags);
    return srcFlags;
  }

  Color getColor({typeItem: int}) {
    Color color = Colors.red;
    switch (typeItem) {
      case Constants.ACHI_CHANGE_AVATAR:
        color = Colors.orange;
        break;
      case Constants.ACHI_TARGET_COMPLETE:
        color = Colors.amber;
        break;
      case Constants.ACHI_VIDEO_COMPLETE:
        color = Colors.red;
        break;
      case Constants.ACHI_TALK_COMPLETE:
        color = Colors.blue;
        break;
      case Constants.ACHI_NEWWORD_COMPLETE:
        color = Colors.purpleAccent;
        break;
      case Constants.ACHI_LEARN_LAST_WEEK:
        color = Colors.green;
        break;
    }

    return color;
  }

  DataUser userData = DataCache().getUserData();

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
      return Container(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 70,
                  child: Image.asset(
                    getIcon(typeItem: achievement.achiData!.type),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData.uid == 0
                            ? achievement.achiData!.getNameByLanguage(
                                    provider.locale!.languageCode) +
                                " (" +
                                "0/" +
                                achievement.achiData!.count.toString() +
                                ")"
                            : achievement.achiData!.getNameByLanguage(
                                    provider.locale!.languageCode) +
                                " (" +
                                achievement.complete.toString() +
                                "/" +
                                achievement.achiData!.count.toString() +
                                ")",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: themeProvider.mode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(.0),
                        child: Text(
                          achievement.achiData!.getDescriptionByLanguage(
                              provider.locale!.languageCode),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: themeProvider.mode == ThemeMode.dark
                                ? const Color.fromRGBO(106, 107, 111, 1)
                                : const Color.fromRGBO(85, 85, 85, 1),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: LinearPercentIndicator(
                              padding: const EdgeInsets.only(
                                left: 0,
                                right: 20,
                              ),
                              animation: true,
                              lineHeight: 7.0,
                              animationDuration: 2000,
                              percent: userData.uid == 0
                                  ? 0
                                  : (achievement.complete /
                                              achievement.achiData!.count) >
                                          1
                                      ? 1
                                      : achievement.complete /
                                          achievement.achiData!.count,
                              linearStrokeCap: LinearStrokeCap.roundAll,
                              backgroundColor: Colors.grey.withOpacity(0.3),
                              progressColor: Colors.red,
                            ),
                          ),
                          Container(
                            child: Text(
                              userData.uid == 0
                                  ? '0%'
                                  : ((achievement.complete /
                                                  achievement.achiData!.count) *
                                              100)
                                          .toStringAsFixed(0) +
                                      '%',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            Divider(
              thickness: 1,
              color: Colors.grey.withOpacity(0.4),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    });
  }
}
