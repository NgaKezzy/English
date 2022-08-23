import 'dart:io';

import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/Providers/video_provider.dart';
import 'package:app_learn_english/homepage/provider/statistical_provider.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/networks/TargetAPIs.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';

import 'package:app_learn_english/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';



class ItemTalkSubedView extends StatefulWidget {
  DataTalk talk;
  ItemTalkSubedView({Key? key, required this.talk});

  @override
  State<ItemTalkSubedView> createState() => _ItemTalkSubedViewState();
}

class _ItemTalkSubedViewState extends State<ItemTalkSubedView> {
  var URL_AVATAR_VIDEO = Session().BASE_IMAGES + "images/talk_avatars/";

  final URL_AVATAR_TEXT = Session().BASE_IMAGES + 'images/talk_text_avatars/';

 late String name;




  String titleLanguage(String languageCode) {
    String title;

    switch (languageCode) {
      case 'vi':
        title = '${widget.talk.name_vi}';
        break;
      case 'ru':
        title = '${widget.talk.name_ru}';
        break;
      case 'es':
        title = '${widget.talk.name_es}';
        break;
      case 'zh':
        title = '${widget.talk.name_zh}';
        break;
      case 'ja':
        title = '${widget.talk.name_ja}';
        break;
      case 'hi':
        title = '${widget.talk.name_hi}';
        break;
      case 'tr':
        title = '${widget.talk.name_tr}';
        break;
      case 'pt':
        title = '${widget.talk.name_pt}';
        break;
      case 'id':
        title = '${widget.talk.name_id}';
        break;
      case 'th':
        title = '${widget.talk.name_th}';
        break;
      case 'ms':
        title = '${widget.talk.name_ms}';
        break;
      case 'ar':
        title = '${widget.talk.name_ar}';
        break;
      case 'fr':
        title = '${widget.talk.name_fr}';
        break;
      case 'it':
        title = '${widget.talk.name_it}';
        break;
      case 'de':
        title = '${widget.talk.name_de}';
        break;
      case 'ko':
        title = '${widget.talk.name_ko}';
        break;
      case 'zh_Hant_TW':
        title = '${widget.talk.name_zh_Hant_TW}';
        break;
      case 'sk':
        title = '${widget.talk.name_sk}';
        break;
      case 'sl':
        title = '${widget.talk.name_sl}';
        break;
      default:
        title = '${widget.talk.name}';
        break;
    }
    return title;
  }

  @override
  void initState() {
    name= Utils.buildNameTalkWithRandomWord(widget.talk.name);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    double width = MediaQuery.of(context).size.width;
    return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
      String lang = provider.locale!.languageCode;
      return ScopedModelDescendant<DataUser>(
          builder: (context, child, userData) {
        return InkWell(
          onTap: () async {
            final videoProvider =
                Provider.of<VideoProvider>(context, listen: false);
            final statisticalProvider = Provider.of<StaticsticalProvider>(
              context,
              listen: false,
            );
            var username = DataCache().getUserData().username;
            var uid = DataCache().getUserData().uid;
            List<int> checkAddVideo = await TargetAPIs().updateWatchedVideo(
              isVip: widget.talk.isVip ? 1 : 0,
              uid: uid,
              username: username,
              videoId: widget.talk.id,
            );
            if (checkAddVideo.isNotEmpty) {
              statisticalProvider.updateTotalVideos(checkAddVideo[0]);
              statisticalProvider.updateTotalVideosVip(checkAddVideo[1]);
            }
            if (videoProvider.getdataTalk() != null) {
              videoProvider.setdataTalk(null);
            }

            Future.delayed(Duration(seconds: 0), () {
              videoProvider.setVal(true);
              videoProvider.setdataTalk(widget.talk);
              videoProvider.miniplayerController.animateToHeight(
                state: PanelState.MAX,
              );
            });
          },
          child: Container(
            height: 100,
            width: width,
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: widget.talk.picLink.isEmpty
                        ? "https://img.youtube.com/vi/" +
                            widget.talk.yt_id +
                            "/maxresdefault.jpg"
                        : widget.talk.picLink,
                    width: MediaQuery.of(context).size.width / 2.65,
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => Center(
                      // child: Platform.isAndroid
                      //     ? const CircularProgressIndicator()
                      //     : const CupertinoActivityIndicator(),
                      child: const PhoLoading(),
                    ),
                    errorWidget: (context, url, error) => CachedNetworkImage(
                      imageUrl: widget.talk.picLink.isEmpty
                          ? "https://img.youtube.com/vi/" +
                              widget.talk.yt_id +
                              "/sddefault.jpg"
                          : widget.talk.picLink,
                      width: MediaQuery.of(context).size.width / 2.65,
                      fit: BoxFit.fitWidth,
                      placeholder: (context, url) => Center(
                        child: const PhoLoading(),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/linh_vat/linhvat2.png',
                        width: MediaQuery.of(context).size.width / 2.65,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
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
                      const Spacer(),
                      Text(
                       name,
                        overflow: TextOverflow.visible,
                        maxLines: 1,
                        style: TextStyle(
                          color: themeProvider.mode == ThemeMode.dark
                              ? const Color.fromRGBO(105, 106, 111, 1)
                              : Colors.black,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
    });
  }
}
