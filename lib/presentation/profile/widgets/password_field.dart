import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/src/provider.dart';

class PasswordFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  const PasswordFieldWidget(
      {Key? key, required this.controller, required this.labelText})
      : super(key: key);
  @override
  _PasswordFieldWidgetState createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
  bool isHidden = true;
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white38.withOpacity(0.6),
        ),
        child: TextFormField(
          style: TextStyle(
            fontSize: 18,
          ),
          controller: widget.controller,
          keyboardType: TextInputType.visiblePassword,
          obscureText: isHidden,
          decoration: InputDecoration(
            fillColor: themeProvider.mode == ThemeMode.dark
                ? const Color.fromRGBO(42, 44, 50, 1)
                : Colors.white.withOpacity(1),
            filled: true,
            hintText: widget.labelText,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(
                width: 1,
                color: Colors.grey.withOpacity(0.3),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 25),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(
                width: 1,
                color: Colors.grey.withOpacity(0.3),
              ),
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              child: SvgPicture.asset(
                'assets/new_ui/more/Iconly-Light-Lock.svg',
              ),
            ),
            suffixIcon: InkWell(
              child: isHidden
                  ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 18),
                      child: SvgPicture.asset(
                        'assets/new_ui/more/Iconly-Light-Hide.svg',
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 18),
                      child: SvgPicture.asset(
                        'assets/new_ui/more/Iconly-Light-Show.svg',
                      ),
                    ),
              onTap: togglePass,
            ),
            prefixIconConstraints: BoxConstraints(
              minHeight: 30,
            ),
            suffixIconConstraints: BoxConstraints(
              minHeight: 30,
            ),
          ),
          // validator: (password) => password != null && password.length < 6
          //     ? "Kiểm tra lại mật khẩu đã nhập"
          //     : (RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$")
          //                 .hasMatch(password.toString()) ==
          //             true
          //         ? null
          //         : "Mật khẩu tối thiểu gồm 6 kí tự,có cả chữ và số"),
        ));
  }

  togglePass() => setState(() => isHidden = !isHidden);
}
