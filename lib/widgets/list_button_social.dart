import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/dialog/dialog_notification.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/DataOffline.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tiengviet/tiengviet.dart';

// list share
class ListButtonSocial extends StatefulWidget {
  final DataTalk talkData;

  const ListButtonSocial({Key? key, required this.talkData}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListButtonSocial(talkData: talkData);
  }
}

enum UniLinksType { string, uri }

class _ListButtonSocial extends State<ListButtonSocial> {
  DataTalk talkData;
  bool isLiked = false;
  bool isReview = false;

  _ListButtonSocial({Key? key, required this.talkData});

  @override
  void initState() {
    DataCache()
        .getTalkLikeStatus(DataCache().userCache!.uid, widget.talkData.id)
        .then((value) {
      setState(() {
        isLiked = value;
      });
    });

    DataCache().checkReviewVideo(widget.talkData).then((value) {
      setState(() {
        isReview = value;
      });
    });
    super.initState();
  }

  String createLinkShare() {
    String convertVi = TiengViet.parse(talkData.name);
    List<String> convertArr = convertVi.trim().split(" ");

    String linkShare =
        "https://phoenglish.com/share/video/${talkData.id}?vid=${talkData.id}&title=" +
            convertArr.join("-");

    return linkShare;
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Consumer<LocaleProvider>(
      builder: (context, provider, snapshot) {
        String lang = provider.locale!.languageCode;
        return Container(
          color: themeProvider.mode == ThemeMode.dark
              ? const Color.fromRGBO(24, 26, 33, 1)
              : Colors.white,
          child: Row(
            children: [
              InkWell(
                onTap: () async {
                  await Share.share(createLinkShare());
                },
                child: Container(
                  width: 45,
                  height: 45,
                  child: Card(
                    elevation: 5,
                    child: SvgPicture.asset(
                      'assets/new_ui/more/share.svg',
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fit: BoxFit.scaleDown,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(
                        color: Colors.white,
                        width: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  TalkAPIs().fetchReviewVideoData(
                    userData: DataCache().getUserData(),
                  );
                  if (isReview) {
                    TalkAPIs()
                        .destroyVideoCourse(
                            DataCache().userCache!.uid.toString(),
                            widget.talkData.id.toString(),
                            widget.talkData.catelog_id.toString())
                        .then((value) {
                      setState(() {
                        isReview = false;
                      });
                      Utils().showNotificationBottom(
                          true, S.of(context).Successfulvideodisliking);
                    });
                  } else {
                    DataOffline().saveIDDataTalk("uidDataTalk", talkData.id);
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return DialogNotification(
                            talkData: talkData,
                          );
                        }).then(
                      (value) {
                        TalkAPIs()
                            .addVideoCourse(
                                DataCache().userCache!.uid.toString(),
                                widget.talkData.id.toString(),
                                lang,
                                value != null ? formatTimeOfDay(value) : "0")
                            .then(
                          (value) {
                            if (value == 1) {
                              Utils().showNotificationBottom(true,
                                  S.of(context).installSuccessfulNotification);
                              setState(() {
                                isReview = true;
                              });
                            } else if (value == 0) {
                              Utils().showNotificationBottom(
                                  false, S.of(context).AddVideoFailed);
                            } else if (value == -1) {
                              Utils().showNotificationBottom(
                                  false, S.of(context).Videocannotadd);
                            }
                          },
                        );
                      },
                    );
                  }
                },
                child: Container(
                  width: 45,
                  height: 45,
                  child: Card(
                    elevation: 5,
                    // color: isReview
                    //     ? Color.fromRGBO(133, 82, 253, 5)
                    //     : themeProvider.mode == ThemeMode.dark
                    //         ? Color.fromRGBO(24, 26, 33, 1)
                    //         : Colors.white,
                    child: SvgPicture.asset(
                      'assets/new_ui/more/bookmark.svg',
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fit: BoxFit.scaleDown,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(
                        color: Colors.white,
                        width: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  isLiked
                      ? TalkAPIs()
                          .unLikeTalk(
                          uid: DataCache().userCache!.uid,
                          talkId: widget.talkData.id,
                          languageCode: lang,
                        )
                          .then((value) {
                          if (value == 1) {
                            setState(() {
                              Utils().showNotificationBottom(
                                  false,
                                  S.of(context).Disliked +
                                      widget.talkData.name);

                              widget.talkData.totalLike--;
                              widget.talkData.totalLike < 0
                                  ? widget.talkData.totalLike = 0
                                  : {};
                              isLiked = false;
                            });
                          }
                        })
                      : TalkAPIs()
                          .likeTalk(
                          uid: DataCache().userCache!.uid,
                          talkId: widget.talkData.id,
                          languageCode: lang,
                        )
                          .then(
                          (value) {
                            if (value == 1) {
                              setState(() {
                                Utils().showNotificationBottom(
                                    true,
                                    S.of(context).Youlikedtheconversation +
                                        widget.talkData.name);
                                widget.talkData.totalLike++;
                                isLiked = true;
                              });
                            }
                          },
                        );
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 45,
                  width: 110,
                  child: Card(
                    elevation: 5,
                    // color: isLiked ? Color.fromRGBO(133, 82, 253, 1) : Color.fromRGBO(24, 26, 33, 1),
                    // color: themeProvider.mode == ThemeMode.dark
                    //     ? Color.fromRGBO(24, 26, 33, 1)
                    //     : Colors.white ; isLiked ? Color.fromRGBO(133, 82, 253, 1) : Color.fromRGBO(24, 26, 33, 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      // child: Row(
                      //   children: [
                      //     isLiked
                      //         // ? SvgPicture.asset(
                      //         //     'assets/new_ui/more/like_2.svg',
                      //         //   )
                      //         ? Lottie.asset(
                      //             'assets/new_ui/animation_lottie/like.json',
                      //             width: 50,
                      //           )
                      //         : SvgPicture.asset(
                      //             'assets/new_ui/more/like_1.svg',
                      //             color: themeProvider.mode == ThemeMode.dark
                      //                 ? Colors.white
                      //                 : Colors.black,
                      //           ),
                      //     // Icon(
                      //     //   Icons.thumb_up_alt,
                      //     //   color: isLiked ? Colors.white : Colors.black54,
                      //     //   size: 23,
                      //     // ),
                      //     const SizedBox(
                      //       width: 17,
                      //     ),
                      //     Text(
                      //       talkData.totalLike.toString(),
                      //       style: TextStyle(
                      //         // color: isLiked ? Color.fromRGBO(133, 82, 253, 1) : Colors.black54,
                      //         // color: themeProvider.mode == ThemeMode.dark
                      //         //     ? Colors.white
                      //         //     : Colors.black54,
                      //         color: isLiked
                      //             ? Color.fromRGBO(133, 82, 253, 1)
                      //             : themeProvider.mode == ThemeMode.dark
                      //                 ? Colors.white
                      //                 : Colors.black,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      child: Stack(
                        children: [
                          isLiked
                              // ? SvgPicture.asset(
                              //     'assets/new_ui/more/like_2.svg',
                              //   )
                              ? Positioned(
                                  child: Lottie.asset(
                                    'assets/new_ui/animation_lottie/like.json',
                                    height: 65,
                                    repeat: false,
                                  ),
                                  left: -20,
                                  top: -17,
                                )
                              : Positioned(
                                  child: SvgPicture.asset(
                                    'assets/new_ui/more/like_1.svg',
                                    color: themeProvider.mode == ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  bottom: 9,
                                ),
                          // Icon(
                          //   Icons.thumb_up_alt,
                          //   color: isLiked ? Colors.white : Colors.black54,
                          //   size: 23,
                          // ),
                          // const SizedBox(
                          //   width: 17,
                          // ),
                          Positioned(
                            child: Text(
                              talkData.totalLike.toString(),
                              style: TextStyle(
                                // color: isLiked ? Color.fromRGBO(133, 82, 253, 1) : Colors.black54,
                                // color: themeProvider.mode == ThemeMode.dark
                                //     ? Colors.white
                                //     : Colors.black54,
                                color: isLiked
                                    ? Color.fromRGBO(27, 104, 255, 1)
                                    : themeProvider.mode == ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            top: 10,
                            left: 35,
                          ),
                        ],
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        color: Colors.white,
                        width: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute, 00);
    final format = DateFormat.jm();
    return format.format(dt);
  }
}
