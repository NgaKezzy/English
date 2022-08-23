import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/searchpage/search_widget/item_channel_result.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:flutter/material.dart';
import 'package:app_learn_english/startpage/responsive_start_page.dart';
import 'package:provider/src/provider.dart';

class ChannelSearchResult extends StatefulWidget {
  final List<Category> listChannel;
  final List<Category> listChannelIndex;
  ChannelSearchResult(
      {Key? key, required this.listChannel, required this.listChannelIndex})
      : super(key: key);

  @override
  _ChannelSearchResult createState() => _ChannelSearchResult(
      listChannel: listChannel, listChannelIndex: listChannelIndex);
}

class _ChannelSearchResult extends State<ChannelSearchResult> {
  final List<Category> listChannel;
  final List<Category> listChannelIndex;
  _ChannelSearchResult(
      {Key? key, required this.listChannel, required this.listChannelIndex});
  var sizeList = 3;

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Card(
      elevation: 5,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
          width: width,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                width: 0.5,
              ),
              color: themeProvider.mode == ThemeMode.dark
                  ? Color.fromRGBO(58, 60, 66, 1)
                  : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    S.of(context).Channel,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fontSize: ResponsiveWidget.isSmallScreen(context)
                          ? width / 18
                          : width / 45,
                    ),
                  ),
                  Text(
                    '(' + listChannel.length.toString() + ')',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fontSize: ResponsiveWidget.isSmallScreen(context)
                          ? width / 18
                          : width / 45,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: ResponsiveWidget.isSmallScreen(context)
                    ? height / 3
                    : height / 1.5,
                width: width,
                child: ListView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  children: [
                    for (var i = 0;
                        i <
                            (listChannel.length > 3
                                ? sizeList
                                : listChannel.length);
                        i++)
                      ItemChannelResult(
                        category: listChannel[i],
                        categoryIndex: listChannelIndex,
                      )
                  ],
                ),
              ),
              sizeList == 3 && listChannel.length > 3
                  ? MaterialButton(
                      onPressed: () => {
                        setState(() {
                          sizeList = listChannel.length;
                        })
                      },
                      minWidth: double.infinity,
                      height: 60,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        children: [
                          Spacer(),
                          Text(
                            S.of(context).SeeMore + ' ',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 26,
                                color: Colors.black),
                          ),
                          Text(
                            '(' + (listChannel.length - 3).toString() + ')',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                              color: Colors.black,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    )
                  : SizedBox()
            ],
          )),
    );
  }
}
