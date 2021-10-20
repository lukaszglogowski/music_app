// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:music_app/widgets/station_favicon.dart';

// This class creates every item on list that displays all tracked radio stations.

class StationListItem extends StatelessWidget {
  final GestureTapCallback onTap;
  final String imageUrl;
  final String name;

  StationListItem({required this.onTap, required this.imageUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            StationFavicon(imageUrl: imageUrl),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                name,
                style: Theme.of(context).textTheme.bodyText1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}