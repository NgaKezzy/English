import 'dart:io';

import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/searchpage/search_widget/channel_detail.dart';

import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/startpage/responsive_start_page.dart';
import 'package:app_learn_english/utils/utils.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemChannelFake extends StatefulWidget {
  Category channel;
  ItemChannelFake({Key? key, required this.channel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ItemChannelFake(channel: channel);
  }
}

class _ItemChannelFake extends State<ItemChannelFake> {
  Category channel;
  _ItemChannelFake({Key? key, required this.channel});

  bool isActive = false;
  bool _isLoadingChannel = true;
  late int numberSub;
  @override
  @override
  void didChangeDependencies() async {
    if (_isLoadingChannel) {
      bool sub = await DataCache().getSubChannelHasData(channel.id);
      setState(() {
        isActive = sub;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var URL_AVATAR_CATEGORY = Session().BASE_IMAGES + "images/cat_avatars/";
    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
        String lang = provider.locale!.languageCode;
        return InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) {
                  return ScopedModel(
                      model: userData,
                      child: ChannelDetail(
                        category: channel,
                        showSetting: () {},
                      ));
                },
              ),
            );
          },
          child: Container(
            height: 80,
            width: ResponsiveWidget.isSmallScreen(context)
                ? width / 1.1
                : width / 1.1,
            margin: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                // color: Colors.black.withOpacity(0.1),
                ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new Container(
                  width: 80,
                  height: 80,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
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
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  placeholder: kTransparentImage,
                                  image: URL_AVATAR_CATEGORY + channel.picture,
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Container(
                                      width: double.infinity,
                                      height: 100,
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: (Image.asset(
                                            'assets/linh_vat/linhvat2.png',
                                          ))),
                                    );
                                  }))
                        ],
                      )),
                ),
                SizedBox(width: 15),
                Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          channel
                              .getNameByLanguage(provider.locale!.languageCode),
                          overflow: TextOverflow.visible,
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 2),
                        channel.getDescriptionByLanguage(
                                    provider.locale!.languageCode) !=
                                ""
                            ? Text(
                                channel.getDescriptionByLanguage(
                                    provider.locale!.languageCode),
                                overflow: TextOverflow.visible,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.left,
                              )
                            : SizedBox(),
                        SizedBox(height: 2),
                        Text(
                          S.of(context).NumberOfPeopleRegistered +
                              ': ' +
                              numberSub.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    )),
                new Expanded(
                  child: InkWell(
                    onTap: () {
                      isActive
                          ? TalkAPIs()
                              .unFollowDataSubChannel(
                                  DataCache().userCache!.uid, channel, lang)
                              .then((value) {
                              if (value == 1) {
                                setState(() {
                                  isActive = false;
                                  numberSub--;
                                });
                                Utils().showNotificationBottom(
                                    true,
                                    S
                                        .of(context)
                                        .Unsubscribechannelsuccessfully);
                              } else {
                                Utils().showNotificationBottom(
                                    false, S.of(context).Cancellationfailed);
                              }
                            })
                          : TalkAPIs()
                              .followDataSubChannel(
                                  DataCache().userCache!.uid, channel, lang)
                              .then((value) {
                              if (value == 1) {
                                setState(() {
                                  isActive = true;
                                  numberSub++;
                                });

                                Utils().showNotificationBottom(
                                    true,
                                    S
                                        .of(context)
                                        .Successfulchannelregistration);
                              } else {
                                Utils().showNotificationBottom(false,
                                    S.of(context).Thischannelissubscribed);
                              }
                            });
                    },
                    child: _isLoadingChannel
                        ? (isActive
                            ? Icon(
                                Icons.done_rounded,
                                size: 35,
                                color: Colors.green.shade700,
                              )
                            : Icon(
                                Icons.add_box_outlined,
                                size: 35,
                                color: Colors.white,
                              ))
                        : Container(),
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
