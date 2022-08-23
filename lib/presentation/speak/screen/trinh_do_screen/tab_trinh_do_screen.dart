import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/presentation/speak/provider/all_list_talk_course.dart';
import 'package:app_learn_english/presentation/speak/screen/trinh_do_screen/trinhdo_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabTrinhDoScreen extends StatefulWidget {
  final bool isLoadingCourse;

  const TabTrinhDoScreen({
    Key? key,
    required this.isLoadingCourse,
  }) : super(key: key);
  @override
  _TabTrinhDoScreenState createState() => _TabTrinhDoScreenState();
}

class _TabTrinhDoScreenState extends State<TabTrinhDoScreen> {
  // Widget _buildTab(String title) {
  //   return Tab(
  //     child: Container(
  //       height: 30,
  //       padding: EdgeInsets.symmetric(
  //         horizontal: 10,
  //         vertical: 0,
  //       ),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(5),
  //         color: Color.fromRGBO(235, 235, 235, 0.7),
  //       ),
  //       child: Align(
  //         alignment: Alignment.center,
  //         child: Text(title),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var allCourseDataTrinhDo = context.watch<AllListTalkCourse>();
    // final allCourses = allCourseDataTrinhDo.itemsTrinhDo;
    final allCourses = DataCache().getTrinhDoCourse();

    return DefaultTabController(
      length: 5,
      initialIndex: 0,
      child: Column(
        children: [
          Container(
            height: 36,
            child: TabBar(
              labelColor: Colors.white,
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              isScrollable: true,
              unselectedLabelColor: themeProvider.mode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
              tabs: [
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          width: 0.5,
                          style: BorderStyle.solid,
                          color: themeProvider.mode == ThemeMode.dark
                              ? Colors.white
                              : Colors.grey.withOpacity(1),
                        ),
                      ),
                      child: Align(
                        child: Text(
                          S.of(context).All,
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          width: 0.5,
                          style: BorderStyle.solid,
                          color: themeProvider.mode == ThemeMode.dark
                              ? Colors.white
                              : Colors.grey.withOpacity(1),
                        ),
                      ),
                      child: Align(
                        child: Text(
                          S.of(context).Introduction,
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          width: 0.5,
                          style: BorderStyle.solid,
                          color: themeProvider.mode == ThemeMode.dark
                              ? Colors.white
                              : Colors.grey.withOpacity(1),
                        ),
                      ),
                      child: Align(
                        child: Text(
                          S.of(context).Primary,
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          width: 0.5,
                          style: BorderStyle.solid,
                          color: themeProvider.mode == ThemeMode.dark
                              ? Colors.white
                              : Colors.grey.withOpacity(1),
                        ),
                      ),
                      child: Align(
                        child: Text(
                          S.of(context).Intermediate,
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          width: 0.5,
                          style: BorderStyle.solid,
                          color: themeProvider.mode == ThemeMode.dark
                              ? Colors.white
                              : Colors.grey.withOpacity(1),
                        ),
                      ),
                      child: Align(
                        child: Text(
                          S.of(context).HighClass,
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ),
                // _buildTab(S.of(context).All),
                // _buildTab(S.of(context).Introduction),
                // _buildTab(S.of(context).Primary),
                // _buildTab(S.of(context).Intermediate),
                // _buildTab(S.of(context).HighClass),
              ],
              // labelColor: Colors.white,
              // indicator: BoxDecoration(
              //   borderRadius: BorderRadius.circular(5),
              //   color: Colors.white,
              // ),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                // gradient: LinearGradient(
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                //   colors: [
                //     Colors.blue.shade700,
                //     Colors.tealAccent.shade400,
                //   ],
                // ),
                color: const Color.fromRGBO(109, 177, 93, 1),
              ),
              // unselectedLabelColor: Colors.black,
              indicatorWeight: 0,
              // unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: TabBarView(children: [
              TrinhDoScreen(
                isLoadingCourse: widget.isLoadingCourse,
                listCourse: allCourseDataTrinhDo.itemsTrinhDo,
              ),
              TrinhDoScreen(
                isLoadingCourse: widget.isLoadingCourse,
                listCourse: allCourseDataTrinhDo.getListFilterLevel(1),
              ),
              TrinhDoScreen(
                isLoadingCourse: widget.isLoadingCourse,
                listCourse: allCourseDataTrinhDo.getListFilterLevel(2),
              ),
              TrinhDoScreen(
                isLoadingCourse: widget.isLoadingCourse,
                listCourse: allCourseDataTrinhDo.getListFilterLevel(3),
              ),
              TrinhDoScreen(
                isLoadingCourse: widget.isLoadingCourse,
                listCourse: allCourseDataTrinhDo.getListFilterLevel(4),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
