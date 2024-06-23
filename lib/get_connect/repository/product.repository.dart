// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/shoppingCart.controller.dart';
import 'package:turnopro_apk/Models/category_model.dart';
import 'package:turnopro_apk/Models/orderDelete_model.dart';
import 'package:turnopro_apk/Models/product_model.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/Views/professional/clientsScheduled/modalHelperClientSchedule.dart';
import 'package:turnopro_apk/env.dart';

class ProductRepository extends GetConnect {
  double PriceT = 0.0;
  double PriceProduct = 0.0;
  double PriceService = 0.0;
  final LoginController loginCont = Get.find<LoginController>();
  Future getCartProductService() async {
    try {
      List<ProductModel> productListCar = [];
      List<ServiceModel> serviceListCar = [];
      final ShoppingCartController shoppingCartController =
          Get.find<ShoppingCartController>();
      PriceT = 0.0;
      PriceProduct = 0.0;
      PriceService = 0.0;
      int carId = shoppingCartController.carIdClienteSelect!;
      String token = loginCont.tokenUserLoggedIn;
      var url =
          '${Env.apiEndpoint}/car_orders?id=$carId'; //todo REVISAR aqui enviar el id del carro correspondiente al cliente-profesional
      print('estoy cargando el carro de id car :$url');
      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(
          Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
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
      } else if (response.statusCode == null) {
        print(
            'estoy cargando el carro de id car services leght response.statusCode:${response.statusCode}');
        return {'statusCode': null};
      }
    } catch (e) {
      // print('eroor:$e,NO RETORNO LAS DOS LISTAS ');
    }
  }

  Future serviceRequestProductDelete(int branchId) async {
    try {
      String token = loginCont.tokenUserLoggedIn;
      List<OrderDeleteModel> orderDEL = [];
      var url =
          '${Env.apiEndpoint}/car_order_delete_branch?branch_id=$branchId'; //AHORA MISMO EL QUE TIENE ES EL ID=6
      // category_branch?branch_id=10
      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(
          Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      if (response.statusCode == 200) {
        print(
            'tambien llegue aqui response.statusCode == :${response.statusCode}');
        final orders = response.body['carOrderDelete'];
        print(orders);
        if (orders != null) {
          for (int i = 0; i < orders.length; i++) {
            print(
                'ordya tengo la cola de la api es estaa Tipos de datos para el objeto ${i + 1}:');
            orders[i].forEach((key, value) {
              print(
                  'ordya tengo la cola de la api es estaa $key: ${value.runtimeType}');
            });
          }
          for (Map order in orders) {
            print('DIO ERROR loadOrderDeleteCarv aqui mapeandooooo');
            OrderDeleteModel u = OrderDeleteModel.fromJson(jsonEncode(order));
            orderDEL.add(u);
            print('DIO ERROR loadOrderDeleteCarv aqui mapeandooooo2222');
          }
        }
        //retornando dos listas

        return orderDEL;
      }
    } catch (e) {
      print('DIO ERROR loadOrderDeleteCar eroor:$e,NO RETORNO LAS DOS LISTAS ');
    }
  }

//*ESTE METODO ME DEVUELVE LOS PRODUCTOS ASOCIADO A UNA CATEGORIA LA CUAL LA SABEMOS PORQUE MANDAMOS EL ID Y ID_BRANCH
  Future getProductCategoryList(id, branchId) async {
    String token = loginCont.tokenUserLoggedIn;
    List<ProductModel> productList = [];
    print('este es el id: $id');
    print('este es el branchId: $branchId');
    try {
      var url =
          '${Env.apiEndpoint}/category_products?id=$id&branch_id=$branchId';
      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(
          Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
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
      String token = loginCont.tokenUserLoggedIn;
      List<ProductModel> productList = [];
      var url = '${Env.apiEndpoint}/product_branch?branch_id=$branchId';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(
          Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
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
  Future addOrderProduct(car_id, productId, categoryId, branchId) async {
    try {
      print('Nuevo metodo para productos - Iniciando');
      List<ProductModel> productList = [];
      var url = '${Env.apiEndpoint}/store-products';

      // Parámetros que deseas enviar en la solicitud POST
      final Map<String, dynamic> body = {
        'car_id': car_id,
        'product_id': productId,
        'category_id': categoryId,
        'branch_id': branchId
      };
      print('Nuevo metodo para productos - car_id:$car_id');
      print('Nuevo metodo para productos - productId:$productId');
      print('Nuevo metodo para productos - categoryId:$categoryId');
      print('Nuevo metodo para productos - branchId:$branchId');
      // Realizar la solicitud POST
      String token = loginController.tokenUserLoggedIn;
      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await post(headers: headers, url, body);
      print(
          'Nuevo metodo para productos - response.statusCode:${response.statusCode}');

      if (response.statusCode == 200) {
        final products = response.body['category_products'];
        if (products != null) {
          print('Nuevo metodo para productos - products != null');
          for (Map product in products) {
            ProductModel prod = ProductModel.fromJson(jsonEncode(product));
            productList.add(prod);
            print(
                'Nuevo metodo para productos - Mapeando los productos:${prod.name}');
          }
        }
        return productList; //aqui retorno los productos
      } else {
        print(
            'Nuevo metodo para productos - Dando error response.statusCode:${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Nuevo metodo para productos - Dando error en el catch:$e');
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
      String token = loginController.tokenUserLoggedIn;
      // Realizar la solicitud POST
      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await post(headers: headers, url, body);
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

  Future<int> awaitRequestDelete(id, request_delete, token) async {
    try {
      var url = '${Env.apiEndpoint}/order';

      // Parámetros que deseas enviar en la solicitud POST
      final Map<String, dynamic> body = {
        'id': id,
        'request_delete': request_delete,
      };

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await put(headers: headers, url, body);
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

  Future awaitRequestDelete2(id, request_delete, idBranch, token) async {
    List<OrderDeleteModel> orderDEL = [];
    try {
      var url = '${Env.apiEndpoint}/order2';

      // Parámetros que deseas enviar en la solicitud POST
      final Map<String, dynamic> body = {
        'id': id,
        'request_delete': request_delete,
        'id_branch': idBranch,
      };

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await put(headers: headers, url, body);
      //print('MANDE A ELIMINAR:$body');
      if (response.statusCode == 200) {
        print('tambien llegue aqui response.statusCode == 200');
        final orders = response.body['carOrderDelete'];
        print(orders);
        if (orders != null) {
          for (int i = 0; i < orders.length; i++) {
            print(
                'ordya tengo la cola de la api es estaa Tipos de datos para el objeto ${i + 1}:');
            orders[i].forEach((key, value) {
              print(
                  'ordya tengo la cola de la api es estaa $key: ${value.runtimeType}');
            });
          }
          for (Map order in orders) {
            print('DIO ERROR loadOrderDeleteCarv aqui mapeandooooo');
            OrderDeleteModel u = OrderDeleteModel.fromJson(jsonEncode(order));
            orderDEL.add(u);
            print('DIO ERROR loadOrderDeleteCarv aqui mapeandooooo2222');
          }
        }
        //retornando dos listas

        return orderDEL;
      } else {
        return orderDEL;
      }
    } catch (e) {
      return orderDEL;
    }
  }

  Future<int> orderDeleteCar(id) async {
    try {
      var url = '${Env.apiEndpoint}/order-destroy';

      // Parámetros que deseas enviar en la solicitud POST
      final Map<String, dynamic> body = {
        'id': id,
      };
      String token = loginController.tokenUserLoggedIn;
      // Realizar la solicitud POST
      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await post(headers: headers, url, body);
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
  Future<List<CategoryModel>> getCategoryList(branchIdLoggedIn, token) async {
    List<CategoryModel> categoryList = [];
    try {
      var url =
          '${Env.apiEndpoint}/category_branch?branch_id=$branchIdLoggedIn';
//todo aqui van las categorias de los productos para el tab
      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(
          Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
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

//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// Define una función para convertir una lista de JSON a una lista de ProductModel
  List<ProductModel> parseProducts(List<dynamic> jsonList) {
    return jsonList.map((json) => ProductModel.fromMap(json)).toList();
  }

//todo BIEN getCategoryList(branchIdLoggedIn)
  Future metdNewServiceProductRepository(
      branch_id, professional_id, car_id, token) async {
    List<CategoryModel> categoryList = [];
    List<ProductModel> products = [];

    try {
      var url =
          '${Env.apiEndpoint}/category-products-branch?branch_id=$branch_id&professional_id=$professional_id&car_id=$car_id';
//todo aqui van las categorias de los productos para el tab
      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(
          Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      print('category.length.new.statusCode:${response.statusCode}');
      print('category.length.new.-url:$url');
      if (response.statusCode == 200) {
        final categorys = response.body[
            'category_products']; //optengo las categorias con tds los productos
        int shoppingCart =
            response.body['product_select'] + response.body['service_select'];
        int cont = 0;
        if (categorys != null) {
          for (Map category in categorys) {
            category.length;
            Map<String, dynamic> categoryMap = {
              'id': category['id'],
              'name': category['name'],
              'code': 'esperando',
              'description': category['description'],
            };

            CategoryModel u = CategoryModel.fromJson(jsonEncode(categoryMap));
            categoryList.add(u);
            print('category.length.new-ya en products:${category['products']}');
// Convertir JSON a List<ProductModel>
            // Convertir List<dynamic> a List<ProductModel>
            // Extrae la lista de productos del objeto category
            List<dynamic> productsJson = category['products'];

// Convierte la lista de JSON a una lista de ProductModel usando la función parseProducts
            if (cont == 0) {
              //solo pasar el primer producto
              products = parseProducts(productsJson);
              print(
                  'category.length.new-ya en products------products:${products}');
              cont++;
            }

            // Usar la lista de productos
            products.forEach((product) {
              print(
                  'category.length.new-ya en products**********:${product.name}');
              print('${product.name}: ${product.sale_price}');
            });
          }

          print(
              'category.length.new-ya en categoryList-ULTIMO:${categoryList.length}');
        }
        //services
        final services = response.body['professional_services'];
        int serviceTimeAux = 0;
        List<ServiceModel> servicesList = [], selectServ = [];
        for (Map service in services) {
          ServiceModel serv = ServiceModel.fromJson(jsonEncode(service));
          servicesList.add(serv);
          if (serviceTimeAux < serv.duration_service) {
            serviceTimeAux = serv
                .duration_service; //aqui guardo el mayor tiempo de servicio para utilizarlo en la barra cuando muetra los servicios
          }
          if (serv.cliente == true) {
            selectServ.add(serv);
          }
        }

        loginCont.setServiceTime(serviceTimeAux);
        // print(
        //     'Aqui retorno los category_products por almacen-branch ${categoryList.length}');
        //  return categoryList;
        return {
          'categoryList': categoryList,
          'productCategory': products,
          'servicesList': servicesList,
          'selectServ': selectServ,
          'shoppingCart': shoppingCart,
        };
      } else if (response.statusCode == null) {
        //fallo internet
        return {'errorInternet': true};
      }
    } catch (e) {
      print('ERROR getCategoryList:$e');
      return categoryList;
    }
  }
}
