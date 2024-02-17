// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Models/notification_model.dart';
import 'package:turnopro_apk/env.dart';
//todo REVISAR aqui se esta cargando una API de ejemplo no la de SIMPLIFI

class NotificationRepository extends GetConnect {
  Future getNotificationList(idBranch, idProf) async {
    print('estoy aqui en getNotificationList');
    List<NotificationModel> notificationList = [];
    List<NotificationModel> notificationListNew = [];
    var url =
        '${Env.apiEndpoint}/notification-professional?branch_id=$idBranch&professional_id=$idProf'; //cambiar aqui por servicios en la api

    final response = await get(url);
    if (response.statusCode == 200) {
      final notifications = response.body['notifications'];
      for (Map notification in notifications) {
        NotificationModel u =
            NotificationModel.fromJson(jsonEncode(notification));
        notificationList.add(u);
        if (u.state == 0) {
          notificationListNew.add(u);
        }
      }

      return {
        "notificationList": notificationList,
        "notificationListNew": notificationListNew,
      };
    } else {
      return notificationList;
    }
  }
}
