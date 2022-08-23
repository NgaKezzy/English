import 'dart:io';

import 'package:app_learn_english/Providers/theme_provider.dart';
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
import 'package:app_learn_english/utils/color_utils.dart';
import 'package:app_learn_english/utils/utils.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemChannelView extends StatefulWidget {
  final Function showSetting;
  Category channel;
  ItemChannelView({Key? key, required this.channel, required this.showSetting})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ItemChannelView(channel: channel, showSetting: showSetting);
  }
}

class _ItemChannelView extends State<ItemChannelView> {
  final Function showSetting;
  Category channel;
  _ItemChannelView(
      {Key? key, required this.channel, required this.showSetting});

  bool isActive = false;

  bool _isLoadingChannel = true;

  @override
  void didChangeDependencies() async {
    if (_isLoadingChannel) {
      var sub = await DataCache().getSubChannelHasData(channel.id);
      setState(() {
        isActive = sub;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    double width = MediaQuery.of(context).size.width;
    var URL_AVATAR_CATEGORY = Session().BASE_IMAGES + "images/cat_avatars/";
    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
        String lang = provider.locale!.languageCode;
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) {
                  return ScopedModel(
                      model: userData,
                      child: ChannelDetail(
                        category: channel,
                        showSetting: showSetting,
                      ));
                },
              ),
            );
          },
          child: Container(
            width: ResponsiveWidget.isSmallScreen(context)
                ? width / 1.1
                : width / 1.1,
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Stack(
                      children: [
                        const Center(
                          // child: Platform.isAndroid
                          //     ? CircularProgressIndicator()
                          //     : CupertinoActivityIndicator(),
                          child: PhoLoading(),
                        ),
                        Center(
                          child: FadeInImage.memoryNetwork(
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                            placeholder: kTransparentImage,
                            image: channel.picLink,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                height: 100,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    'assets/linh_vat/linhvat2.png',
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          channel.getNameByLanguage(
                                          provider.locale!.languageCode) ==
                                      'null' ||
                                  channel.getNameByLanguage(
                                          provider.locale!.languageCode) ==
                                      '' ||
                                  channel.getNameByLanguage(
                                          provider.locale!.languageCode) ==
                                      null
                              ? channel.name
                              : channel.getNameByLanguage(
                                  provider.locale!.languageCode),
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
                        channel.getDescriptionByLanguage(
                                    provider.locale!.languageCode) !=
                                ""
                            ? Text(
                                channel.getDescriptionByLanguage(
                                    provider.locale!.languageCode),
                                overflow: TextOverflow.visible,
                                maxLines: 1,
                                style: TextStyle(
                                  color: themeProvider.mode == ThemeMode.dark
                                      ? const Color.fromRGBO(157, 158, 161, 1)
                                      : ColorsUtils.Color_555555,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.left,
                              )
                            : const SizedBox(),
                        const SizedBox(height: 2),
                        Text(
                          S.of(context).NumberOfPeopleRegistered +
                              ': ' +
                              channel.totalFollow.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: themeProvider.mode == ThemeMode.dark
                                ? const Color.fromRGBO(157, 158, 161, 1)
                                : ColorsUtils.Color_555555,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    )),
                const SizedBox(
                  width: 10,
                ),
                Container(
                    width: 50,
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
                                showSetting(context);
                              })
                            : TalkAPIs()
                                .followDataSubChannel(
                                    DataCache().userCache!.uid, channel, lang)
                                .then((value) {
                                if (value == 1) {
                                  setState(() {
                                    isActive = true;
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
                                showSetting(context);
                              });
                      },
                      child: _isLoadingChannel
                          ? (isActive
                              ? Icon(
                                  Icons.done_rounded,
                                  size: 35,
                                  color: Colors.green.shade700,
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(20, 146, 247, 0.8),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                    vertical: 2,
                                  ),
                                  width: 500,
                                  height: 25,
                                  child: Align(
                                    child: Text(
                                      S.of(context).Add,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                ))
                          : const SizedBox(),
                    ))
              ],
            ),
          ),
        );
      });
    });
  }
}
