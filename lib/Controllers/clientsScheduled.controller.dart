// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Models/clientsScheduled_model.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/get_connect/repository/clientsScheduled.repository.dart';

class ClientsScheduledController extends GetxController {
  //DECLARACION DE VARIABLES
  ClientsScheduledRepository repository = ClientsScheduledRepository();
  int clientsScheduledListLength = 0;
  List<ClientsScheduledModel> clientsScheduledList = []; // Lista de clientes
  ClientsScheduledModel? clientsScheduledNext; // Cliente en espera
  List<ClientsScheduledModel> selectClientsScheduledList = [];
  bool isLoading = true;
  int? carIdClientsScheduled;
  List<ServiceModel> serviceCustomerSelected = [];

  //Variables del reloj
  double sizeClock = 135;
  //Fin Variables del reloj

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 2), () {
      isLoading = false;

      update();
    });
  }

  getList() {
    return clientsScheduledList;
  }

  getselectCustomer(index, idCar) {
    print('IdCar:$idCar');
    (selectClientsScheduledList.contains(clientsScheduledList[index]))
        ? selectClientsScheduledList.remove(clientsScheduledList[index])
        : selectClientsScheduledList.add(clientsScheduledList[index]);
    _searchForCustomerServices(idCar);
    update();
  }

  cleanselectCustomer() {
    selectClientsScheduledList.clear();
    update();
  }

  Future<void> fetchClientsScheduled(idProfessional, idBranch) async {
    Map<String, dynamic> resultList =
        await repository.getClientsScheduledList(idProfessional, idBranch);

    //aqui estoy guardando la cola del dia de hoy del profesional
    clientsScheduledList =
        (resultList['clientList'] ?? []).cast<ClientsScheduledModel>();
    clientsScheduledListLength = clientsScheduledList.length;
    //aqui guardo al proximo de la cola para mostrarlo en el Home de la apk
    clientsScheduledNext = resultList['nextClient'];

    if (clientsScheduledNext != null) {
      int idCar = clientsScheduledNext!.car_id;
      await _searchForCustomerServices(idCar);
      setValueClock(true);
    } else {
      setValueClock(false);
    }

    update();
  }

  setValueClock(bool value) {
    if (value == true) {
      sizeClock = 135;
    } else {
      sizeClock = 175;
    }
  }

  Future<void> _searchForCustomerServices(idCar) async {
    serviceCustomerSelected = await repository.getCustomerServicesList(idCar);
    update();
  }

  Future<void> acceptOrRejectClient(reservationId, attended) async {
    final LoginController controllerLogin = Get.find<LoginController>();
    bool value = await repository.acceptOrRejectClient(reservationId, attended);
    //si lo que devuelve es true actualizo la cola
    if (value == true) {
      int? idBranch = controllerLogin.branchIdLoggedIn;
      int? idProfessional = controllerLogin.idProfessionalLoggedIn;
      //aqui actualizo la cola
      await fetchClientsScheduled(idProfessional, idBranch);
      print('Todo perfectamente se actualizo el valor');
    } else {
      print('Dio error al mandar a aceptar o rechazar al cliente');
    }
  }
}
