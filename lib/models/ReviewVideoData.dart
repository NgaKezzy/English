import 'package:app_learn_english/models/VideoReviewModel.dart';
import 'package:scoped_model/scoped_model.dart';

class DataVideoReview extends Model {
  List<VideoReview> videoReview;

  DataVideoReview({
    required this.videoReview,
  });
  factory DataVideoReview.fromJson(Map<String, dynamic> json) {
    return DataVideoReview(
        videoReview: json['listVideoReview'].map<VideoReview>((json) {
      return VideoReview.fromJson(json);
    }).toList());
  }
  Map toJson() => {
        'videoReview': this.videoReview,
      };
}
