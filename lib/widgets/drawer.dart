// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:music_app/routes/routes.dart';

// AppDrawer takes care of drawer used to navigate between music library and radio.
// It's created and animated according to Material Design standards.

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
            icon: Icons.library_music, 
            text: 'Music library',
            onTap: () => Navigator.pushReplacementNamed(context, Routes.libraryMusic),
          ),
          _createDrawerItem(
            icon: Icons.radio, 
            text: 'Radio',
            onTap: () => Navigator.pushReplacementNamed(context, Routes.radio),
          ),
        ],
      ),
    );
  }

  // This widget is representation of header that belongs to drawer. It consists of
  // decorative image and placeholder title.

  Widget _createHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/desert.jpeg')
        ),
      ),
      child: Stack(children: const <Widget>[
        Positioned(
          bottom: 12.0,
          left: 16.0,
          child: Text("Music App",
                 style: TextStyle(
                   color: Colors.white,
                   fontSize: 30.0,
                   fontWeight: FontWeight.w500
                 ),
          ),
        ),
      ],),
    );
  }

  // Item widget is visual representation of route sign to another layout. It consists 
  // of icon and text.

  Widget _createDrawerItem({required IconData icon, required String text, required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}


