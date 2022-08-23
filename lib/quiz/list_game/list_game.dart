import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/quiz/Screens/Splash.dart';
import 'package:app_learn_english/quiz/game_speak/screens/wait_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class List_game extends StatefulWidget {
  const List_game({Key? key}) : super(key: key);

  @override
  _List_gameState createState() => _List_gameState();
}

class _List_gameState extends State<List_game> {
  late SharedPreferences prefs;

  @override
  void didChangeDependencies() async {
    prefs = await SharedPreferences.getInstance();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/quiz/bg_quizgame.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.only(right: 320),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset(
                  'assets/new_ui/more/Iconly-Arrow-Left.svg',
                  color: Colors.white,
                ),
              ),
            ),
            Image.asset(
              'assets/new_ui/more/ic_splash.png',
              height: 100,
              width: 300,
            ),
            Text(
              S.of(context).PracticeGame,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TurtleSwimming(title: ''),
                  ),
                );
              },
              child: Stack(
                children: [
                  Image.asset(
                    'assets/quiz/border_cross_the_sea.png',
                  ),
                  Positioned(
                    top: 12,
                    left: 20,
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          child:
                              Image.asset('assets/quiz/icon_cross_the_sea.png'),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cross the sea',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Complete the sentence',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WaitScreen(),
                  ),
                );
              },
              child: Stack(
                children: [
                  Image.asset(
                    'assets/quiz/border_moonwalk.png',
                  ),
                  Positioned(
                    top: 12,
                    left: 20,
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          child: Image.asset('assets/quiz/icon_moonwalk.png'),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Moon walk',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Match the definition',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
