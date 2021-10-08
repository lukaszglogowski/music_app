import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/modules/radio/radio_player.dart';

class JustAudioPlayer extends RadioPlayer {
  final audioPlayer = AudioPlayer();
  var _isUrlSet = false;

  @override
  Future<void> pause() {
    return audioPlayer.pause();
  }

  @override
  Future<void> play({required String url}) async {
    if (!_isUrlSet) {
      await audioPlayer.setUrl(url);
      _isUrlSet = true;
    }
    return audioPlayer.play();
  }
}


