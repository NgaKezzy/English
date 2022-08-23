import 'dart:io';

import 'package:app_learn_english/homepage/searchpage/search_channel.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/startpage/responsive_start_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemChannelGridViewWidget extends StatefulWidget {
  final Category category;
  const ItemChannelGridViewWidget({Key? key, required this.category})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ItemChannelGridViewWidget(category: category);
  }
}

class _ItemChannelGridViewWidget extends State<ItemChannelGridViewWidget> {
  Category category;
  _ItemChannelGridViewWidget({Key? key, required this.category});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    var URL_AVATAR_CATEGORY = Session().BASE_IMAGES + "images/cat_avatars/";
    return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchChannel()));
            },
            child: Row(
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
                                        child: (Image.asset(
                                          'assets/linh_vat/linhvat2.png',
                                          height: 50,
                                          width: 50,
                                        ))),
                                  );
                                }))
                      ],
                    )),
                Container(
                  height: ResponsiveWidget.isSmallScreen(context)
                      ? height / 10
                      : height / 5,
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category
                            .getNameByLanguage(provider.locale!.languageCode),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(category.getDescriptionByLanguage(
                          provider.locale!.languageCode)),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${category.totalFollow}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
