// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Models/product_model.dart';

class ProductRepository extends GetConnect {
  Future<List<ProductModel>> getProductList() async {
    List<ProductModel> productList = [];
    var url =
        'http://10.0.2.2:8000/api/product'; //cambiar aqui por servicios en la api

    final response = await get(url);
    if (response.statusCode == 200) {
      final products = response.body['product'];
      for (Map product in products) {
        ProductModel u = ProductModel.fromJson(jsonEncode(product));
        productList.add(u);
      }
      return productList;
    } else {
      return productList;
    }
  }
}
