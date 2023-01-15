import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/bloc/mapa/mapa_bloc.dart';
import 'package:maps_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:maps_app/widgets/widgets.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  LatLng? posicionFinal;
  @override
  void initState() {
    BlocProvider.of<MiUbicacionBloc>(context).iniciarSeguimiento();
    super.initState();
  }

  @override
  void dispose() {
    BlocProvider.of<MiUbicacionBloc>(context).cancelarMovimiento();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
            builder: (context, state) => crearMapa(state),
          ),
          //TODO: Hacerr togglo
          const Positioned(top: 15, child: SearchBar()),
          const MarcadorManual(),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          BtnLocation(),
          BtnSeguirLocation(),
          BtnRuta(),
        ],
      ),
    );
  }

  Widget crearMapa(MiUbicacionState state) {
    if (!state.existeUbicacion) return const Center(child: Text('Ubicando...'));

    final mapaBloc = BlocProvider.of<MapaBloc>(context);

    mapaBloc.add(OnLocationUpdate(state.ubicacion!));

    final initialCamaraPosition = CameraPosition(
      target: state.ubicacion!,
      zoom: 15,
    );

    return BlocBuilder<MapaBloc, MapaState>(
      builder: (context, state) {
        return GoogleMap(
          initialCameraPosition: initialCamaraPosition,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: mapaBloc.initMapa,
          polylines: mapaBloc.state.polylines.values.toSet(),
          markers: mapaBloc.state.markers.values.toSet(),
          onCameraMove: (cameraPosition) {
            posicionFinal = cameraPosition.target;
            //mapaBloc.add(OnMovioMapa(cameraPosition.target));
          },
          onCameraIdle: () {
            if (posicionFinal != null) {
              mapaBloc.add(OnMovioMapa(posicionFinal!));
            }
          },
        );
      },
    );
  }
}
