// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
import 'package:loading/loading.dart';
import 'package:music_app/modules/bloc/player_bloc.dart';
import 'package:music_app/widgets/drawer.dart';
import 'package:music_app/widgets/idle_dots.dart';

// For now stateless widget which will contain radio section of app.

class RadioPage extends StatelessWidget {
  static const String routeName = '/radio';
  final _eskaUrl = 'https://stream-mz.planetradio.co.uk/planetrock.mp3';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Online Radio'),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Center(
          child: BlocBuilder<PlayerBloc, PlayerState>(builder: (context, state) {
            if (state is PausedState) {
              return IdleDots(color: Theme.of(context).colorScheme.secondary);
            } else if (state is PlayingState) {
              return Loading(
                indicator: LineScalePulseOutIndicator(),
                size: 150,
                color: Theme.of(context).colorScheme.secondary,
              );
            } else {
              throw Exception('Unknown state of bloc');
            }
          }),
        ),
      ),
      bottomSheet: Container(
        color: Theme.of(context).primaryColor,
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                height: 60,
                width: 60,
                child: Image.asset('assets/images/music_cover.png'),
              ),
            ),
            Text(
              'Planet Rock',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: BlocBuilder<PlayerBloc, PlayerState>(
                builder: (context, state) {
                  if (state is PausedState) {
                    return IconButton(
                      icon: Icon(
                        Icons.play_arrow,
                        size: 35,
                      ),
                      onPressed: () {
                        context.read<PlayerBloc>().add(PlayEvent(url: _eskaUrl));
                      },
                    );
                  } else {
                    return IconButton(
                      icon: Icon(
                        Icons.pause,
                        size: 35,
                      ),
                      onPressed: () {
                        context.read<PlayerBloc>().add(PauseEvent());
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

