// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Models/clientsScheduled_model.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/env.dart';
//todo REVISAR aqui se esta cargando una API de ejemplo no la de SIMPLIFI

class ClientsScheduledRepository extends GetConnect {
  Future getClientsScheduledList(idProfessional, idBranch) async {
    List<ClientsScheduledModel> clientList = [];
    ClientsScheduledModel? nextClient;
    bool hasNextClient = false;
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
        if (hasNextClient == false) {
          if (client.attended == 0) {
            nextClient = client;
            hasNextClient = true;
          }
        }

        //AQUI LA LOGICA DE SABER CUAL ES EL QUE LE SIGUE
      }
      return {
        "clientList": clientList,
        "nextClient": nextClient,
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
