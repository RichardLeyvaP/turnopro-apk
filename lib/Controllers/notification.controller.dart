// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:turnopro_apk/Models/notification_model.dart';
import 'package:turnopro_apk/get_connect/repository/notification.repository.dart';

class NotificationController extends GetxController {
  //LLAMANDO AL CONTROLADOR
  NotificationController() {
    getTotalSum();
    calculateTime();
    if (yaEntre == false) {
      _fetchNotificationList(); // Llamar al método asincrónico en el constructor
      getTotalSum();
      yaEntre = true;
      update();
    }
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 2), () {
      isLoading = false;
      update();
    });
  }

  NotificationRepository repository = NotificationRepository();
  bool yaEntre = false;
  double getTotal = 20.0;
  int numero = 5;
  int notificationListLength = 0;
  List<NotificationModel> notification = []; // Lista de Notificaciones
  List<NotificationModel> selectNotification =
      []; // Lista de Notificaciones seleccionados vacia
  int time = 30;
  bool isLoading = true;

  void calculateTime() {
    if (time > 60) {
      //controlando que el tiempo no sea mayor que 60 min
      time = 60;
    }
    if (time < 0) {
      //controlando que el tiempo no sea negativo
      time = 0;
    }
    update();
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

  getTotalSum() {
    getTotal = getTotal + 5;

    // getTotal = notification
    //     .map((Notification) => Notification.id)
    //     .fold(0.0, (sum, id) => sum + id)
    //     .toDouble();
    // print(getTotal);
    update();
  }

  //Future<List<UserModel>> userList() async => await repository.getUserList();

  Future<void> _fetchNotificationList() async {
    notification = await repository.getNotificationList();
    notificationListLength = notification.length;
    update();
  }

  void addNotification() {
    NotificationModel newUser = NotificationModel(
        id: 12,
        name: "Servicio $notificationListLength",
        username: "Nuevo servicio");
    notification.add(newUser);
    notificationListLength =
        notification.length; //actualizo la logitud de la lista
    getTotalSum();
    update();
  }

//***************************************************************
//*METODOS ELIMINAR

  //*ELIMINAR 1 ELEMENTO
  void deleteNotification(int index) {
    if (index >= 0 && index < notification.length) {
      //HACER LLAMADA A REPOSITORYY MANDAR A ELIMINAR EN LA BD
      //SI SE ELIMINA CORRECTAMENTE MADO HACER LO DE ABAJO,Q ES ELIMINAR EN LA PARTE VISUAL

      if (selectNotification.contains(notification[index])) {
        selectNotification.removeWhere(
            (notifications) => notifications == notification[index]);
        getTotal = getTotal - 5;
      }
    }
    notification.removeAt(index);
    notificationListLength = notification.length;

    update();
  }

  //*ELIMINAR  ELEMENTOS SELECCIONADOS
  void deleteMultipleNotification() {
    if (selectNotification.isNotEmpty) {
      //HACER LLAMADA A REPOSITORYY MANDAR A ELIMINAR EN LA BD
      //SI SE ELIMINA CORRECTAMENTE MADO HACER LO DE ABAJO,Q ES ELIMINAR EN LA PARTE VISUAL
      notification
          .removeWhere((element) => selectNotification.contains(element));
      notificationListLength = notification.length;
      selectNotification = [];
      getTotal = getTotal - 5;
      update();
    }
  }

  void deleteAll() {
    notification = [];
    selectNotification = [];
    notificationListLength = notification.length;
    getTotal = 0.0;
    update();
  }
}
