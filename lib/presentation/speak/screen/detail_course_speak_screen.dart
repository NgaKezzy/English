import 'dart:io';

import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/main.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/presentation/Ads/AdmobHelper.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/provider/course_trinhdo.dart';
import 'package:app_learn_english/presentation/speak/utils/course_utils.dart';
import 'package:app_learn_english/presentation/speak/widgets/detail_see_more.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
import '../provider/all_list_talk_course.dart';
import '../widgets/detail_course_speak_item.dart';

class DetailCourseSpeakScreen extends StatefulWidget {
  final int idCourse;
  final DataUser dataUser;
  final String imageUrl;

  const DetailCourseSpeakScreen({
    Key? key,
    required this.idCourse,
    required this.dataUser,
    this.imageUrl = '',
  }) : super(key: key);
  static const routeName = '/detail-courses';

  @override
  State<DetailCourseSpeakScreen> createState() =>
      _DetailCourseSpeakScreenState();
}

class _DetailCourseSpeakScreenState extends State<DetailCourseSpeakScreen> {
  final admob = AdmobHelper();
  late CountHeartProvider heartProvider;

  @override
  void initState() {
    heartProvider = Provider.of<CountHeartProvider>(context, listen: false);
    // admob.createInterstitialAd();
    admob.getBannerAd();
    super.initState();
  }

  @override
  void dispose() async {
    if (heartProvider.buttonAds) {
      printBlue("START ADS");
      print('Đang gọi quảng cáo');
      PlyrVideoPlayer().initAdsBanner(admob.bannerAd);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      heartProvider.setButtonAds(false);
      prefs.setBool('isShowAds', false);
      // admob.showInterstitialAd();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    String checkLanguge(String name) {
      switch (name) {
        case "Nhập môn":
          return S.of(context).Introduction;

        case "Sơ cấp":
          return S.of(context).Primary;

        case "Trung cấp":
          return S.of(context).Intermediate;

        case "Cao cấp":
          return S.of(context).HighClass;

        default:
          return '';
      }
    }

    final dataCourse = Provider.of<AllListTalkCourse>(context, listen: false);
    TrinhDoCourse? course = dataCourse.getCourse(widget.idCourse) ?? null;

    return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
      return Scaffold(
        backgroundColor: themeProvider.mode == ThemeMode.dark
            ? const Color.fromRGBO(24, 26, 33, 1)
            : Colors.white,
        body: Stack(
          children: [
            Container(
              // nơi chuyển sang dark mode

              height: MediaQuery.of(context).size.height,
              child: course == null
                  ? Center(
                      child: Text(
                        S.of(context).NoDataFromTheCourseYet,
                      ),
                    )
                  : ListView(
                      children: [
                        Stack(
                          children: [
                            Container(
                              child: Hero(
                                tag: ValueKey(widget.imageUrl),
                                child: FadeInImage.memoryNetwork(
                                  height: MediaQuery.of(context).size.width *
                                      453 /
                                      720,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                  placeholder: kTransparentImage,
                                  image: widget.imageUrl,
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              453 /
                                              720,
                                      width: MediaQuery.of(context).size.width,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: (Image.asset(
                                          'assets/new_ui/more/anh_mac_dinh_luyen_doc.png',
                                          fit: BoxFit.cover,
                                          width:
                                              MediaQuery.of(context).size.width,
                                        )),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            // Container(
                            //   height: MediaQuery.of(context).size.width * 453 / 720,
                            //   width: MediaQuery.of(context).size.width,
                            //   color: Color.fromRGBO(144, 144, 144, 0.5),
                            // ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Platform.isAndroid
                                    ? Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 0.4),
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: SvgPicture.asset(
                                            'assets/new_ui/more/Iconly-Arrow-Left.svg',
                                            color: themeProvider.mode ==
                                                    ThemeMode.dark
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      )
                                    : const Icon(
                                        Icons.chevron_left_outlined,
                                        color: Colors.black,
                                        size: 40,
                                      ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                left: 20,
                                bottom: 10,
                              ),
                              height:
                                  MediaQuery.of(context).size.width * 453 / 720,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(
                                    color:
                                        const Color.fromRGBO(255, 255, 255, 0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: const BorderSide(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 15,
                                      ),
                                      child: Text(
                                        '${checkLanguge(UtilsCourse.convertLevelToString(course.start))}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    course.getNameByLanguage(provider
                                                    .locale!.languageCode) ==
                                                'null' ||
                                            course.getNameByLanguage(provider
                                                    .locale!.languageCode) ==
                                                '' ||
                                            course.getNameByLanguage(provider
                                                    .locale!.languageCode) ==
                                                null
                                        ? course.name
                                        : course.getNameByLanguage(
                                            provider.locale!.languageCode),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        DetailSeeMore(
                          name: course.getNameByLanguage(
                                          provider.locale!.languageCode) ==
                                      'null' ||
                                  course.getNameByLanguage(
                                          provider.locale!.languageCode) ==
                                      '' ||
                                  course.getNameByLanguage(
                                          provider.locale!.languageCode) ==
                                      null
                              ? course.name
                              : course.getNameByLanguage(
                                  provider.locale!.languageCode),
                          description: course.getDescriptionByLanguage(
                                          provider.locale!.languageCode) ==
                                      'null' ||
                                  course.getDescriptionByLanguage(
                                          provider.locale!.languageCode) ==
                                      '' ||
                                  course.getDescriptionByLanguage(
                                          provider.locale!.languageCode) ==
                                      null
                              ? course.description
                              : course.getDescriptionByLanguage(
                                  provider.locale!.languageCode),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                            left: 16,
                            top: 16,
                          ),
                          child: Align(
                            child: Text(
                              S.of(context).Conversation,
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            alignment: Alignment.topLeft,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        course.listTalk.length > 0
                            ? DetailCourseSpeakItem(
                                listTalk: course.listTalk,
                                dataUser: widget.dataUser,
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Text(
                                      S.of(context).NoCourseAvailable,
                                    ),
                                  )
                                ],
                              ),
                      ],
                    ),
            ),
          ],
        ),
      );
    });
  }
}
