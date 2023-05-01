// ignore_for_file: prefer_const_constructors, prefer_const_declarations, avoid_renaming_method_parameters

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:music_app/modules/repository/stations_repo.dart';
import 'package:music_app/station.dart';

// This class sends URL request to API.RADIO-BROWSER.INFO for list of stations, decodes JSON response and puts it in list.

class RadiosBrowserRepo extends StationsRepo {
  final Dio _dio;
  static final String _baseUrl = 'https://de1.api.radio-browser.info';
  static final String _stationsByCountryCodeUrl =
      '$_baseUrl/json/stations/bycountrycodeexact/';

  RadiosBrowserRepo(this._dio) {
    _dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: _baseUrl)).interceptor);
  }

  @override
  Future<List<Station>> getStationsByCountryPaginated(
      String countryCode, int offset, int limit) async {
    final stationsFromCountryCodeUrl = _stationsByCountryCodeUrl + countryCode;
    final Response rawStationsJson = await _dio.get(
      _buildUrlToSortByPopularityWithPagination(
        stationsFromCountryCodeUrl,
        offset,
        limit,
      ),
      options: buildCacheOptions(
        Duration(days: 1),
      ),
    );
    final List<Station> stations = (rawStationsJson.data as List)
        .map((responseJson) => Station(
              responseJson['url_resolved'],
              responseJson['favicon'],
              responseJson['name'],
            ))
        .toList();
    return Future.value(stations);
  }

  String _buildUrlToSortByPopularityWithPagination(
      String url, int offset, int limit) {
    return '$url?hidebroken=true&order=clickcount&reverse=true&offset=$offset&limit=$limit';
  }
}
