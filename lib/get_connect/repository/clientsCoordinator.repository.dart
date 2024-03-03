// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Models/clientsScheduled_model.dart';
import 'package:turnopro_apk/Models/coexistence_model.dart';
import 'package:turnopro_apk/Models/product_model.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/Views/coordinator/coexistencePageCoordinator.dart';
import 'package:turnopro_apk/env.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as dio;

class ClientsCoordinatorRepository extends GetConnect {
  Future getClientsTechnicalList(idBranch) async {
    List<ClientsScheduledModel> clientList = [];
    ClientsScheduledModel? nextClient;
    bool hasNextClient = false;
    int quantityClientAttended = 0;

    var url = '${Env.apiEndpoint}/cola_branch_capilar?branch_id=$idBranch';

    final response = await get(url);
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
  Future reasignedClient(reservationId, clientId, professionalId) async {
    List<ClientsScheduledModel> clientList = [];

    var url =
        '${Env.apiEndpoint}/reasigned_client?reservation_id=$reservationId&client_id=$clientId&professional_id=$professionalId';

    final response = await get(url);
    //si la respuesta fuera null es que no logro conectarse al db,servidor caido o no tienne internet
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
  }

  //
  //
  //
  //
  Future getClientsScheduledListBranch(idBranch) async {
    List<ClientsScheduledModel> clientList = [];

    var url = '${Env.apiEndpoint}/cola_branch_data?branch_id=$idBranch';

    final response = await get(url);
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
  } //

  //
  //
  //
  Future clientsAttendBranch(idBranch) async {
    //clientes que se estan atendiendo de una branch
    List<ClientsScheduledModel> clientList = [];

    var url = '${Env.apiEndpoint}/tail_branch_attended?branch_id=$idBranch';

    final response = await get(url);
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

    return {"clientAttendList": clientList};
  }

  //
  //
  //
  Future getClientHistory(idClient, idBranch) async {
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

      final response = await get(url);
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
      print(
          'llamando _fetchCoexistenceList(); 111--222jsonString jsonStringjsonStringjsonStringjsonStringjsonString');
      String imageLook = responseBody['imageLook'] ?? 'default_profile.jpg';
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
  Future getClientsScheduledList(idProfessional, idBranch) async {
    List<ClientsScheduledModel> clientList = [];
    List<Map> attendingClientList = [];
    ClientsScheduledModel? nextClient;
    bool hasNextClient = false;
    int quantityClientAttended = 0;

    var url =
        '${Env.apiEndpoint}/cola_branch_professional?professional_id=$idProfessional&branch_id=$idBranch';

    final response = await get(url);
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
        if (client.detached == 1) {
          Map newValue = {
            "reservation_id": client.reservation_id,
            "updated_at": convertDateTimeToMinutes(client.updated_at!),
            "clock": client.clock!,
            "timeClock": client.timeClock! * 60, //convirtiendolo en minutos
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
        if (client.attended == 1) {
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

  Future<List<ServiceModel>> getCustomerServicesList(idCar) async {
    List<ServiceModel> serviceCustomer = [];
    var url = '${Env.apiEndpoint}/car_services?car_id=$idCar';

    final response = await get(url);
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
  Future sentValueClockDb(id, clock) async {
    var url = '${Env.apiEndpoint}/set_clock?reservation_id=$id&clock=$clock';

    final response = await get(url);
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
  Future getValueClockDb(id) async {
    var url = '${Env.apiEndpoint}/get_clock?reservation_id=$id';

    final response = await get(url);
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

    final response = await get(url);
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

  Future<bool> typeOfService(idProfessional, idBranch) async {
    var url =
        '${Env.apiEndpoint}/type_of_service?professional_id=$idProfessional&branch_id=$idBranch';

    final response = await get(url);
    if (response.statusCode == 200) {
      final typeService = response.body;
      print('typeOfService(idProfessional, idBranch) async:$typeService');
      return typeService;
    } else {
      return false;
    }
  }

  Future<bool> setTimeClock(reservationId, timeClock, detached, clock) async {
    var url =
        '${Env.apiEndpoint}/set_timeClock?reservation_id=$reservationId&timeClock=$timeClock&detached=$detached&clock=$clock';

    final response = await get(url);
    if (response.statusCode == 200) {
      print('repositorio set_timeClock devolviendo true');
      return true;
    } else {
      print('repositorio set_timeClock devolviendo false');
      return false;
    }
  }

  //AQUI HACE LA LLAMADA PARA LOS INCUMPLIMIENTOS, 0 ES QUE INCUMPLIO Y 1 QUE CUMPLIO
  Future<bool> storeByType(type, branchId, professionalId, estado) async {
    var url = '${Env.apiEndpoint}/storeByType';

    final Map<String, dynamic> body = {
      'type': type,
      'branch_id': branchId,
      'professional_id': professionalId,
      'estado': estado,
    };

    final response = await post(url, body);
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

  Future<int> returnClientStatus(reservationId) async {
    var url =
        '${Env.apiEndpoint}/return_client_status?reservation_id=$reservationId'; //todo hacer un metodo que devuelva dado un idCar si el servicio es simultaneo

    final response = await get(url);
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

  Future<bool> acceptOrRejectClient(reservationId, attended) async {
    bool value = false;
    var url =
        '${Env.apiEndpoint}/tail_attended?reservation_id=$reservationId&attended=$attended';

    final response = await get(url);
    if (response.statusCode == 200) {
      print('acceptOrRejectClient1 value = true');
      value = true;
      return value;
    } else {
      print('ERROR:acceptOrRejectClient1 value = false');

      return false;
    }
  }

  Future<bool> storeByReservationId(
      imag, reservationId, commentText, dioClient) async {
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
    final response = await post(url, body);
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
