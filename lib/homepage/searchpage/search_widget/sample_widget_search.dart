import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/searchpage/search_widget/item_sample_widget_search.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:app_learn_english/startpage/responsive_start_page.dart';
import 'package:provider/src/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class SampleSearch extends StatelessWidget {
  final List<DataTalk> dataTalkSugges;
  SampleSearch({Key? key, required this.dataTalkSugges}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
            padding: const EdgeInsets.only(right: 10, left: 10, top: 20),
            // margin: EdgeInsets.only(
            //   right: 10,
            //   left: 10,
            // )
            width: width,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                width: 0.5,
              ),
              color: themeProvider.mode == ThemeMode.dark
                  ? const Color.fromRGBO(59, 61, 66, 1)
                  : Colors.white.withOpacity(0.2),
              borderRadius: const BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).SuggestionsForYou,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: ResponsiveWidget.isSmallScreen(context)
                      ? height / 1.7
                      : height / 1.3,
                  width: width,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      for (var talk in dataTalkSugges)
                        ScopedModel(
                            model: userData,
                            child: ItemSampleSearchWidget(
                              talkData: talk,
                            )),
                    ],
                  ),
                ),
              ],
            )),
      );
    });
  }
}
