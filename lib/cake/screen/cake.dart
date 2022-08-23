import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/Providers/video_provider.dart';
import 'package:app_learn_english/cake/screen/course.dart';
import 'package:app_learn_english/constant/constant_var.dart';
import 'package:app_learn_english/generated/l10n.dart';

import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/models/cake_model.dart';
import 'package:app_learn_english/models/course_model.dart';
import 'package:app_learn_english/networks/DataCache.dart';

import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class Cake extends StatefulWidget {
  const Cake({Key? key}) : super(key: key);
  @override
  _CakeState createState() => _CakeState();
}

class _CakeState extends State<Cake> {
  List<CakeItem> dataCake = [];
  List<CourseItem> dataCourse = [];
  bool _isloading = true;

  @override
  void didChangeDependencies() async {
    if (_isloading) {
      // dataCake = await TalkAPIs().getDataCake();
      dataCake = await DataCache().getKhoaHoc();
    }
    setState(() {
      _isloading = false;
    });
    super.didChangeDependencies();
  }

  String titleLanguage(String languageCode, int i) {
    String title;

    switch (languageCode) {
      case 'vi':
        title = '${dataCake[i].name_vi}';
        break;
      case 'ru':
        title = '${dataCake[i].name_ru}';
        break;
      case 'es':
        title = '${dataCake[i].name_es}';
        break;
      case 'zh':
        title = '${dataCake[i].name_zh}';
        break;
      case 'ja':
        title = '${dataCake[i].name_ja}';
        break;
      case 'hi':
        title = '${dataCake[i].name_hi}';
        break;
      case 'tr':
        title = '${dataCake[i].name_tr}';
        break;
      case 'pt':
        title = '${dataCake[i].name_pt}';
        break;
      case 'id':
        title = '${dataCake[i].name_id}';
        break;
      case 'th':
        title = '${dataCake[i].name_th}';
        break;
      case 'ms':
        title = '${dataCake[i].name_ms}';
        break;
      case 'ar':
        title = '${dataCake[i].name_ar}';
        break;
      case 'fr':
        title = '${dataCake[i].name_fr}';
        break;
      case 'it':
        title = '${dataCake[i].name_it}';
        break;
      case 'de':
        title = '${dataCake[i].name_de}';
        break;
      case 'ko':
        title = '${dataCake[i].name_ko}';
        break;
      case 'zh_Hant_TW':
        title = '${dataCake[i].name_zh_Hant_TW}';
        break;
      case 'sk':
        title = '${dataCake[i].name_sk}';
        break;
      case 'sl':
        title = '${dataCake[i].name_sl}';
        break;
      default:
        title = '${dataCake[i].name}';
        break;
    }
    return title;
  }

  String desLanguage(String languageCode, int i) {
    String title;

    switch (languageCode) {
      case 'vi':
        title = '${dataCake[i].description_vi}';
        break;
      case 'ru':
        title = '${dataCake[i].description_ru}';
        break;
      case 'es':
        title = '${dataCake[i].description_es}';
        break;
      case 'zh':
        title = '${dataCake[i].description_zh}';
        break;
      case 'ja':
        title = '${dataCake[i].description_ja}';
        break;
      case 'hi':
        title = '${dataCake[i].description_hi}';
        break;
      case 'tr':
        title = '${dataCake[i].description_tr}';
        break;
      case 'pt':
        title = '${dataCake[i].description_pt}';
        break;
      case 'id':
        title = '${dataCake[i].description_id}';
        break;
      case 'th':
        title = '${dataCake[i].description_th}';
        break;
      case 'ms':
        title = '${dataCake[i].description_ms}';
        break;
      case 'ar':
        title = '${dataCake[i].description_ar}';
        break;
      case 'fr':
        title = '${dataCake[i].description_fr}';
        break;
      case 'it':
        title = '${dataCake[i].description_it}';
        break;
      case 'de':
        title = '${dataCake[i].description_de}';
        break;
      case 'ko':
        title = '${dataCake[i].description_ko}';
        break;
      case 'zh_Hant_TW':
        title = '${dataCake[i].description_zh_Hant_TW}';
        break;
      case 'sk':
        title = '${dataCake[i].description_sk}';
        break;
      case 'sl':
        title = '${dataCake[i].description_sl}';
        break;
      default:
        title = '${dataCake[i].description}';
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
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: themeProvider.mode == ThemeMode.dark
                ? const Color.fromRGBO(42, 44, 50, 1)
                : Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: themeProvider.mode == ThemeMode.dark
                  ? const Color.fromRGBO(45, 48, 57, 1)
                  : Colors.white,
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  S.of(context).Course,
                  style: TextStyle(
                    fontSize: 20,
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
            body: ScopedModelDescendant<DataUser>(
              builder: (context, child, userData) {
                return Column(
                  children: [
                    Divider(
                        thickness: 1,
                        color: themeProvider.mode == ThemeMode.dark
                            ? Colors.grey.shade700
                            : const Color(0xFFE4E4E4),
                        height: 1),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        child: Container(
                          color: themeProvider.mode == ThemeMode.dark
                              ? const Color.fromRGBO(42, 44, 50, 1)
                              : Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 15),
                              _isloading
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      alignment: Alignment.topCenter,
                                      child: const Center(child: PhoLoading()),
                                      //     const CircularProgressIndicator(
                                      //   color: Colors.blue,
                                      // ),
                                    )
                                  : Container(
                                      height:
                                          MediaQuery.of(context).size.height -
                                              AppBar().preferredSize.height -
                                              100,
                                      child: GridView(
                                        physics: const BouncingScrollPhysics(),
                                        padding: const EdgeInsets.all(0),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisExtent: 330,
                                        ),
                                        children: [
                                          for (var i = 0;
                                              i < dataCake.length;
                                              i++)
                                            GestureDetector(
                                              onTap: () {
                                                Provider.of<VideoProvider>(
                                                        context,
                                                        listen: false)
                                                    .setdataTalk(null);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Course(
                                                      item: dataCake[i],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8),
                                                    child: Container(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: Image.network(
                                                          dataCake[i].picLink !=
                                                                      null ||
                                                                  dataCake[i]
                                                                      .picLink!
                                                                      .isNotEmpty
                                                              ? dataCake[i]
                                                                  .picLink!
                                                              : '${ConstantsVar.urlImageAdmin}${dataCake[i].picture}',
                                                          errorBuilder:
                                                              (context, object,
                                                                  stackTrace) {
                                                            return Image.network(
                                                                '${ConstantsVar.urlImageAdmin}${dataCake[i].picture}');
                                                          },
                                                          height: 200,
                                                          width: 155,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 12,
                                                          horizontal: 12),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            child: Text(
                                                              titleLanguage(
                                                                          lang,
                                                                          i) ==
                                                                      'null'
                                                                  ? titleLanguage(
                                                                      'en', i)
                                                                  : titleLanguage(
                                                                      lang, i),
                                                              maxLines: 1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: themeProvider
                                                                            .mode ==
                                                                        ThemeMode
                                                                            .dark
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8),
                                                            child: Text(
                                                              desLanguage(lang,
                                                                          i) ==
                                                                      'null'
                                                                  ? desLanguage(
                                                                      'en', i)
                                                                  : desLanguage(
                                                                      lang, i),
                                                              maxLines: 3,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: themeProvider
                                                                            .mode ==
                                                                        ThemeMode
                                                                            .dark
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
