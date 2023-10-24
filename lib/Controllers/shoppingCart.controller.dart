// ignore_for_file: depend_on_referenced_packages, unused_element, non_constant_identifier_names

import 'package:get/get.dart';
import 'package:turnopro_apk/Models/orderDelete_model.dart';
import 'package:turnopro_apk/Models/product_model.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/get_connect/repository/product.repository.dart';
import 'package:turnopro_apk/get_connect/repository/services.repository.dart';

class ShoppingCartController extends GetxController {
  ProductRepository productRepository = ProductRepository();
  ServiceRepository serviceRepository = ServiceRepository();

//DECLARACION DE VARIABLES
  List<ProductModel> productCart = [], selectproduct = []; // Lista de product
  List<ServiceModel> serviceCart = [], selectservice = []; // Lista de service
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

  @override
  void onReady() {
    super.onReady();
    //*AQUI CARGANDO LOS SEVICIO Y PRODUCTOS Y PONIENDOLOS EN LAS LISTAS CORRESPONDIENTES
    intentarConexion();
  }

  Future<void> loadCart() async {
    //print('estoy cargando el carro');
    try {
      //  print('00000');
      Map<String, List<dynamic>> resultList =
          await productRepository.getCartProductService(); //todo
      //print('1111111');
      selectproduct = (resultList['products'] ?? []).cast<ProductModel>();
      selectservice = (resultList['services'] ?? []).cast<ServiceModel>();

      productListLength = selectproduct.length;
      serviceListLength = selectservice.length;
      //print('------------------------');
      //  print(productListLength);
      //  print(serviceListLength);

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
      // print(orderDeleteCar);

      update();
    } catch (e) {
      //print('DIO ERROR:$e');
    }
  }

  Future<void> requestDelete(int id, int request) async {
    try {
      await productRepository.awaitRequestDelete(id, request);
      requestDeleteOrder.add(id);
      internetError = 0;
      update();
    } catch (e) {
      internetError = -99;
      update();
    }
  }

  Future<void> orderDelete(int id) async {
    try {
      await productRepository.orderDeleteCar(id); //todo
      internetError = 0;
      loadOrderDeleteCar(10);
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

  intentarConexion() {
    //TODO REVISAR ESTA FUNCION BIEN CONEXION INTERNET
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
    //print('11111');
    if (type == 'service') {
      // print('22');
      if (internetError != -99) {
        //  print('3333');
        if (!selectservice.contains(serviceCart[index])) {
          //   print(serviceCart[index].id);
          _addOrderCartList(5, 3, 0, (serviceCart[index].id - 1));
          //EN ESTA LINEA DE ABAJO SE LLAMA FUNCION PARA CALCULAR EL TOTAL
          getTotalServicesProduct_Sum(
              type, double.parse(serviceCart[index].price_service));
          shoppingCart += 1;
          serviceListLength = selectservice.length;
          //print('long de serviceListLength:$serviceListLength');
        }
        update();
      }
    } else if (type == 'product') {
      if (internetError != -99) {
        _addOrderCartList(5, 3, id, 0); //todo
        //EN ESTA LINEA DE ABAJO SE LLAMA FUNCION PARA CALCULAR EL TOTAL
        getTotalServicesProduct_Sum(
            type, double.parse(productCart[index].sale_price));
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
