import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Views/coordinator/services/localStorage.dart';
import 'package:intl/intl.dart';
import 'package:turnopro_apk/app_initializer.dart';
import 'package:uuid/uuid.dart';

final LoginController loginController = Get.find<LoginController>();
NotificationController notiController = Get.find<NotificationController>();
final ClientsCoordinatorController clientCord = Get.find<ClientsCoordinatorController>();
final ClientsScheduledController clientsScheduledController = Get.find<ClientsScheduledController>();

const notificationChannelIdSilent = 'silent_channel_id';
const notificationChannelIdNormal = 'normal_channel_id';
const notificationId = 888;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Crear el canal de notificaciones sin sonido
  const AndroidNotificationChannel silentChannel = AndroidNotificationChannel(
    notificationChannelIdSilent,
    'Silent Channel',
    description: 'Canal para notificaciones sin sonido',
    importance: Importance.low,
    playSound: false,
  );

  // Crear el canal de notificaciones con sonido
  const AndroidNotificationChannel normalChannel = AndroidNotificationChannel(
    notificationChannelIdNormal,
    'Normal Channel',
    description: 'Canal para notificaciones con sonido',
    importance: Importance.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound(
        'livechat129007'), // Reemplaza con el sonido que desees       notificationIcon:'ic_new_service_icon',
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(silentChannel);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(normalChannel);

  // Detener cualquier instancia en ejecución antes de iniciar una nueva
  service.invoke('stopService');
  await Future.delayed(const Duration(seconds: 1));

  // Configurar el servicio
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      // isForegroundMode: true,
      notificationChannelId: notificationChannelIdSilent,
      initialNotificationTitle: 'Simplifies-v1.0',
      initialNotificationContent: '',
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
  // Configurar el servicio
  /* await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: notificationChannelIdSilent,
      initialNotificationTitle: 'Simplifies 1.0',
      initialNotificationContent: '',
      // Añadir configuración del icono aquí
      foregroundServiceNotificationId: 888,
      foregroundServiceType: AndroidForegroundType.location,

      // foreground ServiceNotificationContent: () async {
      //   final details = await _notificationDetails();
      //   return details;
      // },
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );*/

  service.startService();
}

@pragma('vm:entry-point')
bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  return true;
}

Future<void> notificationSimplifies() async {
  print('notificacion desde:-:SERVICIO-notificationSimplifies()');
  print('notificacion desde:-:SERVICIO-notificationSimplifies()-${LocalStorage.prefs.getString('charge_profesional')}');

  // Verifica si la clave 'charge_profesional' existe y no está vacía
  String? chargeProfesional = LocalStorage.prefs.getString('charge_profesional');

  if (chargeProfesional != null && chargeProfesional.isNotEmpty) {
    print('notificacion desde:-:SERVICIO-notificationSimplifies()-chargeProfesional:$chargeProfesional');
    // Verifica si el valor de 'charge_profesional' es 'Barbero y Encargado'
    if (chargeProfesional == 'Barbero y Encargado') {
      print('notificacion desde:-:SERVICIO-notificationSimplifies()-1');

      // Verifica si las claves necesarias existen antes de usarlas
      int? branchProfesional = LocalStorage.prefs.getInt('branch_profesional');
      int? idProfesional = LocalStorage.prefs.getInt('id_profesional');
      String? tokenUser = LocalStorage.prefs.getString('tokenUser');

      if (branchProfesional != null && idProfesional != null && tokenUser != null) {
        await notiController.fetchNotificationListSERV(
            branchProfesional, idProfesional, 'Barbero', 'LLamando-desde-background-service', tokenUser);
        await Future.delayed(const Duration(seconds: 3));
        await notiController.fetchNotificationListSERV(
            branchProfesional, idProfesional, 'Encargado', 'LLamando-desde-background-service', tokenUser);
      } else {
        print('Algunas claves necesarias no están presentes en LocalStorage.prefs.');
      }
    } else {
      print('notificacion desde:-:SERVICIO-notificationSimplifies()-2');

      // Verifica si las claves necesarias existen antes de usarlas
      int? branchProfesional = LocalStorage.prefs.getInt('branch_profesional');
      int? idProfesional = LocalStorage.prefs.getInt('id_profesional');
      String? tokenUser = LocalStorage.prefs.getString('tokenUser');

      if (branchProfesional != null && idProfesional != null && tokenUser != null) {
        await notiController.fetchNotificationListSERV(
            branchProfesional, idProfesional, chargeProfesional, 'LLamando-desde-background-service', tokenUser);
      } else {
        print('Algunas claves necesarias no están presentes en LocalStorage.prefs.');
      }
    }
  } else {
    print('La clave charge_profesional no existe o está vacía.');
  }

  //
}

// Inicializa el plugin de notificaciones locales
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// Lista para almacenar los IDs de las notificaciones
List<int> notificationIds = [];

Future<void> initializeNotificationsNew() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_bg_service_small');

  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> localNotificationsSimplifies(String title, String description) async {
  const channelId = notificationChannelIdNormal; // Usa un canal de notificación constante

  // Configuración específica de Android para el canal
  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    channelId,
    'Nombre del Canal',
    channelDescription: 'Descripción del Canal',
    importance: Importance.max,
    priority: Priority.high,
    sound: RawResourceAndroidNotificationSound('livechat129007'),
    icon: 'ic_bg_service_small',
    enableLights: true,
    color: Colors.blue,
    ledColor: Color(0xffffffff),
    ledOnMs: 1000,
    ledOffMs: 500,
    fullScreenIntent: true,
    ongoing: true,
  );

  // Detalles de la notificación para la plataforma
  final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

  // Genera un ID de notificación único
  final int notificationId = Uuid().v1().hashCode;

  // Muestra la notificación
  await flutterLocalNotificationsPlugin.show(notificationId, title, description, platformChannelSpecifics);

  // Añadir el ID de la notificación a la lista
  notificationIds.add(notificationId);

  // Verificar si hay más de 6 notificaciones
  if (notificationIds.length > 6) {
    // Eliminar las 3 primeras notificaciones
    for (int i = 0; i < 3; i++) {
      int idToRemove = notificationIds.removeAt(0);
      await flutterLocalNotificationsPlugin.cancel(idToRemove);
    }
  }
}

// Método para limpiar todas las notificaciones
void clearAllNotifications() {
  // Asegúrate de que esto no cause un error si no hay notificaciones
  try {
    // Aquí debes tener el código que limpia todas las notificaciones
    flutterLocalNotificationsPlugin.cancelAll();

    print('Todas las notificaciones han sido limpiadas');
  } catch (e) {
    print('No hay notificaciones para limpiar: $e');
  }
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  await AppInitializer.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.configurePrefs();

  await initializeNotificationsNew(); // Asegúrate de inicializar aquí

  try {
    await dotenv.load();
  } catch (e) {
    print('Error cargando variables de entorno: $e');
    return; // Salir de la aplicación si no se pueden cargar las variables de entorno
  }

  String apiEndpoint = dotenv.env['API_ENDPOINT'] ?? '';
  print('API Endpoint: $apiEndpoint');

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  service.on('notificationSimplifies').listen((event) {
    notificationSimplifies();
  });
  service.on('clearAllNotifications').listen((event) {
    clearAllNotifications();
  });

  // if (service is AndroidServiceInstance) {
  //   service.setForegroundNotificationInfo(
  //     title: "Simplifies",
  //     content: "",
  //   );
  // }
  Future reasignate() async {
    // Verifica si las claves necesarias existen antes de usarlas
    int? branchProfesional = LocalStorage.prefs.getInt('branch_profesional');
    int? idProfesional = LocalStorage.prefs.getInt('id_profesional');
    String? tokenUser = LocalStorage.prefs.getString('tokenUser');
    String? chargeProfesional = LocalStorage.prefs.getString('charge_profesional');

    if (branchProfesional != null && idProfesional != null && tokenUser != null) {
      if (chargeProfesional != null && chargeProfesional.isNotEmpty) {
        // Verifica si el valor de 'charge_profesional' es 'Barbero y Encargado'
        if ((chargeProfesional == 'Barbero y Encargado') || (chargeProfesional == 'Barbero')) {
          await clientCord.reasignedClientSegundoPlano(idProfesional, branchProfesional, tokenUser, 1);
        }
      }
    } else {
      print('Algunas claves necesarias no están presentes en LocalStorage.prefs.-reasignedClientSegundoPlano');
    }
  }

  // Example of a periodic task.
  Timer.periodic(const Duration(seconds: 11), (timer) async {
    notificationSimplifies();
    await Future.delayed(const Duration(seconds: 6));
    reasignate();
  });
}
