// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

// Shows when first batch of statins is being loaded into app.

class LoadingIndicator extends StatelessWidget {
  final String label;
  LoadingIndicator({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: 20,),
          Text(label),
        ],
      ),
    );
  }
}

