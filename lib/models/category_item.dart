class CatrgoryItem {
  int id;
  String name;
  String TotalQuestion;

  CatrgoryItem({
    required this.id,
    required this.name,
    required this.TotalQuestion,
  });

  factory CatrgoryItem.fromJson(Map<dynamic, dynamic> json) {
    final user = CatrgoryItem(
      id: int.parse('${json['id']}'),
      name: json['name'],
      TotalQuestion: json['TotalQuestion'],
    );

    return user;
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'TotalQuestion': TotalQuestion,
      };
}
