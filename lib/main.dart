// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:turnopro_apk/Views/coordinator/services/localStorage.dart';
import 'package:turnopro_apk/app_initializer.dart';
import 'package:turnopro_apk/dependency_injection.dart';
import 'package:turnopro_apk/myApp.dart';
import 'package:turnopro_apk/providers.dart';
import 'package:turnopro_apk/services/localNotification.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  DependencyInjection.registerDependencies();
  await AppInitializer.initializeApp();
  //
  WidgetsFlutterBinding.ensureInitialized();
  await initializeNotificationsNew();
  await LocalStorage.configurePrefs();

  // Cargar variables de entorno desde env.prod.json
  try {
    // Cargar variables de entorno desde env.prod.json
    await dotenv.load();
  } catch (e) {
    print('Error cargando variables de entorno: $e');
    // Manejar el error según sea necesario
    return; // Salir de la aplicación si no se pueden cargar las variables de entorno
  }

  // Ejemplo de acceso a variables de entorno
  String apiEndpoint = dotenv.env['API_ENDPOINT'] ?? '';
  //String apiKey = dotenv.env['API_KEY'] ?? '';
  // String apiToken = dotenv.env['API_TOKEN'] ?? '';

  // Ejemplo de uso
  print('API Endpoint: $apiEndpoint'); // Accede a la variable API_ENDPOINT

  //  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .requestNotificationsPermission();
  runApp(
    MultiProvider(
      providers:
          providers, //esto es para la autenticacion por la huella dactilar
      child: Myapp(),
    ),
  );
}
