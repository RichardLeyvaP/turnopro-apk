// ignore_for_file: depend_on_referenced_packages, unused_element, unrelated_type_equality_checks

import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Models/clientsScheduled_model.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/get_connect/repository/clientsScheduled.repository.dart';

class ClientsScheduledController extends GetxController {
  //DECLARACION DE VARIABLES
  ClientsScheduledRepository repository = ClientsScheduledRepository();

  List<ClientsScheduledModel> clientsScheduledList = []; // Lista de clientes
  List<ClientsScheduledModel> selectClientsScheduledList = [];
  ClientsScheduledModel? clientsScheduledNext; // Cliente en espera
  List<ServiceModel> serviceCustomerSelected = [];

  int clientsScheduledListLength = 0;
  int? carIdClientsScheduled;
  int quantityClientAttended = 0;
  bool isLoading = true;
  //Variables del reloj
  double sizeClock = 135;
  int totalTimeInitial = 10; //Iniciando en 3 minutos el reloj
  bool callCliente = false; //si esta en false es que es la primera vez
  bool boolFilterShowNext = false; //si esta en false es que es la primera vez

  //Fin Variables del reloj

  //VARIABLES PARA EL CONTROL DE INCUMPLIMINETOS (convivencia)
  Map<String, bool> noncomplianceProfessional = {
    //el tiempo para escoger los clientes inicial (3min)
    'lateCustomerTimeInitial': false,
    'teamQuota': false, //Cuidado de equipo
    'punctuality': false, //Puntualidad
    /******************AGREGAR AQUI TODS LOS QUE DESEN*********************/
  };

  Future<void> filterShowNext() async {
    try {
      final LoginController controllerLogin = Get.find<LoginController>();
      int? idBranch = controllerLogin.branchIdLoggedIn;
      int? idProfessional = controllerLogin.idProfessionalLoggedIn;

      bool resultTypeService =
          await repository.typeOfService(idProfessional, idBranch);
      if (resultTypeService) {
        print('************** true');
        boolFilterShowNext = true;
      } else {
        print('************** false');
        boolFilterShowNext = false;
      }
      update();
    } catch (e) {
      print(e);
    }
  }

  void changeNoncomplianceP(String value) {
    //INCUMPLIMIENTO
    if (noncomplianceProfessional.containsKey(value)) {
      //AQUI ES PÓRQUE INCUMPLIO CON ALGO
      noncomplianceProfessional[value] = true;
      print(noncomplianceProfessional[value]);
      update();
    } else {
      print('La clave $value no existe en el mapa.');
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
    quantityClientAttended = resultList['quantityClientAttended'];

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
      sizeClock = 160;
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
      filterShowNext();
      //AQUI ACTUALIZO LA VARIABLE QUE ME DICE QUE YA LLAMO A UN CLIENTE
      if (attended == 1) {
        callCliente = true;
      }
    } else {
      print('Dio error al mandar a aceptar o rechazar al cliente');
    }
  }

  int convertDateSecons(String tiempo) {
    List<String> partes = tiempo.split(":");
    int horas = int.parse(partes[0]);
    int minutos = int.parse(partes[1]);
    int segundos = int.parse(partes[2]);

    int tiempoEnSegundos = horas * 3600 + minutos * 60 + segundos;
    return tiempoEnSegundos;
  }
}
