// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Models/category_model.dart';
import 'package:turnopro_apk/Models/orderDelete_model.dart';
import 'package:turnopro_apk/Models/product_model.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/env.dart';

class ProductRepository extends GetConnect {
  Future getCartProductService() async {
    try {
      List<ProductModel> productListCar = [];
      List<ServiceModel> serviceListCar = [];

      var url =
          '${Env.apiEndpoint}/car_oders?id=13'; //todo REVISAR aqui enviar el id del carro correspondiente al cliente-profesional
      final response = await get(url);
      if (response.statusCode == 200) {
        // print('codigo 200000000000000000');
        final products = response.body['productscar'];
        if (products != null) {
          for (Map product in products) {
            //   print('estoy aqui para mapear');
            // print(jsonEncode(product));
            ProductModel u = ProductModel.fromJson(jsonEncode(product));
            productListCar.add(u);
            //print('wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww');
            //print(productListCar.length);
          }
        }

        final services = response.body['servicescar'];
        if (services != null) {
          for (Map service in services) {
            ServiceModel u = ServiceModel.fromJson(jsonEncode(service)); //todo
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

  Future serviceRequestProductDelete(int id_car) async {
    try {
      List<OrderDeleteModel> orderDEL = [];
      var url =
          '${Env.apiEndpoint}/car_order_delete?id=$id_car'; //AHORA MISMO EL QUE TIENE ES EL ID=6
      // category_branch?branch_id=10
      final response = await get(url);
      if (response.statusCode == 200) {
        // print('tambien llegue aqui');
        final products = response.body['carOrderDelete'];
        if (products != null) {
          for (Map product in products) {
            //  print('aqui mapeandooooo');
            OrderDeleteModel u = OrderDeleteModel.fromJson(jsonEncode(product));
            orderDEL.add(u);
          }
        }
        //retornando dos listas
        return orderDEL;
      }
    } catch (e) {
      // print('eroor:$e,NO RETORNO LAS DOS LISTAS ');
    }
  }

//*ESTE METODO ME DEVUELVE LOS PRODUCTOS ASOCIADO A UNA CATEGORIA LA CUAL LA SABEMOS PORQUE MANDAMOS EL ID Y ID_BRANCH
  Future getProductCategoryList(id, branchId) async {
    // print('este es el id: $id');
    // print('este es el branchId: $branchId');
    try {
      List<ProductModel> productList = [];
      var url =
          '${Env.apiEndpoint}/category_products?id=$id&branch_id=$branchId';
      final response = await get(url);
      if (response.statusCode == 200) {
        final products = response.body['category_products'];
        if (products != null) {
          for (Map product in products) {
            ProductModel u = ProductModel.fromJson(jsonEncode(product));
            productList.add(u);
          }
        }
        //print('cantidad de Productos:${productList.length}');
        return productList;
      }
    } catch (e) {
      //print('eroor:$e');
    }
  }

  //*ESTE METODO ME DEVUELVE TODOS LOS PRODUCTOS
  Future getProductList(branchId) async {
    //todo 1 REVISAR aqui devuelve los productos
    try {
      List<ProductModel> productList = [];
      var url = '${Env.apiEndpoint}/product_branch?branch_id=$branchId';

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
      //todo REVISAR REVISAR este metodo
      client_id,
      professional_id,
      product_id,
      service_id,
      type) async {
    try {
      var url = '${Env.apiEndpoint}/order';

      // Parámetros que deseas enviar en la solicitud POST
      final Map<String, dynamic> body = {
        'client_id': client_id, //5
        'professional_id': professional_id, //3
        'product_id': product_id, //0
        'service_id': service_id,
        'type': type
      };

      // Realizar la solicitud POST
      final response = await post(url, body);
      if (response.statusCode == 200) {
        //print('addOrderCartList response:$response');
        final id_order = response.body['order_id'];
        // print(
        // 'addOrderCartList soy codigo 200 y hice la llamada a la api bien');
        // print(id_order);
        return id_order;
      } else {
        // print('addOrderCartList return -990099;');
        return -990099;
      }
    } catch (e) {
      // print('addOrderCartList Errorrrrr:$e');
      return -990099;
    }
  }

  Future<int> awaitRequestDelete(id, request_delete) async {
    try {
      var url = '${Env.apiEndpoint}/order';

      // Parámetros que deseas enviar en la solicitud POST
      final Map<String, dynamic> body = {
        'id': id,
        'request_delete': request_delete,
      };

      final response = await put(url, body);
      //print('MANDE A ELIMINAR:$body');
      if (response.statusCode == 200) {
        return 1;
      } else {
        return -990099;
      }
    } catch (e) {
      return -990099;
    }
  }

  Future<int> orderDeleteCar(id) async {
    try {
      var url = '${Env.apiEndpoint}/order-destroy';

      // Parámetros que deseas enviar en la solicitud POST
      final Map<String, dynamic> body = {
        'id': id,
      };

      // Realizar la solicitud POST
      final response = await post(url, body);
      if (response.statusCode == 200) {
        return 1;
      } else {
        return -990099;
      }
    } catch (e) {
      return -990099;
    }
  }

//todo BIEN getCategoryList(branchIdLoggedIn)
  Future<List<CategoryModel>> getCategoryList(branchIdLoggedIn) async {
    List<CategoryModel> categoryList = [];

    try {
      var url =
          '${Env.apiEndpoint}/category_branch?branch_id=$branchIdLoggedIn'; //cambiar aqui por servicios en la api
//todo aqui van las categorias de los productos para el tab
      final response = await get(url);
      if (response.statusCode == 200) {
        final categorys = response.body['category_products'];
        if (categorys != null) {
          for (Map category in categorys) {
            CategoryModel u = CategoryModel.fromJson(jsonEncode(category));
            categoryList.add(u);
          }
        }
        // print(
        //     'Aqui retorno los category_products por almacen-branch ${categoryList.length}');
        return categoryList;
      } else {
        return categoryList;
      }
    } catch (e) {
      print('ERROR:$e');
      return categoryList;
    }
  }
}
