// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Models/customer_model.dart';
//todo REVISAR aqui se esta cargando una API de ejemplo no la de SIMPLIFI

class CustomerRepository extends GetConnect {
  Future<List<CustomerModel>> getcustomersList() async {
    List<CustomerModel> customersList = [];
    var url =
        'http://jsonplaceholder.typicode.com/users'; //cambiar aqui por servicios en la api

    final response = await get(url);
    if (response.statusCode == 200) {
      final customers = response.body;
      for (Map service in customers) {
        CustomerModel u = CustomerModel.fromJson(jsonEncode(service));
        customersList.add(u);
      }
      return customersList;
    } else {
      return customersList;
    }
  }
}
