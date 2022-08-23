import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/widgets/item_channel.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class ListAllChannelScreen extends StatelessWidget {
  final List<Category> listChannel;
  final Function showSetting;
  ListAllChannelScreen(
      {Key? key, required this.listChannel, required this.showSetting})
      : super(key: key);
  String dropdownValue = '';
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Column(
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).Allchannels,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  S.of(context).Numberofchannels +
                      ": " +
                      listChannel.length.toString(),
                  style: TextStyle(
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
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
                  fontSize: 20),
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
        SizedBox(
          height: 10,
        ),
        Expanded(
            child: Container(
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.only(left: 10, right: 10),
                child: listChannel.length > 0
                    ? ListView(
                        children: [
                          for (var channel in listChannel)
                            ItemChannelView(
                              channel: channel,
                              showSetting: showSetting,
                            ),
                        ],
                      )
                    : Text(S.of(context).Therearenochannelsinthiscategory,
                        style: TextStyle(fontSize: 20, color: Colors.white))))
      ],
    );
  }
}
