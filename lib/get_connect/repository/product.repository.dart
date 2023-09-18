// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Models/category_model.dart';
import 'package:turnopro_apk/Models/product_model.dart';

class ProductRepository extends GetConnect {
//*ESTE METODO ME DEVUELVE LOS PRODUCTOS ASOCIADO A UNA CATEGORIA LA CUAL LA SABEMOS PORQUE MANDAMOS EL ID
  Future<List<ProductModel>> getProductCategoryList(int id) async {
    List<ProductModel> productList = [];
    var url =
        'http://10.0.2.2:8000/api/category_products?id=$id'; //cambiar aqui por servicios en la api

    final response = await get(url);
    if (response.statusCode == 200) {
      final products = response.body['category_products']['products'];
      if (products != null) {
        for (Map product in products) {
          ProductModel u = ProductModel.fromJson(jsonEncode(product));
          productList.add(u);
        }
      }
      return productList;
    } else {
      return productList;
    }
  }

  Future<List<CategoryModel>> getCategoryList() async {
    List<CategoryModel> categoryList = [];
    var url =
        'http://10.0.2.2:8000/api/product-category'; //cambiar aqui por servicios en la api

    final response = await get(url);
    if (response.statusCode == 200) {
      final categorys = response.body['productcategories'];
      if (categorys != null) {
        for (Map category in categorys) {
          CategoryModel u = CategoryModel.fromJson(jsonEncode(category));
          categoryList.add(u);
        }
      }
      return categoryList;
    } else {
      return categoryList;
    }
  }
}
