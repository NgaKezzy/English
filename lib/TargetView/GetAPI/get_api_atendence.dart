import 'dart:convert';
import 'dart:io';

import 'package:app_learn_english/TargetView/models/attendance.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GetAttendance with ChangeNotifier {
  late Attendance? _items;

  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json'
  };

  Future<Attendance?> getDaysAttended(int uid, int year, int month) async {
    Uri uri = Uri.https(
      Session().BASE_URL,
      'FlowerAttendance/getDataAttendance',
    );
    Map<String, dynamic> params = {
      'uid': '$uid',
      'year': '$year',
      'month': '$month',
    };
    print(uri);
    try {
      final http.Response response = await http.post(uri, body: params);
      if (response.statusCode == 200) {
        print(response.body);
        final data = json.decode(response.body);

        Map<String, dynamic> dataCourse = data['dataAttendance'];
        _items = Attendance(
          amid: dataCourse['amid'],
          createdTime: dataCourse['createdtime'],
          daysAttendanced: dataCourse['day_attendanced'],
          month: dataCourse['month'],
          year: dataCourse['year'],
          recieved: dataCourse['recieved'],
          status: dataCourse['status'],
          uid: dataCourse['uid'],
          updatedTime: dataCourse['updatetime'],
        );

        printCyan('Lấy dữ liệu thành công');
        return _items;
      } else {
        print('get dữ liệu bị lỗi');
        return _items;
      }
    } catch (e) {
      print('Loi roi!!!!');
      throw e;
    }
  }

  Future<Attendance?> updateAttendanced(
      int uid, int year, int month, int day) async {
    Uri uri = Uri.https(
      Session().BASE_URL,
      'FlowerAttendance/attendance',
    );
    Map<String, dynamic> params = {
      'uid': '$uid',
      'year': '$year',
      'month': '$month',
      'day': '$day',
    };
    print(uri);
    try {
      final http.Response response = await http.post(uri, body: params);
      if (response.statusCode == 200) {
        print(response.body);
        final data = json.decode(response.body);
        Map<String, dynamic> dataCourse = data['dataAttendance'];
        _items = Attendance.fromJson(dataCourse);
        printCyan('Đã điểm danh thành công');
        return _items;
      } else {
        print('get dữ liệu bị lỗi');
        return _items;
      }
    } catch (e) {
      print('Loi roi!!!!');
      throw e;
    }
  }
}
