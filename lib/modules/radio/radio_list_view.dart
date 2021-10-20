// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/modules/bloc/stations_bloc/stations_bloc.dart';
import 'package:music_app/widgets/drawer.dart';
import 'package:music_app/widgets/loading_indicator.dart';
import 'package:music_app/widgets/media_player_sheet.dart';
import 'package:music_app/widgets/radio_status_animation.dart';
import 'package:music_app/widgets/station_list_item.dart';
import 'package:music_app/widgets/title_header.dart';
import 'package:music_app/modules/bloc/player_bloc/player_bloc.dart';

// Main page for Radio part of app, it contains list of stations, status dots and mediaplayer sheet.

class RadioPage extends StatelessWidget {
  static const String routeName = '/radio';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Online Radio'),
      ),
      drawer: AppDrawer(),
      body: BlocBuilder<StationsBloc, StationsState>(
        buildWhen: (previous, current) {
          return (current is! FetchingNextStationState);
        },
        builder: (context, state) {
          if (state is InitialState) {
            context.read<StationsBloc>().add(FetchStations());
            return SizedBox();
          } else if (state is LoadingStationsState) {
            return LoadingIndicator(label: 'Fetching stations');
          } else if (state is StationsFetchedStete) {
            final stations = state.stations;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TitleHeader(
                  title: 'Top Stations',
                  status: BlocBuilder<PlayerBloc, PlayerState>(
                      builder: (context, state) {
                    if (state is PausedState || state is StoppedState) {
                      return PausedStatus();
                    } else {
                      return PlayingStatus();
                    }
                  }),
                ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (state is StationsFetchedStete &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                        context.read<StationsBloc>().add(FetchNextStations());
                        return true;
                      } else {
                        return false;
                      }
                    },
                    child: ListView.builder(
                      itemCount: stations.length,
                      itemBuilder: (context, index) {
                        return StationListItem(
                          name: stations[index].name,
                          imageUrl: stations[index].imageUrl,
                          onTap: () {
                            context
                                .read<PlayerBloc>()
                                .add(PlayEvent(stations[index]));
                          },
                        );
                      },
                    ),
                  ),
                ),
                BlocBuilder<PlayerBloc, PlayerState>(
                  builder: (context, state) {
                    if (state is! StoppedState) {
                      return SizedBox(height: 80);
                    } else {
                      return SizedBox();
                    }
                  },
                )
              ],
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('An error has occurred'),
                  SizedBox(height: 20),
                  MaterialButton(
                    onPressed: () {
                      context.read<StationsBloc>().add(FetchStations());
                    },
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.black,
                    child: Text('Retry'),
                  )
                ],
              ),
            );
          }
        },
      ),
      bottomSheet: BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, state) {
          if (state is StoppedState) {
            return SizedBox();
          } else if (state is PlayingState) {
            final currentStation = state.currentStation;
            return MediaPlayerSheet(
              title: currentStation.name,
              imageUrl: currentStation.imageUrl,
              mediaButtonIcon: Icon(
                Icons.pause,
                size: 32,
              ),
              onMediaButtonPress: () {
                context.read<PlayerBloc>().add(PauseEvent());
              },
            );
          } else {
            final currentStation = (state as PausedState).currentStation;
            return MediaPlayerSheet(
              title: currentStation.name,
              imageUrl: currentStation.imageUrl,
              mediaButtonIcon: Icon(
                Icons.play_arrow,
                size: 32,
              ),
              onMediaButtonPress: () {
                context.read<PlayerBloc>().add(PlayEvent(currentStation));
              },
            );
          }
        },
      ),
    );
  }
}
