// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/material.dart';
import 'package:music_app/modules/library_music/song_progress.dart';


class BottomPanel extends StatelessWidget {
  var audioManagerInstance = AudioManager.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SongProgress(),
        ),
        Container(
          height: 80,
          padding: EdgeInsets.symmetric(vertical: 16),
          color: Theme.of(context).primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircleAvatar(
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.skip_previous,
                    ),
                    onPressed: () => audioManagerInstance.previous(),
                  ),
                ),
                backgroundColor: Theme.of(context).backgroundColor,
              ),
              CircleAvatar(
                radius: 30,
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      audioManagerInstance.isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 20,
                    ),
                    padding: EdgeInsets.all(0.0),
                    onPressed: () async {
                      audioManagerInstance.playOrPause();
                    },
                  ),
                ),
                backgroundColor: Theme.of(context).backgroundColor
              ),
              CircleAvatar(
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.skip_next,
                    ),
                    onPressed: () => audioManagerInstance.next(),
                  ),
                ),
                backgroundColor: Theme.of(context).backgroundColor
              ),
            ],
          ),
        ),
      ],
    );
  }
}






