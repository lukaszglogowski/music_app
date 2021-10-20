// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:music_app/widgets/station_favicon.dart';

class MediaPlayerSheet extends StatelessWidget {
  final String imageUrl;
  final String title;
  final VoidCallback onMediaButtonPress;
  final Icon mediaButtonIcon;

  MediaPlayerSheet({
    required this.imageUrl,
    required this.title,
    required this.onMediaButtonPress,
    required this.mediaButtonIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Theme.of(context).primaryColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: StationFavicon(imageUrl: imageUrl,),
            )
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                icon: mediaButtonIcon,
                onPressed: onMediaButtonPress,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


