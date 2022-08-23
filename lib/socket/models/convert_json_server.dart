class ConvertJsonToServer {
  List<R>? r;

  ConvertJsonToServer({this.r});

  ConvertJsonToServer.fromJson(Map<String, dynamic> json) {
    if (json['r'] != null) {
      r = <R>[];
      json['r'].forEach((v) {
        r!.add(new R.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.r != null) {
      data['r'] = this.r!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class R {
  String? v;


  R({this.v});

  R.fromJson(Map<String, dynamic> json) {
    v = json['v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['v'] = this.v;
    return data;
  }
}
