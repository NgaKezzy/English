import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/presentation/speak/widgets/practice_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class PracticeSceen extends StatefulWidget {
  static const routeName = '/practice';
  final String idText;
  final String title;
  final Function restartSpeaking;

  const PracticeSceen({
    Key? key,
    required this.idText,
    required this.title,
    required this.restartSpeaking,
  }) : super(key: key);

  @override
  _PracticeSceenState createState() => _PracticeSceenState();
}

class _PracticeSceenState extends State<PracticeSceen> {
  @override
  void dispose() {
    widget.restartSpeaking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          S.of(context).PracticeSpeaking,
          style: TextStyle(
            fontSize: 18,
            color: themeProvider.mode == ThemeMode.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios_outlined,
            color: themeProvider.mode == ThemeMode.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        backgroundColor: themeProvider.mode == ThemeMode.dark
            ? Color.fromRGBO(45, 48, 57, 1)
            : Colors.grey[100],
      ),
      body: Column(
        children: [
          Divider(
              thickness: 1,
              color: themeProvider.mode == ThemeMode.dark
                  ? Colors.grey.shade700
                  : Color(0xFFE4E4E4),
              height: 1),
          Expanded(
            child: Container(
              color: themeProvider.mode == ThemeMode.dark
                  ? Color.fromRGBO(24, 26, 33, 1)
                  : Colors.white,
              child: PracticeBox(
                idTalkText: widget.idText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
