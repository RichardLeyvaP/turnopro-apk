// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:soundpool/soundpool.dart';
import 'package:turnopro_apk/Models/notification_model.dart';
import 'package:turnopro_apk/get_connect/repository/notification.repository.dart';

class NotificationController extends GetxController {
  //LLAMANDO AL CONTROLADOR
  NotificationController();
//DECLARACION DE VARIABLES
  NotificationRepository repository = NotificationRepository();
  int notificationListLength = 0;
  int notificationListNewLength = 0;
  int notificationListBack = 0;
  List<NotificationModel> notification = []; // Lista de Notificaciones
  List<NotificationModel> notificationListNew = []; // Lista de Notificaciones
  List<NotificationModel> selectNotification = [];
  bool isLoading = true;

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

  getSelectNotification(index) {
    (selectNotification.contains(notification[index]))
        ? selectNotification.remove(notification[index])
        : selectNotification.add(notification[index]);
    update();
  }

  Future<void> fetchNotificationList(idBranch, idProfe) async {
    print('este es nuevo y estoy llamando a la db a cargar las notificaciones');
    Map<String, dynamic> result =
        await repository.getNotificationList(idBranch, idProfe);
    if (result.containsKey('Erroor') && result['Erroor'] == true) {
      print(
          'mandar alguna variable para la vista deciendo que hay problemas al conectarse con el servidor, el error fue en Future<void> fetchNotificationList');
    } else {
      notification = result['notificationList'];
      notificationListLength = notification.length;

      notificationListNew = result['notificationListNew'];
      notificationListNewLength = notificationListNew.length;
      print(
          'estoy aqui en getNotificationList-   notificationListLength:$notificationListLength');
      update();
    }
  }

  Future<void> updateNotifications(idBranch, idProf) async {
    try {
      int result = await repository.updateNotifications(idBranch, idProf);
      if (result == 1) {
        print('Las notificaciones fueron vistas');
      } else {
        print('No modifico las notificaciones como vistas');
      }
    } catch (e) {
      print('error de notification:$e');
    }
  }
}
