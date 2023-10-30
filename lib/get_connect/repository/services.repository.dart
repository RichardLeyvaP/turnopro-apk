// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/env.dart';

class ServiceRepository extends GetConnect {
  Future<List<ServiceModel>> getServiceList(idProfessional) async {
    List<ServiceModel> serviceList = [];
    if (idProfessional != null) {
      var url =
          '${Env.apiEndpoint}/person_services?professional_id=$idProfessional';

      final response = await get(url);
      if (response.statusCode == 200) {
        final products = response.body['professional_services'];
        for (Map product in products) {
          ServiceModel u = ServiceModel.fromJson(jsonEncode(product));
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
  }
}
