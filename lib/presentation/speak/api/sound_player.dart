// import 'dart:convert';

// import 'package:flutter/widgets.dart';
// import 'package:flutter_sound_lite/flutter_sound.dart';

// class SoundPlayer {
//   FlutterSoundPlayer? _audioPlayer;

//   bool get isPlaying => _audioPlayer!.isPlaying;

//   Future init() async {
//     _audioPlayer = FlutterSoundPlayer();

//     await _audioPlayer!.openAudioSession();
//   }

//   void dispose() {
//     _audioPlayer!.openAudioSession();
//     _audioPlayer = null;
//   }

//   Future _play(VoidCallback whenFinished, String pathToReadAudio) async {
//     await _audioPlayer!.startPlayer(
//       fromURI: pathToReadAudio,
//       codec: Codec.aacADTS,
//       whenFinished: whenFinished,
//     );
//   }

//   Future _stop() async {
//     await _audioPlayer!.stopPlayer();
//   }

//   Future togglePlaying({
//     required VoidCallback whenFinished,
//     required String pathToReadAudio,
//   }) async {
//     if (_audioPlayer!.isStopped) {
//       await _play(whenFinished, pathToReadAudio);
//     } else {
//       await _stop();
//     }
//   }
// }
