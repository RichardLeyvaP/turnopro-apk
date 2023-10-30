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
          '${Env.apiEndpoint}/car_oders?id=9'; //todo REVISAR aqui enviar el id del carro correspondiente al cliente-profesional
      // category_branch?branch_id=10
      //print(url);
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
    //todo
    try {
      List<OrderDeleteModel> orderDEL = [];
      var url =
          '${Env.apiEndpoint}/car_order_delete?id=$id_car'; //cambiar aqui por servicios en la api
      // category_branch?branch_id=10
      //print(url);
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

//*ESTE METODO ME DEVUELVE LOS PRODUCTOS ASOCIADO A UNA CATEGORIA LA CUAL LA SABEMOS PORQUE MANDAMOS EL ID
  Future getProductCategoryList(id) async {
    //print('este es el id: $id');
    try {
      List<ProductModel> productList = [];
      var url =
          '${Env.apiEndpoint}/category_products?id=$id'; //cambiar aqui por servicios en la api

      final response = await get(url);
      // print(response.statusCode);
      if (response.statusCode == 200) {
        final products = response.body['category_products'];
        if (products != null) {
          // print('ok1');
          for (Map product in products) {
            ProductModel u = ProductModel.fromJson(jsonEncode(product));
            productList.add(u);
          }
        }
        print('cantidad de Productos:${productList.length}');
        return productList;
      }
    } catch (e) {
      //print('eroor:$e');
    }
  }

  //*ESTE METODO ME DEVUELVE TODOS LOS PRODUCTOS
  Future getProductList() async {
    //todo 1 REVISAR aqui devuelve los productos
    try {
      List<ProductModel> productList = [];
      var url =
          '${Env.apiEndpoint}/product_branch?branch_id=1'; //cambiar aqui por servicios en la api

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
      var url = '${Env.apiEndpoint}/order';

      // Parámetros que deseas enviar en la solicitud POST
      final Map<String, dynamic> body = {
        'client_id': client_id, //5
        'person_id': person_id, //3
        'product_id': product_id, //0
        'service_id': service_id
      };

      // Realizar la solicitud POST
      final response = await post(url, body);
      if (response.statusCode == 200) {
        final id_order = response.body['order_id'];
        //print('soy codigo 200 y hice la llamada a la api bien');
        // print(id_order);
        return id_order;
      } else {
        return -990099;
      }
    } catch (e) {
      //print('Errorrrrr:$e');
      return -990099;
    }
  }

  Future<int> awaitRequestDelete(int id, int request) async {
    try {
      var url = '${Env.apiEndpoint}/order';

      // Parámetros que deseas enviar en la solicitud POST
      final Map<String, dynamic> body = {
        'id': id,
        'request_delete': request,
      };

      // Realizar la solicitud POST
      final response = await put(url, body);
      //print('MANDE A ELIMINAR:$body');
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
  }
}
