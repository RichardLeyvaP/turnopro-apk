// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Models/clientsScheduled_model.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/env.dart';

class ClientsScheduledRepository extends GetConnect {
  Future getClientsScheduledList(idProfessional, idBranch) async {
    List<ClientsScheduledModel> clientList = [];
    ClientsScheduledModel? nextClient;
    bool hasNextClient = false;
    int quantityClientAttended = 0;

    var url =
        '${Env.apiEndpoint}/cola_branch_professional?professional_id=$idProfessional&branch_id=$idBranch';

    final response = await get(url);
    if (response.statusCode == 200) {
      print('ya tengo la cola de la api');
      final customers = response.body['tail'];
      for (Map service in customers) {
        ClientsScheduledModel client =
            ClientsScheduledModel.fromJson(jsonEncode(service));
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
      return {
        "clientList": clientList,
        "nextClient": nextClient,
        "quantityClientAttended": quantityClientAttended,
      };
    } else {
      return clientList;
    }
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
    if (response.statusCode == 200) {
      print('Acacba de incumplir en este type de convivencia:$type');
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
}
