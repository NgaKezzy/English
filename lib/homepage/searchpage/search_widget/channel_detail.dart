import 'dart:io';

import 'package:app_learn_english/Providers/theme_provider.dart';

import 'package:app_learn_english/generated/l10n.dart';

import 'package:app_learn_english/homepage/searchpage/search_widget/item_render_video_result.dart';

import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class ChannelDetail extends StatefulWidget {
  final Function showSetting;
  Category? category;

  ChannelDetail({Key? key, required this.category, required this.showSetting});

  @override
  State<StatefulWidget> createState() {
    return _ChannelDetail(category: category, showSetting: showSetting);
  }
}

class _ChannelDetail extends State<ChannelDetail> {
  final Function showSetting;
  Category? category;

  _ChannelDetail({Key? key, required this.category, required this.showSetting});

  bool isActive = false;
  bool _isCheckActive = true;
  double h = -1;
  late int numberSub;
  late List<DataTalk> dataTalk;

  @override
  void initState() {
    numberSub = widget.category!.totalFollow;
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isCheckActive) {
      var localeProvider = context.read<LocaleProvider>();
      if (widget.category!.listTalk.isNotEmpty) {
        setState(() {
          dataTalk = widget.category!.listTalk;
        });
      } else {
        var listTalk = await TalkAPIs().getListTalkByCategoryId(
            widget.category!.id,
            page: 1,
            lang: localeProvider.locale?.languageCode ?? 'en');
        setState(() {
          dataTalk = listTalk;
        });
      }
      var check = await DataCache().getSubChannelHasData(widget.category!.id);
      isActive = check;
    }
    setState(() {
      _isCheckActive = false;
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    h == -1 ? h = (width * 9) / 16 : {};
    var URL_AVATAR_CATEGORY = Session().BASE_IMAGES + "images/cat_avatars/";
    return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
      String lang = provider.locale!.languageCode;
      return _isCheckActive
          ? const Scaffold(
              body: Center(
                child: PhoLoading(),
              ),
            )
          : Scaffold(
              backgroundColor: themeProvider.mode == ThemeMode.dark
                  ? const Color.fromRGBO(45, 48, 57, 1)
                  : Colors.white,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: themeProvider.mode == ThemeMode.dark
                    ? const Color.fromRGBO(45, 48, 57, 1)
                    : Colors.white,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: SvgPicture.asset(
                    'assets/new_ui/more/Iconly-Arrow-Left.svg',
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: InkWell(
                      child: IconButton(
                        icon: isActive
                            ? SvgPicture.asset(
                                'assets/new_ui/more/ic_heart.svg',
                                height: 25,
                              )
                            : Icon(
                                Icons.favorite_border,
                                color: themeProvider.mode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black,
                                size: 30,
                              ),
                        color: Colors.red,
                        onPressed: () => {
                          isActive
                              ? TalkAPIs()
                                  .unFollowDataSubChannel(
                                      DataCache().userCache!.uid,
                                      category!,
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
                                    Utils().showNotificationBottom(false,
                                        S.of(context).Cancellationfailed);
                                  }
                                  showSetting(context);
                                })
                              : TalkAPIs()
                                  .followDataSubChannel(
                                      DataCache().userCache!.uid,
                                      category!,
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
                                    Utils().showNotificationBottom(false,
                                        S.of(context).Thischannelissubscribed);
                                  }
                                  showSetting(context);
                                })
                        },
                      ),
                    ),
                  )
                ],
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Divider(
                        thickness: 1,
                        color: themeProvider.mode == ThemeMode.dark
                            ? Colors.grey.shade700
                            : const Color(0xFFE4E4E4),
                        height: 1),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.changeLanguageChannelName(
                              lang,
                              category!,
                            ),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: themeProvider.mode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage(
                              category!.picLink.isEmpty
                                  ? URL_AVATAR_CATEGORY + category!.picture
                                  : category!.picLink,
                            ),
                            backgroundColor: Colors.white,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: themeProvider.mode == ThemeMode.dark
                                    ? const Color.fromRGBO(24, 26, 33, 1)
                                    : Colors.white,
                              ),
                              padding: const EdgeInsets.only(top: 12),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: dataTalk.length > 0
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (category != null)
                                                // for (var talk in category!.listTalk)
                                                for (var i = 0;
                                                    i < dataTalk.length;
                                                    i++)
                                                  ItemVideoResult(
                                                    talkData: dataTalk[i],
                                                    type: category!.type,
                                                  )
                                              else
                                                Align(
                                                    child: Center(
                                                  child: Text(S
                                                      .of(context)
                                                      .NoCourseAvailable),
                                                )),
                                            ],
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                S.of(context).Video,
                                                style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: themeProvider.mode ==
                                                          ThemeMode.dark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 24,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                S
                                                    .of(context)
                                                    .ThereAreNoVideosInThisChannel,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: themeProvider.mode ==
                                                          ThemeMode.dark
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
    });
  }
}
