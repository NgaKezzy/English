import 'package:app_learn_english/models/TalkDetailModel.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/quiz/train_listen/provider/quiz_video_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizVideoBody extends StatefulWidget {
  const QuizVideoBody({Key? key, required this.listSub}) : super(key: key);
  final List<TalkDetailModel> listSub;

  @override
  State<QuizVideoBody> createState() => _QuizVideoBodyState();
}

class _QuizVideoBodyState extends State<QuizVideoBody> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
      String lang = provider.locale!.languageCode;
      return Container(
        padding: const EdgeInsets.all(12),
        height: 250,
        child: Consumer<QuizVideoProvider>(
          builder: (ctx, quizVideoProvider, widget) {
            String changeLanguage(String languageCode) {
              String sample = '';

              switch (languageCode) {
                case 'en':
                  sample = quizVideoProvider
                      .listSub[quizVideoProvider.index].content;
                  break;
                case 'ru':
                  sample = quizVideoProvider
                      .listSub[quizVideoProvider.index].content_ru;
                  break;
                case 'vi':
                  sample = quizVideoProvider
                      .listSub[quizVideoProvider.index].content_vi;
                  break;
                case 'es':
                  sample = quizVideoProvider
                      .listSub[quizVideoProvider.index].content_es;
                  break;
                case 'hi':
                  sample = quizVideoProvider
                      .listSub[quizVideoProvider.index].content_hi;
                  break;
                case 'ja':
                  sample = quizVideoProvider
                      .listSub[quizVideoProvider.index].content_ja;
                  break;
                case 'zh':
                  sample = quizVideoProvider
                      .listSub[quizVideoProvider.index].content_zh;
                  break;
                case 'tr':
                  sample = quizVideoProvider
                      .listSub[quizVideoProvider.index].content_tr;
                  break;
                case 'pt':
                  sample = quizVideoProvider
                      .listSub[quizVideoProvider.index].content_pt;
                  break;
                case 'id':
                  sample = quizVideoProvider
                      .listSub[quizVideoProvider.index].content_id;
                  break;
                case 'th':
                  sample = quizVideoProvider
                      .listSub[quizVideoProvider.index].content_th;
                  break;
                case 'ms':
                  sample = quizVideoProvider
                      .listSub[quizVideoProvider.index].content_ms;
                  break;
                case 'ar':
                  sample = quizVideoProvider
                      .listSub[quizVideoProvider.index].content_ar;
                  break;
                case 'fr':
                  sample = quizVideoProvider
                      .listSub[quizVideoProvider.index].content_fr;
                  break;
                case 'it':
                  sample = quizVideoProvider
                      .listSub[quizVideoProvider.index].content_it;
                  break;
                case 'de':
                  sample = quizVideoProvider
                      .listSub[quizVideoProvider.index].content_de;
                  break;
                case 'ko':
                  sample = quizVideoProvider
                      .listSub[quizVideoProvider.index].content_ko;
                  break;
                case 'zh_Hant_TW':
                  sample = quizVideoProvider
                      .listSub[quizVideoProvider.index].content_zh_Hant_TW;
                  break;
                case 'sk':
                  sample = quizVideoProvider
                      .listSub[quizVideoProvider.index].content_sk;
                  break;
                case 'sl':
                  sample = quizVideoProvider
                      .listSub[quizVideoProvider.index].content_sl;
                  break;
                default:
              }

              return sample;
            }

            return quizVideoProvider.initialize
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Wrap(
                          children: quizVideoProvider.randomStringConvert,
                          // text khi đã được so sánh để hoàn thành câu
                        ),
                      ),
                      SizedBox(height: 16),
                      (quizVideoProvider.index >=
                              quizVideoProvider.listSub.length - 1)
                          ? Container()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                changeLanguage(lang) == 'null'
                                    ? ''
                                    : changeLanguage(lang),
                                style:const TextStyle(
                                  height: 2,
                                ),
                              ),
                            ),
                      Expanded(child: Container()),
                      Text(
                        '${quizVideoProvider.index + 1}/${quizVideoProvider.listSub.length - 1}',
                      ),
                    ],
                  )
                : SizedBox();
          },
        ),
      );
    });
  }
}
