// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Models/notification_model.dart';
//todo REVISAR aqui se esta cargando una API de ejemplo no la de SIMPLIFI

class NotificationRepository extends GetConnect {
  Future<List<NotificationModel>> getNotificationList() async {
    List<NotificationModel> notificationList = [];
    var url =
        'http://jsonplaceholder.typicode.com/users'; //cambiar aqui por servicios en la api

    final response = await get(url);
    if (response.statusCode == 200) {
      final notifications = response.body;
      for (Map notification in notifications) {
        NotificationModel u =
            NotificationModel.fromJson(jsonEncode(notification));
        notificationList.add(u);
      }
      return notificationList;
    } else {
      return notificationList;
    }
  }
}
