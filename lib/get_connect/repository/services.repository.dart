// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Models/services_model.dart';

class ServiceRepository extends GetConnect {
  Future<List<ServiceModel>> getServiceList() async {
    List<ServiceModel> serviceList = [];
    var url =
        'http://jsonplaceholder.typicode.com/users'; //cambiar aqui por servicios en la api

    final response = await get(url);
    if (response.statusCode == 200) {
      final services = response.body;
      for (Map service in services) {
        ServiceModel u = ServiceModel.fromJson(jsonEncode(service));
        serviceList.add(u);
      }
      return serviceList;
    } else {
      return serviceList;
    }
  }
}
