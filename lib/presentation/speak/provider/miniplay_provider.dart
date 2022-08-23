import 'package:app_learn_english/models/TalkModel.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MiniPLayProvider with ChangeNotifier {
  bool _isMiniPlay = false;
  bool _isReady = false;
  DataTalk? _talkData;
  int _timePlay = 0;
  YoutubePlayerController? _controller;
  bool? get isMiniPlay => _isMiniPlay;
  bool? get isReady => _isReady;

  DataTalk? get talkData => _talkData;
  int? get timePlay => _timePlay;
  YoutubePlayerController? get controller => _controller;
  bool isPlay = true;

  Future<void> startMiniPlay(DataTalk data, int time) async {
    isPlay = true;
    _isMiniPlay = true;
    _talkData = data;
    _timePlay = time;
    _controller = YoutubePlayerController(
      initialVideoId: _talkData!.yt_id,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        hideControls: true,
      ),
    );
    notifyListeners();
  }

  Future<void> endMiniPlay() async {
    _isMiniPlay = false;
    _timePlay = 0;
    isPlay = false;
    notifyListeners();
  }

  Future<void> onReady() async {
    _isReady = true;
    notifyListeners();
  }

  Future<void> onCancelVideo() async {
    _isReady = false;
    notifyListeners();
  }

  Future<void> pauseMiniVideo() async {
    isPlay = false;
    notifyListeners();
  }

  Future<void> playMiniVideo() async {
    isPlay = true;
    notifyListeners();
  }
}
