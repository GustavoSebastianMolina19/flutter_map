import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show Colors, Offset;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/helpers/helpers.dart';
import 'package:meta/meta.dart';

import 'package:maps_app/themes/uber_map_theme.dart';

part 'mapa_event.dart';
part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {
  MapaBloc() : super(MapaState()) {
    on<MapaEvent>(
      (event, emit) {
        if (event is OnMapaLoaded) {
          emit(state.copyWith(mapaListo: true));
        } else if (event is OnLocationUpdate) {
          emit(_onLocationUpdate(event));
        } else if (event is OnMarcarRecorrido) {
          emit(_onMarcarRecorrido(event));
        } else if (event is OnSeguirUbicacion) {
          if (!state.seguirUbicacion) {
            moverCamara(_miRuta.points[_miRuta.points.length - 1]);
          }

          emit(state.copyWith(seguirUbicacion: !state.seguirUbicacion));
        } else if (event is OnMovioMapa) {
          emit(state.copyWith(ubicacionCentral: event.centroMapa));
        } else if (event is OnCrearRutaInicioDestino) {
          _onCrearRutaInicioDestino(event, emit);
        }
      },
    );
  }

  void _onCrearRutaInicioDestino(
      OnCrearRutaInicioDestino event, Emitter<MapaState> emitter) async {
    _miRutaDestino =
        _miRutaDestino.copyWith(pointsParam: event.rutasCordenadas);

    final currentPolylines = state.polylines;

    currentPolylines['mi_ruta_destino'] = _miRutaDestino;

    //Icono incio
    final iconoInicio = await getMarkerInicioIcon(event.duracion.toInt());
    /*BitmapDescriptor? icono;
    getAssetImageMarker().then((value) {
      icono = value;
    });*/
    final iconoDestino =
        await getMarkerDestinoIcon(event.nombreDestino, event.distancia);

    final markerInicio = Marker(
      anchor: const Offset(0.04, 0.9),
      markerId: const MarkerId('inicio'),
      position: event.rutasCordenadas.first,
      icon: iconoInicio,
      infoWindow: InfoWindow(
        title: 'Mi ubicacion',
        snippet: 'Duratcion: ${(event.duracion / 60).floor()} minutos',
      ),
    );

    double kilometros = event.distancia / 1000;
    kilometros = (kilometros * 100).floor().toDouble();
    kilometros = kilometros / 100;

    final markerFinal = Marker(
      anchor: const Offset(0.04, 0.9),
      markerId: const MarkerId('final'),
      position: event.rutasCordenadas.last,
      icon: iconoDestino,
      infoWindow: InfoWindow(
        title: event.nombreDestino,
        snippet: 'Kilometros: $kilometros  km',
      ),
    );

    final newMarkers = {...state.markers};

    newMarkers['inicio'] = markerInicio;
    newMarkers['final'] = markerFinal;

    /*Future.delayed(Duration(milliseconds: 300)).then((value) {
      //_mapController?.showMarkerInfoWindow(const MarkerId('inicio'));
      _mapController?.showMarkerInfoWindow(const MarkerId('final'));
    });*/
    emit(state.copyWith(polylines: currentPolylines, markers: newMarkers));

    //return state.copyWith(polylines: currentPolylines, markers: newMarkers);
  }

  MapaState _onLocationUpdate(OnLocationUpdate event) {
    if (state.seguirUbicacion) {
      moverCamara(event.ubicacion);
    }

    List<LatLng> points = [..._miRuta.points, event.ubicacion];

    _miRuta = _miRuta.copyWith(pointsParam: points);

    final currentPolilynes = state.polylines;

    currentPolilynes['mi_ruta'] = _miRuta;

    return state.copyWith(
      polylines: currentPolilynes,
    );
  }

  MapaState _onMarcarRecorrido(OnMarcarRecorrido event) {
    if (!state.dibujarRecorrido) {
      _miRuta = _miRuta.copyWith(colorParam: Colors.black87);
    } else {
      _miRuta = _miRuta.copyWith(colorParam: Colors.transparent);
    }

    final currentPolilynes = state.polylines;

    currentPolilynes['mi_ruta'] = _miRuta;

    return state.copyWith(
      dibujarRecorrido: !state.dibujarRecorrido,
      polylines: currentPolilynes,
    );
  }

  // Controlador de mapa
  GoogleMapController? _mapController;

  //polilyne
  Polyline _miRuta = const Polyline(
    polylineId: PolylineId('mi_ruta'),
    width: 4,
    color: Colors.transparent,
  );

  Polyline _miRutaDestino = const Polyline(
    polylineId: PolylineId('mi_ruta_destino'),
    width: 4,
    color: Colors.black87,
  );

  void moverCamara(LatLng destino) {
    final camaraUpdate = CameraUpdate.newLatLng(destino);
    _mapController?.animateCamera(camaraUpdate);
  }

  void initMapa(GoogleMapController controller) {
    if (!state.mapaListo) {
      _mapController = controller;

      _mapController?.setMapStyle(jsonEncode(uberMapTheme));

      add(OnMapaLoaded());
    }
  }
}
