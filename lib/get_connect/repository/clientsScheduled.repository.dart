// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Models/ClockModel.dart';
import 'package:turnopro_apk/Models/clientsScheduled_model.dart';
import 'package:turnopro_apk/Models/professional_model.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/Views/professional/clientsScheduled/modalHelperClientSchedule.dart';
import 'package:turnopro_apk/env.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as dio;

class ClientsScheduledRepository extends GetConnect {
  //final LoginController controllerLogin = Get.find<LoginController>();

  Future repoShowClock(int differenceInSeconds, professionalId, token) async {
    int timeC1 = -999, timeC2 = -999, timeC3 = -999, timeC4 = -999;

    try {
      var url = '${dotenv.env['API_ENDPOINT']}/show-clocks?professional_id=$professionalId';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(Duration(seconds: 15));
      print(url);
      print(response.statusCode);
      print('RETORNE-- repoShowClock-.url:${response.statusCode}');
      print('RETORNE-- repoShowClock-response.statusCode:${response.statusCode}');
      if ((response.statusCode == 200)) {
        print('RETORNE-- repoShowClock-repoShowClock:${response.body}');
        // Decodifica el JSON
        //Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Mapea la respuesta JSON a una instancia de TailsResponse
        TailsResponse tailsResponse = TailsResponse.fromMap(response.body);
        print('RETORNE-- repoShowClock-repoShowClock2:${tailsResponse}');
        // Por ejemplo, puedes recorrer la lista de ClockModel
        // Verifica si la lista "tails" está vacía
        if (tailsResponse.tails.isEmpty) {
          print('RETORNE---ESTA VACIA');
        } else {
          tailsResponse.tails.forEach((clock) {
            print('RETORNE---Clock: ${clock.clock}, TimeClock: ${clock.timeClock}, Detached: ${clock.detached}');
            if (clock.clock == 1 && (clock.attended != 4 && clock.attended != 5 && clock.attended != 33)) {
              //esta con el tecnco si attended tiene esos valores
              int calculatedTime = clock.timeClock - differenceInSeconds;
              timeC1 = calculatedTime < 0 ? 0 : calculatedTime;
            } else if (clock.clock == 2 && (clock.attended != 4 && clock.attended != 5 && clock.attended != 33)) {
              int calculatedTime = clock.timeClock - differenceInSeconds;
              timeC2 = calculatedTime < 0 ? 0 : calculatedTime;
            } else if (clock.clock == 3 && (clock.attended != 4 && clock.attended != 5 && clock.attended != 33)) {
              int calculatedTime = clock.timeClock - differenceInSeconds;
              timeC3 = calculatedTime < 0 ? 0 : calculatedTime;
            } else if (clock.clock == 4 && (clock.attended != 4 && clock.attended != 5 && clock.attended != 33)) {
              int calculatedTime = clock.timeClock - differenceInSeconds;
              timeC4 = calculatedTime < 0 ? 0 : calculatedTime;
            }
          });
        }

        return {
          'timeC1': timeC1,
          'timeC2': timeC2,
          'timeC3': timeC3,
          'timeC4': timeC4,
        };
      } else {
        print('RETORNE-- repoShowClock-FALSE A LA CREACION DEL Qr');
        return false;
      }
    } catch (e) {
      print('RETORNE-- repoShowClock-ERROR DE SERVIDOR A LA CREACION DEL Qr:$e');
      return -999;
    }
  }

  Future getClientsTechnicalList(idBranch, idProf, token) async {

    try {
      List<ClientsScheduledModel> clientList = [];
      ClientsScheduledModel? nextClient, clientAtenYa;
      bool hasNextClient = false;
      int quantityClientAttended = 0;
      int quantityClientRechaz = 0;
      int idTecn = idProf;

      // var url = '${dotenv.env['API_ENDPOINT']}/cola_branch_capilar?branch_id=$idBranch';
      var url = '${dotenv.env['API_ENDPOINT']}/cola_branch_tecnico?branch_id=$idBranch&professional_id=$idTecn';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response =
          await get(url, headers: headers).timeout(Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
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
          ClientsScheduledModel client = ClientsScheduledModel.fromJson(jsonEncode(service));

          clientList.add(client);
          //AQUI PARA SABER CUAL ES EL CLIENTE QUE LE SIGUE, aqui solo coje el primero que tenga attended == 4
          if (hasNextClient == false) {
            //EL PRIMERO QUE ENCUENTRE CON 4 SERA EL SIGUIENTE
            if (client.attended == 4) {
              nextClient = client;
              hasNextClient = true;
            }
          }
          //AQUI PARA SABER CUANTOS ESTA ATENDIENDO por el tecnico
          if (client.attended == 5) {
            //con solo una vez que entre aqui ya pone en null a nesClient
            //HASTA AHORA EL TECNICO SOLO ATENDERA UNO SOLO
            clientAtenYa = client;

            quantityClientAttended++;
          }
          //AQUI PARA SABER CUANTOS ESTAN DE SOLICITUD DE RECHAZO
          if (client.attended == 33) {
            //HASTA AHORA EL TECNICO SOLO ATENDERA UNO SOLO
            quantityClientRechaz++;
          }
        }
        print('imprimiendo cuantos atinede el tecnico:...$quantityClientAttended');
      }

      return {
        "clientAtenYa": clientAtenYa,
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

  Future getClientsScheduledListNewServ(idProfessional, idBranch, isLoggingIn, token) async {

    try {
      int clientListSalon = 0;
      List<ClientsScheduledModel> clientList = [];
      List<ClientsScheduledModel> clientListSig = [];
      List<Map> attendingClientList = [];
      ClientsScheduledModel? nextClient;
      bool hasNextClient = false;
      int quantityClientAttended = 0;
      bool varclientswaiting = false;

      //final response = await get(url, headers: headers);
      var url = '${dotenv.env['API_ENDPOINT']}/tail-branch-professional?professional_id=$idProfessional&branch_id=$idBranch';
      print('a.......... getClientsScheduledList:url:$url');

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response =
          await get(url, headers: headers).timeout(Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos

      //si la respuesta fuera null es que no logro conectarse al db,servidor caido o no tienne internet
      if (response.statusCode != 200) {
        print('Primer ruta protegida-response.statusCode == null');
        print('response.statusCode:${response.statusCode}');
        //loginController.showConnectionError();
        return {
          "ConnectionIssues": true,
        };
      } else if (response.statusCode == 200) {
        print('Primer ruta protegida-response.statusCode == 200');
        // print('ya tengo la cola de la api es estaa *****************');
        final customers = response.body['tail'];
        // print('ya tengo la cola de la api es estaa${customers}');



        for (Map service in customers) {

          ClientsScheduledModel client = ClientsScheduledModel.fromJson(jsonEncode(service));

          // logica para saber si se cerro inesperadamente la apk y hay relojes activos
          if (isLoggingIn == true) {
            //controllerLogin.isLoggingIn
            if (client.detached == 1 && client.attended != 33 && client.attended != 2) {
              //33 es que lo rechazó el tecnico
              //2 es que ya fue atendido y por alguna razón quedo attendened 1
              //creo nuevo cliente
              print('clientes asistiendo entre a if (client.detached == 1) {//creo nuevo cliente');
              Map newValue = {
                "reservation_id": client.reservation_id,
                //"updated_at": convertDateTimeToMinutes(client.updated_at!),
                "updated_at": client.updated_at!,
                "clock": client.clock!,
                "timeClock": client.timeClock!,
                "client": client,
              };
              attendingClientList.add(newValue);
              print('clientes asistiendo client.reservation_id:${client.reservation_id}');
              print('clientes asistiendo client.clock!:${client.clock!}');
              print('clientes asistiendo timeClock:${client.timeClock! * 60}');
              print('clientes asistiendo client:${client}');
            }
          }

          clientList.add(client);
          if (client.attended == 0) {
            clientListSig.add(client);
          }
          if ((client.attended != 2) && client.confirmation != 1 && client.confirmation != 2) {
            clientListSalon++;
            print('ver cuantas veces entro aqui ');
          }
          //AQUI PARA SABER CUAL ES EL CLIENTE QUE LE SIGUE, aqui solo coje el primero que tenga attended == 0
          print('gggclientes asistiendo entre a if (client.confirmation :2${client.confirmation}) {');
          if (hasNextClient == false) {
            if (client.attended == 0 && client.confirmation == 4) {
              //poner que el siguiente sea solo si está anunciado
              nextClient = client;
              hasNextClient = true;
            }
          }
          //AQUI PARA SABER CUANTOS ESTA ATENDIENDO
          if (client.attended == 1 || client.attended == 11 || client.attended == 111) {
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
        return {
          "clientListSalon": clientListSalon,
          "clientList": clientList,
          "clientListSig": clientListSig,
          "nextClient": nextClient,
          "quantityClientAttended": quantityClientAttended,
          "attendingClient": attendingClientList, //puede ser null
          "varclientswaiting":
              varclientswaiting, //este me dice si hay que mandar alguna notificacion recordando que hay cliente esperando en cola por ser atendido
        };
      }
    } catch (e) {
      print('Error:$e');
    }
  }


  Future getClientsScheduledListNew(idProfessional, idBranch, isLoggingIn, token) async {

    try {
      int clientListSalon = 0;
      List<ClientsScheduledModel> clientList = [];
      List<ClientsScheduledModel> clientListSig = [];
      List<Map> attendingClientList = [];
      ClientsScheduledModel? nextClient;
      bool hasNextClient = false;
      int quantityClientAttended = 0;
      bool varclientswaiting = false;

      //final response = await get(url, headers: headers);

      var url = '${dotenv.env['API_ENDPOINT']}/tail-branch-professional?professional_id=$idProfessional&branch_id=$idBranch';
      print('a.......... getClientsScheduledList:url:$url');

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response =
          await get(url, headers: headers).timeout(Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos

      //si la respuesta fuera null es que no logro conectarse al db,servidor caido o no tienne internet
      if (response.statusCode != 200) {
        print('Primer ruta protegida-response.statusCode == null');
        print('response.statusCode:${response.statusCode}');
        //loginController.showConnectionError();
        return {
          "ConnectionIssues": true,
        };
      } else if (response.statusCode == 200) {
        print('Primer ruta protegida-response.statusCode == 200');
        // print('ya tengo la cola de la api es estaa *****************');
        final customers = response.body['tail'];
        // print('ya tengo la cola de la api es estaa${customers}');



        for (Map service in customers) {

          ClientsScheduledModel client = ClientsScheduledModel.fromJson(jsonEncode(service));

          // logica para saber si se cerro inesperadamente la apk y hay relojes activos
          if (isLoggingIn == true) {
            //controllerLogin.isLoggingIn
            if (client.detached == 1 && client.attended != 33 && client.attended != 2) {
              //33 es que lo rechazó el tecnico
              //2 es que ya fue atendido y por alguna razón quedo attendened 1
              //creo nuevo cliente
              print('clientes asistiendo entre a if (client.detached == 1) {//creo nuevo cliente');
              Map newValue = {
                "reservation_id": client.reservation_id,
                //"updated_at": convertDateTimeToMinutes(client.updated_at!),
                "updated_at": client.updated_at!,
                "clock": client.clock!,
                "timeClock": client.timeClock!,
                "client": client,
              };
              attendingClientList.add(newValue);
              print('clientes asistiendo client.reservation_id:${client.reservation_id}');
              print('clientes asistiendo client.clock!:${client.clock!}');
              print('clientes asistiendo timeClock:${client.timeClock! * 60}');
              print('clientes asistiendo client:${client}');
            }
          }

          clientList.add(client);
          if (client.attended == 0) {
            clientListSig.add(client);
          }
          if ((client.attended != 2) && client.confirmation != 1 && client.confirmation != 2) {
            clientListSalon++;
            print('ver cuantas veces entro aqui ');
          }
          //AQUI PARA SABER CUAL ES EL CLIENTE QUE LE SIGUE, aqui solo coje el primero que tenga attended == 0
          print('gggclientes asistiendo entre a if (client.confirmation :2${client.confirmation}) {');
          if (hasNextClient == false) {
            if (client.attended == 0 && client.confirmation == 4) {
              //poner que el siguiente sea solo si está anunciado
              nextClient = client;
              hasNextClient = true;
            }
          }
          //AQUI PARA SABER CUANTOS ESTA ATENDIENDO
          if (client.attended == 1 || client.attended == 11 || client.attended == 111) {
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
        return {
          "clientListSalon": clientListSalon,
          "clientList": clientList,
          "clientListSig": clientListSig,
          "nextClient": nextClient,
          "quantityClientAttended": quantityClientAttended,
          "attendingClient": attendingClientList, //puede ser null
          "varclientswaiting":
              varclientswaiting, //este me dice si hay que mandar alguna notificacion recordando que hay cliente esperando en cola por ser atendido
        };
      }
    } catch (e) {
      print('Primer ruta protegida error:$e');
    }
  }
//
  //

  Future getClientsScheduledList(idProfessional, idBranch, isLoggingIn, token1) async {

    try {
      List<ClientsScheduledModel> clientList = [];
      List<ClientsScheduledModel> clientListSig = [];
      List<Map> attendingClientList = [];
      ClientsScheduledModel? nextClient;
      bool hasNextClient = false;
      int quantityClientAttended = 0;
      bool varclientswaiting = false;
      String token = token1;
      var url = '${dotenv.env['API_ENDPOINT']}/tail-branch-professional?professional_id=$idProfessional&branch_id=$idBranch';
      print('a.......... getClientsScheduledList:url:$url');
      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(Duration(seconds: 15));
      // Aumenta el tiempo de espera a 30 segundos

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


        for (Map service in customers) {
          ClientsScheduledModel client = ClientsScheduledModel.fromJson(jsonEncode(service));

          // logica para saber si se cerro inesperadamente la apk y hay relojes activos
          if (isLoggingIn == true) {
            //controllerLogin.isLoggingIn
            if (client.detached == 1 && client.attended != 0 && client.attended != 2) {
              //33 es que lo rechazó el tecnico
              //creo nuevo cliente
              print('clientes asistiendo entre a if (client.detached == 1) {//creo nuevo cliente');
              Map newValue = {
                "reservation_id": client.reservation_id,
                //"updated_at": convertDateTimeToMinutes(client.updated_at!),
                "updated_at": client.updated_at!,
                "clock": client.clock!,
                "timeClock": client.timeClock!,
                "client": client,
              };
              attendingClientList.add(newValue);
              print('clientes asistiendo client.reservation_id:${client.reservation_id}');
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
          print('gggclientes asistiendo entre a if (client.confirmation :3${client.confirmation}) {');
          print('gggclientes asistiendo entre a if (client.length :3${client}) {');
          print('gggclientes asistiendo entre a if (token :3${token}) {');
          if (hasNextClient == false) {
            if (client.attended == 0 && client.confirmation == 4) {
              nextClient = client;
              hasNextClient = true;
            }
          }
          //AQUI PARA SABER CUANTOS ESTA ATENDIENDO
          if (client.attended == 1 || client.attended == 11 || client.attended == 111 || client.attended == 33) {
            print('relojes activos:${client.clock!}');
            //33 es rechazado por el tecnico pero es atendido por el Profesional
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
      print('eeror al mapera:$e');
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

  Future getCustomerServicesList2(idCar, token) async {

    try {
      List<ServiceModel> serviceCustomer = [];
      var url = '${dotenv.env['API_ENDPOINT']}/car_services2?car_id=$idCar';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response =
          await get(url, headers: headers).timeout(Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      if (response.statusCode == 200) {
        print('ya tengo los servicios');
        final customers = response.body['services'];

        for (Map service in customers) {
          ServiceModel u = ServiceModel.fromJson(jsonEncode(service));

          serviceCustomer.add(u);
        }


        final data = response.body['clientHistory'];

        String professionalNameBarber = data[0]['professionalName'];
        String imageUrlBarber = data[0]['image_url'] == '' ? 'comments/default_profile.jpg' : data[0]['image_url'];
        String imageLookBarber = data[0]['imageLook'];
        int cantVisitBarber = data[0]['cantVisit'];
        String endLookBarber = data[0]['endLook'] ?? '';
        String frecuenciaBarber = data[0]['frecuencia'];

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
        // return serviceCustomer;
        return {
          //valores de la cola
          "error": 'error',
        };
      }
    } catch (e) {
      print(e);
    }
  }

  Future getCustomerServicesList(idCar, token) async {

    try {
      List<ServiceModel> serviceCustomer = [];
      var url = '${dotenv.env['API_ENDPOINT']}/car_services?car_id=$idCar';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response =
          await get(url, headers: headers).timeout(Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
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


  Future sentValueClockDb(id, clock, token) async {

    try {
      var url = '${dotenv.env['API_ENDPOINT']}/set_clock?reservation_id=$id&clock=$clock';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response =
          await get(url, headers: headers).timeout(Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
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
  }


  Future<int> getValueClockDb(id, token) async {

    int result = -99;
    try {
      var url = '${dotenv.env['API_ENDPOINT']}/get_clock?reservation_id=$id';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response =
          await get(url, headers: headers).timeout(Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      if (response.statusCode == 200) {
        result = response.body;
        print('EL RELOJ DEVUELTO ES :$result');
      }
      return result;
    } catch (e) {
      print(e);
      print('NOO DEVOLVIO NINGUN RELOJ  - el codigo no fue 200');

      return -99;
    }
  }

//
  Future sendWhatsappNotificationRepos(String telefone, token) async {

    try {
      var url = '${dotenv.env['API_ENDPOINT']}/whatsapp-notification?telefone_client=$telefone';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response =
          await get(url, headers: headers).timeout(Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      if (response.statusCode == 200) {
        print('cargando aqui-8-sendWhatsappNotificationRepos-TELEFONO:$telefone');
        print('EL mensaje de whatassapp se ha enviado  correctamente :${response.statusCode}');
      } else {
        print('cargando aqui-8-codigo:${response.statusCode} -sendWhatsappNotificationRepos-TELEFONO:$telefone');
      }
    } catch (e) {
      print(e);
      print('cargando aqui-8 - ERROR AL ENVIAR eL mensaje de whatassapp:$e');
    }
  }



  Future typeOfService(idProfessional, idBranch, token) async {

    try {
      var url = '${dotenv.env['API_ENDPOINT']}/type_of_service?professional_id=$idProfessional&branch_id=$idBranch';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response =
          await get(url, headers: headers).timeout(Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      if (response.statusCode == 200) {
        final typeService = response.body;
        print('typeOfService(idProfessional, idBranch) async:$typeService');
        return typeService;
      } else if (response.statusCode != 200) {
        return -99;
      }
    } catch (e) {
      print('typeOfService(idProfessional, idBranch):$e');
      return -99;
    }
  }

  Future setTimeClock(reservationId, timeClock, detached, clock, token) async {

    try {
      print('EL TIEMPO ACTUAL reservationId->$reservationId');
      print('EL TIEMPO ACTUAL timeClock->$timeClock');
      print('EL TIEMPO ACTUAL detached->$detached');
      print('EL TIEMPO ACTUAL clock->$clock');
      if (timeClock != null) {
        var url =
            '${dotenv.env['API_ENDPOINT']}/set_timeClock?reservation_id=$reservationId&timeClock=$timeClock&detached=$detached&clock=$clock';

        final headers = {
          "Authorization": "Bearer $token", // Agrega el token a los encabezados
        };
        final response = await get(url, headers: headers)
            .timeout(Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
        if (response.statusCode == 200) {
          return true;
        } else {
          return false;
        }
      } else {
        print('el timeClock llego null por eso entro aqui al else');
      }
    } catch (e) {
      print(' Error:$e');
    }
  }

  // HACE LA LLAMADA PARA LOS INCUMPLIMIENTOS, 0 ES QUE INCUMPLIO Y 1 QUE CUMPLIO
  Future storeByType(type, branchId, professionalId, estado, token) async {

    try {
      var url = '${dotenv.env['API_ENDPOINT']}/storeByType';

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
        print('Acacba de incumplir en este type de convivencia-type:$type');
        print('Acacba de incumplir en este type de convivencia-branchId:$branchId');
        print('Acacba de incumplir en este type de convivencia-professionalId:$professionalId');
        print('Acacba de incumplir en este type de convivencia-estado:$estado');
        return true;
      } else {
        print('Intento de darle incumplimiento, pero algo salió mal y no fue posible');
        return false;
      }
    } catch (e) {
      print(e);
    }
  }

  Future storeByTypeId(id, type, branchId, professionalId, estado, token) async {

    try {
      var url = '${dotenv.env['API_ENDPOINT']}/storeByTypeId';

      final Map<String, dynamic> body = {
        'id': id,
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
        print('Acacba de incumplir en este type de convivencia-type:$id');
        print('Acacba de incumplir en este type de convivencia-type:$type');
        print('Acacba de incumplir en este type de convivencia-branchId:$branchId');
        print('Acacba de incumplir en este type de convivencia-professionalId:$professionalId');
        print('Acacba de incumplir en este type de convivencia-estado:$estado');
        return true;
      } else {
        print('Intento de darle incumplimiento, pero algo salió mal y no fue posible');
        return false;
      }
    } catch (e) {
      print(e);
    }
  } //AQUI HACE LA LLAMADA PARA LOS INCUMPLIMIENTOS, 0 ES QUE INCUMPLIO Y 1 QUE CUMPLIO

  Future storeByType2(type, branchId, professionalId, estado, token) async {

    print('llamda a la api desde segundo plano-REPOS');
    try {
      var url = '${dotenv.env['API_ENDPOINT']}/storeByType-time';

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
      print('llamda a la api desde segundo plano-REPOS-CODE-${response.statusCode}');
      if (response.statusCode == 200) {
        print('Acacba de incumplir en este type de convivencia1:$type');
        return true;
      } else {
        print('Intento de darle incumplimiento, pero algo salió mal y no fue posible');
        return false;
      }
    } catch (e) {
      print('llamda a la api desde segundo plano-REPOS-CATCH');
      print(e);
      return false;
    }
  }

  Future returnClientStatus(reservationId, token) async {

    try {
      var url =
          '${dotenv.env['API_ENDPOINT']}/return_client_status?reservation_id=$reservationId';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response =
          await get(url, headers: headers).timeout(Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      if (response.statusCode == 200) {
        final statusClient = response.body;
        print('Future<int> returnClientStatus(reservationId) async {:$statusClient');
        return statusClient;
      } else {
        print('Future<int> returnClientStatus(reservationId) async {:${response.statusCode}');
        return -99;
      }
    } catch (e) {
      print(e);
    }
  }

  Future getProfessionalState(idBranch, token) async {

    try {
      List<ProfessionalModel> professionalList = [];
      var url = '${dotenv.env['API_ENDPOINT']}/professional-state?branch_id=$idBranch';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response =
          await get(url, headers: headers).timeout(Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      print('getProfessionalState(idBranch) async getProfessionalState(idBranch) url:$url');
      print(
          'getProfessionalState(idBranch) async getProfessionalState(idBranch) response.statusCode:${response.statusCode}');
      if (response.statusCode == 200) {
        final professionals = response.body['professionals'];
        for (Map professional in professionals) {
          ProfessionalModel u = ProfessionalModel.fromJson(jsonEncode(professional));
          //AQUI SOLO COJO QUE NO SEAN RESPONSABLES
          if (u.name != 'Encargado' && u.name != 'Coordinador') {
            //charge_id=3 es un responsable
            professionalList.add(u);
          }
        }
        print('getProfessionalState(idBranch) async getProfessionalState(idBranch) async');
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

  Future getProfessionalState2First(idBranch, idReserv, idBarberAct, token) async {

    List<ProfessionalModel> professionalList = [];
    try {
      int cant = 0;
      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      var url = '${dotenv.env['API_ENDPOINT']}/professional-state?branch_id=$idBranch&reservation_id=$idReserv';

      final response = await get(url, headers: headers).timeout(Duration(seconds: 15));
      ;
      print('getProfessionalState(idBranch) async getProfessionalState(idBranch) url:$url');
      print(
          'getProfessionalState(idBranch) async getProfessionalState(idBranch) response.statusCode:${response.statusCode}');
      if (response.statusCode == 200) {
        final professionals = response.body['professionals'];
        for (Map professional in professionals) {
          ProfessionalModel u = ProfessionalModel.fromJson(jsonEncode(professional));
          //AQUI SOLO COJO QUE NO SEAN RESPONSABLES
          if (u.charge_id != 'Encargado' && u.charge_id != 'Coordinador' && u.id != idBarberAct && cant == 0) {
            //que no sea ni coordinador,ni encargado,ni el mismo Profesional

            professionalList.add(u);
            cant++; //para garantizar que solo me devuelva 1
          }
        }
        print('profe libres - professionalList.length:${professionalList.length}');
        return professionalList;
      }

      return professionalList;
    } catch (e) {
      print(e);
      return professionalList;
    }
  }

  Future getProfessionalState2Coord(idBranch, idReserv, token) async {

    try {
      List<ProfessionalModel> professionalList = [];
      var url = '${dotenv.env['API_ENDPOINT']}/professional-state-coordinador?branch_id=$idBranch&reservation_id=$idReserv';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response =
          await get(url, headers: headers).timeout(Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      print('getProfessionalState(idBranch) async getProfessionalState(idBranch) url:$url');
      print(
          'getProfessionalState(idBranch) async getProfessionalState(idBranch) response.statusCode-desde coordinador:${response.statusCode}');
      if (response.statusCode == 200) {
        final professionals = response.body['professionals'];
        for (Map professional in professionals) {
          ProfessionalModel u = ProfessionalModel.fromJson(jsonEncode(professional));
          //AQUI SOLO COJO QUE NO SEAN RESPONSABLES
          if (u.name != 'Encargado' && u.name != 'Coordinador') {
            //charge_id=3 es un responsable
            professionalList.add(u);
          }
        }
        print('getProfessionalState(idBranch) async getProfessionalState(idBranch) async');
        print(professionalList.length);
        print(
            'getProfessionalState(idBranch) async getProfessionalState(idBranch) async professionalList.length:${professionalList.length}');
        return professionalList;
      }

      return professionalList;
    } catch (e) {
      print('getProfessionalState(idBranch) async getProfessionalState(idBranch) url:ERRORRRR:$e');
    }
  }

  Future getProfessionalState2(idBranch, idReserv, token) async {

    try {
      List<ProfessionalModel> professionalList = [];
      var url = '${dotenv.env['API_ENDPOINT']}/professional-state?branch_id=$idBranch&reservation_id=$idReserv';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response =
          await get(url, headers: headers).timeout(Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      print('getProfessionalState(idBranch) async getProfessionalState(idBranch) url:$url');
      print(
          'getProfessionalState(idBranch) async getProfessionalState(idBranch) response.statusCode:${response.statusCode}');
      if (response.statusCode == 200) {
        final professionals = response.body['professionals'];
        for (Map professional in professionals) {
          ProfessionalModel u = ProfessionalModel.fromJson(jsonEncode(professional));
          //AQUI SOLO COJO QUE NO SEAN RESPONSABLES
          if (u.name != 'Encargado' && u.name != 'Coordinador') {
            //charge_id=3 es un responsable
            professionalList.add(u);
          }
        }
        print('getProfessionalState(idBranch) async getProfessionalState(idBranch) async');
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

  Future acceptOrRejectClient(reservationId, attended, token) async {

    try {
      var url = '${dotenv.env['API_ENDPOINT']}/tail_attended?reservation_id=$reservationId&attended=$attended';
      print('ERROR:acceptOrRejectClient1 value = false- reservationId:$reservationId');
      print('ERROR:acceptOrRejectClient1 value = false- attended:$attended');
      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response =
          await get(url, headers: headers).timeout(Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      if (response.statusCode == 200) {
        print('acceptOrRejectClient1 value = true');

        return 1;
      } else if (response.statusCode == null) {
        print('ERROR:acceptOrRejectClient1 value = false- response.statusCode2${response.statusCode}');
        return -99;
      }
    } catch (e) {
      print('error al finalizar un servicio:$e');
      return 0;
    }
  }

  Future acceptClientClock(timeClock, clock, detached, reservationId, attended, token) async {
    try {
      var url =
          '${dotenv.env['API_ENDPOINT']}/tail-attended-client?reservation_id=$reservationId&attended=$attended&timeClock=$timeClock&clock=$clock&detached=$detached';
      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response =
          await get(url, headers: headers).timeout(Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      if (response.statusCode == 200) {
        print('acceptOrRejectClient1 value = true');

        return 1;
      } else if (response.statusCode == null) {
        print('ERROR:acceptOrRejectClient1 value = false- response.statusCode2${response.statusCode}');
        return -99;
      }
    } catch (e) {
      print('error al finalizar un servicio:$e');
      return 0;
    }
  }

  Future<bool> deleteReservationClient(reservationId, cause, token) async {

    try {
      bool value = false;
      var url = '${dotenv.env['API_ENDPOINT']}/reservation-destroy';
      print('deleteReservationClient value reservationId :$reservationId');
      print('deleteReservationClient value cause :$cause');
      final Map<String, dynamic> body = {
        'id': reservationId,
        'cause': cause,
      };
      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await post(headers: headers, url, body);
      print('deleteReservationClient value response.statusCode :${response.statusCode}');
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

  Future storeByReservationId(imag, reservationId, commentText, dioClient, token) async {

    try {
      // Crear FormData y agregar la imagen

      dio.FormData formData = dio.FormData.fromMap({
        'client_look': imag != '' ? await dio.MultipartFile.fromFile(imag, filename: 'client_look.jpg') : '',
        'reservation_id': reservationId,
        'look': commentText,
      });

      try {
        dio.Response response = await dioClient.post(
          '${dotenv.env['API_ENDPOINT']}/storeByReservationId',
          data: formData,
          options: dio.Options(
            headers: {
              'Authorization': 'Bearer $token', // Agregar el token en el encabezado
              'Content-Type': 'multipart/form-data', // Tipo de contenido
            },
          ),
        );
        print(response.data);

        if (response.statusCode == 200) {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        print('Error al subir la imagen: $e');
        return false;
      }

    } catch (e) {
      print(e);
    }
  }
}
