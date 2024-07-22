// lib/utils/utils.dart
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:intl/intl.dart';

//Mascara para valores numericos separado por comas
// String formatNumber(String number) {
//   // Elimina cualquier coma existente en el string
//   String cleanedNumber = number.replaceAll('.', '');

//   // Convierte el string a un número
//   num parsedNumber = num.tryParse(cleanedNumber) ?? 0;

//   // Crea un formato de número con separadores de miles
//   final formatter = NumberFormat('#,##0', 'en_US');

//   // Devuelve el número formateado como String
//   return formatter.format(parsedNumber);
// }
Future<void> restartService() async {
  await stopService();
  // Espera un momento para asegurarte de que el servicio se detiene completamente
  await Future.delayed(Duration(seconds: 1));
  await startService();
}

Future<void> startService() async {
  print(
      'notificacion desde:-:SERVICIO-notificationSimplifies()--******startService()*****');
  await FlutterBackgroundService().startService();
}

Future<void> stopService() async {
  FlutterBackgroundService().invoke("stopService");
}

String formatNumber(String number) {
  // Elimina cualquier coma existente en el string
  String cleanedNumber = number.replaceAll(',', '');

  // Convierte el string a un número
  num parsedNumber = num.tryParse(cleanedNumber) ?? 0;

  // Formato personalizado para usar puntos como separadores de miles
  final formatter = NumberFormat('#,###', 'en_US');

  // Formatea el número y reemplaza las comas por puntos
  String formattedNumber = formatter.format(parsedNumber);
  formattedNumber = formattedNumber.replaceAll(',', '.');

  // Devuelve el número formateado como String
  return formattedNumber;
}
