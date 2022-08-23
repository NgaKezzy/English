import 'dart:async';
import 'dart:io';

import 'package:app_learn_english/generated/l10n.dart';

import 'package:app_learn_english/homepage/pages/sub_chanel_hasdata.dart';
import 'package:app_learn_english/homepage/pages/sub_chanel_no_data.dart';

import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class PageSubChanel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PageSubChanelCheck();
  }
}

class _PageSubChanelCheck extends State<PageSubChanel> {
  void showSettings(BuildContext ctx) async {
    (context as Element).markNeedsBuild();
  }

  Future? futureSubChanel;

  @override
  Widget build(BuildContext context) {
    if (futureSubChanel == null) {
      var localeProvider = context.read<LocaleProvider>();
      var lang = localeProvider.locale?.languageCode ?? 'en';
      futureSubChanel = TalkAPIs()
          .fetchDataSubChannel(userData: DataCache().getUserData(), lang: lang);
    }
    return DataCache().getChannelHasData() != null
        ? PageSubChanelCheck(
            showSetting: showSettings,
          )
        : FutureBuilder(
            future: futureSubChanel,
            builder: (ct, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }

              return snapshot.hasData
                  ? PageSubChanelCheck(
                      showSetting: showSettings,
                    )
                  : Center(
                      // child: Platform.isAndroid
                      //     ? const CircularProgressIndicator()
                      //     : const CupertinoActivityIndicator(),
                      child: const PhoLoading(),
                    );
            },
          );
  }
}

class PageSubChanelCheck extends StatefulWidget {
  final Function showSetting;

  PageSubChanelCheck({Key? key, required this.showSetting}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _PageSubChanel(showSetting: showSetting);
  }
}

class _PageSubChanel extends State<PageSubChanelCheck> {
  final Function showSetting;
  _PageSubChanel({Key? key, required this.showSetting});
  final Future futureSearchIndex =
      TalkAPIs().fetchDataSearchIndex(userData: DataCache().getUserData());
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      return DataCache().getLengthChannel() > 0
          ? (DataCache().getSearchIndex() != null
              ? ScopedModel(
                  model: userData,
                  child: SubChanelHasdata(
                    dataSearchIndex: DataCache().getSearchIndex(),
                    showSetting: showSetting,
                  ))
              : FutureBuilder(
                  future: futureSearchIndex,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          S.of(context).Anerrordata,
                        ),
                      );
                    }
                    return snapshot.hasData
                        ? ScopedModel(
                            model: userData,
                            child: SubChanelHasdata(
                              dataSearchIndex: snapshot.data,
                              showSetting: showSetting,
                            ))
                        : const Center(
                            // child: Platform.isAndroid
                            //     ? const CircularProgressIndicator()
                            //     : const CupertinoActivityIndicator(),
                            child: PhoLoading(),
                          );
                  }))
          : ScopedModel(
              model: userData,
              child: SubChanelNoData(
                showSetting: showSetting,
              ));
    });
  }
}
