import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModeToggleButton extends StatefulWidget {
  @override
  _ModeToggleButtonState createState() => _ModeToggleButtonState();
}

class _ModeToggleButtonState extends State<ModeToggleButton> {
  Size get s => MediaQuery.of(context).size * 0.7;
  int isOn = 0;

  @override
  Widget build(BuildContext context) {
    bool _darkModeEnabled = Theme.of(context).brightness == Brightness.dark;
    _darkModeEnabled ? isOn = 1 : isOn = 0;
    return AnimatedContainer(
      duration: Duration(milliseconds: 360),
      width: s.width / 2,
      height: s.height / 4,
      color: Colors.transparent,
      child: Center(
        child: GestureDetector(
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            HapticFeedback.mediumImpact();
            Provider.of<ThemeProvider>(context, listen: false)
                .toggleMode(prefs);
            prefs.setBool(
                'isDarkMode',
                Provider.of<ThemeProvider>(context, listen: false).mode ==
                        ThemeMode.dark
                    ? true
                    : false);
            setState(() {
              isOn == 0 ? isOn = 1 : isOn = 0;
            });
          },
          child: Container(
            width: s.width / 4,
            height: s.width * 0.125,
            decoration: BoxDecoration(
              color: Color(0xff27173A),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Stack(
              children: <Widget>[
                AnimatedPositioned(
                  duration: Duration(milliseconds: 360),
                  top: 0,
                  left: 0 + (s.width * 0.125) * isOn,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: s.width * 0.125 - 20,
                      height: s.width * 0.125 - 20,
                      decoration: BoxDecoration(
                        color: Color(0xffFFC209),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 360),
                  top: isOn == 0 ? (s.width * 0.125 - 8) / 2 : 8,
                  left: 0 + (s.width * 0.125 - 8) * isOn,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 360),
                    width: 8 + (s.width * 0.125 - 15) * isOn,
                    height: 8 + (s.width * 0.125 - 15) * isOn,
                    decoration: BoxDecoration(
                      color: Color(0xff27173A),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
