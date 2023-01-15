part of 'mapa_bloc.dart';

@immutable
abstract class MapaEvent {}

class OnMapaLoaded extends MapaEvent {}

class OnLocationUpdate extends MapaEvent {
  final LatLng ubicacion;

  OnLocationUpdate(this.ubicacion);
}

class OnMarcarRecorrido extends MapaEvent {}

class OnSeguirUbicacion extends MapaEvent {}

class OnMovioMapa extends MapaEvent {
  final LatLng centroMapa;

  OnMovioMapa(this.centroMapa);
}

class OnCrearRutaInicioDestino extends MapaEvent {
  final List<LatLng> rutasCordenadas;
  final double distancia;
  final double duracion;
  final String nombreDestino;

  OnCrearRutaInicioDestino(
      this.rutasCordenadas, this.distancia, this.duracion, this.nombreDestino);
}
