class RecordModel {
  int? id;
  int? uid;
  int? heart;
  int? type;
  String? createdtime;
  int? typeAction;
  int? vid;
  int? timequiz;
  String? username;

  RecordModel({
    required this.id,
    required this.uid,
    required this.heart,
    required this.type,
    required this.createdtime,
    required this.typeAction,
    required this.vid,
    required this.timequiz,
    required this.username,
  });

  factory RecordModel.fromJson(Map<dynamic, dynamic> json) {
    final user = RecordModel(
      id: int.parse('${json['id']}'),
      uid: int.parse('${json['uid']}'),
      heart: int.parse('${json['heart']}'),
      type: int.parse('${json['type']}'),
      createdtime: json['createdtime'],
      typeAction: int.parse('${json['typeAction']}'),
      vid: int.parse('${json['vid']}'),
      timequiz: int.parse('${json['timequiz']}'),
      username: json['username'],
    );

    return user;
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'heart': heart,
        'type': type,
        'createdtime': createdtime,
        'typeAction': typeAction,
        'vid': vid,
        'timequiz': timequiz,
        'username': username,
      };
}
