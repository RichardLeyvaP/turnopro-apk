// ignore_for_file: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/get_connect/repository/services.repository.dart';

class ServiceController extends GetxController {
//DECLARACION DE VARIABLES
  ServiceRepository repository = ServiceRepository();
  double getTotal = 0;
  int serviceListLength = 0;
  List<ServiceModel> services = []; // Lista de servicios
  List<ServiceModel> selectService = []; //ervicios seleccionados vacia
  List<ServiceModel> sentServiceDelete = [];
  bool isLoading = true;
  bool loadedFirstTime = false;

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

  loadListService() {
    _fetchServiceList();
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
    print('LISTA1 _fetchServiceList:$serviceListLength');
    final LoginController controllerLogin = Get.find<LoginController>();
    print(
        'Id Profesional _fetchServiceList:${controllerLogin.idProfessionalLoggedIn}');
    services = await repository.getServiceList(
        controllerLogin.idProfessionalLoggedIn,
        controllerLogin.branchIdLoggedIn);
    serviceListLength = services.length;
    loadedFirstTime = true;
    update();
    print('LISTA2 _fetchServiceList:$serviceListLength');
  }
}
