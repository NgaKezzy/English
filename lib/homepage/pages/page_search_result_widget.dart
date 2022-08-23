import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/searchpage/search_widget/categories_widget_search_result.dart';
import 'package:app_learn_english/homepage/searchpage/search_widget/channel_widget_search_result.dart';
import 'package:app_learn_english/homepage/searchpage/search_widget/item_render_video_result.dart';
import 'package:app_learn_english/models/DataSearchIndexModel.dart';
import 'package:app_learn_english/models/DataSearchResultModel.dart';
import 'package:flutter/material.dart';

class PageSearchResult extends StatelessWidget {
  final DataSearchModel dataSearchModel;
  final DataSearchIndex dataSearchIndex;
  PageSearchResult({
    Key? key,
    required this.dataSearchModel,
    required this.dataSearchIndex,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListView(padding: EdgeInsets.zero, children: [
      Container(
          color: Color.fromRGBO(24, 26, 33, 1),
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          width: width,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (dataSearchModel.dataCategory.length > 0)
                  CategoriesSearchRedult(
                    listCategory: dataSearchModel.dataCategory,
                    listCategoryIndex: dataSearchIndex.dataCatgory,
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (dataSearchModel.dataChannel.length > 0)
                  ChannelSearchResult(
                      listChannel: dataSearchModel.dataChannel,
                      listChannelIndex: dataSearchIndex.dataChannel),
                if (dataSearchModel.dataTalk.length > 0)
                  for (int i = 0; i < dataSearchModel.dataTalk.length; i++)
                    ItemVideoResult(
                        talkData: dataSearchModel.dataTalk[i], type: 1),

                if (dataSearchModel.dataCategory.length == 0 &&
                    dataSearchModel.dataChannel.length == 0 &&
                    dataSearchModel.dataTalk.length == 0)
                  Center(
                    child: Text(S.of(context).NotFound),
                  ),
                // SizedBox(
                //   height: 10,
                // ),
                // if (dataSearchModel.dataChannel.length > 0)
                //   ChannelSearch(
                //     listChannel: dataSearchModel.dataChannel,
                //   ),
              ]))
    ]);
  }
}
