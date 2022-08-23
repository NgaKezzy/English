import 'dart:math';

import 'package:app_learn_english/Providers/TargetProvider.dart';
import 'package:app_learn_english/extentions/constants.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/provider/statistical_provider.dart';
import 'package:app_learn_english/networks/AchievementAPIs.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TargetAPIs.dart';
import 'package:app_learn_english/presentation/home/component/getRewarded.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopupComplete extends StatefulWidget {
  static const routeName = '/popup-complete';
  const PopupComplete({Key? key}) : super(key: key);

  @override
  _PopupCompleteState createState() => _PopupCompleteState();
}

class _PopupCompleteState extends State<PopupComplete> {
  late ConfettiController _controllerCenterLeft;
  late ConfettiController _controllerCenterRight;

  @override
  void initState() {
    super.initState();
    _controllerCenterLeft = ConfettiController(duration: Duration(seconds: 1));
    _controllerCenterRight = ConfettiController(duration: Duration(seconds: 1));
  }

  @override
  void didChangeDependencies() async {
    Future.delayed(Duration(seconds: 0), () async {
      _controllerCenterLeft.play();
      _controllerCenterRight.play();
    });
    TargetProvider targetProvider = Provider.of<TargetProvider>(
      context,
      listen: false,
    );
    StaticsticalProvider staticsticalProvider =
        Provider.of<StaticsticalProvider>(
      context,
      listen: false,
    );
    int total = await TargetAPIs().updateCompleteTarget(
      uid: DataCache().getUserData().uid,
      target: targetProvider.itemTarget!.timeM,
      username: DataCache().getUserData().username,
      isCompleted: 1,
    );
    staticsticalProvider.updateTotalMonth(total);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: ConfettiWidget(
              confettiController: _controllerCenterLeft,
              blastDirectionality: BlastDirectionality.explosive,
              blastDirection: 0, // radial value - RIGHT
              emissionFrequency: 0.6,
              minimumSize: const Size(10,
                  10), // set the minimum potential size for the confetti (width, height)
              maximumSize: const Size(50,
                  50), // set the maximum potential size for the confetti (width, height)
              numberOfParticles: 20,
              gravity: 0.1,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ConfettiWidget(
              confettiController: _controllerCenterRight,
              blastDirectionality: BlastDirectionality.explosive,
              blastDirection: pi, // radial value - RIGHT
              emissionFrequency: 0.6,
              minimumSize: const Size(10,
                  10), // set the minimum potential size for the confetti (width, height)
              maximumSize: const Size(50,
                  50), // set the maximum potential size for the confetti (width, height)
              numberOfParticles: 20,
              gravity: 0.1,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * 0.1,
                  ),
                  Container(
                    height: height * 0.5,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/Target/icon_achievement.png',
                            width: 180,
                            height: 260,
                            fit: BoxFit.cover,
                          ),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      S
                                          .of(context)
                                          .CongratulationsOnAchievingYourGoal,
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ]),
                            ),
                          ),
                        ]),
                  ),
                  Spacer(),
                  Center(
                    child: Container(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          //update achievement
                          Navigator.pop(context);
                          DataCache()
                              .getDataAchievementByType(
                                  Constants.ACHI_TARGET_COMPLETE)
                              .then(
                                (value) => {
                                  AchievementAPIs()
                                      .updateAchievement(achiId: value.achiId)
                                },
                              );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GetRewarded(),
                            ),
                          );
                        },
                        child: Text(
                          S.of(context).Continue,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: BorderSide(color: Colors.white),
                          ),
                          elevation: 20,
                        ),
                      ),
                    ),
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
