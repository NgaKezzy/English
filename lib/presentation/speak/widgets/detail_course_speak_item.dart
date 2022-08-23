import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/presentation/speak/widgets/detail_course_list_item.dart';
import 'package:flutter/material.dart';

class DetailCourseSpeakItem extends StatefulWidget {
  final List<dynamic> listTalk;
  final DataUser dataUser;

  const DetailCourseSpeakItem({
    Key? key,
    required this.listTalk,
    required this.dataUser,
  }) : super(key: key);

  @override
  State<DetailCourseSpeakItem> createState() => _DetailCourseSpeakItemState();
}

class _DetailCourseSpeakItemState extends State<DetailCourseSpeakItem> {
  double updatePercentCourse = 0;
  List<Widget> listSpeaking(BuildContext context) {
    final List<Widget> listSpeak = [];
    for (var i = 0; i < widget.listTalk.length; i++) {
      printRed(widget.listTalk.toString());
      listSpeak.add(
         DetailCourseListItem(
          listTalk: widget.listTalk,
          dataUser: widget.dataUser,
          indexList: i,
          key: ValueKey(i),
        ),
      );
    }
    return listSpeak;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [...listSpeaking(context)],
    );
  }
}
