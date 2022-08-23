import 'dart:io';

import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/searchpage/search_widget/categories_widget_search.dart';
import 'package:app_learn_english/homepage/searchpage/search_widget/channel_widget_search.dart';
import 'package:app_learn_english/homepage/searchpage/search_widget/sample_widget_search.dart';
import 'package:app_learn_english/models/DataSearchIndexModel.dart';

import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class PageSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PageSearch();
  }
}

class _PageSearch extends State<PageSearch> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      return Center(
        child: DataCache().getSearchIndex() != null
            ? PageSearchIndex(
                dataSearchIndex: DataCache().getSearchIndex(),
                userData: userData,
              )
            : FutureBuilder(
                future: TalkAPIs().fetchDataSearchIndex(userData: userData),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        S.of(context).Anerrordata,
                      ),
                    );
                  }
                  return snapshot.hasData
                      ? PageSearchIndex(
                          dataSearchIndex: snapshot.data,
                          userData: userData,
                        )
                      : Center(
                          // child: Platform.isAndroid
                          //     ? CircularProgressIndicator()
                          //     : CupertinoActivityIndicator(),
                          child: const PhoLoading(),
                        );
                }),
      );
    });
  }
}

class PageSearchIndex extends StatelessWidget {
  final DataSearchIndex dataSearchIndex;
  final DataUser userData;
  PageSearchIndex(
      {Key? key, required this.dataSearchIndex, required this.userData})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CategoriesSearch(
                listCategory: dataSearchIndex.dataCatgory,
              ),
              // SizedBox(
              //   height: 10,
              // ),
              // ChannelSearch(
              //   listChannel: dataSearchIndex.dataChannel,
              // ),
              const SizedBox(
                height: 10,
              ),
              ScopedModel(
                model: userData,
                child: SampleSearch(
                  dataTalkSugges: dataSearchIndex.dataTalkSugges,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
