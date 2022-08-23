import 'dart:io';

import 'package:app_learn_english/homepage/searchpage/search_widget/channel_detail.dart';

import 'package:app_learn_english/models/CateFollowModel.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemSubedView extends StatefulWidget {
  final Function showSetting;
  Category category;
  List<Category> categoryIndex;
  ItemSubedView(
      {Key? key,
      required this.category,
      required this.categoryIndex,
      required this.showSetting});
  @override
  State<StatefulWidget> createState() {
    return _ItemSubedView(
        category: category,
        categoryIndex: categoryIndex,
        showSetting: showSetting);
  }
}

class _ItemSubedView extends State<ItemSubedView> {
  final Function showSetting;
  Category category;
  List<Category> categoryIndex;
  _ItemSubedView(
      {Key? key,
      required this.category,
      required this.categoryIndex,
      required this.showSetting});
  Category convertToCategory(CateFollow cateFollow) {
    Category category = new Category(
        id: cateFollow.id,
        name: cateFollow.name,
        name_vi: cateFollow.name_vi,
        name_zh: cateFollow.name_zh,
        name_ja: cateFollow.name_ja,
        name_hi: cateFollow.name_hi,
        name_es: cateFollow.name_es,
        name_ru: cateFollow.name_ru,
        name_tr: cateFollow.name_tr,
        name_pt: cateFollow.name_pt,
        name_id: cateFollow.name_id,
        name_th: cateFollow.name_th,
        name_ms: cateFollow.name_ms,
        name_ar: cateFollow.name_ar,
        name_fr: cateFollow.name_fr,
        name_it: cateFollow.name_it,
        name_de: cateFollow.name_de,
        name_ko: cateFollow.name_ko,
        name_zh_Hant_TW: cateFollow.name_zh_Hant_TW,
        name_sk: cateFollow.name_sk,
        name_sl: cateFollow.name_sl,
        description: cateFollow.description,
        description_vi: cateFollow.description_vi,
        description_zh: cateFollow.description_zh,
        description_ja: cateFollow.description_ja,
        description_hi: cateFollow.description_hi,
        description_es: cateFollow.description_es,
        description_ru: cateFollow.description_ru,
        description_tr: cateFollow.description_tr,
        description_pt: cateFollow.description_pt,
        description_id: cateFollow.description_id,
        description_th: cateFollow.description_th,
        description_ms: cateFollow.description_ms,
        description_ar: cateFollow.description_ar,
        description_fr: cateFollow.description_fr,
        description_it: cateFollow.description_it,
        description_de: cateFollow.description_de,
        description_ko: cateFollow.description_ko,
        description_zh_Hant_TW: cateFollow.description_zh_Hant_TW,
        description_sk: cateFollow.description_sk,
        description_sl: cateFollow.description_sl,
        parentId: cateFollow.parentId,
        slug: cateFollow.slug,
        picture: cateFollow.picture,
        start: cateFollow.start,
        totalFollow: cateFollow.totalFollow,
        totalTalk: cateFollow.totalTalk,
        type: cateFollow.type,
        isActive: cateFollow.isActive,
        listTalk: [],
        listChannel: [],
        listCourse: [],
        picLink: '');
    categoryIndex.forEach((element) {
      if (element.id == category.id) {
        category.listTalk = element.listTalk;
        category.listChannel = element.listChannel;
        category.listCourse = element.listCourse;
      }
    });
    return category;
  }

  late final Future _fetchChannel;
  @override
  void initState() {
    _fetchChannel = TalkAPIs().getCategoryById(
      categoryId: category.id,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var URL_AVATAR_CATEGORY = Session().BASE_IMAGES + "images/cat_avatars/";
    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
        return InkWell(
          onTap: () async {
            Category? cate = await TalkAPIs().getCategoryById(
              categoryId: category.id,
            );
            if (cate != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) {
                    return ScopedModel(
                      model: userData,
                      child: ChannelDetail(
                        category: cate,
                        showSetting: showSetting,
                      ),
                    );
                  },
                ),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.only(right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    imageUrl: URL_AVATAR_CATEGORY + category.picture,
                    height: 75,
                    width: 75,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/linh_vat/linhvat2.png',
                      height: 75,
                      width: 75,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 75,
                  child: Text(
                    category.getNameByLanguage(provider.locale!.languageCode) ==
                                'null' ||
                            category.getNameByLanguage(
                                    provider.locale!.languageCode) ==
                                '' ||
                            category.getNameByLanguage(
                                    provider.locale!.languageCode) ==
                                null
                        ? category.name
                        : category
                            .getNameByLanguage(provider.locale!.languageCode),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color.fromRGBO(128, 128, 128, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
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
