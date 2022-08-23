import 'dart:math';

import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:flutter/material.dart';

import 'package:provider/src/provider.dart';

class RecordChatItem extends StatelessWidget {
  final String textRecord;
  final bool isOwnerRoom;
  final String linkAvatar;
  final String name;
  final Color color;
  RecordChatItem({
    Key? key,
    required this.textRecord,
    required this.isOwnerRoom,
    required this.linkAvatar,
    required this.name,
    required this.color,
  }) : super(key: key);

  /// tính kích thước with height của một chuỗi String.
  Size calcTextSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textScaleFactor: WidgetsBinding.instance!.window.textScaleFactor,
    )..layout();
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Container(
      color: themeProvider.mode == ThemeMode.dark
          ? Colors.grey[850]
          : Colors.grey[100],
      child: isOwnerRoom
          ? _viewRecordChatOwner(context)
          : _viewRecordChatClient(context),
    );
  }

  ///View text của chủ phòng
  Widget _viewRecordChatOwner(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildAvatarCircle(linkAvatar, name, color),
          _viewChat(textRecord, true, context),
        ],
      ),
    );
  }

  ///View record chat của khách

  Widget _viewRecordChatClient(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _viewChat(
                textRecord,
                false,
                context,
              ),
              const SizedBox(
                width: 5,
              ),
              _buildAvatarCircle(linkAvatar, name, color)
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  List<Color> colors = [
    Colors.red,
    Colors.yellow,
    Colors.pink,
    Colors.purple,
    Colors.lime,
    Colors.green,
    Colors.black,
  ];
  Random random = Random();

  ///View avatar
  Widget _buildAvatarCircle(String imageUrl, String name, Color color) {
    return Container(
      height: 50,
      width: 50,
      child: imageUrl.isNotEmpty
          ? CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                imageUrl.contains('http')
                    ? imageUrl
                    : 'https://${Session().BASE_URL}/images/user_avatars/$imageUrl',
              ),
            )
          : Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
              child: Center(
                child: Text(
                  name.isNotEmpty ? '${name[0].toUpperCase()}' : 'A',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
    );
  }

  Widget _viewChat(String text, bool isOnw, BuildContext context) {
    return Row(
      mainAxisAlignment:
          isOnw ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        isOnw
            ? const SizedBox(
                width: 10,
              )
            : const SizedBox(),
        Container(
          width: MediaQuery.of(context).size.width / 1.5,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[350],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
              topLeft: !isOnw ? Radius.circular(20) : Radius.zero,
              topRight: isOnw ? Radius.circular(20) : Radius.zero,
            ),
          ),
          child: Align(
            alignment: isOnw ? Alignment.centerLeft : Alignment.centerRight,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        isOnw
            ? const SizedBox()
            : const SizedBox(
                width: 10,
              ),
      ],
    );
  }
}
