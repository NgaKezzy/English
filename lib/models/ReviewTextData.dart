import 'package:app_learn_english/models/TextReviewModel.dart';
import 'package:scoped_model/scoped_model.dart';

class DataTextReview extends Model {
  List<TextReview> textReview;
  DataTextReview({
    required this.textReview,
  });
  factory DataTextReview.fromJson(Map<String, dynamic> json) {
    List<TextReview> dataArray = [];
    DataTextReview(
        textReview: json['listTextReview'].forEach((data) {
      if (data.runtimeType != List) {
        dataArray.add(TextReview.fromJson(data));
      }
    }));
    return DataTextReview(textReview: dataArray);
  }
  Map toJson() => {
        'textReview': this.textReview,
      };
}
