import 'package:flutter/material.dart';
import 'package:maps_app/custom_markers/custom_markers.dart';

class TestMarkerPage extends StatelessWidget {
  const TestMarkerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          height: 150,
          color: Colors.red,
          child: CustomPaint(
            //painter: MarkerInicioPainter(15),
            painter:
                MarkerDestino('Mi casa se ubica aquijbcjdsbcdjhs dscsd', 1500),
          ),
        ),
      ),
    );
  }
}
