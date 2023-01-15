import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchResult {
  final bool cancelado;
  final bool? manual;
  final LatLng? posicion;
  final String? nombreDestino;
  final String? descripcion;

  SearchResult(
      {required this.cancelado,
      this.manual,
      this.posicion,
      this.nombreDestino,
      this.descripcion});
}
