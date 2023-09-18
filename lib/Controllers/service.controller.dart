// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/get_connect/repository/services.repository.dart';

class ServiceController extends GetxController {
  //LLAMANDO AL CONTROLADOR
  ServiceController() {
    getTotalSum();
    calculateTime();
    if (yaEntre == false) {
      _fetchServiceList(); // Llamar al método asincrónico en el constructor
      getTotalSum();
      yaEntre = true;
      update();
    }
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
  bool yaEntre = false;
  double getTotal = 20.0;
  int numero = 5;
  int serviceListLength = 0;
  List<ServiceModel> services = []; // Lista de servicios
  List<ServiceModel> selectService =
      []; // Lista de servicios seleccionados vacia
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
        ? selectService.remove(services[index])
        : selectService.add(services[index]);
    update();
  }

  getTotalSum() {
    getTotal = getTotal + 5;

    // getTotal = services
    //     .map((service) => service.id)
    //     .fold(0.0, (sum, id) => sum + id)
    //     .toDouble();
    // print(getTotal);
    update();
  }

  //Future<List<UserModel>> userList() async => await repository.getUserList();

  Future<void> _fetchServiceList() async {
    services = await repository.getServiceList();
    serviceListLength = services.length;
    update();
  }

  // void addService() {
  //   ServiceModel newUser = ServiceModel(
  //       id: 12,
  //       name: "Servicio $serviceListLength",
  //       username: "Nuevo servicio");
  //   services.add(newUser);
  //   serviceListLength = services.length; //actualizo la logitud de la lista
  //   getTotalSum();
  //   update();
  // }

//***************************************************************
//*METODOS ELIMINAR

  //*ELIMINAR 1 ELEMENTO
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

  //*ELIMINAR  ELEMENTOS SELECCIONADOS
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
}
