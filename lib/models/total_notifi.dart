class TotalNotifi {
  int? status;
  String? msg;
  int? total;

  TotalNotifi({this.status, this.msg, this.total});

  TotalNotifi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    data['total'] = this.total;
    return data;
  }
}