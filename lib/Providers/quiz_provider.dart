import 'package:app_learn_english/models/quiz/talk_detail_quiz_model.dart';
import 'package:flutter/cupertino.dart';

class QuizProvider extends ChangeNotifier {
  String _textLanguageLocal = "";
  String _textLanguageEnglish = "";
  int count=0;

  String get textLanguageLocal => _textLanguageLocal;

  String get textLanguageEnglish => _textLanguageEnglish;

  void textLanguage(List<TalkDetailQuizModel> listQuiz){
    if(count<listQuiz.length){
     this._textLanguageLocal = listQuiz[count].contentVi!;
     this._textLanguageEnglish = listQuiz[count].content!;
      this.count++;
      notifyListeners();
    }
  }


}
