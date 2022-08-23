// ignore_for_file: file_names

class ThemeItem {
  int id;
  String name;
  String TotalQuestion;

  ThemeItem({
    required this.id,
    required this.name,
    required this.TotalQuestion,
  });

  factory ThemeItem.fromJson(Map<dynamic, dynamic> json) {
    final user = ThemeItem(
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
