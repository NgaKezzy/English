import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/Providers/video_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/TalkTextModel.dart';
import 'package:app_learn_english/models/course_model.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/screen/main_speak_screen.dart';
import 'package:app_learn_english/screens/new_play_video_screen.dart';
import 'package:app_learn_english/screens/new_play_video_screen_max.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemCourseMyFeel extends StatefulWidget {
  const ItemCourseMyFeel({Key? key, required this.courseItem})
      : super(key: key);
  final CourseItem courseItem;

  @override
  State<ItemCourseMyFeel> createState() => _ItemCourseMyFeelState();
}

class _ItemCourseMyFeelState extends State<ItemCourseMyFeel> {
  List<DataTalk> dataLession = [];
  List<DataTalkText> dataSpeak = [];
  bool onClickedLesson = false;
  bool onClickedSpeak = false;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    dataLession = [];
    dataSpeak = [];
    TalkAPIs()
        .getDataDetailCourse(
      widget.courseItem.id!,
      DataCache().getUserData().uid,
    )
        .then(
      (value) {
        // printRed("VALUE: " + jsonEncode(value).toString());
        if (value![0]!.length > 0) {
          value[0]!.forEach(
            (talkData) => dataLession.add(
              DataTalk.fromJson(talkData),
            ),
          );
          onClickedLesson = dataLession[0].isSubmit!;
        }

        if (value[1]!.length > 0) {
          value[1]!.forEach(
            (talkDataText) => dataSpeak.add(
              DataTalkText.fromJson(talkDataText),
            ),
          );
          onClickedSpeak = dataSpeak[0].isSubmit!;
        }

        setState(() {
          _isLoading = false;
        });
      },
    );

    super.didChangeDependencies();
  }

  String titleLanguage(String languageCode) {
    String title;

    switch (languageCode) {
      case 'vi':
        title = '${widget.courseItem.name_vi}';
        break;
      case 'ru':
        title = '${widget.courseItem.name_ru}';
        break;
      case 'es':
        title = '${widget.courseItem.name_es}';
        break;
      case 'zh':
        title = '${widget.courseItem.name_zh}';
        break;
      case 'ja':
        title = '${widget.courseItem.name_ja}';
        break;
      case 'hi':
        title = '${widget.courseItem.name_hi}';
        break;
      case 'tr':
        title = '${widget.courseItem.name_tr}';
        break;
      case 'pt':
        title = '${widget.courseItem.name_pt}';
        break;
      case 'id':
        title = '${widget.courseItem.name_id}';
        break;
      case 'th':
        title = '${widget.courseItem.name_th}';
        break;
      case 'ms':
        title = '${widget.courseItem.name_ms}';
        break;
      case 'ar':
        title = '${widget.courseItem.name_ar}';
        break;
      case 'fr':
        title = '${widget.courseItem.name_fr}';
        break;
      case 'it':
        title = '${widget.courseItem.name_it}';
        break;
      case 'de':
        title = '${widget.courseItem.name_de}';
        break;
      case 'ko':
        title = '${widget.courseItem.name_ko}';
        break;
      case 'zh_Hant_TW':
        title = '${widget.courseItem.name_zh_Hant_TW}';
        break;
      case 'sk':
        title = '${widget.courseItem.name_sk}';
        break;
      case 'sl':
        title = '${widget.courseItem.name_sl}';
        break;
      default:
        title = '${widget.courseItem.name}';
        break;
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Consumer<LocaleProvider>(
      builder: (context, provider, snapshot) {
        String lang = provider.locale!.languageCode;
        return _isLoading
            ? const SizedBox()
            : GestureDetector(
                onTap: () async {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.35,
                        color: themeProvider.mode == ThemeMode.dark
                            ? const Color.fromRGBO(42, 44, 50, 1)
                            : Colors.grey[100],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 15,
                              ),
                              color: themeProvider.mode == ThemeMode.dark
                                  ? const Color.fromRGBO(42, 44, 50, 1)
                                  : Colors.white,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      titleLanguage(lang) == 'null'
                                          ? titleLanguage('en')
                                          : titleLanguage(lang),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        overflow: TextOverflow.ellipsis,
                                        color:
                                            themeProvider.mode == ThemeMode.dark
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: const Divider(
                                color: Colors.grey,
                              ),
                            ),
                            Container(
                              color: themeProvider.mode == ThemeMode.dark
                                  ? const Color.fromRGBO(42, 44, 50, 1)
                                  : Colors.white,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (!onClickedLesson) {
                                        TalkAPIs()
                                            .submitCourseOnClicked(
                                          widget.courseItem.id!,
                                          DataCache().getUserData().uid,
                                          dataLession[0].id,
                                          1,
                                        )
                                            .then((value) {
                                          setState(() {
                                            onClickedLesson = true;
                                          });
                                        });
                                      }
                                      Provider.of<VideoProvider>(
                                        context,
                                        listen: false,
                                      ).setVal(true);
                                      Provider.of<VideoProvider>(
                                        context,
                                        listen: false,
                                      ).setdataTalk(null);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              NewPlayVideoScreenNormal(
                                            true,
                                            dataTalk: dataLession[0],
                                            percent: 1,
                                            ytId: '',
                                            enablePop: true,
                                          ),
                                        ),
                                      );
                                    },
                                    child: ListTile(
                                      leading: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          image: DecorationImage(
                                            image: AssetImage(
                                              onClickedLesson
                                                  ? 'assets/cake/speak1.png'
                                                  : 'assets/cake/vidoe.png',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      title: const Text(
                                        'Step 1',
                                        style: TextStyle(fontSize: 19),
                                      ),
                                      subtitle: Text(
                                        S.of(context).BaiGiang,
                                        style: TextStyle(
                                            color: themeProvider.mode ==
                                                    ThemeMode.dark
                                                ? const Color.fromRGBO(
                                                    104, 105, 110, 1)
                                                : Colors.black),
                                      ),
                                      trailing: const Icon(
                                        Icons.navigate_next,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: const Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (!onClickedSpeak) {
                                        TalkAPIs()
                                            .submitCourseOnClicked(
                                          widget.courseItem.id!,
                                          DataCache().getUserData().uid,
                                          dataSpeak[0].id,
                                          2,
                                        )
                                            .then((value) {
                                          setState(() {
                                            onClickedSpeak = true;
                                          });
                                        });
                                      }
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MainSpeakScreen(
                                            dataUser: DataCache().getUserData(),
                                            title: dataSpeak[0].name,
                                            id: '${dataSpeak[0].id}',
                                          ),
                                        ),
                                      );
                                    },
                                    child: ListTile(
                                      leading: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          image: DecorationImage(
                                            image: AssetImage(
                                              onClickedSpeak
                                                  ? 'assets/cake/speak1.png'
                                                  : 'assets/cake/luyennoi.png',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      title: const Text(
                                        'Step 2',
                                        style: TextStyle(fontSize: 19),
                                      ),
                                      subtitle: Text(
                                        S.of(context).LuyenNoi,
                                        style: TextStyle(
                                            color: themeProvider.mode ==
                                                    ThemeMode.dark
                                                ? const Color.fromRGBO(
                                                    104, 105, 110, 1)
                                                : Colors.black),
                                      ),
                                      trailing: const Icon(
                                        Icons.navigate_next,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleLanguage(lang) == 'null'
                            ? titleLanguage('en')
                            : titleLanguage(lang),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: onClickedLesson
                                    ? const Color.fromRGBO(109, 177, 93, 1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                border: onClickedLesson
                                    ? null
                                    : Border.all(
                                        color: Colors.grey[350]!,
                                      ),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: onClickedLesson
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    : Text(
                                        '1',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: onClickedLesson
                                              ? Colors.white
                                              : Colors.grey[500],
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: onClickedSpeak
                                    ? const Color.fromRGBO(109, 177, 93, 1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: onClickedSpeak
                                      ? Colors.transparent
                                      : Colors.grey[350]!,
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: onClickedSpeak
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    : Text(
                                        '2',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: onClickedSpeak
                                              ? Colors.white
                                              : Colors.grey[500],
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
