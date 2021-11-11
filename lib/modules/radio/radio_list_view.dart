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
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          'Online Radio',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1!.color
          ),
        ),
      ),
      drawer: AppDrawer(),                                    // This adds side menu to radio side of app
      body: BlocBuilder<StationsBloc, StationsState>(         // Here starts the actual radio part of app
        buildWhen: (previous, current) {
          return (current is! FetchingNextStationState);      // This decides whether to redraw radio or not, it redraws if "state" is not FetchingNextStationState
        },
        builder: (context, state) {
          if (state is InitialState) {
            context.read<StationsBloc>().add(FetchStations());    // Initial state of app, fetching first batch of 20 stations from API server
            return SizedBox();
          } else if (state is LoadingStationsState) {
            return LoadingIndicator(label: 'Fetching stations');    // In this state first 20 stations stations are being loaded into radio app
          } else if (state is StationsFetchedStete) {
            final stations = state.stations;                      // Here we have list of stations and we create all visual effects
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TitleHeader(
                  title: 'Top Stations',                                         //
                  status: BlocBuilder<PlayerBloc, PlayerState>(                  // Title and dosts that showing whether something is playing or not
                      builder: (context, state) {                                //
                    if (state is PausedState || state is StoppedState) {         //
                      return PausedStatus();                                     //
                    } else {                                                     //
                      return PlayingStatus();                                    //
                    }
                  }),
                ),
                Expanded(                                                        // Whole Expanded function covers creation of visual list
                  child: NotificationListener<ScrollNotification>(               // of stations that we have and finding out if user scrolled 
                    onNotification: (ScrollNotification scrollInfo) {            // to the bottom of the list so new stations have to be downloaded
                      if (state is StationsFetchedStete &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {              //
                        context.read<StationsBloc>().add(FetchNextStations());
                        return true;                                             //
                      } else {
                        return false;                                            //
                      }
                    },                                                           //
                    child: ListView.builder(
                      itemCount: stations.length,                                //
                      itemBuilder: (context, index) {
                        return StationListItem(                                  //
                          name: stations[index].name,
                          imageUrl: stations[index].imageUrl,                    //
                          onTap: () {
                            context                                              //
                                .read<PlayerBloc>()                              //
                                .add(PlayEvent(stations[index]));                //
                          },                                                     //
                        );
                      },
                    ),
                  ),
                ),
                BlocBuilder<PlayerBloc, PlayerState>(
                  builder: (context, state) {
                    if (state is! StoppedState) {           // This is bottom sheet that is a background for app activity sheet
                      return SizedBox(height: 80);          //
                    } else {
                      return SizedBox();                    //
                    }
                  },
                )
              ],
            );
          } else {
            return Center(
              child: Column(                                                  // Else is returned if something is wrong (no internet, corrupted data etc.)
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('An error has occurred'),                              //
                  SizedBox(height: 20),
                  MaterialButton(
                    onPressed: () {                                           //
                      context.read<StationsBloc>().add(FetchStations());
                    },
                    color: Theme.of(context).primaryColor,                    //
                    textColor: Colors.black,
                    child: Text('Retry'),
                  )
                ],
              ),
            );
          }
        },
      ),
      bottomSheet: BlocBuilder<PlayerBloc, PlayerState>(          // BottomSheet is a proper instalment of bottom activity panel
        builder: (context, state) {                               // that shows favicon and name of current station, plays or pauses it.
          if (state is StoppedState) {                            // Also home to PLAY and PAUSE buttons
            return SizedBox();
          } else if (state is PlayingState) {
            final currentStation = state.currentStation;
            return MediaPlayerSheet(
              title: currentStation.name,
              imageUrl: currentStation.imageUrl,
              mediaButtonIcon: Icon(
                Icons.pause_rounded,
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
                Icons.play_arrow_rounded,
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
