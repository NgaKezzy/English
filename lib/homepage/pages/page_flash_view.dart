import 'package:app_learn_english/homepage/pages/page_flash_video_screen.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';

import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageFlashView extends StatefulWidget {
  final List<DataTalk> data;
  final int idx;
  final int? currentPage;

  PageFlashView({
    Key? key,
    required this.data,
    required this.idx,
    this.currentPage,
  }) : super(key: key);

  @override
  State<PageFlashView> createState() => _PageFlashViewState();
}

class _PageFlashViewState extends State<PageFlashView> {
  bool _isLoad = false;
  int page = 0;

  List<DataTalk> listFlashView = [];

  late PageController _pageController;
  List<Widget> _buildListFlashVideoScreen() => listFlashView
      .map((e) => FlashVideoScreen(
            dataTalk: e,
            key: UniqueKey(),
          ))
      .toList();
  List<Widget> flashVideoScreens = [];
  @override
  void initState() {
    _pageController = PageController(initialPage: widget.idx);
    listFlashView = widget.data;
    flashVideoScreens = _buildListFlashVideoScreen();
    if (widget.currentPage != null) {
      page = widget.currentPage!;
    }
    super.initState();
  }

  Future<void> getMoreFlashView(String lang) async {
    List<DataTalk> currentTalk = [...listFlashView];
    List<DataTalk> moreTalk = await TalkAPIs().getFlashViewVideo(page, lang);
    if (moreTalk.isNotEmpty) {
      currentTalk.addAll(moreTalk);
      setState(() {
        page++; // page
        listFlashView = currentTalk;
        flashVideoScreens = _buildListFlashVideoScreen();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String lang = Provider.of<LocaleProvider>(context).locale!.languageCode;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            children: flashVideoScreens,
            onPageChanged: (index) async {
              print('đây là index nè $index');
              if (index == listFlashView.length - 2) {
                print('đây rồi này');
                await getMoreFlashView(lang);
              }
              final prefs = await SharedPreferences.getInstance();
              if (prefs.containsKey('isFirstUseFlash')) {
                if (prefs.getBool('isFirstUseFlash') == true) {
                  prefs.setBool('isFirstUseFlash', false);
                }
              }
            },
          ),
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 15,
              left: 15,
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
