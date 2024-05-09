// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Models/clientsScheduled_model.dart';
import 'package:turnopro_apk/Models/notification_model.dart';
import 'package:turnopro_apk/env.dart';
//todo REVISAR aqui se esta cargando una API de ejemplo no la de SIMPLIFI

class NotificationRepository extends GetConnect {
  final LoginController controllerLogin = Get.find<LoginController>();
//insertar notificaciones
  Future<bool> storeNotification2(
      tittle, branchId, professionalId, description, type) async {
    try {
      var url =
          '${Env.apiEndpoint}/notification2'; //esta inserta la notificacion con state = 3
      print('inserto correctamente ********** la notificacio:$tittle');
      final Map<String, dynamic> body = {
        'tittle': tittle,
        'branch_id': branchId,
        'professional_id': professionalId,
        'description': description,
        'type': type,
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
    } catch (e) {
      print('inserto correctamente ********** ERRORRR:$e');
      return false;
    }
  }

  Future<bool> storeNotification(
      tittle, branchId, professionalId, description, type) async {
    try {
      var url = '${Env.apiEndpoint}/notification';
      print('inserto correctamente ********** la notificacio:$tittle');
      final Map<String, dynamic> body = {
        'tittle': tittle,
        'branch_id': branchId,
        'professional_id': professionalId,
        'description': description,
        'type': type,
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
        print(
            'inserto correctamente ********** ERRORRR:${response.statusCode}');
        print('ERROR no inserto la notificacio');
        return false;
      }
    } catch (e) {
      print('inserto correctamente ********** ERRORRR->:$e');
      return false;
    }
  }

//
//
//
//
//
//
//
//
  Future professionalBranchNotifQueque(idBranch, idProf, type) async {
    try {
      print('llamada timer en 10 segundos A professionalBranchNotifQueque');
      List<NotificationModel> notificationList = [];
      List<NotificationModel> notificationListNew = [];
      //variables de la cola
      List<ClientsScheduledModel> clientList = [];
      List<ClientsScheduledModel> clientListSig = [];
      List<Map> attendingClientList = [];
      ClientsScheduledModel? nextClient;
      bool hasNextClient = false;
      int quantityClientAttended = 0;
      bool varclientswaiting = false;
      //variables de la cola
      var url =
          '${Env.apiEndpoint}/professional-branch-notif-queque?branch_id=$idBranch&professional_id=$idProf'; //cambiar aqui por servicios en la api

      final response = await get(url);
      if (response.statusCode == 200) {
        // final jsonResponse = jsonDecode(response.body);

        //todo NOTIFICATIONS
        final notifications = response.body['notifications'];

        for (Map notification in notifications) {
          NotificationModel u =
              NotificationModel.fromJson(jsonEncode(notification));

          if (u.type == type || u.type == 'Barbero y Encargado') {
            notificationList.add(u);
          }
          if (u.state == 0 || u.state == 3) {
            //si esta en estos estados es que no se ha visto
            //el u.state == 3 me dice que eliminaron un servicio y se mando a disminuir el tiempo del reloj
            if (u.type == type || u.type == 'Barbero y Encargado') {
              notificationListNew.add(u); //barbero
            }
          }
        }
        print(
            'llamada timer en 10 segundos CANTIDAD nOTIFICACIONES:${notificationListNew.length}');
        //todo END NOTIFICATIONS
        //aqui el trabajo con la respuesta de la cola
        // final List<dynamic> tailData = jsonResponse['tail'];
        //todo  TAILS
        final customers = response.body['tail'];

        for (Map service in customers) {
          ClientsScheduledModel client =
              ClientsScheduledModel.fromJson(jsonEncode(service));
          // print(
          //     'ya tengo la cola de la api es estaa *********for (Map service in customers22)********');
          //todo logica para saber si se cerro inesperadamente la apk y hay relojes activos
          if (controllerLogin.isLoggingIn == true) {
            if (client.detached == 1 && client.attended != 33) {
              //33 es que lo rechazó el tecnico
              //creo nuevo cliente
              print(
                  'clientes asistiendo entre a if (client.detached == 1) {//creo nuevo cliente');
              Map newValue = {
                "reservation_id": client.reservation_id,
                //"updated_at": convertDateTimeToMinutes(client.updated_at!),
                "updated_at": client.updated_at!,
                "clock": client.clock!,
                "timeClock": client.timeClock! * 60, //convirtiendolo en minutos
                "client": client,
              };
              attendingClientList.add(newValue);
              print(
                  'clientes asistiendo client.reservation_id:${client.reservation_id}');
              print('clientes asistiendo client.clock!:${client.clock!}');
              print('clientes asistiendo timeClock:${client.timeClock! * 60}');
              print('clientes asistiendo client:${client}');
            }
          }

          clientList.add(client);
          if (client.attended == 0) {
            clientListSig.add(client);
          }
          //AQUI PARA SABER CUAL ES EL CLIENTE QUE LE SIGUE, aqui solo coje el primero que tenga attended == 0

          if (hasNextClient == false) {
            if (client.attended == 0) {
              nextClient = client;
              hasNextClient = true;
            }
          }
          //AQUI PARA SABER CUANTOS ESTA ATENDIENDO
          if (client.attended == 1 ||
              client.attended == 11 ||
              client.attended == 111) {
            print('clientes asistiendo entre a if (client.attended == 1) {');
            quantityClientAttended++;
          }
          //Saber si no esta atendiendo a nadie
          if (quantityClientAttended == 0) {
            //para saber si hay algun cliente en espera
            if (nextClient != null) {
              varclientswaiting = true;
            }
          }
        }
        //aqui el trabajo con la respuesta de la cola
        print(
            'llamada timer en 10 segundos CANTIDAD LA COLA:${clientList.length}');
        //todo END TAILS

        if (type == 'Encargado') {
          return {
            //valores de la cola
            "clientList": clientList,
            "clientListSig": clientListSig,
            "nextClient": nextClient,
            "quantityClientAttended": quantityClientAttended,
            "attendingClient": attendingClientList, //puede ser null
            "varclientswaiting":
                varclientswaiting, //este me dice si hay que mandar alguna notificacion recordando que hay cliente esperando en cola por ser atendido
            //valores de la cola
            "notificationListEncarg": notificationList,
            "notificationListNewEncarg": notificationListNew,
          };
        } else {
          return {
            //valores de la cola
            "clientList": clientList,
            "clientListSig": clientListSig,
            "nextClient": nextClient,
            "quantityClientAttended": quantityClientAttended,
            "attendingClient": attendingClientList, //puede ser null
            "varclientswaiting":
                varclientswaiting, //este me dice si hay que mandar alguna notificacion recordando que hay cliente esperando en cola por ser atendido
            //valores de la cola

            "notificationList": notificationList,
            "notificationListNew": notificationListNew,
          };
        }
      } else {
        return notificationList;
      }
    } catch (e) {
      print('llamada timer en 10 segundos DI ERROR EN :$e');
      return {
        'Erroor': true
      }; //si retorna null es que dio error deve ser de conexion
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

          if (type == 'Coordinador' || type == 'Encargado') {
            if (u.type == type ||
                u.type == 'Ambos' ||
                u.type == 'Barbero y Encargado') {
              notificationList.add(u);
            }
            if (u.state == 0 || u.state == 3) {
              //si esta en estos estados es que no se ha visto
              //el u.state == 3 me dice que eliminaron un servicio y se mando a disminuir el tiempo del reloj
              if (u.type == type ||
                  u.type == 'Ambos' ||
                  u.type == 'Barbero y Encargado') {
                notificationListNew.add(u); //barbero
              }
            }
          } else {
            if (u.type == type || u.type == 'Barbero y Encargado') {
              notificationList.add(u);
            }
            if (u.state == 0 || u.state == 3) {
              //si esta en estos estados es que no se ha visto
              //el u.state == 3 me dice que eliminaron un servicio y se mando a disminuir el tiempo del reloj
              if (u.type == type || u.type == 'Barbero y Encargado') {
                notificationListNew.add(u); //barbero
              }
            }
          }
        }
        if (type == 'Encargado') {
          return {
            "notificationListEncarg": notificationList,
            "notificationListNewEncarg": notificationListNew,
          };
        } else {
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
      var url =
          '${Env.apiEndpoint}/notification2'; //pone de es estate del mensaje en 0

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
