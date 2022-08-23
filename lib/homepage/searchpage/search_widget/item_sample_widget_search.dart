import 'dart:io';

import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/screens/new_play_video_screen_max.dart';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemSampleSearchWidget extends StatefulWidget {
  final DataTalk talkData;

  const ItemSampleSearchWidget({Key? key, required this.talkData})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ItemSampleSearchWidget(talkData: talkData);
  }
}

class _ItemSampleSearchWidget extends State<ItemSampleSearchWidget> {
  DataTalk talkData;
  var URL_AVATAR_VIDEO = Session().BASE_IMAGES + "images/talk_avatars/";
  final URL_AVATAR_TEXT = Session().BASE_IMAGES + 'images/talk_text_avatars/';

  _ItemSampleSearchWidget({Key? key, required this.talkData});
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      return Container(
        margin: EdgeInsets.only(
          top: 8,
          bottom: 8,
        ),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // add this
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) {
                            return ScopedModel(
                                model: userData,
                                child: NewPlayVideoScreenNormal(
                                  false,
                                  dataTalk: talkData,
                                  percent: 1,
                                  ytId: '',
                                  enablePop: true,
                                ));
                          },
                        ),
                      );
                    },
                    child: Stack(
                      children: <Widget>[
                        Center(
                          // child: Platform.isAndroid
                          //     ? CircularProgressIndicator()
                          //     : CupertinoActivityIndicator(),
                          child: const PhoLoading(),
                        ),
                        Center(
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: const PhoLoading(),
                              ),
                              Center(
                                child: FadeInImage.memoryNetwork(
                                    height: 160,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: kTransparentImage,
                                    image: talkData.picLink.isEmpty
                                        ?
                                        // URL_AVATAR_VIDEO + talkData.picture,
                                        "https://img.youtube.com/vi/" +
                                            talkData.yt_id +
                                            "/sddefault.jpg"
                                        : talkData.picLink,
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Container(
                                        width: double.infinity,
                                        height: 160,
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: (Image.asset(
                                              'assets/linh_vat/linhvat2.png',
                                            ))),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  height: 60,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        talkData.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Icon(Icons.favorite_border,
                                    color: Colors.red[600]),
                                Text(talkData.totalSub.toString())
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            child: Row(
                              children: [
                                Icon(Icons.thumb_up_alt_outlined,
                                    // Icons
                                    //     .thumb_up_alt_rounded,
                                    color: Colors.blue[600]),
                                Text(talkData.totalLike.toString())
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
