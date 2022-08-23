import 'package:app_learn_english/extentions/constants.dart';
import 'package:app_learn_english/models/AchievementModel.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class ItemAchievementFake extends StatelessWidget {
  int i;
  ItemAchievementFake({Key? key, required this.i});

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

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
      return Container(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 70,
                  child: Image.asset(
                    getIcon(
                      typeItem: this.i,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text(
                          '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: LinearPercentIndicator(
                              animation: true,
                              lineHeight: 10.0,
                              animationDuration: 2000,
                              percent: 0,
                              linearStrokeCap: LinearStrokeCap.roundAll,
                              backgroundColor: Colors.grey.withOpacity(0.3),
                              progressColor: Colors.red,
                            ),
                          ),
                          Container(
                            width: 40,
                            child: Text(
                              '0%',
                              style: TextStyle(
                                color: Colors.black,
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
