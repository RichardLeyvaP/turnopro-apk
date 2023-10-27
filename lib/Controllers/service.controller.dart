// ignore_for_file: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/get_connect/repository/services.repository.dart';

class ServiceController extends GetxController {
  //LLAMANDO AL CONTROLADOR
  ServiceController() {
    _fetchServiceList();
  }

//DECLARACION DE VARIABLES
  ServiceRepository repository = ServiceRepository();
  double getTotal = 0;
  int serviceListLength = 0;
  bool isLoading = true;
  List<ServiceModel> services = []; // Lista de servicios
  List<ServiceModel> selectService = []; //ervicios seleccionados vacia
  List<ServiceModel> sentServiceDelete = [];

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 2), () {
      isLoading = false;
      update();
    });
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

  Future<void> _fetchServiceList() async {
    services = await repository.getServiceList();
    serviceListLength = services.length;
    update();
  }
}
