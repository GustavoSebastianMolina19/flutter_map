import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/bloc/busqueda/busqueda_bloc.dart';
import 'package:maps_app/bloc/mapa/mapa_bloc.dart';
import 'package:maps_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:maps_app/pages/acceso_gps_page.dart';
import 'package:maps_app/pages/loading_page.dart';
import 'package:maps_app/pages/mapa_page.dart';
import 'package:maps_app/pages/test_marker_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MiUbicacionBloc()),
        BlocProvider(create: (_) => MapaBloc()),
        BlocProvider(create: (_) => BusquedaBloc())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: LoadingPage(),
        //home: TestMarkerPage(), //LoadingPage(),
        routes: {
          'mapa': (_) => MapaPage(),
          'Loading': (_) => LoadingPage(),
          'acceso_gps': (_) => AccesiGpsPage()
        },
      ),
    );
  }
}
