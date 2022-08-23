import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/src/provider.dart';

class SearchRoom extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final String hintText;

  const SearchRoom({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchRoom> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: themeProvider.mode == ThemeMode.dark
            ? Color.fromRGBO(42, 44, 50, 1)
            : Colors.white,
        border: Border.all(
            color: themeProvider.mode == ThemeMode.dark
                ? Colors.grey
                : Colors.black26),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            suffixIcon: widget.text.isNotEmpty
                ? GestureDetector(
                    child: Icon(Icons.close,
                        color: themeProvider.mode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black),
                    onTap: () {
                      controller.clear();
                      widget.onChanged('');
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  )
                : null,
            hintText: widget.hintText,
            hintStyle: themeProvider.mode == ThemeMode.dark
                ? TextStyle(color: Colors.white)
                : TextStyle(color: Colors.black),
            border: InputBorder.none,
          ),
          // style: style,
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
