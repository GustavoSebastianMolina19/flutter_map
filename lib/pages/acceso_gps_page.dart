import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AccesiGpsPage extends StatefulWidget {
  const AccesiGpsPage({super.key});

  @override
  State<AccesiGpsPage> createState() => _AccesiGpsPageState();
}

class _AccesiGpsPageState extends State<AccesiGpsPage>
    with WidgetsBindingObserver {
  bool popUp = false;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // ignore: avoid_print
    if (state == AppLifecycleState.resumed && !popUp) {
      if (await Permission.location.isGranted) {
        if (!context.mounted) return;
        Navigator.pushReplacementNamed(context, 'Loading');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Es necesario GPS pára usar esta app'),
          MaterialButton(
            onPressed: () async {
              popUp = true;
              final status = await Permission.location.request();
              await accesoGPS(status);
              popUp = false;
            },
            color: Colors.black,
            shape: const StadiumBorder(),
            elevation: 0,
            splashColor: Colors.transparent,
            child: const Text(
              'Solicitar acceso',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    ));
  }

  Future accesoGPS(PermissionStatus status) async {
    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        await Navigator.pushReplacementNamed(context, 'Loading');
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
    }
  }
}
