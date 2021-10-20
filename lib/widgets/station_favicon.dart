// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';

// This class shows small image of every station logo beside it.

class StationFavicon extends StatelessWidget {
  static const String DEFAULT_ICON = "assets/images/music_cover.png";
  final String imageUrl;

  StationFavicon({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).textTheme.bodyText1!.color!.withAlpha(0)),
      ),
      child: CachedNetworkImage(
        height: 48,
        width: 48,
        imageUrl: imageUrl,
        placeholder: (context, _) {
          return SvgPicture.asset(
            DEFAULT_ICON,
            height: 48,
            width: 48,
            semanticsLabel: 'Music',
            color: Theme.of(context).textTheme.bodyText1!.color,
          );
        },
      ),
    );
  }
}


