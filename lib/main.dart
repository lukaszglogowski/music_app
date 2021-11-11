import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/routes/routes.dart';
import 'modules/bloc/stations_bloc/stations_bloc.dart';
import 'modules/library_music/library_music_list_view.dart';
import 'modules/radio/radio_list_view.dart';
import 'modules/radio/radio_player.dart';
import 'modules/radio/just_audio_player.dart';
import 'modules/bloc/player_bloc/player_bloc.dart';
import 'modules/repository/radio_stations_browser_repo.dart';
import 'modules/repository/stations_repo.dart';
import 'package:dio/dio.dart';



Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final RadioPlayer radioPlayer = JustAudioPlayer();
  final StationsRepo stationsRepo = RadiosBrowserRepo(Dio());
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<PlayerBloc>(
          create: (context) => PlayerBloc(radioPlayer: radioPlayer),
        ),
        BlocProvider<StationsBloc>(
          create: (context) => StationsBloc(stationsRepo: stationsRepo),
        ),
      ],
      child: const MyApp(),
    )
  );
}

// This is main app class that takes care of theme and routing between layouts.
// It also sets home layout (first to display).

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App Master Degree',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.amber,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: LibraryMusicPage(),
      routes: {
        Routes.libraryMusic: (context) => LibraryMusicPage(),
        Routes.radio: (context) => RadioPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

