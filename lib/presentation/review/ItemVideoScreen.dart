import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/Providers/video_provider.dart';
import 'package:app_learn_english/dialog/dialog_action_review.dart';
import 'package:app_learn_english/dialog/dialog_notification.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/models/VideoReviewModel.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/presentation/notification/service/notification_service.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/screens/new_play_video_screen_max.dart';
import 'package:app_learn_english/startpage/responsive_start_page.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemVideoWidget extends StatefulWidget {
  final VideoReview reviewData;
  final VoidCallback onClickDeleteItem;
  final bool isNotHistory;

  const ItemVideoWidget(
      {Key? key,
      required this.reviewData,
      required this.onClickDeleteItem,
      required this.isNotHistory})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ItemVideoWidget(reviewData: reviewData);
  }
}

class _ItemVideoWidget extends State<ItemVideoWidget> {
  VideoReview reviewData;
  var URL_AVATAR_VIDEO = Session().BASE_IMAGES + "images/talk_avatars/";
  final URL_AVATAR_TEXT = Session().BASE_IMAGES + 'images/talk_text_avatars/';
  late String _nameVideo;

  _ItemVideoWidget({Key? key, required this.reviewData});

  String titleLanguage(String languageCode) {
    String title;

    switch (languageCode) {
      case 'vi':
        title = '${reviewData.name_vi}';
        break;
      case 'ru':
        title = '${reviewData.name_ru}';
        break;
      case 'es':
        title = '${reviewData.name_es}';
        break;
      case 'zh':
        title = '${reviewData.name_zh}';
        break;
      case 'ja':
        title = '${reviewData.name_ja}';
        break;
      case 'hi':
        title = '${reviewData.name_hi}';
        break;
      case 'tr':
        title = '${reviewData.name_tr}';
        break;
      case 'pt':
        title = '${reviewData.name_pt}';
        break;
      case 'id':
        title = '${reviewData.name_id}';
        break;
      case 'th':
        title = '${reviewData.name_th}';
        break;
      case 'ms':
        title = '${reviewData.name_ms}';
        break;
      case 'ar':
        title = '${reviewData.name_ar}';
        break;
      case 'fr':
        title = '${reviewData.name_fr}';
        break;
      case 'it':
        title = '${reviewData.name_it}';
        break;
      case 'de':
        title = '${reviewData.name_de}';
        break;
      case 'ko':
        title = '${reviewData.name_ko}';
        break;
      case 'zh_Hant_TW':
        title = '${reviewData.name_zh_Hant_TW}';
        break;
      case 'sk':
        title = '${reviewData.name_sk}';
        break;
      case 'sl':
        title = '${reviewData.name_sl}';
        break;
      default:
        title = '${reviewData.name}';
        break;
    }
    return title;
  }

  @override
  void initState() {
    _nameVideo = Utils.buildNameTalkWithRandomWord(widget.reviewData.name);
    // TODO: implement initState
    super.initState();
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
                        ytId: '',
                        enablePop: true,
                      ));
                },
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.01),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: reviewData.picLink.isEmpty
                              ? "https://img.youtube.com/vi/" +
                                  reviewData.yt_id +
                                  "/sddefault.jpg"
                              : reviewData.picture,
                          placeholder: (context, url) =>
                              Center(child: const PhoLoading()),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/new_ui/home/mac_dinh_speak.png',
                            height: ResponsiveWidget.isSmallScreen(context)
                                ? height / 6
                                : height / 5,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                          width: 150,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleLanguage(lang) == 'null'
                            ? titleLanguage('en')
                            : titleLanguage(lang),
                        overflow: TextOverflow.visible,
                        maxLines: 1,
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
                        _nameVideo,
                        overflow: TextOverflow.visible,
                        maxLines: 2,
                        style: TextStyle(
                          color: themeProvider.mode == ThemeMode.dark
                              ? const Color.fromRGBO(92, 94, 99, 1)
                              : Colors.black,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 10),
                      widget.isNotHistory
                          ? InkWell(
                              // click show dialog setting
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DialogActionReview(
                                        onClickSetTimeNotification: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return DialogNotification(
                                                  talkData: reviewData
                                                      .convertToTalkData(),
                                                  hourNotifi:
                                                      reviewData.hourNoti,
                                                );
                                              });
                                        },
                                        onClickCancelNotification: () {
                                          NotificationService()
                                              .cancelNotification(
                                                  reviewData.uid);
                                        },
                                        onClickDeleteVideo: () {
                                          widget.onClickDeleteItem();
                                        },
                                      );
                                    });
                              },
                              child: Container(
                                width: 50,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: const Center(
                                  child: Icon(Icons.notifications_active),
                                ),
                              ),
                            )
                          : const SizedBox(),
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
