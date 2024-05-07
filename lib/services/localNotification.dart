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

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotificationsNew() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> localNotificationsSimplifies(
    String title, String description) async {
  const channelId = 'my_channel_id'; // Usa un canal de notificación constante

  // Configuración específica de Android para el canal
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    channelId,
    'Nombre del Canal',
    channelDescription:
        'Descripción_del_Canal', // Descripción del Canal (argumento nombrado)
    importance: Importance.max,
    priority: Priority.high,
    sound: const RawResourceAndroidNotificationSound('livechat129007'),
  );

  // Detalles de la notificación para la plataforma
  final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  // Genera un ID de notificación único
  final int notificationId = Uuid().v1().hashCode;

  // Muestra la notificación
  await flutterLocalNotificationsPlugin.show(
    notificationId,
    title,
    description,
    platformChannelSpecifics,
  );
}
