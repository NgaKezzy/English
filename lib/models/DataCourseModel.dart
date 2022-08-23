import 'package:app_learn_english/models/CategoryModel.dart';

class CourseModel {
  List<Category> listCourse;
  CourseModel({required this.listCourse});
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
        listCourse: json['dataCourse'] != null
            ? json['dataCourse'].map<Category>((json) {
                return Category.fromJson(json);
              }).toList()
            : []);
  }
  Map toJson() => {'listCourse': this.listCourse};
}
