// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/env.dart';

class ServiceRepository extends GetConnect {
  Future<List<ServiceModel>> getServiceList() async {
    List<ServiceModel> serviceList = [];
    // var url =
    //     '${Env.apiEndpoint}/person_services?person_id=3'; //cambiar aqui por servicios en la api
    var url = '${Env.apiEndpoint}/person_services?person_id=3';

    final response = await get(url);
    if (response.statusCode == 200) {
      final products = response.body['person_services'];
      for (Map product in products) {
        ServiceModel u = ServiceModel.fromJson(jsonEncode(product));
        serviceList.add(u);
      }
      return serviceList;
    } else {
      return serviceList;
    }
  }
}
