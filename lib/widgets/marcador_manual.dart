part of 'widgets.dart';

class MarcadorManual extends StatelessWidget {
  const MarcadorManual({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (context, state) {
        if (state.seleccionManual) {
          return const _BuildMarcadorManual();
        } else {
          return Container();
        }
      },
    );
  }
}

class _BuildMarcadorManual extends StatelessWidget {
  const _BuildMarcadorManual({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned(
          top: 70,
          left: 20,
          child: FadeInLeft(
            duration: const Duration(milliseconds: 350),
            child: CircleAvatar(
              maxRadius: 25,
              backgroundColor: Colors.white,
              child: IconButton(
                onPressed: () {
                  BlocProvider.of<BusquedaBloc>(context)
                      .add(OnDesactivarMarcadorManual());
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Transform.translate(
            offset: const Offset(0, -18),
            child: BounceInDown(
              from: 350,
              child: const Icon(
                Icons.location_on,
                size: 50,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 70,
          left: 40,
          child: FadeIn(
            child: MaterialButton(
              minWidth: width - 120,
              color: Colors.black,
              shape: const StadiumBorder(),
              elevation: 0,
              splashColor: Colors.transparent,
              onPressed: () {
                calcularDestino(context);
              },
              child: const Text('Confimar destino',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        )
      ],
    );
  }

  void calcularDestino(BuildContext context) async {
    calculandoalerta(context);

    final trafficServices = TrafficServices();

    final mapaBloc = BlocProvider.of<MapaBloc>(context);

    final inicio = BlocProvider.of<MiUbicacionBloc>(context).state.ubicacion;
    final destino = mapaBloc.state.ubicacionCentral;

    // Obtener informacion del destino
    final reverseQuery = await trafficServices.getCordenadasInfo(destino!);

    final trafficResponse =
        await trafficServices.getCordsInicioYFin(inicio!, destino);

    final geometry = trafficResponse.routes![0]!.geometry;
    final duracion = trafficResponse.routes![0]!.duration;
    final distancia = trafficResponse.routes![0]!.distance;
    final nombreDestino = reverseQuery.features!.first!.text;
    final desciption = reverseQuery.features!.first!.address;
    // Decodificar Geometry

    final points = Poly.decodePolyline(
        geometry!); //.Polyline.Decode(encodedString: geometry, precision: 6)
    //.decodedCoords;
    final List<LatLng> rutaCords = points
        .map((point) =>
            LatLng(point[0].toDouble() / 10, point[1].toDouble() / 10))
        .toList();

    mapaBloc.add(OnCrearRutaInicioDestino(
        rutaCords, distancia!, duracion!, nombreDestino!));
    if (!context.mounted) return;
    Navigator.of(context).pop();

    final busquedaBloc = BlocProvider.of<BusquedaBloc>(context);

    busquedaBloc.add(OnDesactivarMarcadorManual());

    final resultado = SearchResult(
        cancelado: false,
        nombreDestino: nombreDestino,
        posicion: rutaCords.last,
        descripcion: desciption);

    //BlocProvider.of<BusquedaBloc>(context).add(OnDesactivarMarcadorManual());

    busquedaBloc.add(OnAgregarHistorial(resultado));
  }
}
