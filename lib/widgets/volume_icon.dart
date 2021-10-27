// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';


class VolumeBar extends StatelessWidget {
  final IconData iconData;
  final String string;
  final Color iconColor;
  final Color textColor;
  final double iconSize;

  VolumeBar({
    required this.iconData,
    required this.string,
    required this.iconColor,
    required this.textColor,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(
          iconData,
          size: iconSize,
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(height: 8.0,),
        Text(
          string,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}





