import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:music_app/modules/repository/stations_repo.dart';
import 'package:music_app/station.dart';

part 'stations_event.dart';
part 'stations_state.dart';

class StationsBloc extends Bloc<StationsEvent, StationsState> {
  final StationsRepo stationsRepo;
  final int _pageSize = 20;
  final String _countryCode = 'pl';

  StationsBloc({required this.stationsRepo}) : super(InitialState());

  StationsState get initialState => InitialState();

  @override
  Stream<StationsState>mapEventToState(StationsEvent event) async* {
    if (event is FetchStations) {
      yield (LoadingStationsState());
      try {
        final List<Station>stations = await stationsRepo.getStationsByCountryPaginated(_countryCode, 0, _pageSize);
        yield StationsFetchedStete(
          stations: stations,
          stationPageIndex: 0,
          hasFetchedAll: false,
        );
      } catch (err) {
        yield StationsFetchErrorState();
      }
    } else if (event is FetchNextStations && state is StationsFetchedStete) {
      final currentState = (state as StationsFetchedStete);
      final int index = currentState.stationPageIndex + _pageSize;
      final List<Station>oldStations = currentState.stations;
      yield FetchingNextStationState();
      try {
        final List<Station>stations = await stationsRepo.getStationsByCountryPaginated(_countryCode, index, _pageSize);
        yield StationsFetchedStete(
          stations: oldStations..addAll(stations),
          stationPageIndex: index,
          hasFetchedAll: (stations.length < _pageSize) ? true : false,
        );
      } catch (err) {
        yield StationsFetchErrorState();
      }
    }
  }
}