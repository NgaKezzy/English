import 'dart:developer';

import 'package:app_learn_english/models/quiz/talk_detail_quiz_model.dart';
import 'package:app_learn_english/models/quiz/talk_quiz_model.dart';

class QuizModel {
  int? status;
  TalkQuizModel? talk;
  List<TalkDetailQuizModel>? talkDetailQuiz;

  QuizModel({this.status, this.talk, this.talkDetailQuiz});

  QuizModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    talk = json['talk'] != null ? new TalkQuizModel.fromJson(json['talk']) : null;
    if (json['talkDetail'] != null) {
      talkDetailQuiz = <TalkDetailQuizModel>[];
      json['talkDetail'].forEach((v) {
        talkDetailQuiz!.add(new TalkDetailQuizModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.talk != null) {
      data['talk'] = this.talk!.toJson();
    }
    if (this.talkDetailQuiz != null) {
      data['talkDetail'] = this.talkDetailQuiz!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}