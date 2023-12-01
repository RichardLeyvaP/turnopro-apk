// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/env.dart';

class ServiceRepository extends GetConnect {
  Future<List<ServiceModel>> getServiceList(idProfessional, idBranch) async {
    List<ServiceModel> serviceList = [];

    try {
      if (idProfessional != null) {
        var url =
            '${Env.apiEndpoint}/professional_services?professional_id=$idProfessional&branch_id=$idBranch';

        final response = await get(url);
        if (response.statusCode == 200) {
          final services = response.body['professional_services'];
          for (Map service in services) {
            print(
                '**************************************estoy aqui - (Map service in services)');
            print(jsonEncode(service));
            ServiceModel u = ServiceModel.fromJson(jsonEncode(service));
            serviceList.add(u);
          }
          print(
              'ServiceRepository1 RETORNANDO LA LISTA DE SERVICIOS:${serviceList.length}');
          return serviceList;
        } else {
          print('ServiceRepository2 LISTA DE SERVICIOS EN BLANCO');
          return serviceList; //retornando lista vacia
        }
      }
      print('ServiceRepository3 LISTA DE SERVICIOS EN BLANCO');
      return serviceList; //retornando lista vacia
    } catch (e) {
      print('ERROR:$e');
      return serviceList;
    }
  }
}
