import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/Providers/video_provider.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/models/video_history/history_model.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';

import 'package:app_learn_english/screens/new_play_video_screen_max.dart';

import 'package:app_learn_english/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemVideoHistory extends StatefulWidget {
  final History reviewData;
  final String ytId;
  final VoidCallback onDeleteVideo;
  final bool isHome;

  const ItemVideoHistory(
      {Key? key,
      required this.reviewData,
      required this.ytId,
      required this.onDeleteVideo,
      required this.isHome})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ItemVideoHistory(reviewData: reviewData);
  }
}

class _ItemVideoHistory extends State<ItemVideoHistory> {
  History reviewData;
  var URL_AVATAR_VIDEO = Session().BASE_IMAGES + "images/talk_avatars/";
  final URL_AVATAR_TEXT = Session().BASE_IMAGES + 'images/talk_text_avatars/';
  late String _nameEn;

  _ItemVideoHistory({Key? key, required this.reviewData});

  @override
  void initState() {
    super.initState();
    _nameEn = Utils.buildNameTalkWithRandomWord(reviewData.Talk.name);
  }

  String titleLanguage(String languageCode) {
    String title;

    switch (languageCode) {
      case 'vi':
        title = '${reviewData.Talk.nameVi}';
        break;
      case 'ru':
        title = '${reviewData.Talk.nameRu}';
        break;
      case 'es':
        title = '${reviewData.Talk.nameEs}';
        break;
      case 'zh':
        title = '${reviewData.Talk.nameZh}';
        break;
      case 'ja':
        title = '${reviewData.Talk.nameJa}';
        break;
      case 'hi':
        title = '${reviewData.Talk.nameHi}';
        break;
      case 'tr':
        title = '${reviewData.Talk.nameTr}';
        break;
      case 'pt':
        title = '${reviewData.Talk.namePt}';
        break;
      case 'id':
        title = '${reviewData.Talk.nameId}';
        break;
      case 'th':
        title = '${reviewData.Talk.nameTh}';
        break;
      case 'ms':
        title = '${reviewData.Talk.nameMs}';
        break;
      case 'ar':
        title = '${reviewData.Talk.nameAr}';
        break;
      case 'fr':
        title = '${reviewData.Talk.nameFr}';
        break;
      case 'it':
        title = '${reviewData.Talk.nameIt}';
        break;
      case 'de':
        title = '${reviewData.Talk.nameDe}';
        break;
      case 'ko':
        title = '${reviewData.Talk.nameKo}';
        break;
      case 'zh_Hant_TW':
        title = '${reviewData.Talk.nameZhHantTw}';
        break;
      case 'sk':
        title = '${reviewData.Talk.nameEs}';
        break;
      case 'sl':
        title = '${reviewData.Talk.nameEs}';
        break;
      default:
        title = '${reviewData.Talk.name}';
        break;
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    double height = MediaQuery.of(context).size.height;
    return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
      String lang = provider.locale!.languageCode;
      return ScopedModelDescendant<DataUser>(
          builder: (context, child, userData) {
        return InkWell(
          onTap: () {
            Provider.of<VideoProvider>(context, listen: false)
                .setdataTalk(null);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) {
                  return ScopedModel(
                      model: userData,
                      child: NewPlayVideoScreenNormal(
                        false,
                        dataTalk: reviewData.convertToTalkData(),
                        percent: 1,
                        ytId: widget.ytId,
                        enablePop: true,
                      ));
                },
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.01),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FadeInImage.memoryNetwork(
                                height: 75,
                                width: 120,
                                fit: BoxFit.cover,
                                placeholder: kTransparentImage,
                                image:
                                    // URL_AVATAR_VIDEO + reviewData.picture,
                                    "https://img.youtube.com/vi/" +
                                        widget.ytId +
                                        "/maxresdefault.jpg",
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Container(
                                    width: 120,
                                    height: 75,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: (Image.asset(
                                            'assets/new_ui/more/defaut.png')),
                                      ),
                                    ),
                                  );
                                })),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  titleLanguage(lang) == 'null'
                                      ? titleLanguage('en')
                                      : titleLanguage(lang),
                                  overflow: TextOverflow.visible,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: themeProvider.mode == ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _nameEn,
                                  overflow: TextOverflow.visible,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: themeProvider.mode == ThemeMode.dark
                                        ? const Color.fromRGBO(92, 94, 99, 1)
                                        : Colors.black,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      widget.isHome
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: GestureDetector(
                                onTap: () {
                                  widget.onDeleteVideo();
                                },
                                child: Row(
                                  children: [
                                    // Spacer(),
                                    SvgPicture.asset(
                                      'assets/new_ui/more/Delete.svg',
                                      color:
                                          themeProvider.mode == ThemeMode.dark
                                              ? const Color.fromRGBO(
                                                  140, 141, 144, 1)
                                              : Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: const Divider(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    });
  }
}
