// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:soundpool/soundpool.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Models/notification_model.dart';
import 'package:turnopro_apk/get_connect/repository/notification.repository.dart';

import 'login.controller.dart';

class NotificationController extends GetxController {
  //LLAMANDO AL CONTROLADOR
  NotificationController();
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
      description) async {
    //AQUI LLAMAR AL REPOSITORIO PARA DAR INCUMPLIMIENTO
    bool result = await repository.storeNotification2(
        tittle, branchId, professionalId, description);
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
      description) async {
    //AQUI LLAMAR AL REPOSITORIO PARA DAR INCUMPLIMIENTO
    bool result = await repository.storeNotification(
        tittle, branchId, professionalId, description);
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

  Future<void> fetchNotificationList(idBranch, idProfe, type) async {
    print('este es nuevo y estoy llamando a la db a cargar las notificaciones');
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

        notificationListLength = notification.length;

        notificationListNew = result['notificationListNew'];
        notificationListNewLength = notificationListNew.length;

        notificationListNew.forEach((element) async {
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
