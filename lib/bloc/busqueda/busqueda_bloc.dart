import 'package:bloc/bloc.dart';
import 'package:maps_app/models/search_result.dart';
import 'package:meta/meta.dart';

part 'busqueda_event.dart';
part 'busqueda_state.dart';

class BusquedaBloc extends Bloc<BusquedaEvent, BusquedaState> {
  BusquedaBloc() : super(BusquedaState()) {
    on<BusquedaEvent>((event, emit) {
      if (event is OnActivarMarcadorManual) {
        emit(state.copyWith(seleccionManual: true));
      } else if (event is OnDesactivarMarcadorManual) {
        emit(state.copyWith(seleccionManual: false));
      } else if (event is OnAgregarHistorial) {
        final existe = state.historial
            .where((result) =>
                result.nombreDestino == event.historialItem.nombreDestino)
            .length;

        if (existe == 0) {
          final newHistial = [...state.historial, event.historialItem];
          emit(state.copyWith(historial: newHistial));
        }
      }
    });
  }
}
