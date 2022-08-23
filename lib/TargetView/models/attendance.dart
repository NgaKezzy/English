class Attendance {
  final int? amid;
  final int? uid;
  final int? month;
  final int? year;
  final List<dynamic>? daysAttendanced;
  final String? createdTime;
  final String? updatedTime;
  final int? status;
  final int? recieved;

  Attendance({
    required this.amid,
    required this.uid,
    required this.month,
    required this.year,
    required this.daysAttendanced,
    required this.createdTime,
    required this.updatedTime,
    required this.status,
    required this.recieved,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        amid: json['amid'],
        uid: json['uid'],
        month: json['month'],
        year: json['year'],
        daysAttendanced: json['day_attendanced'],
        createdTime: json['createdtime'],
        updatedTime: json['updatetime'],
        status: json['status'],
        recieved: json['recieved'],
      );

  Map<String, dynamic> toJson() => {
        'amid': amid,
        'uid': uid,
        'month': month,
        'year': year,
        'daysAttendanced': daysAttendanced,
        'createdTime': createdTime,
        'updatedTime': updatedTime,
        'status': status,
        'recieved': recieved,
      };
}
