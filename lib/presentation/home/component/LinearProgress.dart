import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class LinearProgres extends StatefulWidget {
  @override
  _LinearProgresState createState() => _LinearProgresState();
}

class _LinearProgresState extends State<LinearProgres> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      height: 200,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1.5),
          color: Colors.white54.withOpacity(0.3),
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Đạt 50 kinh nghiệm để mở rương',
              style: TextStyle(
                  fontSize: 26,
                  color: Colors.black,
                  fontWeight: FontWeight.w800),
            ),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: LinearPercentIndicator(
                          width: 290,
                          animation: true,
                          lineHeight: 30.0,
                          animationDuration: 2000,
                          percent: 0.5,
                          center: Text(
                            "50.0%",
                            style: new TextStyle(fontSize: 16.0,
                                color: Colors.black,
                                fontStyle: FontStyle.italic),
                          ),
                          trailing: Image.asset(
                            'assets/images/gg.png',
                            fit: BoxFit.contain,
                          ),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          backgroundColor: Colors.white,
                          progressColor: Colors.green,
                        ),
                    ),
                  ],
                ),
              ],
            ),
            Text('25/50 kinh nghiệm',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),),
          ]),
    );
  }}