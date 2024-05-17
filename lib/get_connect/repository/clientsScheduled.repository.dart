// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Models/clientsScheduled_model.dart';
import 'package:turnopro_apk/Models/professional_model.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/env.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as dio;

class ClientsScheduledRepository extends GetConnect {
  final LoginController controllerLogin = Get.find<LoginController>();
  Future getClientsTechnicalList(idBranch) async {
    print('estoy en repositorio en - 1');
    try {
      List<ClientsScheduledModel> clientList = [];
      ClientsScheduledModel? nextClient;
      bool hasNextClient = false;
      int quantityClientAttended = 0;
      int quantityClientRechaz = 0;
      int idTecn = controllerLogin.idProfessionalLoggedIn!;

      // var url = '${Env.apiEndpoint}/cola_branch_capilar?branch_id=$idBranch';
      var url =
          '${Env.apiEndpoint}/cola_branch_tecnico?branch_id=$idBranch&professional_id=$idTecn';

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
          //AQUI PARA SABER CUANTOS ESTAN DE SOLICITUD DE RECHAZO
          if (client.attended == 33) {
            //HASTA AHORA EL TECNICO SOLO ATENDERA UNO SOLO
            quantityClientRechaz++;
          }
        }
        print('imprimiendo cuantos atinede el tecnico:$quantityClientAttended');
      }

      return {
        "clientList": clientList,
        "nextClient": nextClient,
        "quantityClientAttended": quantityClientAttended,
        "quantityClientRechaz": quantityClientRechaz,
      };
    } catch (e) {
      print(e);
    }
  }

  //
  //

  Future getClientsScheduledListNew(idProfessional, idBranch) async {
    print('estoy en repositorio en - 2');

    try {
      List<ClientsScheduledModel> clientList = [];
      List<ClientsScheduledModel> clientListSig = [];
      List<Map> attendingClientList = [];
      ClientsScheduledModel? nextClient;
      bool hasNextClient = false;
      int quantityClientAttended = 0;
      bool varclientswaiting = false;

      var url =
          '${Env.apiEndpoint}/cola_branch_professional_new?professional_id=$idProfessional&branch_id=$idBranch';
      print('a.......... getClientsScheduledList:url:$url');

      final response = await get(url).timeout(
          Duration(seconds: 15)); // Aumenta el tiempo de espera a 30 segundos

      //si la respuesta fuera null es que no logro conectarse al db,servidor caido o no tienne internet
      if (response.statusCode == null) {
        print('response.statusCode:${response.statusCode}');
        return {
          "ConnectionIssues": true,
        };
      } else
        print('hay coneccion');
      if (response.statusCode == 200) {
        // print('ya tengo la cola de la api es estaa *****************');
        final customers = response.body['tail'];
        // print('ya tengo la cola de la api es estaa${customers}');

// // //todo LEER TIPOS DE DATOS QUE VIENEN D LA API
//       for (int i = 0; i < customers.length; i++) {
//         print(
//             'ya tengo la cola de la api es estaa Tipos de datos para el objeto ${i + 1}:');
//         customers[i].forEach((key, value) {
//           print(
//               'ya tengo la cola de la api es estaa $key: ${value.runtimeType}');
//         });
//       }
// // //todo LEER TIPOS DE DATOS QUE VIENEN D LA API

        for (Map service in customers) {
          // print(
          //     'ya tengo la cola de la api es estaa *********for (Map service in customers)********');
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
      }

      return {
        "clientList": clientList,
        "clientListSig": clientListSig,
        "nextClient": nextClient,
        "quantityClientAttended": quantityClientAttended,
        "attendingClient": attendingClientList, //puede ser null
        "varclientswaiting":
            varclientswaiting, //este me dice si hay que mandar alguna notificacion recordando que hay cliente esperando en cola por ser atendido
      };
    } catch (e) {
      print(e);
    }
  }
//
  //

  Future getClientsScheduledList(idProfessional, idBranch) async {
    print('estoy en repositorio en - 2');

    try {
      List<ClientsScheduledModel> clientList = [];
      List<ClientsScheduledModel> clientListSig = [];
      List<Map> attendingClientList = [];
      ClientsScheduledModel? nextClient;
      bool hasNextClient = false;
      int quantityClientAttended = 0;
      bool varclientswaiting = false;

      var url =
          '${Env.apiEndpoint}/cola_branch_professional?professional_id=$idProfessional&branch_id=$idBranch';
      print('a.......... getClientsScheduledList:url:$url');

      final response = await get(url).timeout(
          Duration(seconds: 15)); // Aumenta el tiempo de espera a 30 segundos

      //si la respuesta fuera null es que no logro conectarse al db,servidor caido o no tienne internet
      if (response.statusCode == null) {
        print('response.statusCode:${response.statusCode}');
        return {
          "ConnectionIssues": true,
        };
      } else
        print('hay coneccion');
      if (response.statusCode == 200) {
        // print('ya tengo la cola de la api es estaa *****************');
        final customers = response.body['tail'];
        // print('ya tengo la cola de la api es estaa${customers}');

// // //todo LEER TIPOS DE DATOS QUE VIENEN D LA API
//       for (int i = 0; i < customers.length; i++) {
//         print(
//             'ya tengo la cola de la api es estaa Tipos de datos para el objeto ${i + 1}:');
//         customers[i].forEach((key, value) {
//           print(
//               'ya tengo la cola de la api es estaa $key: ${value.runtimeType}');
//         });
//       }
// // //todo LEER TIPOS DE DATOS QUE VIENEN D LA API

        for (Map service in customers) {
          // print(
          //     'ya tengo la cola de la api es estaa *********for (Map service in customers)********');
          ClientsScheduledModel client =
              ClientsScheduledModel.fromJson(jsonEncode(service));
          // print(
          //     'ya tengo la cola de la api es estaa *********for (Map service in customers22)********');
          //todo logica para saber si se cerro inesperadamente la apk y hay relojes activos
          if (controllerLogin.isLoggingIn == true) {
            if (client.detached == 1 &&
                client.attended != 0 &&
                client.attended != 2) {
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
              client.attended == 111 ||
              client.attended == 33) {
            print('relojes activos:${client.clock!}');
            //33 es rechazado por el tecnico pero es atendido por el barbero
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
      }

      return {
        "clientList": clientList,
        "clientListSig": clientListSig,
        "nextClient": nextClient,
        "quantityClientAttended": quantityClientAttended,
        "attendingClient": attendingClientList, //puede ser null
        "varclientswaiting":
            varclientswaiting, //este me dice si hay que mandar alguna notificacion recordando que hay cliente esperando en cola por ser atendido
      };
    } catch (e) {
      print(e);
    }
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

  Future getCustomerServicesList2(idCar) async {
    print('estoy en repositorio en - 3');
    print('ertyu - idCar $idCar');
    try {
      List<ServiceModel> serviceCustomer = [];
      var url = '${Env.apiEndpoint}/car_services2?car_id=$idCar';

      final response = await get(url);
      if (response.statusCode == 200) {
        print('ya tengo los servicios');
        final customers = response.body['services'];
        print('ertyu - services $customers');
        // int i = 1;
        for (Map service in customers) {
          ServiceModel u = ServiceModel.fromJson(jsonEncode(service));
          print('ertyu - service ${u.name}');
          serviceCustomer.add(u);
          // i++;
          //AQUI LA LOGICA DE SABER CUAL ES EL QUE LE SIGUE
        }
        print('2 okkkkkkkk');

        final data = response.body['clientHistory'];
        print('ertyu - clientHistory $data');
        String professionalNameBarber = data[0]['professionalName'];
        String imageUrlBarber = data[0]['image_url'];
        String imageLookBarber = data[0]['imageLook'];
        int cantVisitBarber = data[0]['cantVisit'];
        String endLookBarber = data[0]['endLook'] ?? '';
        String frecuenciaBarber = data[0]['frecuencia'];

        print('ertyu - $professionalNameBarber');
        print('ertyu - $imageUrlBarber');
        print('ertyu - $imageLookBarber');
        print('ertyu - $cantVisitBarber');
        print('ertyu - $endLookBarber');
        print('ertyu - $frecuenciaBarber');

        return {
          //valores de la cola
          "serviceCustomer": serviceCustomer,
          "professionalNameBarber": professionalNameBarber,
          "imageUrlBarber": imageUrlBarber,
          "imageLookBarber": imageLookBarber,
          "cantVisitBarber": cantVisitBarber,
          "endLookBarber": endLookBarber,
          "frecuenciaBarber": frecuenciaBarber,
        };
      } else {
        return serviceCustomer;
      }
    } catch (e) {
      print(e);
    }
  }

  Future getCustomerServicesList(idCar) async {
    print('estoy en repositorio en - 3');

    try {
      List<ServiceModel> serviceCustomer = [];
      var url = '${Env.apiEndpoint}/car_services?car_id=$idCar';

      final response = await get(url);
      if (response.statusCode == 200) {
        print('ya tengo los servicios');
        final customers = response.body['services'];
        // int i = 1;
        for (Map service in customers) {
          // print('IdCar:$i');
          ServiceModel u = ServiceModel.fromJson(jsonEncode(service));
          serviceCustomer.add(u);
          // i++;
          //AQUI LA LOGICA DE SABER CUAL ES EL QUE LE SIGUE
        }
        print('2 okkkkkkkk');
        return serviceCustomer;
      } else {
        return serviceCustomer;
      }
    } catch (e) {
      print(e);
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
    print('estoy en repositorio en - 4');
    try {
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
    } catch (e) {
      print(e);
    }
  } //

//
//
//
//
//
  Future getValueClockDb(id) async {
    print('estoy en repositorio en - 5');
    try {
      var url = '${Env.apiEndpoint}/get_clock?reservation_id=$id';

      final response = await get(url);
      if (response.statusCode == 200) {
        final result = response.body;
        print('EL RELOJ DEVUELTO ES :$result');
        return result;
      }
    } catch (e) {
      print(e);
      print('NOO DEVOLVIO NINGUN RELOJ  - el codigo no fue 200');

      return -99;
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

  Future typeOfService(idProfessional, idBranch) async {
    print('estoy en repositorio en - 6');
    try {
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
    } catch (e) {
      print(e);
    }
  }

  Future setTimeClock(reservationId, timeClock, detached, clock) async {
    print('estoy en repositorio en - 7');
    try {
      print('EL TIEMPO ACTUAL reservationId->$reservationId');
      print('EL TIEMPO ACTUAL timeClock->$timeClock');
      print('EL TIEMPO ACTUAL detached->$detached');
      print('EL TIEMPO ACTUAL clock->$clock');
      var url =
          '${Env.apiEndpoint}/set_timeClock?reservation_id=$reservationId&timeClock=$timeClock&detached=$detached&clock=$clock';

      final response = await get(url);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('estoy en repositorio en - 7 error:$e');
    }
  }

  //AQUI HACE LA LLAMADA PARA LOS INCUMPLIMIENTOS, 0 ES QUE INCUMPLIO Y 1 QUE CUMPLIO
  Future storeByType(type, branchId, professionalId, estado) async {
    print('estoy en repositorio en - 8');
    try {
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
        print('Acacba de incumplir en este type de convivencia:$type');
        return true;
      } else {
        print(
            'Intento de darle incumplimiento, pero algo salió mal y no fue posible');
        return false;
      }
    } catch (e) {
      print(e);
    }
  }

  Future returnClientStatus(reservationId) async {
    print('estoy en repositorio en - 9');
    try {
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
    } catch (e) {
      print(e);
    }
  }

  Future getProfessionalState(idBranch) async {
    print('estoy en repositorio en - 10');
    try {
      List<ProfessionalModel> professionalList = [];
      var url = '${Env.apiEndpoint}/professional-state?branch_id=$idBranch';

      final response = await get(url);
      print(
          'getProfessionalState(idBranch) async getProfessionalState(idBranch) url:$url');
      print(
          'getProfessionalState(idBranch) async getProfessionalState(idBranch) response.statusCode:${response.statusCode}');
      if (response.statusCode == 200) {
        final professionals = response.body['professionals'];
        for (Map professional in professionals) {
          ProfessionalModel u =
              ProfessionalModel.fromJson(jsonEncode(professional));
          //AQUI SOLO COJO QUE NO SEAN RESPONSABLES
          if (u.name != 'Encargado' && u.name != 'Coordinador') {
            //charge_id=3 es un responsable
            professionalList.add(u);
          }
        }
        print(
            'getProfessionalState(idBranch) async getProfessionalState(idBranch) async');
        print(professionalList.length);
        print(
            'getProfessionalState(idBranch) async getProfessionalState(idBranch) async professionalList.length:${professionalList.length}');
        return professionalList;
      }

      return professionalList;
    } catch (e) {
      print(e);
    }
  }

  Future getProfessionalState2(idBranch, idReserv) async {
    print('estoy en repositorio en - 10');
    try {
      List<ProfessionalModel> professionalList = [];
      var url =
          '${Env.apiEndpoint}/professional-state?branch_id=$idBranch&reservation_id=$idReserv';

      final response = await get(url);
      print(
          'getProfessionalState(idBranch) async getProfessionalState(idBranch) url:$url');
      print(
          'getProfessionalState(idBranch) async getProfessionalState(idBranch) response.statusCode:${response.statusCode}');
      if (response.statusCode == 200) {
        final professionals = response.body['professionals'];
        for (Map professional in professionals) {
          ProfessionalModel u =
              ProfessionalModel.fromJson(jsonEncode(professional));
          //AQUI SOLO COJO QUE NO SEAN RESPONSABLES
          if (u.name != 'Encargado' && u.name != 'Coordinador') {
            //charge_id=3 es un responsable
            professionalList.add(u);
          }
        }
        print(
            'getProfessionalState(idBranch) async getProfessionalState(idBranch) async');
        print(professionalList.length);
        print(
            'getProfessionalState(idBranch) async getProfessionalState(idBranch) async professionalList.length:${professionalList.length}');
        return professionalList;
      }

      return professionalList;
    } catch (e) {
      print(e);
    }
  }

  Future acceptOrRejectClient(reservationId, attended) async {
    print('estoy en repositorio en - 11');
    try {
      bool value = false;
      var url =
          '${Env.apiEndpoint}/tail_attended?reservation_id=$reservationId&attended=$attended';
      print(
          'ERROR:acceptOrRejectClient1 value = false- reservationId:$reservationId');
      print('ERROR:acceptOrRejectClient1 value = false- attended:$attended');
      final response = await get(url);
      if (response.statusCode == 200) {
        print('acceptOrRejectClient1 value = true');
        value = true;
        return value;
      } else {
        print(
            'ERROR:acceptOrRejectClient1 value = false- response.statusCode2${response.statusCode}');

        return false;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> deleteReservationClient(reservationId, cause) async {
    print('estoy en repositorio en - 12');
    try {
      bool value = false;
      var url = '${Env.apiEndpoint}/reservation-destroy';
      print('deleteReservationClient value reservationId :$reservationId');
      print('deleteReservationClient value cause :$cause');
      final Map<String, dynamic> body = {
        'id': reservationId,
        'cause': cause,
      };
      final response = await post(url, body);
      print(
          'deleteReservationClient value response.statusCode :${response.statusCode}');
      if (response.statusCode == 200) {
        value = true;
      }
      print('deleteReservationClient value = :$value');
      return value;
    } catch (e) {
      print('deleteReservationClient repos value e:$e');
      return false;
    }
  }

  Future storeByReservationId(
      imag, reservationId, commentText, dioClient) async {
    print('estoy en repositorio en - 13');
    try {
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
    } catch (e) {
      print(e);
    }
  }
}
