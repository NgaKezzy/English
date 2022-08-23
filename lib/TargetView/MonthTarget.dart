import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/TargetView/GetAPI/get_api_atendence.dart';
import 'package:app_learn_english/TargetView/models/attendance.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:app_learn_english/presentation/home/component/eventCalendar.dart';
import 'package:app_learn_english/utils/config_heart_utils.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'package:table_calendar/table_calendar.dart';

class MonthTarget extends StatefulWidget {
  final Function playAnim;

  const MonthTarget({
    Key? key,
    required this.playAnim,
  }) : super(key: key);
  @override
  State<MonthTarget> createState() => _MonthTargetState();
}

class _MonthTargetState extends State<MonthTarget> {
  late Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  bool _isLoadingAttendance = true;
  late Attendance? getAttendance;
  late DataUser dataUser;

  @override
  void initState() {
    dataUser = DataCache().getUserData();
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isLoadingAttendance) {
      getAttendance = await GetAttendance().getDaysAttended(
        dataUser.uid,
        DateTime.now().year,
        DateTime.now().month,
      );

      print(getAttendance.toString());
    }
    setState(() {
      _isLoadingAttendance = false;
    });
  }

  Future showBoxAttendance(String text, int color) async {
    return showSimpleNotification(
      Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      background: color == 1 ? Colors.green[400] : Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      height: 520,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.4), width: 0.5),
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).MonthlyGoal,
            style: TextStyle(
              fontSize: 20,
              color: themeProvider.mode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TableCalendar(
            headerVisible: false,
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2050, 3, 14),
            focusedDay: focusedDay,
            calendarFormat: format,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            daysOfWeekVisible: false,
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, _) {
                if (!_isLoadingAttendance) {
                  for (var i = 0;
                      i < getAttendance!.daysAttendanced!.length;
                      i++) {
                    if (DateTime.utc(
                          getAttendance!.year!,
                          getAttendance!.month!,
                          int.parse('${getAttendance!.daysAttendanced![i]}'),
                        ) ==
                        date) {
                      return const Icon(
                        Icons.check,
                        // color: Color.fromRGBO(83, 180, 81, 1),
                        color: Colors.blue,
                      );
                    } else {
                      const SizedBox();
                    }
                  }
                }
              },
            ),
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = selectDay;
                focusedDay = focusDay;
              });
              print(focusDay);
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },
            onPageChanged: (focusDay) async {
              var updateAttendanced = await GetAttendance().getDaysAttended(
                dataUser.uid,
                focusDay.year,
                focusDay.month,
              );
              setState(() {
                getAttendance = updateAttendanced;
                focusedDay = focusDay;
              });
            },
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  style: BorderStyle.solid,
                  color: Colors.black,
                ),
                shape: BoxShape.circle,
                color: Color.fromRGBO(83, 180, 81, 1),
              ),
              selectedTextStyle: TextStyle(color: Colors.black),
              todayDecoration: BoxDecoration(
                color: Colors.red,
                // border: Border.all(
                //   width: 0.5,
                //   style: BorderStyle.solid,
                //   color: Colors.black,
                // ),
                shape: BoxShape.circle,
              ),
              defaultDecoration: BoxDecoration(
                color: Colors.grey.shade300,

                // border: Border.all(
                //   width: 0.5,
                //   style: BorderStyle.solid,
                //   color: Colors.black,
                // ),
                shape: BoxShape.circle,
              ),
              weekendDecoration: BoxDecoration(
                color: Colors.grey.shade300,

                // border: Border.all(
                //   width: 0.5,
                //   style: BorderStyle.solid,
                //   color: Colors.black,
                // ),
                shape: BoxShape.circle,
              ),
              holidayDecoration: BoxDecoration(
                // border: Border.all(
                //   width: 0.5,
                //   style: BorderStyle.solid,
                //   color: Colors.black,
                // ),
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              leftChevronVisible: false,
              rightChevronVisible: false,
              formatButtonDecoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5.0),
              ),
              formatButtonTextStyle: TextStyle(color: Colors.black),
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Center(
            child: Container(
              width: 130,
              height: 40,
              decoration: BoxDecoration(
                color: Color.fromRGBO(
                  83,
                  180,
                  81,
                  1,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () async {
                    bool check = true;
                    printRed(selectedDay.toString());
                    printCyan(getAttendance!.toJson().toString());
                    if (selectedDay.year == getAttendance!.year &&
                        selectedDay.month == getAttendance!.month) {
                      for (var i = 0;
                          i < getAttendance!.daysAttendanced!.length;
                          i++) {
                        if (int.parse(
                              '${getAttendance!.daysAttendanced![i]}',
                            ) ==
                            selectedDay.day) {
                          check = false;
                        }
                      }
                    }
                    if (check) {
                      if (selectedDay.year == DateTime.now().year &&
                          selectedDay.month == DateTime.now().month &&
                          selectedDay.day == DateTime.now().day) {
                        var hello = await GetAttendance().updateAttendanced(
                          dataUser.uid,
                          selectedDay.year,
                          selectedDay.month,
                          selectedDay.day,
                        );
                        setState(() {
                          getAttendance = hello;
                        });
                        print(getAttendance);
                        if (getAttendance != null) {
                          widget.playAnim();
                          showBoxAttendance(
                            S.of(context).YouHaveSuccessfullyRegisteredToday,
                            1,
                          );
                          var heart = await UserAPIs().addAndDivHeart(
                            username: dataUser.username,
                            uid: dataUser.uid,
                            typeAction: ConfigHeart.nhan_tim_tu_admob_cong_tim,
                          );

                          Provider.of<CountHeartProvider>(
                            context,
                            listen: false,
                          ).setCountHeart(heart);
                        } else {
                          showBoxAttendance(
                            S.of(context).TheAttendanceDateIsOver,
                            0,
                          );
                        }
                      } else {
                        showBoxAttendance(
                          S.of(context).YouHaveAlreadyRegistered,
                          0,
                        );
                      }
                    } else {
                      showBoxAttendance(
                        S.of(context).YouHaveAlreadyRegistered,
                        0,
                      );
                    }
                  },
                  child: Text(
                    S.of(context).Attendance,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
