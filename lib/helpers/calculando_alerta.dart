part of 'helpers.dart';

void calculandoalerta(BuildContext context) {
  if (Platform.isAndroid) {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Espere porfavo'),
        content: Text('Cargando'),
      ),
    );
  } else {
    showCupertinoDialog(
        context: context,
        builder: (context) => const CupertinoAlertDialog(
              title: Text('Espere porfavor'),
              content: CupertinoActivityIndicator(),
            ));
  }
}
