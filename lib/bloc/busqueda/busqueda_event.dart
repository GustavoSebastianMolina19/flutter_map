part of 'busqueda_bloc.dart';

@immutable
abstract class BusquedaEvent {}

class OnActivarMarcadorManual extends BusquedaEvent {}

class OnDesactivarMarcadorManual extends BusquedaEvent {}

class OnAgregarHistorial extends BusquedaEvent {
  final SearchResult historialItem;

  OnAgregarHistorial(this.historialItem);
}
