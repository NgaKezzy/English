import 'package:app_learn_english/models/TalkModel.dart';

import 'package:app_learn_english/networks/DataOffline.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';

import 'package:app_learn_english/screens/new_play_video_screen_max.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../main.dart';

class NotificationService {
  // Singleton pattern

  static NotificationService? _singleton;

  NotificationService._internal();

  factory NotificationService() {
    return _singleton ??= NotificationService._internal();
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotificationLocal() async {
    final AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("linhvat2");

    final IOSInitializationSettings iOSInitializationSettings =
        IOSInitializationSettings(
      defaultPresentAlert: false,
      defaultPresentBadge: false,
      defaultPresentSound: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    // *** Initialize timezone here ***
    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
  }

  Future<void> requestIOSPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> onSelectNotification(String? payload) async {
    int idTalk = await DataOffline().getIDDataTalk("uidDataTalk");
    DataTalk? dataTalk = await TalkAPIs().detailVideo(id: idTalk.toString());
    navigator.currentState!.push(
      MaterialPageRoute(
        builder: (context) => NewPlayVideoScreenNormal(
          false,
          dataTalk: dataTalk!,
          percent: 1,
          ytId: '',
          enablePop: true,
        ),
      ),
    );
  }

  Future<void> scheduleNotification(int id, String title, String body,
      DateTime eventDate, TimeOfDay eventTime, String payload,
      [DateTimeComponents? dateTimeComponents]) async {
    final scheduledTime = eventDate.add(Duration(
      hours: eventTime.hour,
      minutes: eventTime.minute,
    ));
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'second channel ID', 'second Channel title', 'second channel body',
            priority: Priority.max, importance: Importance.max, ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails(
      sound: 'default.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: payload,
      matchDateTimeComponents: dateTimeComponents,
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> notificationAfterSec(
      TimeOfDay timeOfDay, String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'second channel ID', 'second Channel title', 'second channel body',
            priority: Priority.high,
            importance: Importance.max,
            ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);
    var time = Time(timeOfDay.hour, timeOfDay.minute, 0);
    // ignore: deprecated_member_use
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        1, title, body, time, notificationDetails);
  }
}
