class Inapps {
  final String? package;
  final int? usd;
  final int? stone;
  final String? save;
  final int? month;

  Inapps({
    required this.package,
    required this.usd,
    required this.stone,
    required this.save,
    required this.month,
  });

  factory Inapps.fromJson(Map<String, dynamic> json) {
    return Inapps(
      package: json['package'] ?? json['subscriptions'],
      usd: json['usd'],
      stone: json['stone'],
      month: json['monther'],
      save: json['save'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['package'] = this.package;
    data['usd'] = this.usd;
    data['stone'] = this.stone;
    return data;
  }
}
