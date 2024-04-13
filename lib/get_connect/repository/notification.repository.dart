// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Models/notification_model.dart';
import 'package:turnopro_apk/env.dart';
//todo REVISAR aqui se esta cargando una API de ejemplo no la de SIMPLIFI

class NotificationRepository extends GetConnect {
//insertar notificaciones
  Future<bool> storeNotification2(
      tittle, branchId, professionalId, description) async {
    var url = '${Env.apiEndpoint}/notification2';
    print('inserto correctamente ********** la notificacio:$tittle');
    final Map<String, dynamic> body = {
      'tittle': tittle,
      'branch_id': branchId,
      'professional_id': professionalId,
      'description': description,
    };

    final response = await post(url, body);
    print(tittle);
    print(branchId);
    print(professionalId);
    print(description);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('inserto correctamente la notificacio:$tittle');
      return true;
    } else {
      print('inserto correctamente ********** ERRORRR');
      print('ERROR no inserto la notificacio');
      return false;
    }
  }

  Future<bool> storeNotification(
      tittle, branchId, professionalId, description) async {
    var url = '${Env.apiEndpoint}/notification';
    print('inserto correctamente ********** la notificacio:$tittle');
    final Map<String, dynamic> body = {
      'tittle': tittle,
      'branch_id': branchId,
      'professional_id': professionalId,
      'description': description,
    };

    final response = await post(url, body);
    print(tittle);
    print(branchId);
    print(professionalId);
    print(description);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('inserto correctamente la notificacio:$tittle');
      return true;
    } else {
      print('inserto correctamente ********** ERRORRR');
      print('ERROR no inserto la notificacio');
      return false;
    }
  }

  Future getNotificationList(idBranch, idProf, type) async {
    try {
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
          print('ENTRO A BUSCAR NOTIFICACIONES - cont: - object000${u.type}');
          print('ENTRO A BUSCAR NOTIFICACIONES - cont: - type:$type');
          if (u.type == type || u.type == 'Barbero y Encargado') {
            print('ENTRO A BUSCAR NOTIFICACIONES - cont: - sii entre aqui-11');
            notificationList.add(u);
          }
          if (u.state == 0 || u.state == 3) {
            //si esta en estos estados es que no se ha visto
            //el u.state == 3 me dice que eliminaron un servicio y se mando a disminuir el tiempo del reloj
            if (u.type == type || u.type == 'Barbero y Encargado') {
              print(
                  'ENTRO A BUSCAR NOTIFICACIONES - cont: - sii entre aqui-22');
              notificationListNew.add(u); //barbero
            }
          }
        }
        if (type == 'Encargado') {
          print(
              'ENTRO A BUSCAR NOTIFICACIONES - cont: - notificationList-Encargado:${notificationList.length}');
          return {
            "notificationListEncarg": notificationList,
            "notificationListNewEncarg": notificationListNew,
          };
        } else {
          print(
              'ENTRO A BUSCAR NOTIFICACIONES - cont: - notificationList-Otros${notificationList.length}');
          return {
            "notificationList": notificationList,
            "notificationListNew": notificationListNew,
          };
        }
      } else {
        return notificationList;
      }
    } catch (e) {
      print(
          'mandar alguna variable para la vista Error en Future getNotificationList:e');
      return {
        'Erroor': true
      }; //si retorna null es que dio error deve ser de conexion
    }
  }

  Future<int> updateNotifications(idBranch, idProf, type) async {
    try {
      var url = '${Env.apiEndpoint}/notification';

      // Parámetros que deseas enviar en la solicitud POST
      final Map<String, dynamic> body = {
        'branch_id': idBranch,
        'professional_id': idProf,
        'type': type,
      };

      final response = await put(url, body);
      //print('MANDE A ELIMINAR:$body');
      if (response.statusCode == 200) {
        return 1;
      } else {
        return -990099;
      }
    } catch (e) {
      return -990099;
    }
  }

  Future<int> updateNotifications2(idBranch, idProf, id) async {
    try {
      var url = '${Env.apiEndpoint}/notification2';

      // Parámetros que deseas enviar en la solicitud POST
      final Map<String, dynamic> body = {
        'branch_id': idBranch,
        'professional_id': idProf,
        'id': id,
      };

      final response = await put(url, body);
      //print('MANDE A ELIMINAR:$body');
      if (response.statusCode == 200) {
        return 1;
      } else {
        return -990099;
      }
    } catch (e) {
      return -990099;
    }
  }
}
