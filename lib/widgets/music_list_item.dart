// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors, import_of_legacy_library_into_null_safe

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:audio_manager/audio_manager.dart';
import 'package:music_app/widgets/volume_icon.dart';



class MusicListItem extends StatelessWidget {
  var audioManagerInstance = AudioManager.instance;
  final List<SongInfo> songList;

  MusicListItem({required this.songList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: songList.length,
      itemBuilder: (context, index) {
        SongInfo songInfo = songList[index];
        if (songInfo.displayName.contains(".mp3")) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    child: Image(
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                      image: FileImage(File(songInfo.albumArtwork)),
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              songInfo.title,
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              songInfo.artist,
                              style: TextStyle(
                                fontSize: 11.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            audioManagerInstance
                              .start("file://${songInfo.filePath}", 
                                      songInfo.title,
                                      desc: songInfo.displayName,
                                      auto: true,
                                      cover: songInfo.albumArtwork
                            );
                          },
                          child: VolumeBar(
                              iconData: Icons.play_circle_outline,
                              iconColor: Colors.red,
                              string: "Play",
                              textColor: Colors.black,
                              iconSize: 25,
                            ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return SizedBox();
      },
    );
  } 
}