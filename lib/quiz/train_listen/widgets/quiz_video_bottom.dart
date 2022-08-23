import 'package:app_learn_english/quiz/train_listen/provider/quiz_video_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizVideoBottom extends StatelessWidget {
  const QuizVideoBottom({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Consumer<QuizVideoProvider>(
        builder: (ctx, quizVideoProvider, widget) =>
            quizVideoProvider.initialize
                ? Wrap(
                    alignment: WrapAlignment.start,
                    children: quizVideoProvider.elementConvert,
                  )
                : SizedBox(),
      ),
    );
  }
}
