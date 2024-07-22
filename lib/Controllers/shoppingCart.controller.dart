// ignore_for_file: depend_on_referenced_packages, unused_element, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/product.controller.dart';
import 'package:turnopro_apk/Controllers/service.controller.dart';
import 'package:turnopro_apk/Models/orderDelete_model.dart';
import 'package:turnopro_apk/Models/product_model.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/Views/professional/clientsScheduled/modalHelperClientSchedule.dart';
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
  List<String> idServiceCart = []; // Lista de service
  List<OrderDeleteModel> orderDeleteCar = [];
  bool buttonPress = false;
  List<int> requestDeleteOrder = []; // id de las ordenes solicitadas a eliminar
  List<int> productCarr = [];
  int internetError = 0;
  double getTotalServices = 0;
  double getTotalProduct = 0;
  double totalPrice = 0.0;
  int productListLength = 0;
  int serviceListLength = 0;
  int serviceListLengthCant = 0;
  int shoppingCart = 0;
  int responseId = 0;
  bool load_request = false;
  bool isLoading = true;
  int? carIdClienteSelect;
  final LoginController controllerLogin = Get.find<LoginController>();
  final ClientsScheduledController clientScheduCont =
      Get.find<ClientsScheduledController>();
  void setLoading(value) {
    isLoading = value;
    update();
  }

  void setButtonPress(value) {
    buttonPress = value;
    update();
  }

  void setServiceSelectCant(int value) {
    if (value == 0) {
      // vaciar
      serviceListLengthCant = 0;
    } else {
      serviceListLengthCant = serviceListLengthCant + value;
    }

    update();
  }

  Future<void> loadCart() async {
    await Future.delayed(const Duration(seconds: 1));
    final ServiceController serviceControll = Get.find<ServiceController>();
    idServiceCart.clear();
    requestDeleteOrder.clear();
    print('estoy cargando el carro de id car :$carIdClienteSelect');

    try {
      print(
          '**** 11111111 **** *** ESTE ES EL getTotalServices ACTUALMENTE:$getTotalServices');
      //  print('00000');
      Map<String, dynamic> resultList =
          await productRepository.getCartProductService(); //todo aqui revisando
      //print('1111111');

      //primero veo que no halla dado null la llamada
      if (resultList.containsKey('statusCode') &&
          resultList['statusCode'] == null) {
        controllerLogin.showConnectionError();
      } else {
        selectproduct = (resultList['products'] ?? []).cast<ProductModel>();
        selectserviceCart = (resultList['services'] ?? []).cast<ServiceModel>();
        // if (totalPrice == 0.0) {
        //Este condicional controlando que solo entrela primera vez
        totalPrice = resultList['PriceTotal'];
        getTotalServices = resultList['PriceService'];
        getTotalProduct = resultList['PriceProduct'];
        //}
        print(
            '**** 11111111 **** *** ESTE ES EL getTotalServices ACTUALMENTE:$getTotalServices');
        productListLength = selectproduct.length;
        serviceListLength = selectserviceCart.length;
        //aqui asigno los servicios que ya tiene sekeccionados
        serviceControll.asigSelectService(selectserviceCart);
        print(
            'LISTA2 _fetchServiceList Limpiando**** *** ESTE ES EL getTotalServices ACTUALMENTE:${selectserviceCart.length}');
        print(
            'LISTA2 _fetchServiceList Limpiando**** *** ESTE ES EL getTotalServices ACTUALMENTE:${selectserviceCart}');

        for (int i = 0; i < selectserviceCart.length; i++) {
          idServiceCart.add(selectserviceCart[i].nameService!);
        }
        shoppingCart = productListLength + serviceListLength;

        update();
      }
    } catch (e) {
      //print('DIO ERROR:$e');
    } finally {
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Future<void> loadOrderDeleteCar(branchId) async {
    print(' estoy loadOrderDeleteCar aqui en loadOrderDeleteCar');
    try {
      orderDeleteCar =
          await productRepository.serviceRequestProductDelete(branchId); //todo
      print('estoy loadOrderDeleteCar llegue aquiiiii orderDeleteCar');
      print(orderDeleteCar);
      print(
          'estoy loadOrderDeleteCar llegue aquiiiii orderDeleteCar.length:${orderDeleteCar.length}');

      update();
    } catch (e) {
      print('DIO ERROR loadOrderDeleteCar:$e');
    } finally {
      // controllerLogin.setMakeCallC(true); //avilite las llamadas del timer
      // controllerLogin.setMakeCallE(true);
    }
  }

  Future<int> requestDelete(int id, int request_delete) async {
    //todooooooooo
    try {
      int result = await productRepository.awaitRequestDelete(
          id, request_delete, controllerLogin.tokenUserLoggedIn);
      if (result == 1) {
        requestDeleteOrder.add(id);
        internetError = 0;
      }
      update();
      return result;
    } catch (e) {
      internetError = -99;
      update();
      return -99;
    }
  }

  Future<int> requestDelete2(int id, int request_delete, int idBranch) async {
    //todooooooooo
    try {
      orderDeleteCar = await productRepository.awaitRequestDelete2(
          id, request_delete, idBranch, controllerLogin.tokenUserLoggedIn);
      if (orderDeleteCar.isNotEmpty) {
        requestDeleteOrder.add(id);
        internetError = 0;
        update();
        return 1;
      } else {
        return 0;
      }
    } catch (e) {
      internetError = -99;
      update();
      return -99;
    }
  }

  Future<int> orderDelete(id) async {
    try {
      int result = await productRepository.orderDeleteCar(id); //todo
      if (result == 1) {
        internetError = 0;
        //  loadOrderDeleteCar(carIdClienteSelect!); //todo mandar branch_id errorrrr
      }
      print('return resul: $result');
      return result;
    } catch (e) {
      print('return resul: Error desde el controlador $e');
      internetError = -99;

      return -99;
    }
  }

  getTotalServicesProduct_Sum(String type, int prec) {
    if (type == 'service') {
      getTotalServices = getTotalServices + prec;
    } else if (type == 'product') {
      //todo revisar la suma de los precios del producto
      getTotalProduct = getTotalProduct + prec;
    }
    totalPrice = getTotalServices + getTotalProduct;
    update();
  }

  loadDataInitiallyNecessary() async {
    //*AQUI CARGANDO LOS SEVICIO Y PRODUCTOS Y PONIENDOLOS EN LAS LISTAS CORRESPONDIENTES

    //TODO REVISAR ESTA FUNCION BIEN CONEXION INTERNET
    try {
      final ServiceController controllerService = Get.find<ServiceController>();

      await controllerService.loadListService();
      print('************* onReady:****serviceCart:${serviceCart.length}');
      await loadCart();

      internetError = 0;
    } catch (e) {
      internetError = -99;
      update();
    }
  }

  Future<void> _fetchServiceList() async {
    //todo esta esta revisada ok
    try {
      final LoginController controllerLogin = Get.find<LoginController>();
      serviceCart = await serviceRepository.getServiceList(
          controllerLogin.idProfessionalLoggedIn,
          controllerLogin.branchIdLoggedIn);
      internetError = 0;
      update();
    } catch (e) {
      internetError = -99;
      update();
    }
  }

  /* Future<void> _fetchProductList() async {
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
  }*/

  Future<int> _addOrderCartListNEW(car_id, product_id, service_id, type) async {
    try {
      int res = await productRepository.addOrderCartList(
          car_id, product_id, service_id, type);
      print('internetError responseId:$responseId');
      if (res != -990099) {
        print('agregar responseId');
        productCarr.add(res);
        internetError = 0;
        update();
        return 0;
      } else {
        print('internetError ');
        internetError = -99;
        update();
        return -99;
      }
    } catch (e) {
      internetError = -99;
      print('error:$e');
      update();
      return -990099;
    }
  }

  Future<int> _addOrderCartList(car_id, product_id, service_id, type) async {
    try {
      int res = await productRepository.addOrderCartList(
          car_id, product_id, service_id, type);
      print('internetError responseId:$responseId');
      if (res != -990099) {
        print('agregar responseId');
        productCarr.add(res);
        internetError = 0;
        update();
        return 0;
      } else {
        print('internetError ');
        internetError = -99;
        update();
        return -99;
      }
    } catch (e) {
      internetError = -99;
      print('error:$e');
      update();
      return -990099;
    }
  }

  //
  //

  Future shopProduct(
      priceProduct, car_id, productId, categoryId, branchId) async {
    try {
      final ProductController productCont = Get.find<ProductController>();
      List<ProductModel>? tempProduct;
      getTotalProduct = getTotalProduct + priceProduct;
      totalPrice = getTotalServices + getTotalProduct;

      tempProduct = await productRepository.addOrderProduct(
          car_id, productId, categoryId, branchId);
      //actualizar los productos pasando el id de la categoria
      if (tempProduct != null) {
        productCont.productActualizate(tempProduct);

        shoppingCart += 1;
      } else {
        print('Ha dado error al comprar los productos y dio tempProduct=null');
      }
    } catch (e) {
      print('error:$e');
    } finally {
      await Future.delayed(const Duration(seconds: 1));
      update();
    }
  }

  void updateShoppingCartValueSer(
      priceService, id, car_id, type, servicioName) async {
    // print('*************serviceCart:${serviceCart.length}');

    if (!idServiceCart.contains(servicioName)) {
      // selectserviceCart.add(servicio);
      idServiceCart.add(servicioName);
      _addOrderCartList(car_id, 0, id, type); //todo REVISAR TIENE PROBLEMA
      //EN ESTA LINEA DE ABAJO SE LLAMA FUNCION PARA CALCULAR EL TOTAL
      getTotalServicesProduct_Sum(type, priceService);
      shoppingCart += 1;
      serviceListLength = selectserviceCart.length;
      print(
          'LISTA2 _fetchServiceList Limpiando long de idServiceCart.length:${idServiceCart.length}');
    }
    update();
  }

// updateShoppingCartValueSer(
  //                       _.services[index].price_service, //aqui 0 porque este campo solo lo utilizo si fuera un producto
  //                     _.services[index].id,
  //                       controllerShoppingCart.carIdClienteSelect,
  //                    'service',
  //                 _.services[index].name);
  //(priceService, id, car_id, type, servicioName)
  Future<int> updateShoppingCartValueSerNew(
      List<ServiceModel> selectServiceNew) async {
    try {
      int durationService = 0;
      final ClientsScheduledController clientsController =
          Get.find<ClientsScheduledController>();
      int cant = 0;
      for (ServiceModel service in selectServiceNew) {
        // Llama al método _addOrderCartList con los parámetros necesarios
        idServiceCart.add(service.name);
        int resul = await _addOrderCartListNEW(carIdClienteSelect, 0,
            service.id, 'service'); //todo REVISAR TIENE PROBLEMA
        //EN ESTA LINEA DE ABAJO SE LLAMA FUNCION PARA CALCULAR EL TOTAL
        if (resul == 0) //todo esta bien si retorna 0
        {
          cant++;
          getTotalServicesProduct_Sum('service', service.price_service);
          shoppingCart += 1;
          serviceListLength = selectserviceCart.length;
          print('memsj Servicio guardado exitosamente: ${service.id}');
          print('memsj durationService:en el for: ${service.duration_service}');
          durationService += service.duration_service;
        }
        // Pausa por 200 ms entre cada solicitud para evitar sobrecargar el servidor
        await Future.delayed(const Duration(milliseconds: 200));
      }
      if (cant == selectServiceNew.length) {
        print('todos los servicios se insertaron correctamente');
      } else {
        cant = cant - selectServiceNew.length;
        print(
            'todos los servicios NO se insertaron correctamente faltaron: $cant por insertarse');
      }
      print('memsj durationService: $durationService');
      //agregar el tiempo al reloj
      print('memsj durationService:en el for: $durationService');

      if (cant > 0) //si es menor o igual no insertó nada
      {
        if (clientScheduCont.modifyTimeSpecific == 0) //es el reloj 1
        {
          addDurationToTimer(clientScheduCont.animationController1!,
              Duration(minutes: durationService));
        } else if (clientScheduCont.modifyTimeSpecific == 1) //reloj 2
        {
          addDurationToTimer(clientScheduCont.animationController2!,
              Duration(minutes: durationService));
        } else if (clientScheduCont.modifyTimeSpecific == 2) //reloj 3
        {
          addDurationToTimer(clientScheduCont.animationController3!,
              Duration(minutes: durationService));
        } else if (clientScheduCont.modifyTimeSpecific == 3) //reloj
        {
          addDurationToTimer(clientScheduCont.animationController4!,
              Duration(minutes: durationService));
        }
        //esta e spara actualizar las variables de memoria del telefono
        controllerLogin.getUpdateTime(
            durationService,
            (clientScheduCont.modifyTimeSpecific + 1),
            'updateShoppingCartValueSerNew-reloj=${clientScheduCont.modifyTimeSpecific + 1}');
      }

      //clientsController.modifingTime((durationService));
      return cant;
    } catch (e) {
      print('memsj Error al guardar el servicio: $e');
      return -990099;
      // Manejar el error según sea necesario
    } finally {
      update();
    }
  }

  void addDurationToTimer(
      AnimationController controller, Duration additionalDuration) {
    // Verificar si el controlador está detenido o activo
    int currentTime;
    if (controller.isAnimating) {
      // Obtener el tiempo restante en segundos del AnimationController si está activo
      currentTime = (controller.duration!.inSeconds).round();
    } else {
      // Si está detenido, establecer el tiempo actual a la duración total del controlador
      currentTime = controller.duration!.inSeconds;
    }
    print('memsj durationService:ESTE ES EL TIEMPO QUE TENIA:$currentTime');
    // Convertir additionalDuration a segundos
    int additionalTime = additionalDuration.inSeconds;
    print('tiempoooooo : additionalTime:$additionalTime');

    // Calcular el nuevo tiempo total en segundos
    int newTotalTime = currentTime + additionalTime;
    print('tiempoooooo : newTotalTime:$newTotalTime');

    // Asignar la nueva duración al AnimationController
    controller.duration = Duration(seconds: newTotalTime);

    // Reiniciar y avanzar el AnimationController con la nueva duración
    controller
      ..reset()
      ..forward();
  }

  void updateShoppingCartValue(priceProduct, index, car_id, type, id) async {
    final ProductController productCont = Get.find<ProductController>();
    if (type == 'service') {
      // print('22');
      if (internetError != -99) {
        // print('*************serviceCart:${serviceCart.length}');
        if (!selectserviceCart.contains(serviceCart[index])) {
          selectserviceCart.add(serviceCart[index]);
          _addOrderCartList(car_id, 0, serviceCart[index].id,
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
        await _addOrderCartList(car_id, id, 0, type); //todo
        print('else if (type == product):$index');
        //EN ESTA LINEA DE ABAJO SE LLAMA FUNCION PARA CALCULAR EL TOTAL
        getTotalServicesProduct_Sum(type, priceProduct);
        //actualizar los productos pasando el id de la categoria
        await productCont.fetchproductList(index);
        shoppingCart += 1;
        update();
      }
    }
  }

  /* Future shopProduct(
      priceProduct, categoryId, car_id, type, productId, branchId) async {
    final ProductController productCont = Get.find<ProductController>();
    List<ProductModel>? tempProduct;
    if (type == 'product') {
      //EN ESTA LINEA DE ABAJO SE LLAMA FUNCION PARA CALCULAR EL TOTAL
      getTotalProduct = getTotalProduct + priceProduct;
      totalPrice = getTotalServices + getTotalProduct;

      tempProduct =
          await addShopProduct(priceProduct,car_id, productId, categoryId, branchId);
//actualizar los productos pasando el id de la categoria
      if (tempProduct != null) {
        productCont.product = tempProduct;
        productListLength = productCont.product.length;
        print('Cantidad de productos -- -- -- $productListLength');
        shoppingCart += 1;
      } else {
        print('Ha dado error al comprar los productos y dio tempProduct=null');
      }

      update();
    }
  }*/

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
