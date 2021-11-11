// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, import_of_legacy_library_into_null_safe, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_app/widgets/drawer.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_app/modules/library_music/music_player.dart';

// This part of app contains list of songs present in phone memory. Clicking on a song navigates to 
// another screen with options to control audio output. Music library part of app is stateful in 
// contrast to Radio part.

class LibraryMusicPage extends StatefulWidget {
  static const String routeName = '/libraryMusic';

  @override
  _LibraryMusicPageState createState() => _LibraryMusicPageState();
}

// Below is state of LibraryMusic class.

class _LibraryMusicPageState extends State<LibraryMusicPage> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();        // Here AudioQuery library is invoked.
  List<SongInfo> songs = [];                                       // List of songs found on device.
  int currentSong = 0;                                             // Index of song surrently in use.
  final GlobalKey<MusicPlayerState> key = GlobalKey<MusicPlayerState>();      // This is connection to MusicPlayerState class that manipulates current song.

  // Here Music library is initiated and establishes List of songs to use.
  @override
  void initState() {
    super.initState();
    getTracks();
  }

  // This function uses AudioQuery to get every song present on device and saves it to previously created List.
  void getTracks() async {
    songs = await audioQuery.getSongs();

    setState(() {
      songs = songs;
    });
  }

  // This function navigates between songs in playmode.
  void changeTrack(bool isNext) {
    if(isNext) {
      if(currentSong != songs.length - 1) {
        currentSong++;
      }
    } else {
      if(currentSong != 0) {
        currentSong--;
      }
    }
    key.currentState!.setSong(songs[currentSong]);
  }

  // Part of graphical interface of Music library, it shows list of songs available on the device.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          'Music library',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1!.color
          ),
        ),
      ),
      drawer: AppDrawer(),                                            // This adds side menu to Music library side of app
      body: ListView.separated(                                                   // From here we have implementation of list of songs.
        separatorBuilder: (context, index) => Divider(),
        itemCount: songs.length,
        itemBuilder: (context, index) => ListTile(                          
          leading: CircleAvatar(                                                      // This creates picture besides song title, it's default picture or
            backgroundImage: songs[index].albumArtwork == null                        // image provided with song in metadata.
              ? AssetImage('assets/images/default.png') as ImageProvider 
              : FileImage(File(songs[index].albumArtwork
            )),
            radius: 30,
          ),
          title: Text(                                              // Title of song.
            songs[index].title,
            style: Theme.of(context).textTheme.bodyText1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(                                           // Name of artist.
            songs[index].artist,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {                                               // onTap sends user to different screen in MusicPlayer class where song will be played.
            currentSong = index;
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MusicPlayer(
                changeTrack: changeTrack,
                songInfo: songs[currentSong],
                key: key,
              )
            ));
          },
        ),
      ),
    );
  }
}





