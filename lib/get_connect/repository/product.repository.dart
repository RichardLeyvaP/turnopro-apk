// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/shoppingCart.controller.dart';
import 'package:turnopro_apk/Models/category_model.dart';
import 'package:turnopro_apk/Models/orderDelete_model.dart';
import 'package:turnopro_apk/Models/product_model.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/env.dart';

class ProductRepository extends GetConnect {
  double PriceT = 0.0;
  double PriceProduct = 0.0;
  double PriceService = 0.0;

  Future getCartProductService() async {
    try {
      List<ProductModel> productListCar = [];
      List<ServiceModel> serviceListCar = [];
      final ShoppingCartController shoppingCartController =
          Get.find<ShoppingCartController>();
      int carId = shoppingCartController.carIdClienteSelect!;
      var url =
          '${Env.apiEndpoint}/car_orders?id=$carId'; //todo REVISAR aqui enviar el id del carro correspondiente al cliente-profesional
      print('estoy cargando el carro de id car :$url');
      final response = await get(url);
      if (response.statusCode == 200) {
        // print('codigo 200000000000000000');
        final products = response.body['productscar'];
        if (products != null) {
          for (Map product in products) {
            ProductModel u = ProductModel.fromJson(jsonEncode(product));
            productListCar.add(u);
            PriceT += u.sale_price;
            PriceProduct += u.sale_price;
          }
        }

        final services = response.body['servicescar'];
        if (services != null) {
          for (Map service in services) {
            ServiceModel u = ServiceModel.fromJson(jsonEncode(service)); //todo
            serviceListCar.add(u);
            PriceT += u.price_service;
            PriceService += u.price_service;
          }
        }
        //retornando dos listas
        print(
            'estoy cargando el carro de id car services leght :${serviceListCar.length}');
        return {
          'products': productListCar,
          'services': serviceListCar,
          'PriceTotal': PriceT,
          'PriceService': PriceService,
          'PriceProduct': PriceProduct,
        };
      }
    } catch (e) {
      // print('eroor:$e,NO RETORNO LAS DOS LISTAS ');
    }
  }

  Future serviceRequestProductDelete(int branchId) async {
    try {
      List<OrderDeleteModel> orderDEL = [];
      var url =
          '${Env.apiEndpoint}/car_order_delete_branch?branch_id=$branchId'; //AHORA MISMO EL QUE TIENE ES EL ID=6
      // category_branch?branch_id=10
      final response = await get(url);
      if (response.statusCode == 200) {
        print('tambien llegue aqui response.statusCode == 200');
        final orders = response.body['carOrderDelete'];
        print(orders);
        if (orders != null) {
          for (Map order in orders) {
            print('aqui mapeandooooo');
            OrderDeleteModel u = OrderDeleteModel.fromJson(jsonEncode(order));
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
    List<ProductModel> productList = [];
    print('este es el id: $id');
    print('este es el branchId: $branchId');
    try {
      var url =
          '${Env.apiEndpoint}/category_products?id=$id&branch_id=$branchId';
      final response = await get(url);
      if (response.statusCode == 200) {
        print('response.statusCode == 200');
        final products = response.body['category_products'];
        if (products != null) {
          print('products != null');
          for (Map product in products) {
            ProductModel u = ProductModel.fromJson(jsonEncode(product));
            productList.add(u);
          }
        }
        print('cantidad de Productos:${productList.length}');
        return productList;
      }
    } catch (e) {
      return productList;
      print('eroor:$e');
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
        print('Lista aqui:${productList.length}');
        return productList;
      }
    } catch (e) {
      print('**-*Error**-*:$e');
      return null;
    }
  }

  //*ESTE METODO ME DEVUELVE TODOS LOS PRODUCTOS
  Future<int> addOrderCartList(
      //todo REVISAR REVISAR este metodo
      car_id,
      product_id,
      service_id,
      type) async {
    try {
      print('internetError car_id:$car_id');
      print('internetError product_id:$product_id');
      print('internetError service_id:$service_id');
      print('internetError type:$type');
      var url = '${Env.apiEndpoint}/order';

      // Parámetros que deseas enviar en la solicitud POST
      final Map<String, dynamic> body = {
        'car_id': car_id,
        'product_id': product_id,
        'service_id': service_id,
        'type': type
      };
      // Realizar la solicitud POST
      final response = await post(url, body);
      if (response.statusCode == 200) {
        //print('addOrderCartList response:$response');
        final id_order = response.body['order_id'];
        print(
            'addOrderCartList soy codigo 200 y hice la llamada a la api bien');
        print(id_order);
        return id_order;
      } else {
        print(
            'internetError addOrderCartList return -990099;:response.statusCode:${response.statusCode}');
        return -990099;
      }
    } catch (e) {
      print('addOrderCartList Errorrrrr:$e');
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
          '${Env.apiEndpoint}/category_branch?branch_id=$branchIdLoggedIn';
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
      print('ERROR getCategoryList:$e');
      return categoryList;
    }
  }
}
