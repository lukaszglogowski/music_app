part of 'stations_bloc.dart';

@immutable
abstract class StationsState {
  const StationsState();
}

class InitialState extends StationsState {}

class LoadingStationsState extends StationsState {}

class FetchingNextStationState extends StationsState {}

class StationsFetchedStete extends StationsState {
  final List<Station> stations;
  final int stationPageIndex;
  final bool hasFetchedAll;

  const StationsFetchedStete({
    required this.stations,
    required this.stationPageIndex,
    required this.hasFetchedAll,
  });
}

class StationsFetchErrorState extends StationsState {}


