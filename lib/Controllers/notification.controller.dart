// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:turnopro_apk/Models/notification_model.dart';
import 'package:turnopro_apk/get_connect/repository/notification.repository.dart';

class NotificationController extends GetxController {
  //LLAMANDO AL CONTROLADOR
  NotificationController() {
    _fetchNotificationList();
  }
//DECLARACION DE VARIABLES
  NotificationRepository repository = NotificationRepository();
  int notificationListLength = 0;
  List<NotificationModel> notification = []; // Lista de Notificaciones
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

  getSelectNotification(index) {
    (selectNotification.contains(notification[index]))
        ? selectNotification.remove(notification[index])
        : selectNotification.add(notification[index]);
    update();
  }

  Future<void> _fetchNotificationList() async {
    notification = await repository.getNotificationList();
    notificationListLength = notification.length;
    update();
  }
}
