// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:soundpool/soundpool.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Models/notification_model.dart';
import 'package:turnopro_apk/get_connect/repository/notification.repository.dart';
import 'package:uuid/uuid.dart';

import 'login.controller.dart';

class NotificationController extends GetxController {
  //LLAMANDO AL CONTROLADOR
  NotificationController() {
    initializeNotifications();
  }
//DECLARACION DE VARIABLES
  NotificationRepository repository = NotificationRepository();
  final LoginController controllerLogin = Get.find<LoginController>();
  final ClientsScheduledController controllerclient =
      Get.find<ClientsScheduledController>();
  int notificationListLength = 0;
  int notificationListLengthEncarg = 0;
  int notificationListNewLength = 0;
  int notificationListNewLengthEncarg = 0;
  int notificationListBack = 0;
  int notificationListBackEncarg = 0;
  List<NotificationModel> notification = []; // Lista de Notificaciones
  List<NotificationModel> notificationEncarg = []; // Lista de Notificaciones
  List<NotificationModel> notificationListNew = []; // Lista de Notificaciones
  List<int> notificationListNewSounded = []; // Lista de Notificaciones
  List<NotificationModel> notificationListNewEncarg =
      []; // Lista de Notificaciones
  List<NotificationModel> selectNotification = [];
  bool isLoading = true;
  List<String> created_atTime = [];

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 2), () {
      isLoading = false;
      update();
    });
  }

  getList() {
    return notification;
  }

  Future<bool> storeNotification2(
      //todo1
      tittle,
      branchId,
      professionalId,
      description,
      type) async {
    //AQUI LLAMAR AL REPOSITORIO PARA DAR INCUMPLIMIENTO
    bool result = await repository.storeNotification2(
        tittle, branchId, professionalId, description, type);
    if (result) {
      print('CORRECTO inserto una nueva notificacion ');
    }
    return result;
  }

  Future<bool> storeNotification(
      //todo1
      tittle,
      branchId,
      professionalId,
      description,
      type) async {
    //AQUI LLAMAR AL REPOSITORIO PARA DAR INCUMPLIMIENTO
    bool result = await repository.storeNotification(
        tittle, branchId, professionalId, description, type);
    if (result) {
      print('CORRECTO inserto una nueva notificacion ');
    }
    return result;
  }

  Future<void> reproducirSound() async {
    Soundpool pool = Soundpool(streamType: StreamType.notification);
    print('reproduciendo el sonido-1');
    int soundId = await rootBundle
        .load("assets/sound/livechat-129007.mp3")
        .then((ByteData soundData) {
      print('reproduciendo el sonido-3');
      return pool.load(soundData);
    });
    int streamId = await pool.play(soundId);
    print('reproduciendo el sonido-2');
  }

  updateNotificationListBack(int value) {
    notificationListBack = value;
    update();
  }

  updateNotificationListBackEncarg(int value) {
    notificationListBackEncarg = value;
    update();
  }

  getSelectNotification(index) {
    (selectNotification.contains(notification[index]))
        ? selectNotification.remove(notification[index])
        : selectNotification.add(notification[index]);
    update();
  }

  //todo/****AQUI LO DE LAS NOTIFICACIONES LOCALES****/
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void scheduleNotification(String title, String descripcion) async {
    final Uuid uuid = Uuid(); // Crea una instancia de Uuid
    final String channelId = uuid.v4(); // Genera un channelId único
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channelId, // ID del canal
      'Nombre del Canal', // Nombre del Canal
      channelDescription:
          'Descripción del Canal', // Descripción del Canal (argumento nombrado)
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      sound: RawResourceAndroidNotificationSound('livechat129007'),
      // ^ Utiliza el nombre del archivo de sonido sin la extensión
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      descripcion,
      platformChannelSpecifics,
    );
  }
  //todo/****AQUI LO DE LAS NOTIFICACIONES LOCALES****/

  Future<void> fetchNotificationList(idBranch, idProfe, type, msj) async {
    print('qwerc SII mandar ->NOTIFICACIONES-$msj');
    print('12345llamada timer estoy en CAntidad de Notificaciones-$type');
    print(
        'llamada timer ...tipo:$type......idSucursal:$idBranch......iProf:$idProfe');
    try {
      Map<String, dynamic> result =
          await repository.getNotificationList(idBranch, idProfe, type);
      bool siHayEliminarService = false;

      if (result.containsKey('Erroor') && result['Erroor'] == true) {
        print(
            'mandar alguna variable para la vista deciendo que hay problemas al conectarse con el servidor, el error fue en Future<void> fetchNotificationList');
      } else if (result.containsKey('notificationList') &&
          result.containsKey('notificationListNew')) {
        notification = result['notificationList'];

        print(
            'llamada timer estoy en CAntidad de Notificaciones :${notification.length}');

        notificationListLength = notification.length;

        notificationListNew = result['notificationListNew'];
        notificationListNewLength = notificationListNew.length;

        notificationListNew.forEach((element) async {
          if (element.state == 0) {
            if (!notificationListNewSounded.contains(element.id)) {
              notificationListNewSounded.add(element.id);
              scheduleNotification(element.tittle, element.description);
            }
          }

          //SI HAY QUE ELIMINAR TIEMPO DEL RELOJ
          if (element.state == 3 &&
              element.tittle == 'Aceptada Eliminación de Servicio') {
            print('modificar time de mm 1 estoy aqui en el forEach');
            String textoCompleto = element.description;
            // String descripcion =
            //     textoCompleto.split('.')[0]; // Obtener la descripción
            // Obtener el segundo número (999)
            String numeroOcultoString = textoCompleto
                .split('.')[1]
                .trim(); // Obtener la parte después del punto y eliminar espacios en blanco
            int idReservation =
                int.parse(numeroOcultoString); // Convertir a entero
            controllerclient.watchModifyTimeRest(idReservation,
                textoCompleto); //aqui le mando el tiempo tambien y los voy sumando si el id coincidiera
            updateNotifications2(idBranch, idProfe,
                element.id); //aqui es para no repetir esto y lo pongo en 0

            //NOTIFICAR UQ HAY CAMBIOS EN LOS RELOJES
            //DESCONTAR EL TIEMPO AL RELOJ
            //MANDAR AL METODO DE SABER CUANTOS MINUTOS HAY QUE DESCONTAR
            siHayEliminarService = true;
          }
        });
        if (siHayEliminarService ==
            true) //entro solo si entro al if de 'Aceptada Eliminación de Servicio'
        {
          controllerclient.setActiveModifyTimeRest(true);
        }

        update();
      } else if (result.containsKey('notificationListEncarg') &&
          result.containsKey('notificationListNewEncarg')) {
        print('ENTRO A BUSCAR NOTIFICACIONES - cont: estoy en el controlador');
        notificationEncarg = result['notificationListEncarg'];

        notificationListLengthEncarg = notificationEncarg.length;

        notificationListNewEncarg = result['notificationListNewEncarg'];
        notificationListNewLengthEncarg = notificationListNewEncarg.length;
        print(
            'ENTRO A BUSCAR NOTIFICACIONES - cont: estoy en el controlador - notificationListNewLengthEncarg:${notificationEncarg.length}');

        notificationListNewEncarg.forEach((element) async {
          if (element.state == 3 &&
              element.tittle == 'Aceptada Eliminación de Servicio') {
            print('modificar time de mm 1 estoy aqui en el forEach');
            String textoCompleto = element.description;
            // String descripcion =
            //     textoCompleto.split('.')[0]; // Obtener la descripción
            // Obtener el segundo número (999)
            String numeroOcultoString = textoCompleto
                .split('.')[1]
                .trim(); // Obtener la parte después del punto y eliminar espacios en blanco
            int idReservation =
                int.parse(numeroOcultoString); // Convertir a entero
            controllerclient.watchModifyTimeRest(idReservation,
                textoCompleto); //aqui le mando el tiempo tambien y los voy sumando si el id coincidiera
            updateNotifications2(idBranch, idProfe,
                element.id); //aqui es para no repetir esto y lo pongo en 0

            //NOTIFICAR UQ HAY CAMBIOS EN LOS RELOJES
            //DESCONTAR EL TIEMPO AL RELOJ
            //MANDAR AL METODO DE SABER CUANTOS MINUTOS HAY QUE DESCONTAR
            siHayEliminarService = true;
          }
        });
        if (siHayEliminarService ==
            true) //entro solo si entro al if de 'Aceptada Eliminación de Servicio'
        {
          controllerclient.setActiveModifyTimeRest(true);
        }

        update();
      }
      controllerLogin.setIsLoadingFor(false);
    } catch (e) {
      controllerLogin.setIsLoadingFor(false);
      // Manejo de errores
      print('Error al obtener la lista de notificaciones: $e');
    }
  }

  Future<void> updateNotifications(idBranch, idProf, type) async {
    try {
      int result = await repository.updateNotifications(idBranch, idProf, type);
      if (result == 1) {
        print('Las notificaciones fueron vistas');
      } else {
        print('No modifico las notificaciones como vistas');
      }
    } catch (e) {
      print('error de notification:$e');
    }
  }

  Future<void> updateNotifications2(idBranch, idProf, id) async {
    try {
      int result = await repository.updateNotifications2(idBranch, idProf, id);
      if (result == 1) {
        print('Las notificaciones fueron cambiada a 3 estas de id:$id');
      } else {
        print('Las notificaciones fueron cambiada a 3 NOOOOOOOOOOOOO');
      }
    } catch (e) {
      print('error de notification:$e');
    }
  }
}
