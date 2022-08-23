import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/screens/new_play_video_screen_max.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:app_learn_english/Providers/video_provider.dart';

import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ItemSuggesInVideo extends StatefulWidget {
  final List<DataTalk> data;
  final bool pop;
  ItemSuggesInVideo({Key? key, required this.data, required this.pop})
      : super(key: key);

  @override
  State<ItemSuggesInVideo> createState() => _ItemSuggesInVideoState();
}

class _ItemSuggesInVideoState extends State<ItemSuggesInVideo> {
  List<String> listName = [];

  void addListName() {
    widget.data.forEach((element) {
      if (element.name.length > 0) {
        listName.add(Utils.buildNameTalkWithRandomWord(element.name));
      } else {
        listName.add(element.name);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    addListName();
  }

  String changeLanguage(String languageCode, int index) {
    String sample = '';

    switch (languageCode) {
      case 'en':
        sample = widget.data[index].name;
        break;
      case 'ru':
        sample = widget.data[index].name_ru;
        break;
      case 'vi':
        sample = widget.data[index].name_vi;
        break;
      case 'es':
        sample = widget.data[index].name_es;
        break;
      case 'hi':
        sample = widget.data[index].name_hi;
        break;
      case 'ja':
        sample = widget.data[index].name_ja;
        break;
      case 'zh':
        sample = widget.data[index].name_zh;
        break;
      case 'tr':
        sample = widget.data[index].name_tr;
        break;
      case 'pt':
        sample = widget.data[index].name_pt;
        break;
      case 'id':
        sample = widget.data[index].name_id;
        break;
      case 'th':
        sample = widget.data[index].name_th;
        break;
      case 'ms':
        sample = widget.data[index].name_ms;
        break;
      case 'ar':
        sample = widget.data[index].name_ar;
        break;
      case 'fr':
        sample = widget.data[index].name_fr;
        break;
      case 'it':
        sample = widget.data[index].name_it;
        break;
      case 'de':
        sample = widget.data[index].name_de;
        break;
      case 'ko':
        sample = widget.data[index].name_ko;
        break;
      case 'zh_Hant_TW':
        sample = widget.data[index].name_zh_Hant_TW;
        break;
      case 'sk':
        sample = widget.data[index].name_sk;
        break;
      case 'sl':
        sample = widget.data[index].name_sl;
        break;
      default:
    }

    return sample;
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var URL_AVATAR_VIDEO = Session().BASE_IMAGES + "images/talk_avatars/";
    final URL_AVATAR_TEXT = Session().BASE_IMAGES + 'images/talk_text_avatars/';
    List<String> listStr = widget.data.map((e) {
      return e.link_origin.split('?v=')[1];
    }).toList();
    return Consumer<LocaleProvider>(
      builder: (ctx, localeProvider, child) => Container(
        margin: const EdgeInsets.only(top: 15),
        child: Column(
          children: [
            for (var i = 0; i < widget.data.length; i++)
              InkWell(
                onTap: () async {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NewPlayVideoScreenNormal(
                            true,
                            dataTalk: widget.data[i],
                            percent: 1,
                            ytId: '',
                            enablePop: false,
                          )));
                  //không xóa đoạn code dưới
                  // if (widget.pop) {
                  //   Navigator.of(context).pop();
                  //   Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (context) => NewPlayVideoScreenNormal(
                  //             true,
                  //             dataTalk: widget.data[i],
                  //             percent: 1,
                  //             ytId: '',
                  //           )));
                  // } else {
                  //   final videoProvider = Provider.of<VideoProvider>(
                  //     context,
                  //     listen: false,
                  //   );
                  //   if (videoProvider.getdataTalk() != null) {
                  //     videoProvider.setdataTalk(null);
                  //   }
                  //
                  //   Future.delayed(Duration(seconds: 0), () {
                  //     videoProvider.setVal(true);
                  //     videoProvider.setdataTalk(widget.data[i]);
                  //     videoProvider.miniplayerController.animateToHeight(
                  //       height: MediaQuery.of(context).size.height,
                  //     );
                  //   });
                  // }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: themeProvider.mode == ThemeMode.dark
                        ? const Color.fromRGBO(42, 44, 50, 1)
                        : Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              widget.data[i].picLink.isEmpty
                                  ?
                                  // URL_AVATAR_VIDEO + data[i].picture,
                                  "https://img.youtube.com/vi/" +
                                      '${widget.data[i].yt_id}' +
                                      "/sddefault.jpg"
                                  : URL_AVATAR_TEXT + widget.data[i].picture,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 65),
                            child: Align(
                              alignment: Alignment.center,
                              child: Opacity(
                                opacity: 0.6,
                                child: SvgPicture.asset(
                                  'assets/new_ui/home/play_ic_play.svg',
                                  height: 60,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                changeLanguage(
                                            localeProvider.locale!.languageCode,
                                            i) ==
                                        'null'
                                    ? changeLanguage('en', i)
                                    : changeLanguage(
                                        localeProvider.locale!.languageCode, i),
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                listName[i],
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ],
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
    );
  }
}
