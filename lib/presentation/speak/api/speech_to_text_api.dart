import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechApi {
  static final _speech = SpeechToText();

  static SpeechToText get speech => _speech;

  static Future<bool> toggleRecording({
    required Function onResult,
    required ValueChanged onListening,
  }) async {
    if (_speech.isListening) {
      _speech.stop();
      return true;
    }

    final isAvailable = await _speech.initialize(
      onStatus: (status) {
        onListening(status);
        print('Đây là status : $status');
      },
      onError: (e) {},
    );

    if (isAvailable) {
      _speech.listen(onResult: (value) {
        onResult(value);
      });
    }

    return isAvailable;
  }
}
