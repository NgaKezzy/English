import 'dart:math';
import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/models/category_item.dart';
import 'package:app_learn_english/models/listen_item.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/quiz/game_speak/screens/advertise2.dart';
import 'package:app_learn_english/quiz/game_speak/screens/playing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaitScreen extends StatefulWidget {
  const WaitScreen({Key? key}) : super(key: key);

  @override
  _WaitScreenState createState() => _WaitScreenState();
}

class _WaitScreenState extends State<WaitScreen> {
  List<CatrgoryItem> dataCategory = [];
  List<ListenItem> dataListen = [];

  bool _isLoading = true;
  late SharedPreferences prefs;

  @override
  void didChangeDependencies() async {
    prefs = await SharedPreferences.getInstance();
    if (_isLoading) {
      dataCategory = await TalkAPIs().getDataListCate();
      dataListen = await TalkAPIs().getDataListen();
    }
    setState(() {
      _isLoading = false;
    });
    super.didChangeDependencies();
  }

  int randomInt(
      Random random, List<int> arrRandom, List<ListenItem> filterTopic) {
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

  List<ListenItem> filterTopicChoose10(int id) {
    List<ListenItem> filterTopic = [];
    for (var i = 0; i < dataListen.length; i++) {
      if (dataListen[i].cate_id == id) {
        filterTopic.add(dataListen[i]);
      }
    }
    if (filterTopic.length <= 10) {
      return filterTopic;
    } else {
      List<ListenItem> questionRandom = [];
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
    var hearProvider = Provider.of<CountHeartProvider>(
      context,
      listen: false,
    );
    return Scaffold(
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
                      Row(
                        children: [
                          Spacer(),
                          Column(
                            children: [
                              Text(
                                'Moon walk',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                              Text(
                                'Match the definition',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Column(
                          children: [
                            for (var item in dataCategory)
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (hearProvider.countHeart < 0 ||
                                          hearProvider.countHeart == 0) {
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
                                            builder: (context) => Playing(
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
                                  )
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
