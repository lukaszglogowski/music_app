// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, import_of_legacy_library_into_null_safe, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:music_app/widgets/bottom_panel.dart';
import 'package:music_app/widgets/drawer.dart';
import 'package:audio_manager/audio_manager.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_app/widgets/music_list_item.dart';
import 'package:music_app/widgets/volume_icon.dart';

// For now stateless widget which will contain music library section of app.

class LibraryMusicPage extends StatefulWidget {
  static const String routeName = '/libraryMusic';

  @override
  _LibraryMusicPageState createState() => _LibraryMusicPageState();
}


class _LibraryMusicPageState extends State<LibraryMusicPage> {
  var audioManagerInstance = AudioManager.instance;
  bool showVolume = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  showVolume = !showVolume;
                });
              },
              child: VolumeBar(
                iconData: Icons.volume_down, 
                string: "Volume", 
                iconColor: Colors.black54, 
                textColor: Colors.black54, 
                iconSize: 20.0,
              ),
            ),
          ),
        ],
        title: showVolume ? Slider(
          value: audioManagerInstance.volume,
          onChanged: (value) {
            setState(() {
              audioManagerInstance.setVolume(value, showVolume: true);
            });
          },
        ) : Text("Music library"),
      ),
      drawer: AppDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 500,
            child: FutureBuilder(
              future: FlutterAudioQuery().getSongs(),
              builder: (context, snapshot) {
                List<SongInfo> songInfo = snapshot.data as List<SongInfo>;
                if (snapshot.hasData) {
                  return MusicListItem(songList: songInfo);
                }
                return Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(width: 20.0),
                        Text(
                          "Loading music", 
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomSheet: BottomPanel(),
    );
  }
}





