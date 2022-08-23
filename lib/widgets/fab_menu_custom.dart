import 'package:app_learn_english/Providers/TargetProvider.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/TargetView/TargetScreen.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class FABMenuCustom extends StatefulWidget {
  final double fabSize = 70;
  final double fabElevation = 8;
  final Function callbackTarget;
  FABMenuCustom({Key? key, required this.callbackTarget}) : super(key: key);
  Widget? fabChild;
  @override
  State<StatefulWidget> createState() {
    return FABMenuCustomState();
  }
}

void getToTarget(BuildContext context) {
  printCyan("Callback");
  Navigator.of(context).pushNamed(TargetScreen.routeName);
}

class FABMenuCustomState extends State<FABMenuCustom>
    with SingleTickerProviderStateMixin {
  Offset _offset = Offset(0, 50);
  double size = 250 * 0.3;
  double percent = 0.0;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Consumer<TargetProvider>(
        builder: (context, targetProvider, snapshot) {
      return Positioned(
        right: _offset.dx,
        bottom: _offset.dy,
        child: Container(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanUpdate: (details) {
              _offset -= details.delta;
              if (_offset.dx < 0) {
                _offset = Offset(0, _offset.dy);
              }
              if (_offset.dx > width - size) {
                _offset = Offset(width - size, _offset.dy);
              }

              if (_offset.dy < 0) {
                _offset = Offset(_offset.dx, 0);
              }
              if (_offset.dy > height - size) {
                _offset = Offset(_offset.dx, height - size);
              }
              (context as Element).markNeedsBuild();
            },
            child: Container(
              width: widget.fabSize,
              height: widget.fabSize,
              child: RawMaterialButton(
                fillColor: Colors.white,
                shape: CircleBorder(),
                elevation: widget.fabElevation,
                onPressed: () {
                  widget.callbackTarget();
                },
                child: Center(
                  child: CircularPercentIndicator(
                      radius: 70,
                      lineWidth: 3.0,
                      animation: false,
                      percent:
                          (((targetProvider.count! / (10 * 60)) * 100) / 100) %
                              1,
                      center: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/linh_vat/linhvat2.png',
                              fit: BoxFit.contain,
                              width: 40,
                            ),
                          ],
                        ),
                      ),
                      linearGradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: <Color>[
                            Color(0xFF1AB600),
                            Color(0xFF6DD400)
                          ]),
                      backgroundColor: Colors.grey.shade200,
                      rotateLinearGradient: true,
                      circularStrokeCap: CircularStrokeCap.round),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
