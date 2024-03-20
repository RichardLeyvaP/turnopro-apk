// ignore_for_file: depend_on_referenced_packages, unused_element, unrelated_type_equality_checks

import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Models/clientsScheduled_model.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/get_connect/repository/clientsScheduled.repository.dart';

class ClientsTechnicalController extends GetxController {
  //DECLARACION DE VARIABLES
  ClientsScheduledRepository repository = ClientsScheduledRepository();

  List<ClientsScheduledModel> clientsScheduledListTechnical =
      []; // Lista de clientes
  List<ClientsScheduledModel> selectclientsScheduledListTechnical = [];
  ClientsScheduledModel? clientsScheduledNext; // Cliente en espera
  ClientsScheduledModel?
      clientsNextTechnical; // Cliente en espera // Cliente en espera
  ClientsScheduledModel? clientsAttendedTechnical; // Cliente en espera
  bool activeModifyTime = false;
  int modifyTimeSpecific = -99;
  int availability = 1;
  int busyClock = -99;
  String clientsAttended = 'nobody';
  String technicalClientsAttended = 'nobody';
  List<ServiceModel> serviceCustomerSelected = [];

  int clientsTechnicalLength = 0;
  int? carIdClientsScheduled;
  int quantityClientAttended = 0;
  int quantityClientAttendedTechnical = 0;
  bool isLoading = true;
  bool correctConnection = true;

  //Variables del reloj

  double sizeClockTechnical = 145;
  int totalTimeInitial = 3 * 60; //Iniciando en 3 minutos el reloj
  bool callCliente = false; //si esta en false es que es la primera vez
  bool boolFilterShowNext = false; //si esta en false es que es la primera vez
  bool boolFilterShowNextTecnhical =
      false; //si esta en false es que es la primera vez
  bool showingServiceClients = false;
  bool showingServiceClientsTechnical =
      false; //saber si estoy mostrando los servicios de algun cliente en el tecnico ne el desplegable
  int filterShowTimer = 0; //si esta en false es que es la primera vez
  int statusClientTemporary = -99;
  String nameClientTemporary = 'Cliente';

  //Fin Variables del reloj

  //VARIABLES PARA EL CONTROL DE INCUMPLIMINETOS (convivencia)
  //ESTA VARIABLE HAY QUE LLENARLA DIRECTAMENTE DE LA DB
  Map<String, int> noncomplianceProfessional = {
    /* //el tiempo para escoger los clientes inicial (3min)
    'Tiempo': 3,
    'teamQuota': 3, //Cuidado de equipo
    'punctuality': 3, //Puntualidad
    'clearCommunication': 3, //Comunicacion clara
    'confidentiality': 3, //Confidencialidad
    'cleanlinessOrder': 3, //Limpieza y Orden
    'drugProhibition': 3, //Prohibición de Drogas y Alcohol
    'respectTreatment': 3, //Respeto y Trato Cordial
    /******************AGREGAR AQUI TODS LOS QUE DESEN*********************/*/
  };

  bool verificateValueTimersTec() {
    bool hasClient1 = clientsAttendedTechnical != null;
    if (hasClient1) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> acceptClientTechnical(reservationId, attended) async {
    final LoginController controllerLogin = Get.find<LoginController>();
    final ClientsScheduledController controllerSche =
        Get.find<ClientsScheduledController>();
    quantityClientAttendedTechnical = 1;
    boolFilterShowNextTecnhical = false;
    update();
    bool value = await repository.acceptOrRejectClient(reservationId, attended);
    //si lo que devuelve es true actualizo la cola
    if (value == true) {
      quantityClientAttendedTechnical = 1;
      int? idBranch = controllerLogin.branchIdLoggedIn;
      await fetchClientsTechnical(idBranch);
      //obtener de Db el clock dado reservationId
      int clock = await controllerSche.getValueClockDb(reservationId);
      controllerSche.pauseResumeClock((clock - 1), 1);
    }
  }

  Future<void> returnClientStatus(int reservationId) async {
    try {
      int result = await repository.returnClientStatus(reservationId);
      statusClientTemporary = result;
      update();
    } catch (e) {
      print(e);
    }
  }

  void returnClientName(String name) async {
    try {
      nameClientTemporary = name;
      update();
    } catch (e) {
      print(e);
    }
  }

  Future<void> searchForCustomerServices(idCar) async {
    serviceCustomerSelected = await repository.getCustomerServicesList(idCar);
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

  getselectCustomerTechnical(index, idCar) async {
    print('IdCar:$idCar');
    // await searchForCustomerServices(idCar);
    (selectclientsScheduledListTechnical
            .contains(clientsScheduledListTechnical[index]))
        ? selectclientsScheduledListTechnical
            .remove(clientsScheduledListTechnical[index])
        : selectclientsScheduledListTechnical
            .add(clientsScheduledListTechnical[index]);

    update();
  }

  showingServiceClient(bool value) {
    print(
        'No actualizar la cola, tengo desplegado los servicios ahora mandando:$value');
    showingServiceClients = value;
    update();
  }

  showingServiceClientTechnical(bool value) {
    print(
        'No actualizar la cola, tengo desplegado los servicios al  TECNICO-> ahora mandando:$value');
    showingServiceClientsTechnical = value;
    update();
  }

  cleanselectCustomerTechnical() {
    selectclientsScheduledListTechnical.clear();
    update();
  }

  Future<void> fetchClientsTechnical(idBranch) async {
    Map<String, dynamic> resultList =
        await repository.getClientsTechnicalList(idBranch);
    print('111ya entre a buscar inicialmente los clientes del tecnico');
    print(resultList);
    //verificando , si entra al if es problemas de coneccion
    if (resultList.containsKey('ConnectionIssues') &&
        resultList['ConnectionIssues'] == true) {
      correctConnection = false;
      print(
          'mandar alguna variable para la vista deciendo que hay problemas al conectarse con el servidor');
    } else {
      correctConnection = true;
      //aqui estoy guardando la cola del dia de hoy del profesional
      clientsScheduledListTechnical =
          (resultList['clientList'] ?? []).cast<ClientsScheduledModel>();
      clientsTechnicalLength = clientsScheduledListTechnical.length;
      //aqui guardo al proximo de la cola para mostrarlo en el Home de la apk

      clientsNextTechnical = resultList['nextClient'];
      quantityClientAttendedTechnical = resultList['quantityClientAttended'];
      if (quantityClientAttendedTechnical == 0) {
        clientsAttendedTechnical = clientsNextTechnical;
        boolFilterShowNextTecnhical = true;
        technicalClientsAttended = 'nobody';
      } else {
        boolFilterShowNextTecnhical = false;
      }
    }
    update();
  }

  Future<void> selectCarClient(carId) async {
    final ShoppingCartController shoppingCartController =
        Get.find<ShoppingCartController>();
    shoppingCartController.carIdClienteSelect = carId;
    update();
  }

  int convertDateSecons(String tiempo) {
    List<String> partes = tiempo.split(":");
    int horas = int.parse(partes[0]);
    int minutos = int.parse(partes[1]);
    int segundos = int.parse(partes[2]);

    int tiempoEnSegundos = horas * 3600 + minutos * 60 + segundos;
    return tiempoEnSegundos;
  }

  Future<bool> changeNoncomplianceTecnhical(
      //todo1
      type,
      branchId,
      professionalId,
      estado) async {
    //AQUI LLAMAR AL REPOSITORIO PARA DAR INCUMPLIMIENTO
    bool result =
        await repository.storeByType(type, branchId, professionalId, estado);
    if (result) {
      print('CORRECTO actualizo el estado correctamente');
      //AQUI ES PÓRQUE INCUMPLIO CON ALGO
      if (estado == 1) {
        noncomplianceProfessional[type] = 1;
        update();
      } else {
        noncomplianceProfessional[type] = 0;
        update();
      }
    }
    return result;
  }
}
