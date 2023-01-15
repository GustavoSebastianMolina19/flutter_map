import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart' as Geolocation;
import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'mi_ubicacion_event.dart';
part 'mi_ubicacion_state.dart';

class MiUbicacionBloc extends Bloc<MiUbicacionEvent, MiUbicacionState> {
  MiUbicacionBloc() : super(MiUbicacionState()) {
    on<MiUbicacionEvent>((event, emit) {
      if (event is OnUbicacionCambio) {
        emit(state.copyWith(existeUbicacion: true, ubicacion: event.ubicacion));
      }
    });
  }

  StreamSubscription<Geolocation.Position>? _subscripcion;

  void iniciarSeguimiento() {
    const geoLocationOptions = Geolocation.LocationSettings(
      accuracy: Geolocation.LocationAccuracy.high,
      distanceFilter: 10,
    );
    Geolocation.Geolocator.getPositionStream(
            locationSettings: geoLocationOptions)
        .listen((Geolocation.Position poscion) {
      final nuevaUbicacion = LatLng(poscion.latitude, poscion.longitude);
      add(OnUbicacionCambio(nuevaUbicacion));
    });
  }

  void cancelarMovimiento() {
    _subscripcion?.cancel();
  }
}
