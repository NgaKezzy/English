import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/presentation/speak/widgets/conversation_box.dart';

import 'package:flutter/material.dart';

import 'package:provider/src/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ShowMessageNotify extends StatelessWidget {
  final String message;
  final CheckVoiceState stateVoice;
  final SpeechToText speechToText;
  const ShowMessageNotify({
    Key? key,
    required this.message,
    required this.stateVoice,
    required this.speechToText,
  }) : super(key: key);

  Widget buildStateFunctionWidget(BuildContext ctx) {
    if (stateVoice == CheckVoiceState.NotRecognized) {
      return Align(
        child: InkWell(
            onTap: () async {
              Navigator.pop(ctx);
              // dialogProvider.setClickItem(false);
            },
            child: ElevatedButton(
              child: Text(S.of(ctx).Retry),
              onPressed: () {
                Navigator.pop(ctx);
              },
            )),
        alignment: Alignment.center,
      );
    } else if (stateVoice == CheckVoiceState.Wrong) {
      return Align(
        child: InkWell(
            onTap: () async {
              Navigator.pop(ctx);
            },
            child: ElevatedButton(
              child: Text(S.of(ctx).Continue),
              onPressed: () {
                Navigator.pop(ctx);
              },
            )),
        alignment: Alignment.center,
      );
    } else {
      return Align(
        child: InkWell(
            onTap: () async {
              Navigator.pop(ctx);
            },
            child: ElevatedButton(
              child: Text(S.of(ctx).Close),
              onPressed: () {
                Navigator.pop(ctx);
              },
            )),
        alignment: Alignment.center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              child: InkWell(
                onTap: () async {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close_sharp,
                  size: 30,
                ),
              ),
              alignment: Alignment.centerRight,
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              child: Text(
                message,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: stateVoice == CheckVoiceState.NotRecognized
                      ? Colors.red
                      : Colors.green[400],
                ),
              ),
              alignment: Alignment.center,
            ),
            buildStateFunctionWidget(context),
          ],
        ),
      ),
    );
  }
}
