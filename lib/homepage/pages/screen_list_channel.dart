import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/widgets/item_channel.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/startpage/responsive_start_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListChannelScreen extends StatelessWidget {
  final Function showSetting;
  final Category category;
  ListChannelScreen(
      {Key? key, required this.category, required this.showSetting})
      : super(key: key);
  String dropdownValue = '';

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    double width = MediaQuery.of(context).size.width;
    return Consumer<LocaleProvider>(
      builder: (context, provider, snapshot) {
        return Container(
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.7),
                          child: Text(
                            category.getNameByLanguage(
                                provider.locale!.languageCode),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: themeProvider.mode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          S.of(context).Numberofchannels +
                              ": " +
                              category.listChannel.length.toString(),
                          style: TextStyle(
                              color: themeProvider.mode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 14),
                        )
                      ],
                    ),
                    Spacer(),
                    DropdownButton<String>(
                      value: dropdownValue.toString() == ''
                          ? S.of(context).Popular
                          : dropdownValue,
                      icon: Icon(
                        Icons.expand_more,
                        color: themeProvider.mode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                      iconSize: 30,
                      style: TextStyle(
                        color: themeProvider.mode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 16,
                      ),
                      onChanged: (String? newValue) {
                        dropdownValue = newValue!;
                        (context as Element).markNeedsBuild();
                      },
                      items: <String>[
                        S.of(context).Popular,
                        S.of(context).FromAZ,
                        S.of(context).Latest,
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              color: themeProvider.mode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: category.listChannel.length > 0
                    ? ListView(
                        children: [
                          for (var channel in category.listChannel)
                            ItemChannelView(
                              channel: channel,
                              showSetting: showSetting,
                            ),
                        ],
                      )
                    : Container(
                        padding: const EdgeInsets.all(10),
                        height: 100,
                        width: ResponsiveWidget.isSmallScreen(context)
                            ? width / 1
                            : width / 1,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          S.of(context).Therearenochannelsinthiscategory,
                          style: TextStyle(
                            fontSize: 20,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
