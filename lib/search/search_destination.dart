import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:maps_app/models/search_response.dart';
import 'package:maps_app/models/search_result.dart';
import 'package:maps_app/services/traffic_services.dart';

class SearchDestination extends SearchDelegate<SearchResult> {
  @override
  final String searchFieldLabel;
  final TrafficServices _trafficServices;
  final LatLng proximidad;
  final List<SearchResult> historial;

  SearchDestination(this.proximidad, this.historial)
      : searchFieldLabel = 'Buscar....',
        _trafficServices = TrafficServices();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, SearchResult(cancelado: true)),
        icon: const Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    return _construirResultadoSugerencia();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Colocar ubicacion manueal'),
            onTap: () =>
                close(context, SearchResult(cancelado: false, manual: true)),
          ),
          ...historial
              .map((result) => ListTile(
                    leading: const Icon(Icons.history_rounded),
                    title: Text(result.nombreDestino!),
                    subtitle: Text(result.descripcion!),
                    onTap: () {
                      close(context, result);
                    },
                  ))
              .toList(),
        ],
      );
    }

    return _construirResultadoSugerencia();
  }

  Widget _construirResultadoSugerencia() {
    if (query.isEmpty) {
      return Container();
    }

    _trafficServices.getSugerenciasPorQuery(query.trim(), proximidad);
    return StreamBuilder<Object>(
        stream: _trafficServices.sugerenciasStream,
        builder: (context, snapshot) {
          return FutureBuilder(
            future: _trafficServices.getResultadosPorQuery(
                query.trim(), proximidad),
            builder:
                (BuildContext context, AsyncSnapshot<SearchResponse> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final lugares = snapshot.data?.features ?? [];

              if (lugares.isEmpty) {
                return ListTile(
                  title: Text('No hay resultado con el $query'),
                );
              }

              return ListView.separated(
                  itemBuilder: (_, i) => const Divider(),
                  separatorBuilder: (_, i) {
                    final lugar = lugares[i];

                    return ListTile(
                      leading: const Icon(Icons.place),
                      title: Text(lugar?.textEs ?? ''),
                      subtitle: Text(lugar?.placeNameEs ?? ''),
                      onTap: () {
                        if (lugar != null) {
                          close(
                              context,
                              SearchResult(
                                cancelado: false,
                                manual: false,
                                posicion: LatLng(
                                    lugar.center![1]!, lugar.center![0]!),
                                nombreDestino: lugar.textEs,
                                descripcion: lugar.placeNameEs,
                              ));
                        }
                      },
                    );
                  },
                  itemCount: lugares.length);
            },
          );
        });
  }
}
