// ignore_for_file: import_of_legacy_library_into_null_safe, must_be_immutable, annotate_overrides, overridden_fields

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';


// This class takes care of playing choosen song and allows to manipulate it, as well as goint to next or previous track.
class MusicPlayer extends StatefulWidget {
  SongInfo songInfo;                                // songInfo contains metadata collected from song file.
  Function changeTrack;                             // changeTrack obviously allows to change current song into next or previous.
  final GlobalKey<MusicPlayerState> key;            // This is connection to MusicPlayerState class that manipulates current song.


  MusicPlayer({required this.songInfo, required this.changeTrack, required this.key}) : super(key: key);

  @override
  MusicPlayerState createState() => MusicPlayerState();
}


class MusicPlayerState extends State<MusicPlayer> {
  double minValue = 0.0, maxValue = 0.0, currentValue = 0.0;      // Values for custom Slider.
  String currentTime = '', endTime = '';                          // Values for showing song time under Slider.
  bool isPlaying = false;                                         // For checking if something is playing currently.
  final AudioPlayer player = AudioPlayer();                       // Initialization of AudioPlayer library.

  // Here MusicPlayerState is initilaized and provided with current song metadata.
  @override
  void initState() {
    super.initState();
    setSong(widget.songInfo);
  }

  // This is used to get rid of song metadata after its not usefull anymore.
  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  // This function sets up various data about current song.
  void setSong(SongInfo songInfo) async {
    widget.songInfo = songInfo;
    await player.setUrl(widget.songInfo.uri);
    currentValue = minValue;                                  // Place from where song starts playing.
    maxValue = player.duration!.inMilliseconds.toDouble();

    // Here initial start and end time values are set.
    setState(() {
      currentTime = getDuration(currentValue);
      endTime = getDuration(maxValue);
    });

    isPlaying = false;
    changeStatus();         // Here song is made to start playing immidiately after beeing loaded.

    // This method watches song current playtime (which can be manipulated by user)
    player.positionStream.listen((duration) { 
      currentValue = duration.inMilliseconds.toDouble();

      // If current song time is greater than maxValue, next song is beeing started.
      if(currentValue >= maxValue) {
        widget.changeTrack(true);
      }

      setState(() {
        currentTime = getDuration(currentValue);
      });
    });   
  }

  // This function takes song playtime and converts it to 'minutes:seconds' format.
  String getDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());

    return [duration.inMinutes, duration.inSeconds]
      .map((e) => e.remainder(60).toString().padLeft(2, '0')).join(':');
  }

  // This function simply changes song status between playing and pausing.
  void changeStatus() {
    setState(() {
      isPlaying =! isPlaying;
    });

    if(isPlaying) {
      player.play();
    } else {
      player.pause();
    }
  }

  // UI part of class.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(                                             // This is simple AppBar with pop icon that returns user to  
        backgroundColor: Theme.of(context).backgroundColor,       // list of songs in previous window.
        leading: IconButton(
          onPressed: () {                                         //
            Navigator.of(context).pop();
          }, 
          icon: const Icon(
            Icons.arrow_back_ios_rounded,                         //
            color: Colors.black,
          ),
        ),
        title: const Text(                                        //
          'Now Playing',
          style: TextStyle(
            color: Colors.black,                                  //
          ),
        ),
      ),
      // This is main part of window where all featuers are present.
      body: Container(
        margin: const EdgeInsets.fromLTRB(5, 40, 5, 0),
        child: Column(
          children: <Widget>[
            CircleAvatar(backgroundImage: widget.songInfo.albumArtwork == null              // Image from song metadata or app default.
              ? const AssetImage('assets/images/default.png') as ImageProvider 
              : FileImage(File(widget.songInfo.albumArtwork)), 
              radius: 100,
            ),
            Container(                                                                      // Title
              margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
              child: Text(
                widget.songInfo.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w800,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Container(                                                                      // Artist
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 33),
              child: Text(
                widget.songInfo.artist,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500
                ),
              )
            ),
            Slider(                                                                         // Slider
              inactiveColor: Colors.black12,
              activeColor: Theme.of(context).primaryColor,
              min: minValue,
              max: maxValue,
              value: currentValue,
              onChanged: (value) {
                currentValue = value;
                player.seek(
                  Duration(
                    milliseconds: currentValue.round()
                  )
                );
              },
            ),
            Container(                                                          // Time values from below Slider.
              transform: Matrix4.translationValues(0, -15, 0),
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(                                                         // Current time value.
                    currentTime,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(                                                         // Max time value.
                    endTime,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(                                                  // Container with navigation buttons.
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(                                      // Previous song button
                    child: Icon(
                      Icons.skip_previous_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 55.0,
                    ),
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      widget.changeTrack(false);
                    },
                  ),
                  GestureDetector(                                      // Play / pause buttons
                    child: Icon(
                      isPlaying ? Icons.pause_circle_filled_rounded 
                      : Icons.play_circle_filled_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 85.0,
                    ),
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      changeStatus();
                    },
                  ),
                  GestureDetector(                                      // Next song button
                    child: Icon(
                      Icons.skip_next_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 55.0,
                    ),
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      widget.changeTrack(true);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}