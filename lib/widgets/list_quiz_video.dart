import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/TalkDetailModel.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/widgets/item_quiz_video.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ListQuizVideo extends StatelessWidget {
  const ListQuizVideo({
    Key? key,
    required this.listSub,
    required this.controllerYT,
    required this.dataTalk,
  }) : super(key: key);
  final List<TalkDetailModel> listSub;
  final YoutubePlayerController controllerYT;
  final DataTalk dataTalk;

  List<TalkDetailModel> handleListSub(int numberSub, BuildContext context) {
    if (numberSub > listSub.length) {
      return [];
    } else if (numberSub == listSub.length) {
      return listSub;
    } else {
      List<TalkDetailModel> list = [];

      switch (numberSub) {
        case 2:
          var mapArr = listSub.map((e) => e.content.length).toList();
          mapArr.sort();
          for (var i = 0; i <= numberSub; i++) {
            // var indexSearch = mapArr.indexOf(mapArr[i]);
            list.add(listSub[i]);
          }
          break;
        case 3:
          var mapArr = listSub.map((e) => e.content.length).toList();
          mapArr.sort();
          for (var i = 0; i <= numberSub; i++) {
            // var indexSearchShort = mapArr.indexOf(mapArr[i]);
            list.add(listSub[i]);
          }
          // for (var j = numberSub - 1; j > numberSub - 2; j--) {
          //   var indexSearchLong = mapArr.indexOf(mapArr[j]);
          //   list.add(listSub[indexSearchLong]);
          // }
          break;
        case 4:
          var mapArr = listSub.map((e) => e.content.length).toList();
          mapArr.sort();
          for (var i = 0; i <= numberSub; i++) {
            // var indexSearchShort = mapArr.indexOf(mapArr[i]);
            list.add(listSub[i]);
          }
          // for (var j = numberSub - 1; j > numberSub - 3; j--) {
          //   var indexSearchLong = mapArr.indexOf(mapArr[j]);
          //   list.add(listSub[indexSearchLong]);
          // }
          break;
      }
      printCyan(list.toString());
      return list;
    }
  }

  @override
  Widget build(BuildContext context) {
    DataUser userData = DataCache().getUserData();
    return Container(
      height: 140,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        scrollDirection: Axis.horizontal,
        children: [
          if (handleListSub(4, context).length > 0||userData.isVip!=3)
            ItemQuizVideo(
              listSub: handleListSub(4, context),
              controllerYT: controllerYT,
              dataTalk: dataTalk,
              part: 'Part 1',
              star: '4',
            ),
          if (handleListSub(3, context).length > 0||userData.isVip!=3)
            ItemQuizVideo(
              listSub: handleListSub(3, context),
              controllerYT: controllerYT,
              dataTalk: dataTalk,
              part: 'Part 2',
              star: '3',
            ),
          if (handleListSub(2, context).length > 0||userData.isVip!=3)
            ItemQuizVideo(
              listSub: handleListSub(2, context),
              controllerYT: controllerYT,
              dataTalk: dataTalk,
              part: 'Part 3',
              star: '2',
            )
        ],
      ),
    );
  }
}
