import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/models/video_history/history_model.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/review/item_video_history.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/src/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class AllVideoHistoryScreens extends StatefulWidget {
  final DataUser dataUser;
  final bool isHome;

  AllVideoHistoryScreens(
      {Key? key, required this.dataUser, required this.isHome})
      : super(key: key);

  @override
  State<AllVideoHistoryScreens> createState() => _AllVideoHistoryScreensState();
}

class _AllVideoHistoryScreensState extends State<AllVideoHistoryScreens> {
  late List<History>? _listVideoHistory;
  ScrollController _scrollController = ScrollController();
  bool _isCheckLoadMore = false;
  int page = 0;

  void _loadMore() async {
    if (_isCheckLoadMore == false &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      setState(() {
        _isCheckLoadMore = true;
        page = page + 1;
      });
      await TalkAPIs().fetchDataVideoHistory(
          uid: widget.dataUser.uid,
          langugeCode: widget.dataUser.langnative,
          page: page);
    }
    setState(() {
      _isCheckLoadMore = false;
    });
  }

  @override
  void initState() {
    _listVideoHistory = DataCache().getListHistory();
    if (_listVideoHistory != null && _listVideoHistory!.isEmpty) {
      TalkAPIs().fetchDataVideoHistory(
          uid: widget.dataUser.uid,
          langugeCode: widget.dataUser.langnative,
          page: 0);
    }
    _scrollController.addListener(_loadMore);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      return Container(
        color: themeProvider.mode == ThemeMode.dark
            ? const Color.fromRGBO(24, 26, 33, 1)
            : Colors.white,
        child: (_listVideoHistory != null)
            ? _listVideoHistory!.length > 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Center(
                      child: widget.isHome
                          ? ListView.builder(
                              physics: BouncingScrollPhysics(),
                              controller: _scrollController,
                              itemCount: _listVideoHistory!.length + 1,
                              itemBuilder: (BuildContext context, int index) {
                                if (index == _listVideoHistory!.length) {
                                  if (_isCheckLoadMore == true) {
                                    return Align(
                                      child: new Container(
                                        width: 70.0,
                                        height: 70.0,
                                        child: new Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: const Center(
                                            // child: CircularProgressIndicator(),
                                            child: const PhoLoading(),
                                          ),
                                        ),
                                      ),
                                      alignment: FractionalOffset.bottomCenter,
                                    );
                                  } else {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: const Text(''),
                                    );
                                  }
                                }
                                return ScopedModel(
                                  model: userData,
                                  child: ItemVideoHistory(
                                    reviewData: _listVideoHistory![index],
                                    ytId: setYtId(_listVideoHistory![index]
                                        .Talk
                                        .linkOrigin),
                                    onDeleteVideo: () {
                                      _modalBottomSheetMenu(
                                          _listVideoHistory![index]
                                              .uid
                                              .toString(),
                                          _listVideoHistory![index]
                                              .vid
                                              .toString(),
                                          _listVideoHistory![index]
                                              .id
                                              .toString(),
                                          index);
                                    },
                                    isHome: true,
                                  ),
                                );
                              })
                          : Column(
                              children: [
                                ScopedModel(
                                  model: userData,
                                  child: ItemVideoHistory(
                                    reviewData: _listVideoHistory![0],
                                    ytId: setYtId(
                                        _listVideoHistory![0].Talk.linkOrigin),
                                    onDeleteVideo: () {},
                                    isHome: false,
                                  ),
                                ),
                                (_listVideoHistory!.length > 2)
                                    ? ScopedModel(
                                        model: userData,
                                        child: ItemVideoHistory(
                                          reviewData: _listVideoHistory![1],
                                          ytId: setYtId(_listVideoHistory![1]
                                              .Talk
                                              .linkOrigin),
                                          isHome: false,
                                          onDeleteVideo: () {},
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        // Image.asset(
                        //   'assets/new_ui/more/poor.png',
                        //   height: 160,
                        // ),
                        const PhoLoading(),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          S.of(context).Nostudydatayet,
                          overflow: TextOverflow.visible,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    // Image.asset(
                    //   'assets/new_ui/more/poor.png',
                    //   height: 160,
                    // ),
                    const PhoLoading(),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      S.of(context).Nostudydatayet,
                      overflow: TextOverflow.visible,
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
      );
    });
  }

//dialog xác nhận trước khi xóa video
  void _modalBottomSheetMenu(String uid, String vid, String id, int index) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          var themeProvider = context.watch<ThemeProvider>();
          return new Container(
            height: 200.0,
            color: Colors.transparent,
            child: new Container(
                decoration: new BoxDecoration(
                    color: themeProvider.mode == ThemeMode.dark
                        ? const Color.fromRGBO(42, 44, 50, 1)
                        : Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: new Center(
                    child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        S.of(context).confirmDeleteVideoHistory,
                        style: TextStyle(
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 100,
                            height: 50.0,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: themeProvider.mode == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Center(
                              child: Text(
                                S.of(context).cancel,
                                style: TextStyle(
                                    color: themeProvider.mode == ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            _deleteVideo(uid, vid, id, index);
                          },
                          child: Container(
                            width: 100,
                            height: 50.0,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Center(
                              child: Text(
                                S.of(context).deleteVideoHistory,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ))),
          );
        });
  }

// fun delete video
  void _deleteVideo(String uid, String vid, String id, int index) async {
    await TalkAPIs().deleteVideoHistory(uid, id, vid);
    setState(() {
      _listVideoHistory = List.from(_listVideoHistory!)..removeAt(index);
      DataCache().removerAtListHistory(index);
      if (_listVideoHistory!.length == 0) {
        DataCache().clearListHistory();
      }
    });

    Fluttertoast.showToast(
      msg: S.of(context).deleteSuccessful,
    );
  }

// cắt Youtube ID từ sever trả về
  String setYtId(String linkOrigin) {
    String ytID = linkOrigin.substring(linkOrigin.indexOf("=") + 1);
    ytID.trim();
    if (ytID.contains("-")) {
      ytID.replaceAll("-", "");
    }
    return ytID;
  }
}
