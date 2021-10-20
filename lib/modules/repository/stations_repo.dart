import 'package:music_app/station.dart';

abstract class StationsRepo {
  Future<List<Station>>getStationsByCountryPaginated(String country, int offset, int limit);
}


