import 'dart:convert';
import 'dart:math';

import 'package:app_learn_english/Providers/theme_provider.dart';

import 'package:app_learn_english/dialog/widget/tutorial_screen.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/notification_model.dart';

import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:app_learn_english/presentation/notification/service/notification_service.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:date_field/date_field.dart';

class DialogNotification extends StatefulWidget {
  final DataTalk talkData;
  final String? hourNotifi;

  const DialogNotification({Key? key, required this.talkData, this.hourNotifi})
      : super(key: key);

  @override
  State<DialogNotification> createState() => _DialogNotificationState();
}

class _DialogNotificationState extends State<DialogNotification> {
  NotificationService? notificationService;

  DateTime currentDate = DateTime.now();
  DateTime? eventDate;

  TimeOfDay currentTime = TimeOfDay.now();
  TimeOfDay? eventTime;
  TimeOfDay? eventTimeItemVideo;
  int segmentedControlGroupValue = 0;
  bool isDaily = false;
  late NotificationModel notificationModel;

  @override
  void initState() {
    super.initState();
    notificationService = NotificationService();
    if (widget.hourNotifi != null) {
      eventTimeItemVideo = TimeOfDay(
          hour: int.parse(widget.hourNotifi!.split(":")[0]),
          minute: int.parse(widget.hourNotifi!.split(":")[1]));
    }
  }

  T getRandomElement<T>(List<T> list) {
    final random = new Random();
    var i = random.nextInt(list.length);
    return list[i];
  }

  Future<void> onCreate(BuildContext context) async {
    var listBodyRandom = [
      S.of(context).bodyNotification1,
      S.of(context).bodyNotification2,
      S.of(context).bodyNotification3,
      S.of(context).bodyNotification4,
      S.of(context).bodyNotification5
    ];
    var title = S.of(context).titleNotification + widget.talkData.name;

    notificationModel = await UserAPIs().getNotificationModel();
    int? isLocalNoti = notificationModel.datas?.isLocalNoti;
    if (isLocalNoti == 1) {
      await notificationService?.scheduleNotification(
          widget.talkData.id,
          title,
          getRandomElement(listBodyRandom),
          eventDate!,
          eventTime!,
          jsonEncode({
            "title": S.of(context).titleNotification,
            "eventDate": DateFormat("EEEE, d MMM y").format(eventDate!),
            "eventTime": eventTime!.format(context),
          }),
          DateTimeComponents.time);
      Navigator.pop(context, eventTime);
      resetForm();
    } else {
      Navigator.pop(context, eventTime);
    }
  }

  dialogContent(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: new BoxDecoration(
        color: themeProvider.mode == ThemeMode.dark
            ? Color.fromRGBO(42, 44, 50, 1)
            : Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        // To make the card compact
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              S.of(context).timerQuestion,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16.0),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    S.of(context).dateAndTime,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return TutorialScreen();
                        });
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    // child: Image.asset(
                    //   'assets/images/list_learn.png',
                    //   width: 20.0,
                    // ),
                    child: Icon(
                      Icons.alarm,
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 32.0),
          // GestureDetector(
          //   onTap: selectEventTime,
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16),
          //     child: TimeField(
          //         eventTime:
          //             (eventTime != null) ? eventTime : eventTimeItemVideo),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: themeProvider.mode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black12,
                ),
              ),
              child: DateTimeFormField(
                decoration: InputDecoration(
                  // hintStyle: TextStyle(color: AppColors.text),
                  // hintStyle: TextStyle(color: Colors.black),
                  errorStyle: TextStyle(color: Colors.redAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 16),
                    // child: SvgPicture.asset(AssetPath.ic_lich),
                    child: Icon(
                      Icons.date_range,
                      color: Colors.blue,
                    ),
                  ),
                  // filled: true,
                  fillColor: Colors.black,
                  // hintText: StringConst.inputDate,
                  hintText: S.of(context).SelectDateTime,
                ),
                firstDate: DateTime.now(),
                // lastDate:
                //     DateTime.now().add(const Duration(days: 40)),
                initialDate: DateTime.now(),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (DateTime? e) => (e?.day ?? 0) == 1 ? '' : null,
                // validator: (value) =>
                //     Validator.requiredInputExpiryDateValidator(
                //         value),
                onDateSelected: (DateTime value) {
                  print(value);
                  eventDate = value;
                  // model.postsArticlesModel.expiryDate.value = value;
                },
              ),
            ),
          ),
          SizedBox(height: 30.0),
          Align(
            alignment: Alignment.bottomRight,
            child: buildWidgetsBottom(),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  void resetForm() {
    eventDate = null;
  }

  Widget buildWidgetsBottom() {
    var themeProvider = context.watch<ThemeProvider>();
    return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
      String lang = provider.locale!.languageCode;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Container(
                width: 120,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black12,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Center(
                  child: Text(
                    S.of(context).cancel,
                    style: TextStyle(
                        color: themeProvider.mode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (eventDate != null) {
                onCreate(context);
                // Fluttertoast.showToast(
                //   msg: S.of(context).installSuccessfulNotification,
                // );
                Navigator.pop(context);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                width: 120,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Center(
                  child: Text(
                    S.of(context).create,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
