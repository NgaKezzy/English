import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PersonalAchievements extends StatefulWidget {
  const PersonalAchievements({Key? key}) : super(key: key);

  @override
  _PersonalAchievementsState createState() => _PersonalAchievementsState();
}

class _PersonalAchievementsState extends State<PersonalAchievements> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SafeArea(
      child: Container(
        width: width,
        decoration: BoxDecoration(
          // image: DecorationImage(
          //     image: AssetImage('assets/images/background.png'),
          //     fit: BoxFit.fill)
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade700,
              Colors.tealAccent.shade400,
            ],
          ),
        ),
        child: ListView(
          children: [
            SizedBox(
              height: 12,
            ),
            Expanded(
              child: Row(children: [
                InkWell(
                  onTap: () => {
                    Navigator.pop(context),
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 25,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Thành tích cá nhân',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
              ]),
            ),
            SizedBox(
              height: 16,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.greenAccent.shade700.withOpacity(0.6),
                              Colors.tealAccent.shade200.withOpacity(0.6),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Đang tiến hành',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 1.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/Profile/icon_camera.png',
                                      height: 62,
                                      width: 60,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Ăn ảnh',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Cập nhật avatar',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    LinearPercentIndicator(
                                      width: 250,
                                      animation: true,
                                      lineHeight: 15.0,
                                      animationDuration: 2000,
                                      percent: 0.5,
                                      center: Text(
                                        "50.0%",
                                        style: new TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      linearStrokeCap: LinearStrokeCap.roundAll,
                                      backgroundColor: Colors.white,
                                      progressColor: Colors.green,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 1.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/Profile/icon_thanhtich_chamchi.png',
                                        height: 62,
                                        width: 60,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Chăm chỉ',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Expanded(
                                          child: Text(
                                            '3 ngày hoàn thàh mục tiêu liên tục',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        LinearPercentIndicator(
                                          width: 250,
                                          animation: true,
                                          lineHeight: 15.0,
                                          animationDuration: 2000,
                                          percent: 0.5,
                                          center: Text(
                                            "50.0%",
                                            style: new TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black,
                                                fontStyle: FontStyle.italic),
                                          ),
                                          linearStrokeCap:
                                              LinearStrokeCap.roundAll,
                                          backgroundColor: Colors.white,
                                          progressColor: Colors.green,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 1.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/Profile/icon_thanhtich_chienbinh.png',
                                      height: 62,
                                      width: 60,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Chiến binh',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Học xong 10 video',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    LinearPercentIndicator(
                                      width: 250,
                                      animation: true,
                                      lineHeight: 15.0,
                                      animationDuration: 2000,
                                      percent: 0.5,
                                      center: Text(
                                        "50.0%",
                                        style: new TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      linearStrokeCap: LinearStrokeCap.roundAll,
                                      backgroundColor: Colors.white,
                                      progressColor: Colors.green,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 1.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/Profile/icon_thanhtich_thienxa.png',
                                      height: 62,
                                      width: 60,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Thiện xạ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Hoàn thành 3 bài speak',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    LinearPercentIndicator(
                                      width: 250,
                                      animation: true,
                                      lineHeight: 15.0,
                                      animationDuration: 2000,
                                      percent: 0.5,
                                      center: Text(
                                        "50.0%",
                                        style: new TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      linearStrokeCap: LinearStrokeCap.roundAll,
                                      backgroundColor: Colors.white,
                                      progressColor: Colors.green,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 1.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/Profile/icon_thanhtich_hocgia.png',
                                      height: 62,
                                      width: 60,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Học giả',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'học 50 từ vựng mới',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    LinearPercentIndicator(
                                      width: 250,
                                      animation: true,
                                      lineHeight: 15.0,
                                      animationDuration: 2000,
                                      percent: 0.5,
                                      center: Text(
                                        "50.0%",
                                        style: new TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      linearStrokeCap: LinearStrokeCap.roundAll,
                                      backgroundColor: Colors.white,
                                      progressColor: Colors.green,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 1.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/Profile/icon_thanhtich_dungsicuoituan.png',
                                      height: 62,
                                      width: 60,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Dũng sĩ cuối tuần',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Hoàn thành 1 bài học vào thứ 7 hoặc chủ nhật',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    LinearPercentIndicator(
                                      width: 250,
                                      animation: true,
                                      lineHeight: 15.0,
                                      animationDuration: 2000,
                                      percent: 0.5,
                                      center: Text(
                                        "50.0%",
                                        style: new TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      linearStrokeCap: LinearStrokeCap.roundAll,
                                      backgroundColor: Colors.white,
                                      progressColor: Colors.green,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
