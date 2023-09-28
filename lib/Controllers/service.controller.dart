// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:get/get.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/get_connect/repository/services.repository.dart';

class ServiceController extends GetxController {
  //LLAMANDO AL CONTROLADOR
  ServiceController() {
    calculateTime();
    _fetchServiceList(); // Llamar al método asincrónico en el constructor
    update();
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 2), () {
      isLoading = false;
      update();
    });
  }

  ServiceRepository repository = ServiceRepository();
  double getTotal = 0;
  int numero = 5;
  int serviceListLength = 0;
  List<ServiceModel> services = []; // Lista de servicios

  List<ServiceModel> selectService =
      []; // Lista de servicios seleccionados vacia

  List<ServiceModel> sentServiceDelete = [];

  int time = 30;
  bool isLoading = true;

  void calculateTime() {
    if (time > 60) {
      //controlando que el tiempo no sea mayor que 60 min
      time = 60;
    }
    if (time < 0) {
      //controlando que el tiempo no sea negativo
      time = 0;
    }
    update();
  }

  getList() {
    return services;
  }

  getSelectService(index) {
    (selectService.contains(services[index]))
        ? null
        : selectService.add(services[index]);
    update();
  }

  sentServiceDelet(index) {
    (sentServiceDelete.contains(services[index]))
        ? null
        : sentServiceDelete.add(services[index]);
    update();
  }

  //*ESTE ERA EL QUE ESTABA,SELECIONAS Y DESELECCIONAS
  // getSelectService(index) {
  //   (selectService.contains(services[index]))
  //       ? selectService.remove(services[index])
  //       : selectService.add(services[index]);
  //   update();
  // }

  getTotalSum(double x) {
    getTotal = getTotal + x;
    update();
  }

  Future<void> _fetchServiceList() async {
    services = await repository.getServiceList();
    serviceListLength = services.length;
    update();
  }

  Future<bool> internetConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('soy true');
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

//*ESTOS METODOS FUNCIONAN BIEN,ESTA COMENTADO PORQUE AQUI NO C NECESITA */
//*ADICIONAR
/* 
  void addService() {
    ServiceModel newUser = ServiceModel(
      id: 12,
      name: "Servicio $serviceListLength",
      simultaneou: false,
      price_service: "20.99",
      type_service: "Corte normal",
      profit_percentaje: "10%",
      duration_service: 55,
      image_service: "/assest/imag.jpg",
      service_comment: "comentario",
    );
    services.add(newUser);
    serviceListLength = services.length; //actualizo la logitud de la lista
    getTotalSum();
    update();
  }
  */

//***************************************************************
//*METODOS ELIMINAR

  //*ELIMINAR 1 ELEMENTO
  /*
  void deleteService(int index) {
    if (index >= 0 && index < services.length) {
      //HACER LLAMADA A REPOSITORYY MANDAR A ELIMINAR EN LA BD
      //SI SE ELIMINA CORRECTAMENTE MADO HACER LO DE ABAJO,Q ES ELIMINAR EN LA PARTE VISUAL

      if (selectService.contains(services[index])) {
        selectService.removeWhere((service) => service == services[index]);
        getTotal = getTotal - 5;
      }
    }
    services.removeAt(index);
    serviceListLength = services.length;

    update();
  }

  void deleteMultipleService() {
    if (selectService.isNotEmpty) {
      //HACER LLAMADA A REPOSITORYY MANDAR A ELIMINAR EN LA BD
      //SI SE ELIMINA CORRECTAMENTE MADO HACER LO DE ABAJO,Q ES ELIMINAR EN LA PARTE VISUAL
      services.removeWhere((element) => selectService.contains(element));
      serviceListLength = services.length;
      selectService = [];
      getTotal = getTotal - 5;
      update();
    }
  }

  void deleteAll() {
    services = [];
    selectService = [];
    serviceListLength = services.length;
    getTotal = 0.0;
    update();
  }
  */
}
