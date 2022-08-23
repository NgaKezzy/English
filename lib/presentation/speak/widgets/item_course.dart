import 'dart:io';

import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/presentation/speak/screen/detail_course_speak_screen.dart';
import 'package:app_learn_english/presentation/speak/utils/course_utils.dart';

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import 'pho_loading.dart';

class ItemCourse extends StatefulWidget {
  dynamic course;
  ItemCourse({Key? key, required this.course});
  @override
  State<StatefulWidget> createState() {
    return _ItemCourseView(course: course);
  }
}

class _ItemCourseView extends State<ItemCourse> {
  dynamic course;
  _ItemCourseView({Key? key, required this.course});

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

  @override
  Widget build(BuildContext context) {
    var URL_AVATAR_CATEGORY = Session().BASE_IMAGES + "images/cat_avatars/";
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          DetailCourseSpeakScreen.routeName,
          arguments: {
            'idCourse': course.id,
            'idUser': DataCache().getUserData().uid,
            'data': DataCache().getUserData(),
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: <Widget>[
                    Center(
                      // child: Platform.isAndroid
                      //     ? CircularProgressIndicator()
                      //     : CupertinoActivityIndicator(),
                      child: const PhoLoading(),
                    ),
                    Center(
                        child: FadeInImage.memoryNetwork(
                      width: (100 * 4) / 3,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: kTransparentImage,
                      image: Session().BASE_IMAGES +
                          '/images/cat_avatars/${course['picture']}',
                    ))
                  ],
                )),
            Expanded(
              child: Container(
                height: 90,
                margin: const EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${checkLanguge(UtilsCourse.convertLevelToString(course['start']))} | ${course['listTalk'].length} ${S.of(context).Lesson}',
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
