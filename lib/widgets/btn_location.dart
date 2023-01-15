part of 'widgets.dart';

class BtnLocation extends StatelessWidget {
  const BtnLocation({super.key});

  @override
  Widget build(BuildContext context) {
    final mapaBloc = BlocProvider.of<MapaBloc>(context);
    final ubicacionBloc = BlocProvider.of<MiUbicacionBloc>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
            onPressed: () {
              final destino = ubicacionBloc.state.ubicacion;
              mapaBloc.moverCamara(destino!);
            },
            icon: const Icon(
              Icons.my_location,
              color: Colors.black87,
            )),
      ),
    );
  }
}
