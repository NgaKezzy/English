import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/models/ReviewTextData.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';

import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/review/SampleSentences.dart';

import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SampleSentencesFirst extends StatefulWidget {
  const SampleSentencesFirst({Key? key}) : super(key: key);

  @override
  State<SampleSentencesFirst> createState() => _SampleSentencesFirstState();
}

class _SampleSentencesFirstState extends State<SampleSentencesFirst> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      return FutureBuilder(
          future: DataCache().getListTextReview(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return _buildLoadNoData();
            } else {
              return snapshot.hasData
                  ? ScopedModel(
                      model: userData,
                      child: PageSampleSentencesWidget(
                        dataTextReview: snapshot.data,
                      ))
                  : _buildLoadNoData();
            }
          });
      // : FutureBuilder(
      //     future: TalkAPIs().fetchReviewTextData(userData: userData),
      //     builder: (context, AsyncSnapshot snapshot) {
      //       if (snapshot.hasError) {
      //         return _buildLoadNoData();
      //       } else if (snapshot.connectionState ==
      //           ConnectionState.waiting) {
      //         return Center(
      //           child: const PhoLoading(),
      //         );
      //       } else {
      //         return snapshot.hasData
      //             ? ScopedModel(
      //                 model: userData,
      //                 child: PageSampleSentencesWidget(
      //                   dataTextReview:
      //                       DataTextReview.fromJson(snapshot.data),
      //                 ))
      //             : _buildLoadNoData();
      //       }
      //     });
    });
  }

  // Screens No data
  Widget _buildLoadNoData() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          // Image.asset(
          //   'assets/linh_vat/linhvat2.png',
          //   height: 90,
          // ),
          const PhoLoading(),
          const SizedBox(
            height: 10,
          ),
          Text(
            S.of(context).Nostudydatayet,
            overflow: TextOverflow.visible,
            maxLines: 2,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}

class PageSampleSentencesWidget extends StatefulWidget {
  final DataTextReview dataTextReview;

  const PageSampleSentencesWidget({Key? key, required this.dataTextReview})
      : super(key: key);

  @override
  State<PageSampleSentencesWidget> createState() =>
      _PageSampleSentencesWidgetState();
}

class _PageSampleSentencesWidgetState extends State<PageSampleSentencesWidget> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      return Center(
        child: (widget.dataTextReview.textReview.length > 0)
            ? _buildPageView(
                context, ScopedModel(model: userData, child: SampleSentences()))
            : _buildLoadNoData(),
      );
    });
  }

  Widget _buildPageView(BuildContext context, Widget widgetSelect) {
    var themeProvider = context.watch<ThemeProvider>();
    final controller = PageController(viewportFraction: 0.85, keepPage: true);
    final pages = List.generate(
        widget.dataTextReview.textReview.length > 2 ? 3 : 2,
        (index) => _buildItemViewPage(context, index, widgetSelect));
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 210,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: controller,
              itemCount: widget.dataTextReview.textReview.length > 2 ? 3 : 2,
              padEnds: false,
              onPageChanged: (int index) {
                setState(() {
                  currentPageIndex = (index % pages.length);
                });
              },
              itemBuilder: (_, index) {
                return pages[index % pages.length];
              },
            ),
          ),
          const SizedBox(height: 5),
          SmoothPageIndicator(
            controller: controller,
            count: widget.dataTextReview.textReview.length > 2 ? 3 : 2,
            effect: WormEffect(
              dotHeight: 5,
              dotWidth: 5,
              dotColor: themeProvider.mode == ThemeMode.dark
                  ? const Color.fromRGBO(82, 83, 88, 1)
                  : Colors.black12,
              activeDotColor: Colors.green,
              type: WormType.thin,
              // strokeWidth: 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemViewPage(
      BuildContext context, int index, Widget selectWidget) {
    var themeProvider = context.watch<ThemeProvider>();
    return (index == 0)
        ? GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => selectWidget));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFF04D076),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30.0, horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).reviewSentencePattern,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 28.0),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30))),
                                child: const Center(
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                          child: Lottie.asset(
                            'assets/new_ui/animation_lottie/shiba.json',
                            width: 150,
                          ),
                          right: 20,
                          bottom: -25),
                    ],
                  )),
            ),
          )
        : GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => selectWidget));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: themeProvider.mode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black38)),
                margin: const EdgeInsets.only(left: 10),
                child: Container(
                  height: 200,
                  child: Center(
                      child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0, left: 20),
                          child: Text(
                            "''",
                            style: TextStyle(
                                color: themeProvider.mode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black54,
                                fontSize: 40),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    "${widget.dataTextReview.textReview[index - 1].content}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            themeProvider.mode == ThemeMode.dark
                                                ? Colors.white
                                                : Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    titleLanguage(
                                        Provider.of<LocaleProvider>(context,
                                                listen: true)
                                            .locale!
                                            .languageCode,
                                        index - 1),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            themeProvider.mode == ThemeMode.dark
                                                ? const Color.fromRGBO(
                                                    82, 83, 88, 1)
                                                : Colors.black45),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                ),
              ),
            ),
          );
  }

  // Screens No data
  Widget _buildLoadNoData() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          // Image.asset(
          //   'assets/new_ui/more/poor.png',
          //   height: 160,
          // ),
          const PhoLoading(),
          const SizedBox(
            height: 15,
          ),
          Text(
            S.of(context).Nostudydatayet,
            overflow: TextOverflow.visible,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  String titleLanguage(String languageCode, int index) {
    String title;

    switch (languageCode) {
      case 'vi':
        title = '${widget.dataTextReview.textReview[index].content_vi}';
        break;
      case 'ru':
        title = '${widget.dataTextReview.textReview[index].content_ru}';
        break;
      case 'es':
        title = '${widget.dataTextReview.textReview[index].content_es}';
        break;
      case 'zh':
        title = '${widget.dataTextReview.textReview[index].content_zh}';
        break;
      case 'ja':
        title = '${widget.dataTextReview.textReview[index].content_ja}';
        break;
      case 'hi':
        title = '${widget.dataTextReview.textReview[index].content_hi}';
        break;
      case 'tr':
        title = '${widget.dataTextReview.textReview[index].content_tr}';
        break;
      case 'pt':
        title = '${widget.dataTextReview.textReview[index].content_pt}';
        break;
      case 'id':
        title = '${widget.dataTextReview.textReview[index].content_id}';
        break;
      case 'th':
        title = '${widget.dataTextReview.textReview[index].content_th}';
        break;
      case 'ms':
        title = '${widget.dataTextReview.textReview[index].content_ms}';
        break;
      case 'ar':
        title = '${widget.dataTextReview.textReview[index].content_ar}';
        break;
      case 'fr':
        title = '${widget.dataTextReview.textReview[index].content_fr}';
        break;
      case 'it':
        title = '${widget.dataTextReview.textReview[index].content_it}';
        break;
      case 'de':
        title = '${widget.dataTextReview.textReview[index].content_de}';
        break;
      case 'ko':
        title = '${widget.dataTextReview.textReview[index].content_ko}';
        break;
      case 'zh_Hant_TW':
        title = '${widget.dataTextReview.textReview[index].content_zh_Hant_TW}';
        break;
      case 'sk':
        title = '${widget.dataTextReview.textReview[index].content_sk}';
        break;
      case 'sl':
        title = '${widget.dataTextReview.textReview[index].content_sl}';
        break;
      default:
        title = '${widget.dataTextReview.textReview[index].content}';
        break;
    }
    return title;
  }
}
