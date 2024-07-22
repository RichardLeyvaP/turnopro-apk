// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:uuid/uuid.dart';

// //todo/****AQUI LO DE LAS NOTIFICACIONES LOCALES****/
// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> initializeNotificationsNew() async {
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/launcher_icon');
//   const DarwinInitializationSettings initializationSettingsIOS =
//       DarwinInitializationSettings();

//   const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
// }

// Future<void> scheduleNotificationNew(String title, String descripcion) async {
//   final Uuid uuid = Uuid(); // Crea una instancia de Uuid
//   final String channelId = uuid.v4(); // Genera un channelId único
//   AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     channelId, // ID del canal
//     'Nombre_del_Canal', // Nombre del Canal
//     channelDescription:
//         'Descripción_del_Canal', // Descripción del Canal (argumento nombrado)
//     importance: Importance.max,
//     priority: Priority.high,
//     ticker: 'ticker',
//     sound: const RawResourceAndroidNotificationSound('livechat129007'),
//     // ^ Utiliza el nombre del archivo de sonido sin la extensión
//   );
//   NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);
//   await flutterLocalNotificationsPlugin.show(
//     1,
//     title,
//     descripcion,
//     platformChannelSpecifics,
//   );
// }
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';

// Inicializa el plugin de notificaciones locales
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin2 =
    FlutterLocalNotificationsPlugin();

// Lista para almacenar los IDs de las notificaciones
List<int> notificationIds = [];

Future<void> initializeNotificationsNew2() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin2.initialize(initializationSettings);
}

Future<void> localNotificationsSimplifies(
    String title, String description) async {
  const channelId = 'my_channel_id'; // Usa un canal de notificación constante

  // Configuración específica de Android para el canal
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    channelId,
    'Nombre del Canal',
    channelDescription: 'Descripción del Canal',
    importance: Importance.max,
    priority: Priority.high,
    sound: RawResourceAndroidNotificationSound('livechat129007'),
    enableLights: true,
    color: Colors.blue,
    ledColor: Color(0xffffffff),
    ledOnMs: 1000,
    ledOffMs: 500,
    fullScreenIntent: true,
  );

  // Detalles de la notificación para la plataforma
  final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  // Genera un ID de notificación único
  final int notificationId = Uuid().v1().hashCode;

  // Muestra la notificación
  await flutterLocalNotificationsPlugin2.show(
    notificationId,
    title,
    description,
    platformChannelSpecifics,
  );

  // Añadir el ID de la notificación a la lista
  notificationIds.add(notificationId);

  // Verificar si hay más de 5 notificaciones
  if (notificationIds.length > 6) {
    // Eliminar las 3 primeras notificaciones
    for (int i = 0; i < 3; i++) {
      int idToRemove = notificationIds.removeAt(0);
      await flutterLocalNotificationsPlugin2.cancel(idToRemove);
    }
  }
}

// Método para limpiar todas las notificaciones
Future<void> clearAllNotifications() async {
  await flutterLocalNotificationsPlugin2.cancelAll();
}
