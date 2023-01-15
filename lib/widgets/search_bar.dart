part of 'widgets.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (context, state) {
        if (state.seleccionManual) {
          return Container();
        } else {
          return FadeInDown(
            duration: const Duration(milliseconds: 300),
            child: buildSearchbar(context),
          );
        }
      },
    );
  }

  Widget buildSearchbar(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        width: width,
        child: GestureDetector(
          onTap: () async {
            final proximidad =
                BlocProvider.of<MiUbicacionBloc>(context).state.ubicacion;
            final historial =
                BlocProvider.of<BusquedaBloc>(context).state.historial;

            final resultado = await showSearch(
                context: context,
                delegate: SearchDestination(proximidad!, historial));
            if (!context.mounted) return;
            retornoBusqueda(context, resultado);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 5))
                ]),
            child: const Text(
              'A donde quieres ir ?',
              style: TextStyle(color: Colors.black87),
            ),
          ),
        ),
      ),
    );
  }

  void retornoBusqueda(BuildContext context, SearchResult? result) async {
    if (result == null) return;
    if (result.cancelado) return;

    if (result.manual!) {
      BlocProvider.of<BusquedaBloc>(context).add(OnActivarMarcadorManual());
      return;
    }

    calculandoalerta(context);

    //TODO: Calcular ruta en base al valor del result

    final trafficService = TrafficServices();
    final mapaBlox = BlocProvider.of<MapaBloc>(context);

    final inicio = BlocProvider.of<MiUbicacionBloc>(context).state.ubicacion;
    final destino = result.posicion;

    final drivingTraffic =
        await trafficService.getCordsInicioYFin(inicio!, destino!);

    final geometry = drivingTraffic.routes![0]!.geometry;
    final duration = drivingTraffic.routes![0]!.duration;
    final distance = drivingTraffic.routes![0]!.distance;
    final nombreDestino = result.nombreDestino;

    final points = Poly.decodePolyline(geometry!);

    final List<LatLng> rutaCordenadas = points
        .map((point) =>
            LatLng(point[0].toDouble() / 10, point[1].toDouble() / 10))
        .toList();

    mapaBlox.add(OnCrearRutaInicioDestino(
        rutaCordenadas, distance!, duration!, nombreDestino!));

    if (!context.mounted) return;
    Navigator.of(context).pop();
    // Agregar al historial

    final busquedaBloc = BlocProvider.of<BusquedaBloc>(context);
    busquedaBloc.add(OnAgregarHistorial(result));
  }
}
