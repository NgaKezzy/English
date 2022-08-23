import 'dart:io';

import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/searchpage/search_widget/channel_detail.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemChannelSearchWidget extends StatefulWidget {
  final Category category;
  const ItemChannelSearchWidget({Key? key, required this.category})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ItemChannelSearchWidget(category: category);
  }
}

class MyClipper extends CustomClipper<Rect> {
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, 100, 100);
    // return Rect.f
  }

  bool shouldReclip(oldClipper) {
    return true;
  }
}

class _ItemChannelSearchWidget extends State<ItemChannelSearchWidget> {
  Category category;
  _ItemChannelSearchWidget({Key? key, required this.category});
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    double width = MediaQuery.of(context).size.width;
    var URL_AVATAR_CATEGORY = Session().BASE_IMAGES + "images/cat_avatars/";
    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
        return Container(
          height: 100,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return ScopedModel(
                          model: userData,
                          child: ChannelDetail(
                            category: widget.category,
                            showSetting: () {},
                          ),
                        );
                      },
                    ),
                  );
                },
                child: Row(
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
                                child: FadeInImage.memoryNetwork(
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  placeholder: kTransparentImage,
                                  image: URL_AVATAR_CATEGORY + category.picture,
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
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      // flex: 3,
                      child: Container(
                        height: 100,
                        margin: EdgeInsets.only(left: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.getNameByLanguage(
                                  provider.locale!.languageCode),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              S.of(context).NumberOfFollowers +
                                  ': ${category.totalFollow}',
                              style: TextStyle(
                                color: themeProvider.mode == ThemeMode.dark
                                    ? Color.fromRGBO(157, 158, 161, 1)
                                    : Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              category.getDescriptionByLanguage(
                                  provider.locale!.languageCode),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}
