import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/models/ReviewVideoData.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/models/VideoReviewModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/review/ItemVideoScreen.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/startpage/responsive_start_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/src/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class VideoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VideoScreen();
  }
}

class _VideoScreen extends State<VideoScreen> {
  List<VideoReview> listVideoReview = [];
  List<VideoReview> listVideoReviewPage = [];
  ScrollController _scrollController = ScrollController();
  bool _isCheckLoadMore = false;
  int count = 10;

  void _loadMore() async {
    if (_isCheckLoadMore == false &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      setState(() {
        _isCheckLoadMore = true;
        count = count + 10;
        listVideoReviewPage = listVideoReview.take(count).toList();
      });
    }
    // setState(() {
    //
    // });
    _isCheckLoadMore = false;
  }

  @override
  void initState() {
    // _scrollController.addListener(_loadMore);
    super.initState();
  }

  @override
  void dispose() {
    // _scrollController.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      return FutureBuilder(
          future: TalkAPIs().fetchReviewVideoData(userData: userData),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  S.of(context).Anerrordata,
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                color: themeProvider.mode == ThemeMode.dark
                    ? const Color.fromRGBO(24, 26, 33, 1)
                    : Colors.white,
                child: Center(
                  // child: CircularProgressIndicator(),
                  child: const PhoLoading(),
                ),
              );
            }
            // else{
            return snapshot.hasData
                ? ScopedModel(
                    model: userData,
                    child: _createListView(context, snapshot.data, userData))
                : _buildLoadNoData();
            // }
          });
    });
  }

  Widget _createListView(BuildContext context, DataVideoReview dataVideoReview,
      DataUser userData) {
    var themeProvider = context.watch<ThemeProvider>();
    listVideoReview = dataVideoReview.videoReview;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: themeProvider.mode == ThemeMode.dark
          ? const Color.fromRGBO(24, 26, 33, 1)
          : Colors.white,
      padding: const EdgeInsets.only(right: 10, left: 10),
      height:
          ResponsiveWidget.isSmallScreen(context) ? height / 1.1 : height / 1.1,
      width: ResponsiveWidget.isSmallScreen(context) ? width / 1 : width / 1,
      child: Card(
        color: themeProvider.mode == ThemeMode.dark
            ? const Color.fromRGBO(24, 26, 33, 1)
            : Colors.white,
        elevation: 3,
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          height: ResponsiveWidget.isSmallScreen(context)
              ? height / 1.1
              : height / 1.3,
          width: ResponsiveWidget.isSmallScreen(context)
              ? width / 1.1
              : width / 1.1,
          child: listVideoReview.length > 0
              ? ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  // controller: _scrollController,
                  itemCount: listVideoReview.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == listVideoReview.length) {
                      if (_isCheckLoadMore == true) {
                        return Align(
                          child: new Container(
                            width: 70.0,
                            height: 70.0,
                            child: new Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: new Center(
                                child: const PhoLoading(),
                              ),
                            ),
                          ),
                          alignment: FractionalOffset.bottomCenter,
                        );
                      } else {
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: const Text(''),
                        );
                      }
                    }
                    return ScopedModel(
                      model: userData,
                      child: ItemVideoWidget(
                        reviewData: listVideoReview[index],
                        onClickDeleteItem: () {
                          removeItem(index, context);
                        },
                        isNotHistory: true,
                      ),
                    );
                  })
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    // Image.asset(
                    //   'assets/new_ui/more/poor.png',
                    //   height: 90,
                    // ),
                    const PhoLoading(),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      S.of(context).Nostudydatayet,
                      overflow: TextOverflow.visible,
                      maxLines: 2,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void removeItem(int index, BuildContext context) async {
    await TalkAPIs().destroyVideoCourse(
        DataCache().userCache!.uid.toString(),
        listVideoReview[index].tid.toString(),
        listVideoReview[index].vrid.toString());

    setState(() {
      // listVideoReviewPage = List.from(listVideoReviewPage)..removeAt(index);
      listVideoReview = List.from(listVideoReview)..removeAt(index);
    });

    Fluttertoast.showToast(
      msg: S.of(context).deleteSuccessful,
    );
  }

  // Screens No data
  Widget _buildLoadNoData() {
    var themeProvider = context.watch<ThemeProvider>();
    return Container(
      color: themeProvider.mode == ThemeMode.dark
          ? const Color.fromRGBO(24, 26, 33, 1)
          : Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            // Image.asset(
            //   'assets/new_ui/more/poor.png',
            //   height: 90,
            // ),
            const PhoLoading(),
            const SizedBox(
              height: 10,
            ),
            Text(
              S.of(context).Nostudydatayet,
              overflow: TextOverflow.visible,
              maxLines: 2,
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
