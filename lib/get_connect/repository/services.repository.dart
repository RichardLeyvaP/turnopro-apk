// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Models/services_model.dart';

class ServiceRepository extends GetConnect {
  Future<List<ServiceModel>> getServiceList() async {
    List<ServiceModel> serviceList = [];
    var url =
        'http://10.0.2.2:8000/api/service'; //cambiar aqui por servicios en la api

    final response = await get(url);
    if (response.statusCode == 200) {
      final products = response.body['services'];
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
