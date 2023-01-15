import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/bloc/busqueda/busqueda_bloc.dart';
import 'package:maps_app/bloc/mapa/mapa_bloc.dart';
import 'package:maps_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart'
    as Poly;
import 'package:maps_app/helpers/helpers.dart';

import 'package:maps_app/models/search_result.dart';
import 'package:maps_app/models/traffic_response.dart';
import 'package:maps_app/search/search_destination.dart';
import 'package:animate_do/animate_do.dart';
import 'package:maps_app/services/traffic_services.dart';

part 'btn_location.dart';
part 'btn_ruta.dart';
part 'btn_seguir_location.dart';
part 'search_bar.dart';
part 'marcador_manual.dart';
