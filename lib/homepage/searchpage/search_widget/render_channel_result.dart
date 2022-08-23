import 'dart:io';

import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/searchpage/search_widget/item_channel_widget_search.dart';

import 'package:app_learn_english/homepage/searchpage/search_widget/item_render_video_result.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:app_learn_english/startpage/responsive_start_page.dart';

import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class RenderVideoResult extends StatefulWidget {
  final Function showSetting;
  Category category;
  RenderVideoResult(
      {Key? key, required this.category, required this.showSetting});
  @override
  State<StatefulWidget> createState() {
    return _RenderVideoResult(category: category, showSetting: showSetting);
  }
}

class _RenderVideoResult extends State<RenderVideoResult> {
  final Function showSetting;
  Category category;
  _RenderVideoResult(
      {Key? key, required this.category, required this.showSetting});

  bool isActive = false;
  @override
  void initState() {
    DataCache().getSubChannelHasData(category.id).then((value) {
      setState(() {
        isActive = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var URL_AVATAR_CATEGORY = Session().BASE_IMAGES + "images/cat_avatars/";
    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
        String lang = provider.locale!.languageCode;
        return Scaffold(
            body: Container(
                decoration: BoxDecoration(
                  // image: DecorationImage(
                  //   image: AssetImage('assets/images/background.png'),
                  //   fit: BoxFit.cover,
                  // ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blue.shade700,
                      Colors.tealAccent.shade400,
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () => {
                              Navigator.pop(context),
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                          Container(
                            width: ResponsiveWidget.isSmallScreen(context)
                                ? width / 1.3
                                : width / 1.1,
                            child: Text(
                              category.getNameByLanguage(
                                  provider.locale!.languageCode),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                          height: ResponsiveWidget.isSmallScreen(context)
                              ? height / 1.1
                              : height / 1.1,
                          width: width,
                          child: ListView(padding: EdgeInsets.zero, children: [
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              width: width,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 0.2,
                                    color: Colors.black,
                                  ),
                                  color: Colors.white.withOpacity(1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: ClipOval(
                                        clipper: MyClipper(),
                                        child: Stack(
                                          children: <Widget>[
                                            Center(
                                              // child: Platform.isAndroid
                                              //     ? CircularProgressIndicator()
                                              //     : CupertinoActivityIndicator(),
                                              child: const PhoLoading(),
                                            ),
                                            Center(
                                                child:
                                                    FadeInImage.memoryNetwork(
                                                        height: 100,
                                                        width: 100,
                                                        fit: BoxFit.cover,
                                                        placeholder:
                                                            kTransparentImage,
                                                        image:
                                                            URL_AVATAR_CATEGORY +
                                                                category
                                                                    .picture,
                                                        imageErrorBuilder:
                                                            (context, error,
                                                                stackTrace) {
                                                          return Container(
                                                            width:
                                                                double.infinity,
                                                            height: 100,
                                                            child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: (Image
                                                                    .asset(
                                                                  'assets/linh_vat/linhvat2.png',
                                                                ))),
                                                          );
                                                        }))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    category.getNameByLanguage(
                                        provider.locale!.languageCode),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    category.getDescriptionByLanguage(
                                        provider.locale!.languageCode),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              category.totalFollow.toString() +
                                                  ' ' +
                                                  S
                                                      .of(context)
                                                      .NumberOfPeopleRegistered,
                                              style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                fontWeight: FontWeight.w300,
                                                fontSize: 16,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              category.totalTalk.toString() +
                                                  ' ' +
                                                  S.of(context).SampleSentences,
                                              style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                fontWeight: FontWeight.w300,
                                                fontSize: 16,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: () => {
                                            isActive
                                                ? TalkAPIs()
                                                    .unFollowDataSubChannel(
                                                        DataCache()
                                                            .userCache!
                                                            .uid,
                                                        category,
                                                        lang)
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
                                                          false,
                                                          S
                                                              .of(context)
                                                              .Cancellationfailed);
                                                    }
                                                    showSetting(context);
                                                  })
                                                : TalkAPIs()
                                                    .followDataSubChannel(
                                                        DataCache()
                                                            .userCache!
                                                            .uid,
                                                        category,
                                                        lang)
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
                                                      Utils().showNotificationBottom(
                                                          false,
                                                          S
                                                              .of(context)
                                                              .Thischannelissubscribed);
                                                    }
                                                    showSetting(context);
                                                  })
                                          },
                                          child: Text(
                                            isActive
                                                ? S.of(context).Unsubscribe
                                                : S.of(context).Subscribe,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              S.of(context).Video,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            for (var talk in category.listTalk)
                              ScopedModel(
                                  model: userData,
                                  child: ItemVideoResult(
                                    talkData: talk,
                                    type: category.type,
                                  )),
                          ])),
                    ],
                  ),
                )));
      });
    });
  }
}
