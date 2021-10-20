import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/modules/radio/radio_player.dart';

// This class takes care of playing and pausing current radio station.

class JustAudioPlayer extends RadioPlayer {
  final _audioPlayer = AudioPlayer();
  
  @override
  Future<void> pause() {
    return _audioPlayer.pause();
  }

  @override
  Future<void> play() async {
    return _audioPlayer.play();
  }

  @override
  Future<void> setUrl(String url) {
    return _audioPlayer.setUrl(url);
  }
}


