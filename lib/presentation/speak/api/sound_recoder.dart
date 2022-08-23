// import 'package:app_learn_english/logError/LogCustom.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_sound_lite/flutter_sound.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:random_string/random_string.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:speech_to_text/speech_to_text.dart';

// class SoundRecoder {
//   FlutterSoundRecorder? _audioRecorder;
//   bool _isRecoderInitialised = false;

//   bool get isRecording => _audioRecorder!.isRecording;

//   Future init() async {
//     _audioRecorder = FlutterSoundRecorder();

//     final status = await Permission.microphone.request();

//     if (status != PermissionStatus.granted) {
//       throw RecordingPermissionException('Microphone permissions');
//     }

//     await _audioRecorder!.openAudioSession();
//     _isRecoderInitialised = true;
//   }

//   void dispose() {
//     _audioRecorder!.closeAudioSession();
//     _audioRecorder = null;
//     _isRecoderInitialised = false;
//   }

//   Future record(String pathToSaveAudio) async {
//     await _audioRecorder!.startRecorder(toFile: pathToSaveAudio);
//   }

//   Future stop() async {
//     if (!_isRecoderInitialised) return;

//     await _audioRecorder!.stopRecorder();
//   }

//   Future<void> toggleRecording({required String pathToSaveAudio}) async {
//     if (_audioRecorder!.isStopped) {
//       await record(pathToSaveAudio);
//     } else {
//       await stop();
//     }
//   }
// }
