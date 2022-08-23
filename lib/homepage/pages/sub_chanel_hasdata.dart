import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/widgets/item_chanel_subed.dart';
import 'package:app_learn_english/homepage/widgets/item_more_chanel_1.dart';
import 'package:app_learn_english/homepage/widgets/item_talk_chanel_subed.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/models/DataSearchIndexModel.dart';
import 'package:app_learn_english/models/HomeData.dart';
import 'package:app_learn_english/models/SubChannelData.dart';

import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';

import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class SubChanelHasdata extends StatefulWidget {
  final Function showSetting;
  final DataSearchIndex dataSearchIndex;
  SubChanelHasdata(
      {Key? key, required this.dataSearchIndex, required this.showSetting})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _SubChanelHasdata(
        dataSearchIndex: dataSearchIndex, showSetting: showSetting);
  }
}

class _SubChanelHasdata extends State<SubChanelHasdata> {
  final Function showSetting;
  DataSearchIndex dataSearchIndex;
  _SubChanelHasdata(
      {Key? key, required this.dataSearchIndex, required this.showSetting});
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      return FutureBuilder(
        future: TalkAPIs().getDataSubChannel(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return activeDialog(context, S.of(context).ErrorLoadData);
          }

          return snapshot.hasData
              ? _SubChanelHasdataView(
                  listChannelIndex: dataSearchIndex.dataChannel,
                  userData: userData,
                  subChannelData: snapshot.data,
                  showSetting: showSetting,
                  // dataHome: snapshot.data,
                )
              : const Center(
                  // child: Platform.isAndroid
                  //     ? const CircularProgressIndicator()
                  //     : const CupertinoActivityIndicator(),
                  child: PhoLoading(),
                );
        },
      );
    });
  }
}

class _SubChanelHasdataView extends StatefulWidget {
  final List<Category> listChannelIndex;
  final DataUser userData;
  final SubChannelData subChannelData;
  final Function showSetting;
  // final DataHome dataHome;

  _SubChanelHasdataView({
    Key? key,
    required this.userData,
    required this.subChannelData,
    required this.listChannelIndex,
    required this.showSetting,
    // required this.dataHome,
  }) : super(key: key);

  @override
  State<_SubChanelHasdataView> createState() => _SubChanelHasdataViewState();
}

class _SubChanelHasdataViewState extends State<_SubChanelHasdataView> {
  late DataHome? dataHome;
  ScrollController _listViewController = ScrollController();
  int _numberLoadSuggest = 2;
  @override
  void initState() {
    super.initState();

    dataHome = DataCache().getDataHome();
    _listViewController.addListener(() {
      double maxScroll = _listViewController.position.maxScrollExtent;
      double currentScroll = _listViewController.position.pixels;
      double delta = 100;
      if (maxScroll - currentScroll <= delta) {

        TalkAPIs()
            .fetchMoreDataHomeSuggest(
                langugeCode: Provider.of<LocaleProvider>(context, listen: false)
                    .locale!
                    .languageCode,
                page: _numberLoadSuggest,
                uid: DataCache().getUserData().uid)
            .then((value) {
          if (value) {
            _numberLoadSuggest++;
            setState(() {
              dataHome = DataCache().getDataHome();
            });
          }
          print('Đây là trang $_numberLoadSuggest');
        });
      }
    });
    print('Noschayvao1');
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print("BuildCal");
    return Container(
        child: Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: themeProvider.mode == ThemeMode.dark
              ? const Color.fromRGBO(24, 26, 33, 4)
              : const Color.fromRGBO(236, 236, 236, 1),
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              Text(
                S.of(context).SubscribedChannel,
                style: TextStyle(
                  color: themeProvider.mode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: width,
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ItemMoreSubView(
                      userData: widget.userData,
                      listCategory: [],
                      showSetting: widget.showSetting,
                    ),
                    for (var category
                        in widget.subChannelData.listCatgoryFollow)
                      ItemSubedView(
                        category: category,
                        categoryIndex: widget.listChannelIndex,
                        showSetting: widget.showSetting,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text(
                    S.of(context).SuggestionsForYou,
                    style: TextStyle(
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
                if (dataHome != null)
                  const SizedBox(height: 5)
                else
                  const SizedBox(height: 50),
                if (dataHome != null)
                  Expanded(
                    child: ListView.builder(
                      controller: _listViewController,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (_, index) => Column(
                        children: [
                          ItemTalkSubedView(
                            talk: dataHome!.dataSugges[index],
                          ),
                          Divider(
                            color: Colors.grey.withOpacity(0.9),
                          ),
                        ],
                      ),
                      itemCount: dataHome!.dataSugges.length,
                    ),
                  )
                else
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'No new videos have been updated yet',
                      style: TextStyle(
                        color: themeProvider.mode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ],
    )
    );
  }
}
