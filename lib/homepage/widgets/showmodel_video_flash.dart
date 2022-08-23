import 'package:app_learn_english/generated/l10n.dart';

import 'package:app_learn_english/models/TalkDetailModel.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/screens/login_account_screen.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowmodelVideoFlash extends StatefulWidget {
  final DataTalk dataTalk;
  final List<TalkDetailModel> listSub;
  const ShowmodelVideoFlash(
      {Key? key, required this.dataTalk, required this.listSub})
      : super(key: key);

  @override
  State<ShowmodelVideoFlash> createState() => _ShowmodelVideoFlashState();
}

class _ShowmodelVideoFlashState extends State<ShowmodelVideoFlash> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(builder: (context, provider, snaphot) {
      String lang = provider.locale!.languageCode;
      return Container(
        height: 250,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Text(
                    S.of(context).SentenceCards,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
              color: Colors.grey[200],
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var i = 0; i < widget.listSub.length; i++)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${i + 1}'),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.listSub[i].content,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      Utils.changeLanguageTalkShowModel(
                                          lang, i, widget.listSub),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  20,
                                ),
                                side: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              elevation: 0,
                              child: DataCache().checkSentenceVideo(
                                          widget.listSub[i], 1) ==
                                      false
                                  ? InkWell(
                                      onTap: () {
                                        if (DataCache().getUserData().uid ==
                                            0) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginAccountScreen(),
                                            ),
                                          );
                                        }
                                        TalkAPIs()
                                            .addItemCourse(
                                                '${DataCache().getUserData().uid}',
                                                widget.listSub[i].id.toString(),
                                                1,
                                                lang)
                                            .then((value) {
                                          (context as Element).markNeedsBuild();
                                          if (value == 1) {
                                            Utils().showNotificationBottom(true,
                                                S.of(context).AddedSuccess);
                                          } else if (value == 0) {
                                            Utils().showNotificationBottom(
                                                false,
                                                S
                                                    .of(context)
                                                    .AddFailedSentence);
                                          } else if (value == -1) {
                                            Utils().showNotificationBottom(
                                                false,
                                                S
                                                    .of(context)
                                                    .SentencePatternAlready);
                                          }
                                        });
                                      },
                                      child: const Icon(
                                        Icons.add,
                                        size: 25,
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        Utils().showNotificationBottom(
                                            false,
                                            S
                                                .of(context)
                                                .SentencePatternAlready);
                                      },
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                        size: 25,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
