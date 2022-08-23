import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class TextNameWidget extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final Icon icon;
  const TextNameWidget({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.icon,
  }) : super(key: key);

  @override
  _TextNameWidgetState createState() => _TextNameWidgetState(
      controller: controller, labelText: labelText, icon: icon);
}

class _TextNameWidgetState extends State<TextNameWidget> {
  final TextEditingController controller;
  final String labelText;
  final Icon icon;
  _TextNameWidgetState(
      {Key? key,
      required this.controller,
      required this.labelText,
      required this.icon});
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: themeProvider.mode == ThemeMode.dark
                ? Color.fromRGBO(24, 26, 33, 1)
                : Colors.white38.withOpacity(0.6),
        ),
        child: TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            fillColor: Colors.white38.withOpacity(0.6),
            hintText: labelText,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                width: 1,
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                width: 1,
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
            prefixIcon: icon,
          ),
          validator: (password) => password != null && password.length > 24
              ? "kiểm tra lại tên đã đổi!"
              : (RegExp(r'^[A-Za-z0-9_.].{6,}$')
                          .hasMatch(password.toString()) ==
                      true
                  ? null
                  : S.of(context).LengthFrom6To24Characters),
        ));
  }
}
