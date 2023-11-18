// ignore_for_file: depend_on_referenced_packages, unused_element, non_constant_identifier_names

import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/service.controller.dart';
import 'package:turnopro_apk/Models/orderDelete_model.dart';
import 'package:turnopro_apk/Models/product_model.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/get_connect/repository/product.repository.dart';
import 'package:turnopro_apk/get_connect/repository/services.repository.dart';
//todo REVISAR REVISAR este controlador y que  funcione correctamente,no lo he revisado me refiero funcionalmente

class ShoppingCartController extends GetxController {
  ProductRepository productRepository = ProductRepository();
  ServiceRepository serviceRepository = ServiceRepository();

//DECLARACION DE VARIABLES
  List<ProductModel> productCart = [], selectproduct = []; // Lista de product
  List<ServiceModel> serviceCart = [],
      selectserviceCart = []; // Lista de service
  List<OrderDeleteModel> orderDeleteCar = [];
  List<int> requestDeleteOrder = []; // id de las ordenes solicitadas a eliminar
  List<int> productCarr = [];
  int internetError = 0;
  double getTotalServices = 0;
  double getTotalProduct = 0;
  double totalPrice = 0.0;
  int productListLength = 0;
  int serviceListLength = 0;
  int shoppingCart = 0;
  int responseId = 0;
  bool load_request = false;
  bool isLoading = true;

  Future<void> loadCart() async {
    //print('estoy cargando el carro');

    update();
    try {
      print(
          '**** 11111111 **** *** ESTE ES EL getTotalServices ACTUALMENTE:$getTotalServices');
      //  print('00000');
      Map<String, dynamic> resultList =
          await productRepository.getCartProductService(); //todo aqui revisando
      //print('1111111');
      selectproduct = (resultList['products'] ?? []).cast<ProductModel>();
      selectserviceCart = (resultList['services'] ?? []).cast<ServiceModel>();
      if (totalPrice == 0.0) {
        //Este condicional controlando que solo entrela primera vez
        totalPrice = resultList['PriceTotal'];
        getTotalServices = resultList['PriceService'];
        getTotalProduct = resultList['PriceProduct'];
      }
      print(
          '**** 11111111 **** *** ESTE ES EL getTotalServices ACTUALMENTE:$getTotalServices');
      productListLength = selectproduct.length;
      serviceListLength = selectserviceCart.length;

      shoppingCart = productListLength + serviceListLength;

      update();
    } catch (e) {
      //print('DIO ERROR:$e');
    }
  }

  Future<void> loadOrderDeleteCar(int id_car) async {
    //print('estoy aqui en load');
    try {
      //print('1111111');
      orderDeleteCar =
          await productRepository.serviceRequestProductDelete(id_car); //todo
      print(orderDeleteCar);

      update();
    } catch (e) {
      //print('DIO ERROR:$e');
    }
  }

  Future<void> requestDelete(int id, int request_delete) async {
    //todooooooooo
    try {
      await productRepository.awaitRequestDelete(id, request_delete);
      requestDeleteOrder.add(id);
      internetError = 0;
      update();
    } catch (e) {
      internetError = -99;
      update();
    }
  }

  Future<void> orderDelete(id) async {
    try {
      await productRepository.orderDeleteCar(id); //todo
      internetError = 0;
      loadOrderDeleteCar(
          13); //todo REVISAR aqui mandando el id del carro estatico
      update();
    } catch (e) {
      internetError = -99;
      update();
    }
  }

  getTotalServicesProduct_Sum(String type, double x) {
    if (type == 'service') {
      getTotalServices = getTotalServices + x;
    } else if (type == 'product') {
      //todo revisar la suma de los precios del producto
      getTotalProduct = getTotalProduct + x;
    }
    totalPrice = getTotalServices + getTotalProduct;
    update();
  }

  loadDataInitiallyNecessary() async {
    //*AQUI CARGANDO LOS SEVICIO Y PRODUCTOS Y PONIENDOLOS EN LAS LISTAS CORRESPONDIENTES

    //TODO REVISAR ESTA FUNCION BIEN CONEXION INTERNET
    try {
      final ServiceController controllerService = Get.find<ServiceController>();
      if (controllerService.loadedFirstTime == false) {
        await controllerService.loadListService();
      }
      await _fetchServiceList(); //todo revisar para que yo queria saber si tenia servicio y productos el profesional
      await _fetchProductList();
      print('************* onReady:****serviceCart:${serviceCart.length}');
      // _fetchProductList();
      loadCart();
      //******************************************************************************** */
      internetError = 0;
      Future.delayed(const Duration(seconds: 2), () {
        isLoading = false;
        update();
      });
    } catch (e) {
      internetError = -99;
      update();
    }
  }

  Future<void> _fetchServiceList() async {
    //todo esta esta revisada ok
    try {
      final LoginController controllerLogin = Get.find<LoginController>();
      serviceCart = await serviceRepository
          .getServiceList(controllerLogin.idProfessionalLoggedIn);
      internetError = 0;
      update();
    } catch (e) {
      internetError = -99;
      update();
    }
  }

  Future<void> _fetchProductList() async {
    try {
      final LoginController controllerLogin = Get.find<LoginController>();
      productCart = await productRepository.getProductList(controllerLogin
          .branchIdLoggedIn); //todo1 mando a pedir los productos que hay en la sucursal
      internetError = 0;
      update();
    } catch (e) {
      internetError = -99;
      update();
    }
  }

  Future<void> _addOrderCartList(
      client_id, person_id, product_id, service_id, type) async {
    try {
      responseId = await productRepository.addOrderCartList(
          client_id, person_id, product_id, service_id, type);
      if (responseId != -990099) {
        productCarr.add(responseId);
        internetError = 0;
      } else {
        internetError = -99;
      }
      update();
    } catch (e) {
      internetError = -99;
      update();
    }
  }

  void updateShoppingCartValue(index, idProfessional, type, id) {
    if (type == 'service') {
      // print('22');
      if (internetError != -99) {
        // print('*************serviceCart:${serviceCart.length}');
        if (!selectserviceCart.contains(serviceCart[index])) {
          selectserviceCart.add(serviceCart[index]);
          _addOrderCartList(5, idProfessional, 0, serviceCart[index].id,
              type); //todo REVISAR TIENE PROBLEMA
          //EN ESTA LINEA DE ABAJO SE LLAMA FUNCION PARA CALCULAR EL TOTAL
          getTotalServicesProduct_Sum(type, serviceCart[index].price_service);
          shoppingCart += 1;
          serviceListLength = selectserviceCart.length;
          print('long de serviceListLength:$serviceListLength');
        }
        update();
      }
    } else if (type == 'product') {
      if (internetError != -99) {
        print('todavia qui llego bien');
        _addOrderCartList(5, idProfessional, id, 0, type); //todo
        //EN ESTA LINEA DE ABAJO SE LLAMA FUNCION PARA CALCULAR EL TOTAL
        getTotalServicesProduct_Sum(type, productCart[index].sale_price);
        shoppingCart += 1;
        update();
      }
    }
  }

  void deleteShoppingCartValue(int newValue) {
    shoppingCart -= newValue;
    update();
  }

  getList() {
    return productCart;
  }

  getCategoryList() {
    return serviceCart;
  }
}
