// ignore_for_file: depend_on_referenced_packages, unused_element, non_constant_identifier_names

import 'package:get/get.dart';
import 'package:turnopro_apk/Models/product_model.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/get_connect/repository/product.repository.dart';
import 'package:turnopro_apk/get_connect/repository/services.repository.dart';

class ShoppingCartController extends GetxController {
  ProductRepository productRepository = ProductRepository();
  ServiceRepository serviceRepository = ServiceRepository();

  List<ProductModel> productCart = [], selectproduct = []; // Lista de product
  List<ServiceModel> serviceCart = [], selectservice = []; // Lista de service

  List<int> requestDeleteOrder = []; // id de las ordenes solicitadas a eliminar

  List<int> productCarr = [];

  int internetError = 0;
  int productListLength = 0;
  int serviceListLength = 0;
  int shoppingCart = 0;
  double totalPrice = 0.0;
  int responseId = 0;

  @override
  void onReady() {
    super.onReady();
    //*AQUI CARGANDO LOS SEVICIO Y PRODUCTOS Y PONIENDOLOS EN LAS LISTAS CORRESPONDIENTES
    intentarConexion();
  }

  Future<void> loadCart() async {
    try {
      Map<String, List<dynamic>> resultList =
          await productRepository.getCartProductService();

      List<ProductModel> productListCar =
          (resultList['products'] ?? []).cast<ProductModel>();
      List<ServiceModel> serviceListCar =
          (resultList['services'] ?? []).cast<ServiceModel>();

      selectproduct = productListCar;
      selectservice = serviceListCar;
      productListLength = selectproduct.length;
      serviceListLength = selectservice.length;
      shoppingCart = productListLength + serviceListLength;
      update();
    } catch (e) {
      //print('DIO ERROR:$e');
    }
  }

  Future<void> requestDelete(int id) async {
    try {
      await productRepository.awaitRequestDelete(id);
      requestDeleteOrder.add(id);
      internetError = 0;
      update();
    } catch (e) {
      internetError = -99;
      update();
    }
  }

  intentarConexion() {
    try {
      _fetchServiceList();
      _fetchProductList();
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
    try {
      serviceCart = await serviceRepository.getServiceList();
      internetError = 0;
    } catch (e) {
      internetError = -99;
      update();
    }
  }

  Future<void> _fetchProductList() async {
    try {
      productCart = await productRepository.getProductList();
      internetError = 0;
      update();
    } catch (e) {
      internetError = -99;
      update();
    }
  }

  Future<void> _addOrderCartList(
      client_id, person_id, product_id, service_id) async {
    try {
      responseId = await productRepository.addOrderCartList(
          client_id, person_id, product_id, service_id);
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

  void updateShoppingCartValue(index, String type, id) {
    if (type == 'service') {
      if (internetError != -99) {
        if (!selectservice.contains(serviceCart[index])) {
          _addOrderCartList(5, 3, 0, (serviceCart[index].id - 1));
          totalPrice += double.parse(serviceCart[index]
              .price_service); //convierte un estring en un double
          shoppingCart += 1;
          serviceListLength = selectservice.length;
        }
        update();
      }
    } else if (type == 'product') {
      if (internetError != -99) {
        print('indice:$index');
        print(id);
        _addOrderCartList(5, 3, id, 0); //todo
        //todo revisar el totalPrice, que venga de la db
        totalPrice += double.parse(productCart[index].sale_price);
        shoppingCart += 1;
        update();
      }
    }
  }

  void deleteShoppingCartValue(int newValue) {
    shoppingCart -= newValue;
    update();
  }

  //  RxInt shoppingCart = 0.obs;

  // void updateAppBarValue(int newValue) {
  //   shoppingCart.value += newValue;
  // }

  int time = 30;
  bool isLoading = true;

  getList() {
    return productCart;
  }

  getCategoryList() {
    return serviceCart;
  }

  //Future<List<UserModel>> userList() async => await repository.getUserList();

//***************************************************************
//*METODOS ELIMINAR

  //*ELIMINAR 1 ELEMENTO
  void deleteproduct(int index) {
    if (index >= 0 && index < productCart.length) {
      //HACER LLAMADA A REPOSITORYY MANDAR A ELIMINAR EN LA BD
      //SI SE ELIMINA CORRECTAMENTE MADO HACER LO DE ABAJO,Q ES ELIMINAR EN LA PARTE VISUAL

      if (selectproduct.contains(productCart[index])) {
        selectproduct.removeWhere((products) => products == productCart[index]);
      }
    }
    productCart.removeAt(index);
    productListLength = productCart.length;

    update();
  }

  //*ELIMINAR  ELEMENTOS SELECCIONADOS
  void deleteMultipleproduct() {
    if (selectproduct.isNotEmpty) {
      //HACER LLAMADA A REPOSITORYY MANDAR A ELIMINAR EN LA BD
      //SI SE ELIMINA CORRECTAMENTE MADO HACER LO DE ABAJO,Q ES ELIMINAR EN LA PARTE VISUAL
      productCart.removeWhere((element) => selectproduct.contains(element));
      productListLength = productCart.length;
      selectproduct = [];
      update();
    }
  }

  void deleteAll() {
    productCart = [];
    selectproduct = [];
    productListLength = productCart.length;
    update();
  }
}
