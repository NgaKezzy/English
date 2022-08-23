import 'dart:math';

import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/models/question_item.dart';
import 'package:app_learn_english/models/theme_item.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/quiz/game_speak/screens/advertise2.dart';
import 'package:app_learn_english/quiz/Screens/play_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TurtleSwimming extends StatefulWidget {
  TurtleSwimming({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TurtleSwimming> createState() => _TurtleSwimmingState();
}

class _TurtleSwimmingState extends State<TurtleSwimming> {
  List<ThemeItem> data = [];
  List<QuestionItem> dataQuestion = [];
  DataUser userData = DataCache().getUserData();
  bool _isLoading = true;
  late SharedPreferences prefs;

  @override
  void didChangeDependencies() async {
    prefs = await SharedPreferences.getInstance();
    if (_isLoading) {
      data = await TalkAPIs().getCate();
      dataQuestion = await TalkAPIs().getDataQuestion();
      // print(data.toList().toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  int randomInt(
      Random random, List<int> arrRandom, List<QuestionItem> filterTopic) {
    var randomNum = random.nextInt(filterTopic.length);
    bool checkFlag = false;
    for (var i = 0; i < arrRandom.length; i++) {
      if (randomNum == arrRandom[i]) {
        checkFlag = true;
      }
    }
    if (checkFlag) {
      return randomNum = randomInt(random, arrRandom, filterTopic);
    } else {
      return randomNum;
    }
  }

  List<QuestionItem> filterTopicChoose10(int id) {
    List<QuestionItem> filterTopic = [];
    for (var i = 0; i < dataQuestion.length; i++) {
      if (dataQuestion[i].cate_id == id) {
        filterTopic.add(dataQuestion[i]);
      }
    }
    if (filterTopic.length <= 10) {
      return filterTopic;
    } else {
      List<QuestionItem> questionRandom = [];
      List<int> arrRandomIndex = [];
      var random = Random();
      int randomNum = 0;
      for (var i = 0; i < 10; i++) {
        if (arrRandomIndex.length == 0) {
          randomNum = random.nextInt(filterTopic.length);
          arrRandomIndex.add(randomNum);
        } else {
          randomNum = randomInt(random, arrRandomIndex, filterTopic);
          arrRandomIndex.add(randomNum);
        }
      }

      arrRandomIndex.forEach((element) {
        questionRandom.add(filterTopic[element]);
      });
      return questionRandom;
    }
  }

  String checkBG(int i) {
    var bg = '';
    switch (i) {
      case 1:
        bg = 'button_activities_event';
        break;
      case 2:
        bg = 'button_choices';
        break;
      case 3:
        bg = 'button_communication';
        break;
      case 4:
        bg = 'decrebing_people';
        break;
      case 5:
        bg = 'button_test';
        break;
    }
    return bg;
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var hearProvider = Provider.of<CountHeartProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      backgroundColor: themeProvider.mode == ThemeMode.dark
          ? Color.fromRGBO(42, 44, 50, 1)
          : Colors.white,
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(
            left: 5,
            right: 5,
            top: 20,
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/quiz/bg_quizgame.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: _isLoading
              ? Center(
                  // child: CircularProgressIndicator(color: Colors.white),
                  child: const PhoLoading(),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 22),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: SvgPicture.asset(
                          'assets/new_ui/more/Iconly-Arrow-Left.svg',
                          color: Colors.white,
                        ),
                      ),
                      Row(children: [
                        Spacer(),
                        Column(
                          children: [
                            Text(
                              'CROSS THE SEA',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              'Complete the sentence',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                      ]),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Column(
                          children: [
                            for (var item in data)
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      if (userData.isVip != 1 &&
                                          userData.isVip != 2) {
                                        if (hearProvider.countHeart == 0 ||
                                            hearProvider.countHeart < 0) {
                                          // int bonusHeart = await
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Advertise(
                                                checkOnce: false,
                                              ),
                                            ),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PlayGame(
                                                data: filterTopicChoose10(
                                                    item.id),
                                                filterTopicChoose10:
                                                    filterTopicChoose10,
                                                idChoose: item.id,
                                              ),
                                            ),
                                          );
                                        }
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PlayGame(
                                              data:
                                                  filterTopicChoose10(item.id),
                                              filterTopicChoose10:
                                                  filterTopicChoose10,
                                              idChoose: item.id,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 200,
                                          width: 200,
                                          child: Image.asset(
                                              'assets/quiz/${checkBG(item.id)}.png'),
                                        ),
                                        Positioned(
                                          top: 50,
                                          right: 20,
                                          left: 20,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                item.name,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                item.TotalQuestion + ' word',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
