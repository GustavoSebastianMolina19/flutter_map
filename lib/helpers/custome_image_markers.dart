part of 'helpers.dart';

Future<BitmapDescriptor> getAssetImageMarker() async {
  final icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(
        devicePixelRatio: 2.5,
      ),
      'assets/custom-pin.png');
  return icon;
}
