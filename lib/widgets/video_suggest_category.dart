import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/Providers/video_provider.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/screens/new_play_video_screen_max.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/provider.dart';

class VideoSuggest extends StatefulWidget {
  final Category data;
  final bool pop;
  const VideoSuggest({Key? key, required this.data, required this.pop})
      : super(key: key);

  @override
  State<VideoSuggest> createState() => _VideoSuggestState();
}

class _VideoSuggestState extends State<VideoSuggest> {
  String filterIdYoutube(String str) {
    List<String> listStr = str.split('?v=');
    return listStr[listStr.length - 1];
  }

  List<String> listName = [];

  void addListName() {
    widget.data.listTalk.forEach((element) {
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
        sample = widget.data.listTalk[index].name;
        break;
      case 'ru':
        sample = widget.data.listTalk[index].name_ru;
        break;
      case 'vi':
        sample = widget.data.listTalk[index].name_vi;
        break;
      case 'es':
        sample = widget.data.listTalk[index].name_es;
        break;
      case 'hi':
        sample = widget.data.listTalk[index].name_hi;
        break;
      case 'ja':
        sample = widget.data.listTalk[index].name_ja;
        break;
      case 'zh':
        sample = widget.data.listTalk[index].name_zh;
        break;
      case 'tr':
        sample = widget.data.listTalk[index].name_tr;
        break;
      case 'pt':
        sample = widget.data.listTalk[index].name_pt;
        break;
      case 'id':
        sample = widget.data.listTalk[index].name_id;
        break;
      case 'th':
        sample = widget.data.listTalk[index].name_th;
        break;
      case 'ms':
        sample = widget.data.listTalk[index].name_ms;
        break;
      case 'ar':
        sample = widget.data.listTalk[index].name_ar;
        break;
      case 'fr':
        sample = widget.data.listTalk[index].name_fr;
        break;
      case 'it':
        sample = widget.data.listTalk[index].name_it;
        break;
      case 'de':
        sample = widget.data.listTalk[index].name_de;
        break;
      case 'ko':
        sample = widget.data.listTalk[index].name_ko;
        break;
      case 'zh_Hant_TW':
        sample = widget.data.listTalk[index].name_zh_Hant_TW;
        break;
      case 'sk':
        sample = widget.data.listTalk[index].name_sk;
        break;
      case 'sl':
        sample = widget.data.listTalk[index].name_sl;
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
    List<String> listStr = widget.data.listTalk.map((e) {
      return e.link_origin.split('?v=')[1];
    }).toList();
    return Consumer<LocaleProvider>(
      builder: (ctx, localeProvider, child) => Container(
        margin: const EdgeInsets.only(top: 15),
        height: 300,
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          children: [
            for (var i = 0; i < widget.data.listTalk.length; i++)
              InkWell(
                onTap: () async {
                  widget.data.listTalk[i].yt_id =
                      filterIdYoutube(widget.data.listTalk[i].link_origin);
                  if (widget.pop) {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NewPlayVideoScreenNormal(
                          true,
                          dataTalk: widget.data.listTalk[i],
                          percent: 1,
                          ytId: '',
                          enablePop: false,
                        ),
                      ),
                    );
                  } else {
                    final videoProvider = Provider.of<VideoProvider>(
                      context,
                      listen: false,
                    );
                    if (videoProvider.getdataTalk() != null) {
                      videoProvider.setdataTalk(null);
                    }

                    Future.delayed(Duration(seconds: 0), () {
                      videoProvider.setVal(true);
                      videoProvider.setdataTalk(widget.data.listTalk[i]);
                      videoProvider.miniplayerController.animateToHeight(
                        state: PanelState.MAX,
                      );
                    });
                  }
                },
                child: Card(
                  color: themeProvider.mode == ThemeMode.dark
                      ? const Color.fromRGBO(42, 44, 50, 1)
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    height: 300,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Stack(
                            children: [
                              Image.network(
                                widget.data.listTalk[i].picLink.isEmpty
                                    ?
                                    // URL_AVATAR_VIDEO + data.listTalk[i].picture,
                                    (widget.data.listTalk[i].link_origin.isEmpty
                                        ? URL_AVATAR_VIDEO +
                                            widget.data.listTalk[i].picture
                                        : "https://img.youtube.com/vi/" +
                                            '${listStr[i]}' +
                                            '/0.jpg')
                                    : widget.data.listTalk[i].picture,
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 180,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 55),
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
                                              localeProvider
                                                  .locale!.languageCode,
                                              i) ==
                                          'null'
                                      ? changeLanguage('en', i)
                                      : changeLanguage(
                                          localeProvider.locale!.languageCode,
                                          i),
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  // widget.data.listTalk[i].name,
                                  listName[i],
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 16,
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
              ),
          ],
        ),
      ),
    );
  }
}
