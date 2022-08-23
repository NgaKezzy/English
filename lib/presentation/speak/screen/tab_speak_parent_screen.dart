import 'package:app_learn_english/Providers/theme_provider.dart';

import 'package:app_learn_english/generated/l10n.dart';

import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';

import 'package:app_learn_english/presentation/speak/provider/course_chuyenmuc.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../screen/chuyen_mon_screen/tab_chuyen_muc_screen.dart';
import '../screen/trinh_do_screen/tab_trinh_do_screen.dart';
import '../provider/all_list_talk_course.dart';

class TabScreenParentSpeak extends StatefulWidget {
  @override
  _TabScreenParentSpeakState createState() => _TabScreenParentSpeakState();
}

class _TabScreenParentSpeakState extends State<TabScreenParentSpeak> {
  var _isLoadingCourse = true;
  var _initLoading = true;

  @override
  void didChangeDependencies() {
    var providerCourse = Provider.of<AllListTalkCourse>(context);
    List<ChuyenMucCourse?> chuyenMuc = providerCourse.items;
    if (_initLoading) {
      if (chuyenMuc.length == 0) {
        providerCourse.getAllTalkByCategory(context, 1).then((_) {
          setState(() {
            _isLoadingCourse = false;
          });
        });
      } else {
        setState(() {
          _isLoadingCourse = false;
        });
      }
    }
    _initLoading = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return ScopedModelDescendant<DataUser>(
      builder: (context, child, userData) => DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              S.of(context).Speak,
              style: TextStyle(
                color: themeProvider.mode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            backgroundColor: themeProvider.mode == ThemeMode.dark
                ? const Color.fromRGBO(45, 48, 57, 1)
                : Colors.white,
          ),
          backgroundColor: themeProvider.mode == ThemeMode.dark
              ? const Color.fromRGBO(24, 26, 33, 1)
              : Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: themeProvider.mode == ThemeMode.dark
                        ? const Color.fromRGBO(45, 48, 57, 1)
                        : Colors.white,
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 40,
                          width: 230,
                          child: TabBar(
                            unselectedLabelColor:
                                themeProvider.mode == ThemeMode.dark
                                    ? const Color.fromRGBO(97, 100, 106, 1)
                                    : Colors.black,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: const Color(0xFF04D076),
                            unselectedLabelStyle: TextStyle(
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
                                text: S.of(context).Level,
                              ),
                              Tab(
                                text: S.of(context).Categories,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                          thickness: 1,
                          color: themeProvider.mode == ThemeMode.dark
                              ? Colors.grey.shade700
                              : const Color(0xFFE4E4E4),
                          height: 1),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      TabTrinhDoScreen(
                        isLoadingCourse: _isLoadingCourse,
                      ),
                      TabChuyenMucScreen(
                        isLoadingCourse: _isLoadingCourse,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
