import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/TextReviewModel.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/startpage/responsive_start_page.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

class ItemExitSampleSentencesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return ScopedModelDescendant<TextReview>(
        builder: (context, child, textReview) {
      return Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16))),
        padding: EdgeInsets.only(right: 20, left: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              // onTap: () {
              //   Navigator.pop(context);
              // },
              child: ListTile(
                  title: InkWell(
                    onTap: () {
                      activeDialog(context, 'chưa có gì');
                    },
                    child: ListTile(
                      leading: Text(
                        S.of(context).SeeMore,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: ResponsiveWidget.isSmallScreen(context)
                              ? width / 15
                              : width / 45,
                        ),
                      ),
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 40,
                    ),
                  )),
            ),
            Divider(
              thickness: 1,
              color: Colors.black,
            ),
            InkWell(
              onTap: () {
                activeDialog(context, 'chưa có gì');
              },
              child: ListTile(
                leading: Text(
                  S.of(context).ReportPronunciationError,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: ResponsiveWidget.isSmallScreen(context)
                        ? width / 20
                        : width / 45,
                  ),
                ),
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.black,
            ),
            InkWell(
              onTap: () {
                activeDialog(context, 'chưa có gì');
              },
              child: ListTile(
                leading: Text(
                  S.of(context).ViewLesson,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: ResponsiveWidget.isSmallScreen(context)
                        ? width / 20
                        : width / 45,
                  ),
                ),
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.black,
            ),
            InkWell(
              onTap: () {
                TalkAPIs()
                    .deleteItemCourse(textReview.ttrid.toString())
                    .then((value) => {
                          if (value == 1)
                            {
                              Utils().showNotificationBottom(
                                  true, "Xoá mẫu câu thành công!"),
                              Navigator.pop(context),
                            }
                          else
                            {
                              Utils().showNotificationBottom(
                                  true, "Xoá mẫu câu thành công!"),
                            }
                        });
              },
              child: ListTile(
                leading: Text(
                  S.of(context).DeleteSentencePattern,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: ResponsiveWidget.isSmallScreen(context)
                        ? width / 20
                        : width / 45,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      );
    });
  }
}
