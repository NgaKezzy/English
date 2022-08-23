import 'package:app_learn_english/Providers/theme_provider.dart';

import 'package:app_learn_english/generated/l10n.dart';

import 'package:app_learn_english/models/UserModel.dart';

import 'package:app_learn_english/presentation/review/VideoScreen.dart';

import 'package:app_learn_english/screens/all_video_history_review.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class LibraryVideoScreens extends StatefulWidget {
  const LibraryVideoScreens({Key? key}) : super(key: key);

  @override
  State<LibraryVideoScreens> createState() => _LibraryVideoScreensState();
}

class _LibraryVideoScreensState extends State<LibraryVideoScreens> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      return DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: themeProvider.mode == ThemeMode.dark
                  ? const Color.fromRGBO(45, 48, 57, 1)
                  : Colors.white,
              title: Text(
                S.of(context).vieoLibrary,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black),
              ),
              leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: SvgPicture.asset(
                  'assets/new_ui/more/Iconly-Arrow-Left.svg',
                  fit: BoxFit.scaleDown,
                  height: MediaQuery.of(context).size.width <= 375 ? 25 : 30,
                  color: themeProvider.mode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(40),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 40,
                        // margin: EdgeInsets.only(bottom: 10),
                        child: TabBar(
                          unselectedLabelColor:
                              themeProvider.mode == ThemeMode.dark
                                  ? const Color.fromRGBO(97, 100, 106, 1)
                                  : Colors.black,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: const Color(0xFF04D076),
                          unselectedLabelStyle: const TextStyle(
                            fontSize: 18,
                          ),
                          labelColor: const Color(0xFF04D076),
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          indicator: const UnderlineTabIndicator(
                            borderSide: BorderSide(
                              width: 2.5,
                              color: Color(0xFF04D076),
                            ),
                          ),
                          padding: const EdgeInsets.only(left: 0),
                          indicatorPadding: const EdgeInsets.only(left: 0),
                          labelPadding: const EdgeInsets.only(left: 0),
                          tabs: [
                            Tab(
                              child: Container(
                                child: Text(
                                  S.of(context).All,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                child: Text(
                                  S.of(context).tick,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                        thickness: 1, color: Color(0xFFE4E4E4), height: 1),
                  ],
                ),
              ),
            ),
            body: SafeArea(
              top: true,
              bottom: true,
              child: TabBarView(
                children: [
                  ScopedModel(
                      model: userData,
                      child: AllVideoHistoryScreens(
                        dataUser: userData,
                        isHome: true,
                      )),
                  ScopedModel(model: userData, child: VideoScreen()),
                ],
              ),
            ),
          ));
    });
  }
}
