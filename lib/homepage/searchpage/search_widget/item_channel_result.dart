import 'dart:io';

import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/homepage/searchpage/search_widget/channel_detail.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemChannelResult extends StatefulWidget {
  final Category category;
  final List<Category> categoryIndex;
  const ItemChannelResult(
      {Key? key, required this.category, required this.categoryIndex})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ItemChannelResult(category: category, categoryIndex: categoryIndex);
  }
}

class _ItemChannelResult extends State<ItemChannelResult> {
  Category category;
  List<Category> categoryIndex;
  _ItemChannelResult(
      {Key? key, required this.category, required this.categoryIndex});
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var checklist = category;
    var URL_AVATAR_CATEGORY = Session().BASE_IMAGES + "images/cat_avatars/";
    for (var i = 0; i < categoryIndex.length; i++) {
      if (category.name == categoryIndex[i].name) checklist = categoryIndex[i];
    }

    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 20),
          margin: EdgeInsets.only(top: 5, bottom: 5),
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
                              category: checklist,
                              showSetting: () {},
                            ));
                      },
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
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
                                    height: 70,
                                    width: 70,
                                    fit: BoxFit.cover,
                                    placeholder: kTransparentImage,
                                    image:
                                        URL_AVATAR_CATEGORY + category.picture,
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Container(
                                        width: double.infinity,
                                        height: 70,
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: (Image.asset(
                                              'assets/linh_vat/linhvat2.png',
                                            ))),
                                      );
                                    }))
                          ],
                        )),
                    Container(
                      width: 225,
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
                            category.getDescriptionByLanguage(
                                provider.locale!.languageCode),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: themeProvider.mode == ThemeMode.dark
                                    ? Color.fromRGBO(157, 158, 161, 1)
                                    : Colors.black),
                          ),
                        ],
                      ),
                    ),
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
