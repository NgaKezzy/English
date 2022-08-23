import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/searchpage/search_widget/item_channel_widget_search.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:flutter/material.dart';
import 'package:app_learn_english/startpage/responsive_start_page.dart';
import 'package:provider/src/provider.dart';

class ChannelSearch extends StatelessWidget {
  final List<Category> listChannel;
  ChannelSearch({Key? key, required this.listChannel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    double width = MediaQuery.of(context).size.width;

    return Card(
      elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      child: Container(
        padding: EdgeInsets.only(top: 10, left: 10),
        // margin: EdgeInsets.only(right: 10, left: 10),
        height: 310,
        width: width,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
              width: 0.5,
            ),
            color: themeProvider.mode == ThemeMode.dark
                ? Color.fromRGBO(59, 61, 66, 1)
                : Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(
                S.of(context).Channel,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: themeProvider.mode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: ResponsiveWidget.isSmallScreen(context)
                      ? width / 18
                      : width / 45,
                ),
              ),
              Spacer(),
              // Row(
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     TextButton(
              //       child: Text(
              //         S.of(context).SeeAll,
              //         style: TextStyle(
              //           fontWeight: FontWeight.w500,
              //           color: Colors.orange,
              //           fontSize: ResponsiveWidget.isSmallScreen(context)
              //               ? width / 22
              //               : width / 45,
              //         ),
              //       ),
              //       onPressed: () {
              //         activeDialog(context, "Chưa xử lý");
              //       },
              //     ),
              //     RotatedBox(
              //       quarterTurns: 2,
              //       child: Icon(
              //         Icons.arrow_back_ios,
              //         color: Colors.orange,
              //         size: 20,
              //       ),
              //     ),
              //   ],
              // ),
            ]),
            const SizedBox(height: 10),
            Container(
              height: 240,
              width: width,
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1 / 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  listChannel.length,
                  (index) {
                    return ItemChannelSearchWidget(
                      category: listChannel[index],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
