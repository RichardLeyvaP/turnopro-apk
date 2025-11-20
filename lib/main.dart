// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnopro_apk/Views/coordinator/services/localStorage.dart';
import 'package:turnopro_apk/app_initializer.dart';
import 'package:turnopro_apk/myApp.dart';
import 'package:turnopro_apk/providers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Esto asegura la inicialización de Flutter antes de ejecutar código asíncrono

  // Manejo de errores al iniciar la aplicación
  try {
   await AppInitializer.initializeApp(); // Encargado de configuraciones previas
   await LocalStorage.configurePrefs(); // Configurar almacenamiento local

    // Cargar variables de entorno
    await loadEnvironmentVariables();

    // Inicializar la aplicación
    runApp(
      MultiProvider(
        providers: providers,
        child: Myapp(),
      ),
    );

    // Solicitar permisos después de que la app ya esté inicializada
    requestNotificationPermission();
  } catch (e) {
    print('Error en el inicio de la aplicación: $e');
  }
}

// Función para cargar variables de entorno de manera segura
Future<void> loadEnvironmentVariables() async {
  try {

    await dotenv.load(fileName: "assets/prod.env");  // <- importante
    print("Variables de entorno cargadas correctamente");

    final String apiEndpoint = dotenv.env['API_ENDPOINT']?.isNotEmpty == true
        ? dotenv.env['API_ENDPOINT']!
        : "https://api3.simplifies.cl/api";

    final String apiKey = dotenv.env['API_KEY']?.isNotEmpty == true
        ? dotenv.env['API_KEY']!
        : "2RICHARDlEYVApEREZ";

    final String apiToken = dotenv.env['API_TOKEN']?.isNotEmpty == true
        ? dotenv.env['API_TOKEN']!
        : " !PRODUCCION";

    print(dotenv.env['API_ENDPOINT']);
    print('API Key: $apiKey');
    print('API Token: $apiToken');
  } catch (e) {
    print('Error al cargar las variables de entorno: $e');
    throw Exception('No se pudieron cargar las variables de entorno');
  }
}

// Solicitar permisos de notificación
Future<void> requestNotificationPermission() async {
  try {
    PermissionStatus status = await Permission.notification.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      PermissionStatus newStatus = await Permission.notification.request();
      if (newStatus.isDenied || newStatus.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  } catch (e) {
    print('Error al solicitar permisos de notificación: $e');
  }
}
