import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/helpers/debouncer.dart';
import 'package:maps_app/models/reverser_query_response.dart';
import 'package:maps_app/models/search_response.dart';
import 'package:maps_app/models/traffic_response.dart';

class TrafficServices {
  // Singleton
  TrafficServices._privateConstructor();

  static final TrafficServices _instance =
      TrafficServices._privateConstructor();
  factory TrafficServices() {
    return _instance;
  }

  final _dio = Dio();
  final debouncer =
      Debouncer<String>(duration: const Duration(milliseconds: 200));

  final StreamController<SearchResponse> _sugerenciasStreamController =
      StreamController<SearchResponse>.broadcast();

  Stream<SearchResponse> get sugerenciasStream =>
      _sugerenciasStreamController.stream;

  final _baseURL = 'https://api.mapbox.com/directions/v5';
  final _baseURLGeo = 'https://api.mapbox.com/geocoding/v5';
  final _mapBoxApiKey =
      'pk.eyJ1IjoiZ3VzdGF2b3NlYmFzdGlhbiIsImEiOiJjbGNyNGlnZDMwYWptM3VtYmNzZWc3NTJuIn0.8edRd-LhTAvdWnoFaZ6fbA';

  Future<DrivingResponse> getCordsInicioYFin(
      LatLng inicio, LatLng destino) async {
    final cordString =
        '${inicio.longitude},${inicio.latitude};${destino.longitude},${destino.latitude}';
    final url = '$_baseURL/mapbox/driving/$cordString';
    final response = await _dio.get(
      url,
      queryParameters: {
        'alternatives': 'true',
        'geometries': 'polyline6',
        'steps': 'false',
        'access_token': _mapBoxApiKey,
        'language': 'es',
      },
    );
    final data = DrivingResponse.fromJson(response.data);
    return data;
  }

  Future<SearchResponse> getResultadosPorQuery(
      String busqueda, LatLng proximidad) async {
    final url = '$_baseURLGeo/mapbox.places//$busqueda.json';

    try {
      final resp = await _dio.get(url, queryParameters: {
        'access_token': _mapBoxApiKey,
        'autocomplete': true,
        'proximity': '${proximidad.longitude},${proximidad.latitude}',
        'language': 'es'
      });

      //final data = jsonEncode(resp.data);

      final searchResponse = searchResponseFromJson(jsonEncode(resp.data));

      return searchResponse!;
    } catch (e) {
      return SearchResponse();
    }
  }

  void getSugerenciasPorQuery(String busqueda, LatLng proximidad) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final resultados = await getResultadosPorQuery(value, proximidad);
      _sugerenciasStreamController.add(resultados);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      debouncer.value = busqueda;
    });

    Future.delayed(const Duration(milliseconds: 201))
        .then((_) => timer.cancel());
  }

  Future<ReverseQueryResponse> getCordenadasInfo(LatLng destinoCords) async {
    final url =
        '$_baseURLGeo/mapbox.places/${destinoCords.longitude},${destinoCords.latitude}.json';
    final response = await _dio.get(
      url,
      queryParameters: {
        'access_token': _mapBoxApiKey,
        'language': 'es',
      },
    );
    final data = reverseQueryResponseFromJson(jsonEncode(response.data));
    return data!;
  }
}
