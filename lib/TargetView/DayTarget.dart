import 'package:app_learn_english/Providers/TargetProvider.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import 'SettingTarget.dart';

class DayTarget extends StatefulWidget {
  DayTarget({Key? key}) : super(key: key);

  @override
  _LearningState createState() => _LearningState();
}

class _LearningState extends State<DayTarget> {
  // late ItemTargetModel itemTarget;
  // List<ItemTargetModel> listTarget = [];

  String formatHHMMSS(int seconds) {
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return "$minutesStr ${S.of(context).Minutesday} $secondsStr ${S.of(context).second}";
    }

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  @override
  void initState() {
    super.initState();
    // DataOffline().getDataTarget("dataTarget").then((value) => {
    //       setState(() {
    //         listTarget.add(value);
    //         // itemTarget = listTarget.last;
    //       })
    //     });
    // itemTarget = TargetOffline().getListTarget().first;
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Consumer<TargetProvider>(
        builder: (context, targetProvider, snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
              width: 0.5,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).TodayAttendance,
              style: TextStyle(
                fontSize: 20,
                color: themeProvider.mode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
            Container(
              child: Row(children: [
                Text(
                  S.of(context).Target,
                  style: TextStyle(
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 16,
                  ),
                ),
                Text(
                  ' ${targetProvider.itemTarget!.timeM} ' +
                      S.of(context).Minutesday,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                Container(
                  child: ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.of(context).Change,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              // builder: (context) => SettingTarget(itemTargetLocal: itemTarget!,))).then((value) => {(context as Element).markNeedsBuild()});
                              builder: (context) => SettingTarget()));
                      // update khi select, dungf provider k cần nữa

                      // if (result != null) {
                      //   print('xxxx${result.name}');
                      //   setState(() {
                      //     itemTarget = result;
                      //   });
                      // }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ]),
            ),
            Center(
              child: Container(
                height: 150,
                width: 150,
                child: CircularPercentIndicator(
                  radius: 150,
                  lineWidth: 5.0,
                  animation: false,
                  percent: (((targetProvider.count! /
                                  (targetProvider.itemTarget!.timeM * 60)) *
                              100) /
                          100) %
                      1,
                  center: new Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/new_ui/more/ic_splash.png',
                          fit: BoxFit.contain,
                          width: 130,
                        ),
                      ],
                    ),
                  ),
                  linearGradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: <Color>[Color(0xFF1AB600), Color(0xFF6DD400)]),
                  backgroundColor: Colors.grey[400]!.withOpacity(0.1),
                  rotateLinearGradient: true,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Column(
                children: [
                  Text(formatHHMMSS(targetProvider.count!),
                      style: TextStyle(
                          color: themeProvider.mode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w500)),
                  Text(
                      '(' +
                          ((targetProvider.count! /
                                      (targetProvider.itemTarget!.timeM * 60)) *
                                  100)
                              .toStringAsFixed(0) +
                          '%)',
                      style: TextStyle(
                          color: themeProvider.mode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black87,
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
