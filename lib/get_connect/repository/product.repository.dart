// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Models/category_model.dart';
import 'package:turnopro_apk/Models/product_model.dart';
import 'package:turnopro_apk/Models/services_model.dart';

class ProductRepository extends GetConnect {
  Future getCartProductService() async {
    try {
      List<ProductModel> productListCar = [];
      List<ServiceModel> serviceListCar = [];
      var url =
          'http://10.0.2.2:8000/api/car_oders?id=7'; //cambiar aqui por servicios en la api
      // category_branch?branch_id=10

      final response = await get(url);
      if (response.statusCode == 200) {
        final products = response.body['productscar'];
        if (products != null) {
          for (Map product in products) {
            ProductModel u = ProductModel.fromJson(jsonEncode(product));
            productListCar.add(u);
          }
        }

        final services = response.body['servicescar'];
        if (services != null) {
          for (Map service in services) {
            ServiceModel u = ServiceModel.fromJson(jsonEncode(service));
            serviceListCar.add(u);
          }
        }
        //retornando dos listas
        return {
          'products': productListCar,
          'services': serviceListCar,
        };
      }
    } catch (e) {
      // print('eroor:$e,NO RETORNO LAS DOS LISTAS ');
    }
  }

//*ESTE METODO ME DEVUELVE LOS PRODUCTOS ASOCIADO A UNA CATEGORIA LA CUAL LA SABEMOS PORQUE MANDAMOS EL ID
  Future getProductCategoryList(int id) async {
    try {
      List<ProductModel> productList = [];
      var url =
          'http://10.0.2.2:8000/api/category_products?id=$id&branch_id=10'; //cambiar aqui por servicios en la api
      // category_branch?branch_id=10

      final response = await get(url);
      if (response.statusCode == 200) {
        final products = response.body['category_products'];
        if (products != null) {
          for (Map product in products) {
            ProductModel u = ProductModel.fromJson(jsonEncode(product));
            productList.add(u);
          }
        }
        return productList;
      }
    } catch (e) {
      // print('eroor:$e');
    }
  }

  //*ESTE METODO ME DEVUELVE TODOS LOS PRODUCTOS
  Future getProductList() async {
    try {
      List<ProductModel> productList = [];
      var url =
          'http://10.0.2.2:8000/api/product_branch?branch_id=1'; //cambiar aqui por servicios en la api

      final response = await get(url);
      if (response.statusCode == 200) {
        final products = response.body['branch_products'];
        if (products != null) {
          for (Map product in products) {
            ProductModel u = ProductModel.fromJson(jsonEncode(product));
            productList.add(u);
          }
        }
        return productList;
      }
    } catch (e) {
      return null;
    }
  }

  //*ESTE METODO ME DEVUELVE TODOS LOS PRODUCTOS
  Future<int> addOrderCartList(
      client_id, person_id, product_id, service_id) async {
    try {
      const url = 'http://10.0.2.2:8000/api/order';

      // Parámetros que deseas enviar en la solicitud POST
      final Map<String, dynamic> body = {
        'client_id': client_id,
        'person_id': person_id,
        'product_id': product_id,
        'service_id': service_id
      };

      // Realizar la solicitud POST
      final response = await post(url, body);
      if (response.statusCode == 200) {
        final id_order = response.body['order_id'];
        //print('soy codigo 200 y hice la llamada a la api bien');
        return id_order;
      } else {
        return -990099;
      }
    } catch (e) {
      // print('Error');
      return -990099;
    }
  }

  Future<int> awaitRequestDelete(id) async {
    try {
      const url = 'http://10.0.2.2:8000/api/order';

      // Parámetros que deseas enviar en la solicitud POST
      final Map<String, dynamic> body = {
        'id': id,
      };

      // Realizar la solicitud POST
      final response = await put(url, body);
      if (response.statusCode == 200) {
        //final id_order = response.body['order_id'];
        return 1;
      } else {
        return -990099;
      }
    } catch (e) {
      return -990099;
    }
  }

  Future<List<CategoryModel>> getCategoryList() async {
    List<CategoryModel> categoryList = [];
    var url =
        'http://10.0.2.2:8000/api/category_branch?branch_id=1'; //cambiar aqui por servicios en la api

    final response = await get(url);
    if (response.statusCode == 200) {
      final categorys = response.body['category_products'];
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
