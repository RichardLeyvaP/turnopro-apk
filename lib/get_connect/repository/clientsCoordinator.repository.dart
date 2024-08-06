// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Models/clientsScheduled_model.dart';
import 'package:turnopro_apk/Models/coexistence_model.dart';
import 'package:turnopro_apk/Models/notification_model.dart';
import 'package:turnopro_apk/Models/orderDelete_model.dart';
import 'package:turnopro_apk/Models/product_model.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/Views/coordinator/coexistencePageCoordinator.dart';
import 'package:turnopro_apk/env.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as dio;

class ClientsCoordinatorRepository extends GetConnect {
  Future getClientsTechnicalList(idBranch, token) async {
    List<ClientsScheduledModel> clientList = [];
    ClientsScheduledModel? nextClient;
    bool hasNextClient = false;
    int quantityClientAttended = 0;

    var url = '${Env.apiEndpoint}/cola_branch_capilar?branch_id=$idBranch';

    final headers = {
      "Authorization": "Bearer $token", // Agrega el token a los encabezados
    };
    final response = await get(url, headers: headers).timeout(
        Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
    //si la respuesta fuera null es que no logro conectarse al db,servidor caido o no tienne internet
    if (response.statusCode == null) {
      print('response.statusCode tecnico:${response.statusCode}');
      return {
        "ConnectionIssues": true,
      };
    } else
      print('hay coneccion tecnico');
    if (response.statusCode == 200) {
      print('ya tengo la cola de la api tecnico');
      final customers = response.body['tail'];
      for (Map service in customers) {
        ClientsScheduledModel client =
            ClientsScheduledModel.fromJson(jsonEncode(service));
        clientList.add(client);
        //AQUI PARA SABER CUAL ES EL CLIENTE QUE LE SIGUE, aqui solo coje el primero que tenga attended == 0
        if (hasNextClient == false) {
          //EL PRIMERO QUE ENCUENTRE CON 4 SERA EL SIGUIENTE
          if (client.attended == 4) {
            nextClient = client;
            hasNextClient = true;
          }
        }
        //AQUI PARA SABER CUANTOS ESTA ATENDIENDO por el tecnico
        if (client.attended == 5) {
          //HASTA AHORA EL TECNICO SOLO ATENDERA UNO SOLO
          quantityClientAttended++;
        }
      }
    }

    return {
      "clientList": clientList,
      "nextClient": nextClient,
      "quantityClientAttended": quantityClientAttended,
    };
  }

  //
  //
  //
  //
  //
  //
  Future reasignedClientTotem(branchId, professionalId, token) async {
    List<ClientsScheduledModel> clientList = [];
    try {
      var url =
          '${Env.apiEndpoint}/reasigned-client-totem?branch_id=$branchId&professional_id=$professionalId';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(
          Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos

      print('url que viene en reasignedClientTotem:$url');
      if (response.statusCode == null) {
        print('response.statusCode:${response.statusCode}');
        return {
          "ConnectionIssues": true,
        };
      } else if (response.statusCode == 200) {
        int res = response.body;
        if (res == 1) {
          return {
            "result": true,
          };
        } else if (res == 0) {
          return {
            "result": false,
          };
        }
      }

      return {"result": 2};
    } catch (e) {
      print('response.statusCode:${e}');
      print(e);
    }
  } //

  //
  //
  //
  Future reasignedClientSegundoPlano(
      professionalId, branchId, token, place) async {
    List<ClientsScheduledModel> clientList = [];
    //si place = 0 es para que reasigne ahi sin comprobar horas
    //si es 1 es normal la llamada con verificacion desde el servicio
    try {
      var url =
          '${Env.apiEndpoint}/reasigned-secound-plain?professional_id=$professionalId&branch_id=$branchId&place=$place';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(
          Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      //si la respuesta fuera null es que no logro conectarse al db,servidor caido o no tienne internet
      print('response.statusCode splano professionalId:${professionalId}');
      print('response.statusCode splano branchId:${branchId}');
      if (response.statusCode == 200) {
        print(
            'response.statusCode splano devuelve true,response.statusCode == 200 ');
        return {
          "result": true,
        };
      }
      if (response.statusCode == null) {
        print('response.statusCode:${response.statusCode}');
        return {
          "ConnectionIssues": true,
        };
      }

      return {"clientList": clientList};
    } catch (e) {
      print('response.statusCode:${e}');
      print(e);
    }
  }

  //
  //
  Future reasignedClientCoord(
      reservationId, clientId, professionalId, token) async {
    List<ClientsScheduledModel> clientList = [];
    try {
      var url =
          '${Env.apiEndpoint}/reasigned_client_coordinador?reservation_id=$reservationId&client_id=$clientId&professional_id=$professionalId';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(
          Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      //si la respuesta fuera null es que no logro conectarse al db,servidor caido o no tienne internet
      print('response.statusCode reservationId:${reservationId}');
      print('response.statusCode clientId:${clientId}');
      print('response.statusCode professionalId:${professionalId}');
      print('response.statusCode professionalId:${url}');
      print(
          'response.statusCode professionalId:response.statusCode${response.statusCode}');
      if (response.statusCode == null) {
        print('response.statusCode:${response.statusCode}');
        return {
          "ConnectionIssues": true,
        };
      } else if (response.statusCode == 200) {
        print(
            'hay coneccion reasignedClient devuelve true,response.statusCode == 200 ');
        return {
          "result": true,
        };
      }

      return {"clientList": clientList};
    } catch (e) {
      print('response.statusCode:${e}');
      print(e);
    }
  }

  //
  Future reasignedClient(reservationId, clientId, professionalId, token) async {
    List<ClientsScheduledModel> clientList = [];
    try {
      var url =
          '${Env.apiEndpoint}/reasigned_client?reservation_id=$reservationId&client_id=$clientId&professional_id=$professionalId';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(
          Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      //si la respuesta fuera null es que no logro conectarse al db,servidor caido o no tienne internet
      print('response.statusCode reservationId:${reservationId}');
      print('response.statusCode clientId:${clientId}');
      print('response.statusCode professionalId:${professionalId}');
      print('response.statusCode professionalId:${url}');
      print(
          'response.statusCode professionalId:response.statusCode${response.statusCode}');
      if (response.statusCode == null) {
        print('response.statusCode:${response.statusCode}');
        return {
          "ConnectionIssues": true,
        };
      } else if (response.statusCode == 200) {
        print(
            'hay coneccion reasignedClient devuelve true,response.statusCode == 200 ');
        return {
          "result": true,
        };
      }

      return {"clientList": clientList};
    } catch (e) {
      print('response.statusCode:${e}');
      print(e);
    }
  }

  //
  //
  //
  //
  //
  //
  Future notification_tail_colationR(idBranch, idProf, type, token) async {
    List<ClientsScheduledModel> clientList = [];
    List<ClientsScheduledModel> professionals3 = [];
    List<ClientsScheduledModel> professionals4 = [];
    List<NotificationModel> notificationList = [];
    List<NotificationModel> notificationListNew = [];
    List<OrderDeleteModel> orderDEL = [];
    List<ClientsScheduledModel> clientListDel = [];
    try {
      var url =
          '${Env.apiEndpoint}/notification-tail-colation?branch_id=$idBranch&professional_id=$idProf';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(
          Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      //si la respuesta fuera null es que no logro conectarse al db,servidor caido o no tienne internet

      print('hay coneccion getClientsScheduledListBranch');
      if (response.statusCode == 200) {
        //aqui evaluar tds las respuestas
        //todo-1
        //cola_branch_data
        final customers = response.body['tail'];
        for (Map service in customers) {
          ClientsScheduledModel client =
              ClientsScheduledModel.fromJson(jsonEncode(service));
          clientList.add(client);
        }
        //todo-1
        //
        //todo-2 notifications
        final notifications = response.body['notifications'];
        print(
            'llamada timer estoy en CAntidad de Notificaciones fetchNotificationList Tecn:$notifications');
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

        //todo-2 notifications
        //
        //
        //todo-3 Cola
        final orders = response.body['carOrderDelete'];
        print(orders);
        if (orders != null) {
          for (int i = 0; i < orders.length; i++) {
            print(
                'ordya tengo la cola de la api es estaa Tipos de datos para el objeto ${i + 1}:');
            orders[i].forEach((key, value) {
              print(
                  'ordya tengo la cola de la api es estaa $key: ${value.runtimeType}');
            });
          }
          for (Map order in orders) {
            print('DIO ERROR loadOrderDeleteCarv aqui mapeandooooo');
            OrderDeleteModel u = OrderDeleteModel.fromJson(jsonEncode(order));
            orderDEL.add(u);
            print('DIO ERROR loadOrderDeleteCarv aqui mapeandooooo2222');
          }
        }
        //retornando dos listas

        //todo-3 Cola
        //
        //
        //todo-4 Cola1
        final customers2 = response.body['tail1']; //cola_branch_data2
        print(
            'ya tengo la cola de la api getClientsRechazBranch:${customers2}');
        for (Map service in customers2) {
          print('ya tengo la cola de la api getClientsRechazBranch222222222');
          ClientsScheduledModel client =
              ClientsScheduledModel.fromJson(jsonEncode(service));
          clientListDel.add(client);
          print('ya tengo la cola de la api getClientsRechazBranch333333333');
          //AQUI PARA SABER CUAL ES EL CLIENTE QUE LE SIGUE, aqui solo coje el primero que tenga attended == 0
        }
        //todo-4 Cola1
        //
        //
        //todo-5 Cola1
        final customers3 = response.body['professionals3'];
        for (Map service in customers3) {
          ClientsScheduledModel client2 =
              ClientsScheduledModel.fromJson(jsonEncode(service));

          professionals3.add(client2);
        }
        //todo-5 Cola1
        //
        //todo-6 Cola1
        final customers4 = response.body['professionals4'];
        for (Map service in customers4) {
          ClientsScheduledModel client4 =
              ClientsScheduledModel.fromJson(jsonEncode(service));

          professionals4.add(client4);
          print(
              'yccca tengo la cola de la api profOutRequestBranch:${clientList.length}');
        }
        //todo-6 Cola1
        //
        //
      } else if (response.statusCode == null) {
        print(
            'response.statusCode al ser diferente de 200:${response.statusCode}');
        return {
          "ConnectionIssues": true,
        };
      }

      if (type == 'Encargado') {
        return {
          "tail": clientList,
          "orderDEL": orderDEL,
          "clientListDel": clientListDel,
          "professionals3": professionals3,
          "professionals4": professionals4,
          "notificationListEncarg": notificationList,
          "notificationListNewEncarg": notificationListNew,
        };
      } else {
        return {
          "tail": clientList,
          "orderDEL": orderDEL,
          "clientListDel": clientListDel,
          "professionals3": professionals3,
          "professionals4": professionals4,
          "notificationList": notificationList,
          "notificationListNew": notificationListNew,
        };
      }
    } catch (e) {
      print('estoy dando este error ...:$e');
      return {"clientList": clientList};
    }
  } //

  //
  //
  Future getClientsScheduledListBranch(idBranch, token) async {
    List<ClientsScheduledModel> clientList = [];
    try {
      var url = '${Env.apiEndpoint}/cola_branch_data?branch_id=$idBranch';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(
          Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      //si la respuesta fuera null es que no logro conectarse al db,servidor caido o no tienne internet
      if (response.statusCode == null) {
        print('response.statusCode:${response.statusCode}');
        return {
          "ConnectionIssues": true,
        };
      } else
        print('hay coneccion getClientsScheduledListBranch');
      if (response.statusCode == 200) {
        print('ya tengo la cola de la api getClientsScheduledListBranch');
        final customers = response.body['tail'];
        for (Map service in customers) {
          ClientsScheduledModel client =
              ClientsScheduledModel.fromJson(jsonEncode(service));
          clientList.add(client);
          //AQUI PARA SABER CUAL ES EL CLIENTE QUE LE SIGUE, aqui solo coje el primero que tenga attended == 0
        }
      }

      return {"clientList": clientList};
    } catch (e) {
      print(e);
      return {"clientList": clientList};
    }
  } //

  //
  //
  Future getClientsRechazBranch(idBranch, token) async {
    List<ClientsScheduledModel> clientListDel = [];
    try {
      //esta me muestra los que estan rechazados
      var url = '${Env.apiEndpoint}/cola_branch_data2?branch_id=$idBranch';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(
          Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      //si la respuesta fuera null es que no logro conectarse al db,servidor caido o no tienne internet
      if (response.statusCode == null) {
        print('response.statusCode:${response.statusCode}');
        return {
          "ConnectionIssues": true,
        };
      } else
        print('hay coneccion getClientsRechazBranch');
      if (response.statusCode == 200) {
        print('ya tengo la cola de la api getClientsRechazBranch');
        final customers = response.body['tail'];
        print('ya tengo la cola de la api getClientsRechazBranch:${customers}');
        for (Map service in customers) {
          print('ya tengo la cola de la api getClientsRechazBranch222222222');
          ClientsScheduledModel client =
              ClientsScheduledModel.fromJson(jsonEncode(service));
          clientListDel.add(client);
          print('ya tengo la cola de la api getClientsRechazBranch333333333');
          //AQUI PARA SABER CUAL ES EL CLIENTE QUE LE SIGUE, aqui solo coje el primero que tenga attended == 0
        }
        print(
            'ya tengo la cola de la api getClientsRechazBranch clientListDel:${clientListDel.length}');
      }

      return {"clientListDel": clientListDel};
    } catch (e) {
      print(e);
    }
  } //

  //
  //
  //
  Future clientsColacionBranch(idBranch, token) async {
    //clientes que se estan atendiendo de una branch
    List<ClientsScheduledModel> clientList = [];

    var url = '${Env.apiEndpoint}/branch_colacion?branch_id=$idBranch';

    final headers = {
      "Authorization": "Bearer $token", // Agrega el token a los encabezados
    };
    final response = await get(url, headers: headers).timeout(
        Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
    //si la respuesta fuera null es que no logro conectarse al db,servidor caido o no tienne internet
    if (response.statusCode == null) {
      print('response.statusCode:${response.statusCode}');
      return {
        "ConnectionIssues": true,
      };
    } else
      print('hay coneccion ClientsColacionBranch');
    if (response.statusCode == 200) {
      print('ya tengo la cola de la api ClientsColacionBranch');
      final customers = response.body['professionals'];
      for (Map service in customers) {
        ClientsScheduledModel client =
            ClientsScheduledModel.fromJson(jsonEncode(service));

        clientList.add(client);
        print(
            'yccca tengo la cola de la api ClientsColacionBranchLength:${clientList.length}');
      }
    }

    return {"clientAttendList": clientList};
  } //

  //
  //
  Future clientsColacionRequestBranch(idBranch, token) async {
    //clientes que se estan atendiendo de una branch
    List<ClientsScheduledModel> clientList = [];

    var url = '${Env.apiEndpoint}/branch_colacion3?branch_id=$idBranch';

    final headers = {
      "Authorization": "Bearer $token", // Agrega el token a los encabezados
    };
    final response = await get(url, headers: headers).timeout(
        Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
    //si la respuesta fuera null es que no logro conectarse al db,servidor caido o no tienne internet
    if (response.statusCode == null) {
      print('response.statusCode:${response.statusCode}');
      return {
        "ConnectionIssues": true,
      };
    } else
      print('hay coneccion ClientsColacionBranch');
    if (response.statusCode == 200) {
      print('ya tengo la cola de la api ClientsColacionBranch');
      final customers = response.body['professionals'];
      for (Map service in customers) {
        ClientsScheduledModel client =
            ClientsScheduledModel.fromJson(jsonEncode(service));

        clientList.add(client);
        print(
            'yccca tengo la cola de la api ClientsColacionBranchLength:${clientList.length}');
      }
    }

    return {"clientAttendList": clientList};
  } //

  //
  //
  Future profOutRequestBranch(idBranch, token) async {
    //clientes que se estan atendiendo de una branch
    List<ClientsScheduledModel> clientList = [];

    var url = '${Env.apiEndpoint}/branch_colacion4?branch_id=$idBranch';

    final headers = {
      "Authorization": "Bearer $token", // Agrega el token a los encabezados
    };
    final response = await get(url, headers: headers).timeout(
        Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
    //si la respuesta fuera null es que no logro conectarse al db,servidor caido o no tienne internet
    if (response.statusCode == null) {
      print('response.statusCode:${response.statusCode}');
      return {
        "ConnectionIssues": true,
      };
    } else
      print('hay coneccion profOutRequestBranch');
    if (response.statusCode == 200) {
      print('ya tengo la cola de la api ClientsColacionBranch');
      final customers = response.body['professionals'];
      for (Map service in customers) {
        ClientsScheduledModel client =
            ClientsScheduledModel.fromJson(jsonEncode(service));

        clientList.add(client);
        print(
            'yccca tengo la cola de la api profOutRequestBranch:${clientList.length}');
      }
    }

    return {"clientAttendList": clientList};
  } //

  Future clientsAttendBranch(idBranch, token) async {
    //clientes que se estan atendiendo de una branch
    List<ClientsScheduledModel> clientList = [];

    var url = '${Env.apiEndpoint}/tail_branch_attended?branch_id=$idBranch';

    final headers = {
      "Authorization": "Bearer $token", // Agrega el token a los encabezados
    };
    final response = await get(url, headers: headers).timeout(
        Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
    //si la respuesta fuera null es que no logro conectarse al db,servidor caido o no tienne internet
    if (response.statusCode == null) {
      print('response.statusCode:${response.statusCode}');
      return {
        "ConnectionIssues": true,
      };
    } else
      print('hay coneccion getClientsScheduledListBranch');
    if (response.statusCode == 200) {
      print('ya tengo la cola de la api getClientsScheduledListBranch');
      // final customers = response.body['tail'];
      final customers = response.body['attended'];
      print(
          'ya tengo la cola de la api getClientsScheduledListBranch:customers:$customers');
      for (Map service in customers) {
        ClientsScheduledModel client =
            ClientsScheduledModel.fromJson(jsonEncode(service));

        clientList.add(client);
        print(
            'yccca tengo la cola de la api getClientsScheduledListBranch:${clientList.length}');
      }
    }

    return {"clientAttendList": clientList};
  }

  //
  //
  //
  Future getClientHistory(idClient, idBranch, token) async {
    try {
      List<ServiceModel> serviceCustomer = [];
      List<ProductModel> productCustomer = [];
      String frecuencia = 'No frecuente';
      String endLook = 'No hay comentarios al respecto';

      print('llamando _fetchCoexistenceList(); --- getClientHistory1');
      print('llamando _fetchCoexistenceList(); --- idClient:$idClient');
      print('llamando _fetchCoexistenceList(); --- idBranch:$idBranch');
      var url =
          '${Env.apiEndpoint}/client-history?client_id=$idClient&branch_id=$idBranch';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(
          Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      print('llamando _fetchCoexistenceList(); --- getClientHistory2');
      // Verifica si hubo algún problema de conexión.
      if (response.statusCode != 200) {
        print(
            'llamando _fetchCoexistenceList(); --- getClientHistory-- response.statusCode != 200');
        print(
            'llamando _fetchCoexistenceList(); Error de conexión: ${response.statusCode}');
        return {
          "ConnectionIssues": true,
        };
      } else {
        print(
            'llamando _fetchCoexistenceList(); --- getClientHistory -- Conexión exitosa');
        print('Conexión exitosa');
      }
      print(
          'llamando _fetchCoexistenceList(); 111jsonString jsonStringjsonStringjsonStringjsonStringjsonString');
      // Decodifica el cuerpo de la respuesta.

      final Map<String, dynamic> responseBody = response.body['clientHistory'];
      print(
          'llamando _fetchCoexistenceList(); 111--111--1111jsonString jsonStringjsonStringjsonStringjsonStringjsonString');
      //aqui cogemos las variables
      String clientName = responseBody['clientName'];
      String professionalName = responseBody['professionalName'];
      String image_url = responseBody['image_url'];

      String imageLook = responseBody['imageLook'];
      print(
          'llamando _fetchCoexistenceList(); 111--333jsonString jsonStringjsonStringjsonStringjsonStringjsonString');
      int cantVisit = responseBody['cantVisit'];
      print(
          'llamando _fetchCoexistenceList(); 111--444jsonString jsonStringjsonStringjsonStringjsonStringjsonString');
      if (responseBody['endLook'] is String) {
        endLook = responseBody['endLook'];
      }

      print(
          'llamando _fetchCoexistenceList(); 111--555jsonString jsonStringjsonStringjsonStringjsonStringjsonString');
      //REVISANDO QUE LLEGUE UN STRING
      if (responseBody['frecuencia'] is String) {
        frecuencia = responseBody['frecuencia'];
      }
      print(
          'llamando _fetchCoexistenceList(); 111--666jsonString jsonStringjsonStringjsonStringjsonStringjsonString');

      final serv = responseBody['services'];
      print(
          'llamando _fetchCoexistenceList(); 111--777jsonString jsonStringjsonStringjsonStringjsonStringjsonString');
      for (Map service in serv) {
        print('1');
        ServiceModel u = ServiceModel.fromJson(jsonEncode(service));
        serviceCustomer.add(u);
        //AQUI LA LOGICA DE SABER CUAL ES EL QUE LE SIGUE
      }

      final prod = responseBody['products'];
      print(
          'llamando _fetchCoexistenceList(); 111--888jsonString jsonStringjsonStringjsonStringjsonStringjsonString');
//       // //todo LEER TIPOS DE DATOS QUE VIENEN D LA API
//       for (int i = 0; i < prod.length; i++) {
//         print(
//             'ya tengo la cola de la api es estaa Tipos de datos para el objeto ${i + 1}:');
//         prod[i].forEach((key, value) {
//           print(
//               'ya tengo la cola de la api es estaa $key: ${value.runtimeType}');
//         });
//       }
// // //todo LEER TIPOS DE DATOS QUE VIENEN D LA API
      for (Map product in prod) {
        print('1');
        ProductModel u = ProductModel.fromJson(jsonEncode(product));
        productCustomer.add(u);
        //AQUI LA LOGICA DE SABER CUAL ES EL QUE LE SIGUE
      }
      print(
          'llamando _fetchCoexistenceList(); 555jsonString jsonStringjsonStringjsonStringjsonStringjsonString');

      return {
        "clientName": clientName,
        "professionalName": professionalName,
        "image_url": image_url,
        "imageLook": imageLook,
        "cantVisit": cantVisit,
        "endLook": endLook,
        "frecuencia": frecuencia,
        "services": serviceCustomer,
        "products": productCustomer
      };
    } catch (e) {
      print('Error llamando _fetchCoexistenceList();: $e');
    }
  }

//
  //
  //
  Future getClientsScheduledList(idProfessional, idBranch, token) async {
    List<ClientsScheduledModel> clientList = [];
    List<Map> attendingClientList = [];
    ClientsScheduledModel? nextClient;
    bool hasNextClient = false;
    int quantityClientAttended = 0;

    var url =
        '${Env.apiEndpoint}/cola_branch_professional?professional_id=$idProfessional&branch_id=$idBranch';

    final headers = {
      "Authorization": "Bearer $token", // Agrega el token a los encabezados
    };
    final response = await get(url, headers: headers).timeout(
        Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
    //si la respuesta fuera null es que no logro conectarse al db,servidor caido o no tienne internet
    if (response.statusCode == null) {
      print('response.statusCode:${response.statusCode}');
      return {
        "ConnectionIssues": true,
      };
    } else
      print('hay coneccion');
    if (response.statusCode == 200) {
      print('ya tengo la cola de la api');
      final customers = response.body['tail'];
      for (Map service in customers) {
        ClientsScheduledModel client =
            ClientsScheduledModel.fromJson(jsonEncode(service));
        //todo logica para saber si se cerro inesperadamente la apk y hay relojes activos
        if (client.detached == 1 &&
            client.attended != 0 &&
            client.attended != 2) {
          //0 es estar en cola, 2 es finalizado

          Map newValue = {
            "reservation_id": client.reservation_id,
            "updated_at": convertDateTimeToMinutes(client.updated_at!),
            "clock": client.clock!,
            "timeClock": client.timeClock!, //todo cambiar123RLP
            "client": client,
          };
          attendingClientList.add(newValue);
        }

        clientList.add(client);
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
            client.attended == 111 ||
            client.attended == 33) {
          //33 es rechazado por el tecnico pero es atendido por el barbero
          //agregue aqui estos dos 11 y 111
          quantityClientAttended++;
        }
      }
    }

    return {
      "clientList": clientList,
      "nextClient": nextClient,
      "quantityClientAttended": quantityClientAttended,
      "attendingClient": attendingClientList, //puede ser null
    };
  }

  String convertDateTimeToString(DateTime dateTimeDb) {
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateTimeDb);
  }

  int convertDateTimeToMinutes(String dateTimeDb) {
    // String dateTimeString = convertDateTimeToString(dateTimeDb);
    // Parsing the date and time string to a DateTime object
    DateTime dateTime = DateTime.parse(dateTimeDb);

    // Getting the total minutes elapsed since the epoch (1970-01-01 00:00:00)
    int minutes = dateTime.toUtc().millisecondsSinceEpoch ~/ (1000 * 60);

    return minutes;
  }

  Future<List<ServiceModel>> getCustomerServicesList(idCar, token) async {
    print('estoy en repositorio en - 3-getCustomerServicesList');
    List<ServiceModel> serviceCustomer = [];
    var url = '${Env.apiEndpoint}/car_services?car_id=$idCar';

    final headers = {
      "Authorization": "Bearer $token", // Agrega el token a los encabezados
    };
    final response = await get(url, headers: headers).timeout(
        Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
    if (response.statusCode == 200) {
      print('ya tengo los servicios');
      final customers = response.body['services'];
      for (Map service in customers) {
        print('1');
        ServiceModel u = ServiceModel.fromJson(jsonEncode(service));
        serviceCustomer.add(u);
        //AQUI LA LOGICA DE SABER CUAL ES EL QUE LE SIGUE
      }
      print('2 okkkkkkkk');
      return serviceCustomer;
    } else {
      return serviceCustomer;
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
//
//
//
  Future sentValueClockDb(id, clock, token) async {
    var url = '${Env.apiEndpoint}/set_clock?reservation_id=$id&clock=$clock';

    final headers = {
      "Authorization": "Bearer $token", // Agrega el token a los encabezados
    };
    final response = await get(url, headers: headers).timeout(
        Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
    if (response.statusCode == 200) {
      print('ya guardo el reloj que esta utilizando');
      return true;
    } else {
      print('NOO guardo el reloj que esta utilizando - el codigo no fue 200');
      print(response.statusCode);
      return false;
    }
  } //

//
//
//
//
//
  Future getValueClockDb(id, token) async {
    var url = '${Env.apiEndpoint}/get_clock?reservation_id=$id';

    final headers = {
      "Authorization": "Bearer $token", // Agrega el token a los encabezados
    };
    final response = await get(url, headers: headers).timeout(
        Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
    if (response.statusCode == 200) {
      final result = response.body;
      print('EL RELOJ DEVUELTO ES :$result');
      return result;
    } else {
      print('NOO DEVOLVIO NINGUN RELOJ  - el codigo no fue 200');
      print(response.statusCode);
      return false;
    }
  }

  /* Future<bool> getServicesSimultaneou(idCar) async {
    var url =
        '${Env.apiEndpoint}/car_services?car_id=$idCar'; //todo hacer un metodo que devuelva dado un idCar si el servicio es simultaneo

    final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(
          Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
    if (response.statusCode == 200) {
      final customers = response.body['services'];
      for (Map service in customers) {
        ServiceModel serv = ServiceModel.fromJson(jsonEncode(service));
        if (serv.simultaneou == 1) {
          return true;
        } else {
          return false;
        }
      }
      return false;
    } else {
      return false;
    }
  }*/

  Future<bool> typeOfService(idProfessional, idBranch, token) async {
    print('estoy en repositorio en - 6-2');
    var url =
        '${Env.apiEndpoint}/type_of_service?professional_id=$idProfessional&branch_id=$idBranch';

    final headers = {
      "Authorization": "Bearer $token", // Agrega el token a los encabezados
    };
    final response = await get(url, headers: headers).timeout(
        Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
    if (response.statusCode == 200) {
      final typeService = response.body;
      print('typeOfService(idProfessional, idBranch) async:$typeService');
      return typeService;
    } else {
      return false;
    }
  }

  Future<bool> setTimeClock(
      reservationId, timeClock, detached, clock, token) async {
    var url =
        '${Env.apiEndpoint}/set_timeClock?reservation_id=$reservationId&timeClock=$timeClock&detached=$detached&clock=$clock';

    final headers = {
      "Authorization": "Bearer $token", // Agrega el token a los encabezados
    };
    final response = await get(url, headers: headers).timeout(
        Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //AQUI HACE LA LLAMADA PARA LOS INCUMPLIMIENTOS, 0 ES QUE INCUMPLIO Y 1 QUE CUMPLIO
  Future<bool> storeByType(
      type, branchId, professionalId, estado, token) async {
    var url = '${Env.apiEndpoint}/storeByType';

    final Map<String, dynamic> body = {
      'type': type,
      'branch_id': branchId,
      'professional_id': professionalId,
      'estado': estado,
    };

    final headers = {
      "Authorization": "Bearer $token", // Agrega el token a los encabezados
    };
    final response = await post(headers: headers, url, body);
    print(type);
    print(branchId);
    print(professionalId);
    print(estado);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('Acacba de cambiar el type de convivencia:$type');
      return true;
    } else {
      print(
          'Intento de darle incumplimiento, pero algo salió mal y no fue posible');
      return false;
    }
  }

  Future<int> returnClientStatus(reservationId, token) async {
    var url =
        '${Env.apiEndpoint}/return_client_status?reservation_id=$reservationId'; //todo hacer un metodo que devuelva dado un idCar si el servicio es simultaneo

    final headers = {
      "Authorization": "Bearer $token", // Agrega el token a los encabezados
    };
    final response = await get(url, headers: headers).timeout(
        Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
    if (response.statusCode == 200) {
      final statusClient = response.body;
      print(
          'Future<int> returnClientStatus(reservationId) async {:$statusClient');
      return statusClient;
    } else {
      print(
          'Future<int> returnClientStatus(reservationId) async {:${response.statusCode}');
      return -99;
    }
  }

  Future<bool> acceptOrRejectClient(reservationId, attended, token) async {
    bool value = false;
    var url =
        '${Env.apiEndpoint}/tail_attended?reservation_id=$reservationId&attended=$attended';

    final headers = {
      "Authorization": "Bearer $token", // Agrega el token a los encabezados
    };
    final response = await get(url, headers: headers).timeout(
        Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
    if (response.statusCode == 200) {
      print('acceptOrRejectClient1 value = true');
      value = true;
      return value;
    } else {
      print(
          'ERROR:acceptOrRejectClient1 value = false- response.statusCode${response.statusCode}');

      return false;
    }
  }

  Future<bool> storeByReservationId(
      imag, reservationId, commentText, dioClient, token) async {
    // Crear FormData y agregar la imagen
    dio.FormData formData = dio.FormData.fromMap({
      'client_look':
          await dio.MultipartFile.fromFile(imag, filename: 'client_look.jpg'),
      'reservation_id': reservationId,
      'look': commentText,
    });

    try {
      dio.Response response = await dioClient.post(
        '${Env.apiEndpoint}/storeByReservationId',
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization':
                'Bearer $token', // Agregar el token en el encabezado
            'Content-Type': 'multipart/form-data', // Tipo de contenido
          },
        ),
      );
      print('++++++++++++++++++++');
      print(response.data);
      return true;
    } catch (e) {
      print('Error al subir la imagen: $e');
      return false;
    }

    /*  var url = '${Env.apiEndpoint}/storeByReservationId';

    // Parámetros que deseas enviar en la solicitud POST
    final Map<String, dynamic> body = {
      'reservation_id': reservationId,
      'look': look,
      'client_look': image,
    };
    // Realizar la solicitud POST
    final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
    final response = await post(headers:headers,url, body);
    if (response.statusCode == 200) {
      print('storeByReservationId value = true');
      value = true;
      return value;
    } else {
      print('ERROR:storeByReservationId value = false');
      print(
          'ERROR:storeByReservationId value = false : ${response.statusCode}');

      return false;
    }*/
  }
}
