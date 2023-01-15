part of 'custom_markers.dart';

class MarkerDestino extends CustomPainter {
  final String descripcion;
  final double metros;

  MarkerDestino(this.descripcion, this.metros);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.black;

    const double circuloNegroRadio = 20;
    const double circuloBlancoRadio = 7;
    //Dibujar circurlo
    canvas.drawCircle(
      Offset(circuloNegroRadio, size.height - circuloNegroRadio),
      20,
      paint,
    );

    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(circuloNegroRadio, size.height - circuloNegroRadio),
      circuloBlancoRadio,
      paint,
    );

    // sombra
    final Path path = Path();
    path.moveTo(0, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(0, 100);

    canvas.drawShadow(path, Colors.black87, 10, false);

    //Cajas
    final cajaBlanca = Rect.fromLTWH(0, 20, size.width - 10, 80);
    canvas.drawRect(cajaBlanca, paint);
    //Caja negra
    paint.color = Colors.black;
    const cajaNegra = Rect.fromLTWH(0, 20, 70, 80);
    canvas.drawRect(cajaNegra, paint);

    //Dibujar texto
    double kilometro = metros / 1000;
    kilometro = (kilometro * 100).floor().toDouble();
    kilometro = kilometro / 100;
    TextSpan textSpan = TextSpan(
        style: const TextStyle(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
        text: '$kilometro');

    TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: 70, minWidth: 70);

    textPainter.paint(canvas, Offset(0, 30));

    // minutos
    textSpan = const TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
        text: 'km');

    textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: 70);

    textPainter.paint(canvas, const Offset(20, 67));

    // Mi Ubicacion
    textSpan = TextSpan(
        style: const TextStyle(
            color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400),
        text: '$descripcion');

    textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
        maxLines: 2,
        ellipsis: '...')
      ..layout(maxWidth: size.width - 100);

    textPainter.paint(canvas, const Offset(90, 35));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
