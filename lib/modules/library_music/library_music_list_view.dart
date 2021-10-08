// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:music_app/widgets/drawer.dart';

// For now stateless widget which will contain music library section of app.

class LibraryMusicPage extends StatelessWidget {
  static const String routeName = '/libraryMusic';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Music library"),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Text("Music library"),
      ),
    );
  }
}

