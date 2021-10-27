// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/material.dart';



class SongProgress extends StatefulWidget {
  @override
  _SongProgressState createState() => _SongProgressState();
}

class _SongProgressState extends State<SongProgress> {
  var audioManagerInstance = AudioManager.instance;
  double _slider = 0.0;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    setupAudio();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        children: <Widget>[
          Text(
            _formatDuration(audioManagerInstance.duration),
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2,
                  thumbColor: Colors.black,
                  //overlayColor: Theme.of(context).colorScheme.secondary,
                  thumbShape: RoundSliderThumbShape(
                    disabledThumbRadius: 10,
                    enabledThumbRadius: 10,
                  ),
                  overlayShape: RoundSliderOverlayShape(
                    overlayRadius: 15,
                  ),
                  activeTrackColor: Colors.black,
                  inactiveTrackColor: Colors.grey[600],
                ),
                child: Slider(
                  value: _slider,
                  onChanged: (value) {
                    setState(() {
                      _slider = value;
                    });
                  },
                  onChangeEnd: (value) {
                    if (audioManagerInstance.duration != null) {
                      Duration msec = Duration(
                          milliseconds:
                              (audioManagerInstance.duration.inMilliseconds *
                                      value)
                                  .round());
                      audioManagerInstance.seekTo(msec);
                    }
                  },
                ),
              ),
            ),
          ),
          Text(
            _formatDuration(audioManagerInstance.duration),
            style: Theme.of(context).textTheme.bodyText1,
          )
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration == null) {
      return "--:--";
    }

    int minute = duration.inMinutes;
    int second = (duration.inSeconds > 60)
        ? (duration.inSeconds % 60)
        : duration.inSeconds;
    String format = ((minute < 10) ? "0$minute" : "$minute") +
        ":" +
        ((second < 10) ? "0$second" : "$second");
    return format;
  }


  void setupAudio() {
    audioManagerInstance.onEvents((events, args) {
      switch (events) {
        case AudioManagerEvents.start:
          _slider = 0;
          break;
        case AudioManagerEvents.seekComplete:
          _slider = audioManagerInstance.position.inMilliseconds / audioManagerInstance.duration.inMilliseconds;
          setState(() {});
          break;
        case AudioManagerEvents.playstatus:
          isPlaying = audioManagerInstance.isPlaying;
          setState(() {});
          break;
        case AudioManagerEvents.timeupdate:
          _slider = audioManagerInstance.position.inMilliseconds / audioManagerInstance.duration.inMilliseconds;
          audioManagerInstance.updateLrc(args["position"].toString());
          setState(() {});
          break;
        case AudioManagerEvents.ended:
          audioManagerInstance.next();
          setState(() {});
          break;
        default:
          break;
      }
    });
  }
}






