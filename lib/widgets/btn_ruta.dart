part of 'widgets.dart';

class BtnRuta extends StatelessWidget {
  const BtnRuta({super.key});

  @override
  Widget build(BuildContext context) {
    final mapaBloc = BlocProvider.of<MapaBloc>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
            onPressed: () {
              mapaBloc.add(OnMarcarRecorrido());
              //mapaBloc.moverCamara(destino!);
            },
            icon: const Icon(
              Icons.route_outlined,
              color: Colors.black87,
            )),
      ),
    );
  }
}
