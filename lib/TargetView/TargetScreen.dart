import 'dart:math';

import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/TargetView/DayTarget.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/TargetView/MonthTarget.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/src/provider.dart';

class TargetScreen extends StatefulWidget {
  static const routeName = '/target-page';

  @override
  _TargetScreenState createState() => _TargetScreenState();
}

class _TargetScreenState extends State<TargetScreen> {
  late ConfettiController controllerAnimationFireWorkTop;

  @override
  void initState() {
    controllerAnimationFireWorkTop = ConfettiController(
      duration: const Duration(seconds: 1),
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controllerAnimationFireWorkTop.dispose();
  }

  void playAnim() {
    controllerAnimationFireWorkTop.play();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeProvider.mode == ThemeMode.dark
            ? Color.fromRGBO(45, 48, 57, 1)
            : Colors.white,
        automaticallyImplyLeading: false,
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
        title: Text(
          S.of(context).Target,
          style: TextStyle(
            color: themeProvider.mode == ThemeMode.dark
                ? Colors.white
                : Colors.black87,
            fontSize: 20,
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
              width: width,
              height: height * 1,
              decoration: BoxDecoration(
                // image: DecorationImage(
                //     image: AssetImage('assets/images/background.png'),
                //     fit: BoxFit.fill)
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
                    : Colors.white,
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: 150),
                      child: ConfettiWidget(
                        confettiController: controllerAnimationFireWorkTop,
                        blastDirectionality: BlastDirectionality.explosive,
                        blastDirection: pi / 2, // radial value - LEFT
                        particleDrag: 0.1, // apply drag to the confetti
                        emissionFrequency: 1, // how often it should emit
                        numberOfParticles: 10, // number of particles to emit
                        gravity: 0.1, // gravity - or fall speed
                        shouldLoop: false,
                        colors: const [
                          Colors.green,
                          Colors.blue,
                          Colors.pink,
                          Colors.red,
                          Colors.purple,
                          Colors.orange,
                          Colors.yellow,
                        ], // manually specify the colors to be used
                      ),
                    ),
                  ),
                  ListView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      DayTarget(),
                      SizedBox(
                        height: 16,
                      ),
                      MonthTarget(
                        playAnim: playAnim,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      // LinearProgres(),
                    ],
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
