part of 'widgets.dart';

class BtnSeguirLocation extends StatelessWidget {
  const BtnSeguirLocation({super.key});

  @override
  Widget build(BuildContext context) {
    final mapaBloc = BlocProvider.of<MapaBloc>(context);

    return BlocBuilder<MapaBloc, MapaState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            maxRadius: 25,
            child: IconButton(
                onPressed: () {
                  mapaBloc.add(OnSeguirUbicacion());
                  //mapaBloc.moverCamara(destino!);
                },
                icon: Icon(
                  mapaBloc.state.seguirUbicacion
                      ? Icons.directions_run
                      : Icons.accessibility_new,
                  color: Colors.black87,
                )),
          ),
        );
      },
    );
  }
}
