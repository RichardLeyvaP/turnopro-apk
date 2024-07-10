// // ignore_for_file: depend_on_referenced_packages
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:provider/provider.dart';
// import 'package:turnopro_apk/Views/coordinator/services/localStorage.dart';
// import 'package:turnopro_apk/app_initializer.dart';
// import 'package:turnopro_apk/dependency_injection.dart';
// import 'package:turnopro_apk/myApp.dart';
// import 'package:turnopro_apk/providers.dart';
// import 'package:turnopro_apk/services/localNotification.dart';
// import 'package:workmanager/workmanager.dart';

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) {
//     print("Native called background task: $task");

//     // Aquí debes llamar a tu API
//     // Puedes usar el paquete http para hacer la solicitud
//     // Ejemplo:
//     // final response = await http.get(Uri.parse('https://example.com/api'));
//     // if (response.statusCode == 200) {
//     //   // La llamada fue exitosa
//     // } else {
//     //   // Hubo un error
//     // }

//     return Future.value(true);
//   });
// }

// void main() async {
//   DependencyInjection.registerDependencies();
//   await AppInitializer.initializeApp();

//   WidgetsFlutterBinding.ensureInitialized();
//   await initializeNotificationsNew();
//   await LocalStorage.configurePrefs();

//   // Inicializa Workmanager
//   Workmanager().initialize(
//     callbackDispatcher,
//     isInDebugMode: true, // Cambia a false en producción
//   );

//   // Registra la tarea periódica
//   Workmanager().registerPeriodicTask(
//     "1",
//     "simplePeriodicTask",
//     frequency:
//         Duration(seconds: 10000), // La frecuencia mínima es de 15 minutos
//   );

//   flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()!
//       .requestNotificationsPermission();

//   runApp(
//     MultiProvider(
//       providers:
//           providers, // Esto es para la autenticación por la huella dactilar
//       child: Myapp(),
//     ),
//   );
// }
