import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/Providers/video_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/searchpage/search_widget/channel_detail.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/utils/color_utils.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';

import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemChanelNew extends StatefulWidget {
  final double percent;
  final Category category;
  ItemChanelNew({
    Key? key,
    required this.percent,
    required this.category,
  }) : super(key: key);

  @override
  _ItemChanelNewState createState() => _ItemChanelNewState();
}

class _ItemChanelNewState extends State<ItemChanelNew> {
  var URL_AVATAR_CATEGORY = Session().BASE_IMAGES + "images/cat_avatars/";
  bool isActive = false;
  bool _isLoadingChannel = true;

  late int numberSub;

  @override
  void initState() {
    numberSub = widget.category.totalFollow;
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isLoadingChannel) {
      bool sub = await DataCache().getSubChannelHasData(widget.category.id);
      setState(() {
        isActive = sub;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Consumer<LocaleProvider>(
      builder: (context, provider, snapshot) {
        String lang = provider.locale!.languageCode;
        return InkWell(
          onTap: () {
            Provider.of<VideoProvider>(context, listen: false)
                .setdataTalk(null);
            Provider.of<VideoProvider>(context, listen: false)
                .miniplayerController
                .animateToHeight(state: PanelState.MIN);
            DataUser user = DataCache().getUserData();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) {
                  return ScopedModel(
                      model: user,
                      child: ChannelDetail(
                        category: widget.category,
                        showSetting: () {},
                      ));
                },
              ),
            );
          },
          child: Consumer<LocaleProvider>(
            builder: (context, provider, child) => Container(
              color: themeProvider.mode == ThemeMode.dark
                  ? const Color.fromRGBO(24, 26, 33, 1)
                  : Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  color: themeProvider.mode == ThemeMode.dark
                      ? const Color.fromRGBO(42, 44, 50, 1)
                      : Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: themeProvider.mode == ThemeMode.dark
                            ? Colors.black
                            : ColorsUtils.Color_64D4DF,
                        width: 0.6,
                      )),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10 * widget.percent),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Stack(
                                    children: <Widget>[
                                      Center(
                                        child: FadeInImage.memoryNetwork(
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                          placeholder: kTransparentImage,
                                          image: URL_AVATAR_CATEGORY +
                                              widget.category.picture,
                                          imageErrorBuilder:
                                              (context, error, stackTrace) {
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
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10 * widget.percent,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: AutoSizeText(
                                        widget.category.getNameByLanguage(
                                            provider.locale!.languageCode),
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: themeProvider.mode ==
                                                  ThemeMode.dark
                                              ? Colors.white
                                              : Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Container(
                                      child: AutoSizeText(
                                        '${S.of(context).NumberOfPeopleRegistered}:${numberSub + 1000}',
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                        ),
                                        // overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            isActive
                                ? TalkAPIs()
                                    .unFollowDataSubChannel(
                                        DataCache().userCache!.uid,
                                        widget.category,
                                        lang)
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
                                          false,
                                          S
                                              .of(context)
                                              .Unsubscribechannelsuccessfully
                                          // S.of(context).Cancellationfailed
                                          );
                                    }
                                  })
                                : TalkAPIs()
                                    .followDataSubChannel(
                                        DataCache().userCache!.uid,
                                        widget.category,
                                        lang)
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
                                      Utils().showNotificationBottom(
                                          false,
                                          S
                                              .of(context)
                                              .Thischannelissubscribed);
                                    }
                                  });
                          },
                          child: Card(
                            elevation: 0,
                            color: _isLoadingChannel
                                ? (isActive
                                    ? Colors.blue[400]
                                    : Colors.transparent)
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.blue[400]!,
                                width: 1 * widget.percent,
                              ),
                              borderRadius:
                                  BorderRadius.circular(5 * widget.percent),
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5 * widget.percent,
                                vertical: 5 * widget.percent,
                              ),
                              child: _isLoadingChannel
                                  ? (isActive
                                      ? Align(
                                          alignment: Alignment.center,
                                          child: AutoSizeText(
                                            S.of(context).SubscribedChannel,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        )
                                      : Row(
                                          children: [
                                            Icon(
                                              Icons.add_rounded,
                                              size: 15 * widget.percent,
                                              color: Colors.blue[400],
                                            ),
                                            SizedBox(
                                              width: 5 * widget.percent,
                                            ),
                                            AutoSizeText(
                                              S.of(context).Register,
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Colors.blue[400],
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ))
                                  : Row(
                                      children: [
                                        Icon(
                                          Icons.add_rounded,
                                          size: 15 * widget.percent,
                                          color: Colors.blue[400],
                                        ),
                                        SizedBox(
                                          width: 5 * widget.percent,
                                        ),
                                        AutoSizeText(
                                          S.of(context).Register,
                                          style: TextStyle(
                                            color: Colors.blue[400],
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
