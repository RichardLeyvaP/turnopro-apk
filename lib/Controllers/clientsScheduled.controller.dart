// ignore_for_file: depend_on_referenced_packages, unused_element, unrelated_type_equality_checks

import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Models/clientsScheduled_model.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/get_connect/repository/clientsScheduled.repository.dart';

class ClientsScheduledController extends GetxController {
  //DECLARACION DE VARIABLES
  ClientsScheduledRepository repository = ClientsScheduledRepository();

  List<ClientsScheduledModel> clientsScheduledList = []; // Lista de clientes
  List<ClientsScheduledModel> selectClientsScheduledList = [];
  ClientsScheduledModel? clientsScheduledNext; // Cliente en espera
  ClientsScheduledModel? clientsAttended1; // Cliente en espera
  ClientsScheduledModel? clientsAttended2; // Cliente en espera
  String clientsAttended = 'nobody';
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
  bool showingServiceClients =
      false; //saber si estoy mostrando los servicios de algun cliente ne el desplegable
  int filterShowTimer = 0; //si esta en false es que es la primera vez
  int statusClientTemporary = -99;
  String nameClientTemporary = 'Cliente';

  //Fin Variables del reloj

  //VARIABLES PARA EL CONTROL DE INCUMPLIMINETOS (convivencia)
  Map<String, bool> noncomplianceProfessional = {
    //el tiempo para escoger los clientes inicial (3min)
    'lateCustomerTimeInitial': false,
    'teamQuota': false, //Cuidado de equipo
    'punctuality': false, //Puntualidad
    /******************AGREGAR AQUI TODS LOS QUE DESEN*********************/
  };

  Future<void> newClientAttended(ClientsScheduledModel client, int cant) async {
    //este nuevo cliente se le va a signar un reloj
    if (cant == 1) {
      clientsAttended1 = client;
    }
    if (cant == 2) {
      clientsAttended2 = client;
    }
    await filterShowCardTimer();
    update();
  }

  Future<void> filterShowCardTimer() async {
    if (clientsAttended1 != null && clientsAttended2 == null) {
      //solo client1
      print('filterShowCardTimer client1');
      clientsAttended = 'client1';
    }
    if (clientsAttended2 != null && clientsAttended1 == null) {
      //solo client2
      print('filterShowCardTimer client2');
      clientsAttended = 'client2';
    }
    if (clientsAttended1 != null && clientsAttended2 != null) {
      //los 2 (client1 y client2)
      print('filterShowCardTimer allClient');
      clientsAttended = 'allClient';
    }
    if (clientsAttended1 == null && clientsAttended2 == null) {
      //ningun cliente client1
      print('filterShowCardTimer nobody');
      clientsAttended = 'nobody';
    }
    update();
  }

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

  showingServiceClient(bool value) {
    print(
        'No actualizar la cola, tengo desplegado los servicios ahora mandando:$value');
    showingServiceClients = value;
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
    if (quantityClientAttended == 0) {
      clientsAttended = 'nobody';
    }

    if (clientsScheduledNext != null) {
      int idCar = clientsScheduledNext!.car_id;
      await _searchForCustomerServices(idCar);
      await filterShowNext();
      setValueClock(true);
    } else {
      setValueClock(false);
    }

    update();
  }

  Future<void> selectCarClient(carId) async {
    final ShoppingCartController shoppingCartController =
        Get.find<ShoppingCartController>();
    shoppingCartController.carIdClienteSelect = carId;
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
      //verificar que reloj es el que hay que detener
      if (attended == 2) {
        //si es 2 es que ya termino de atender al cliente1
        if (clientsAttended1 != null) {
          if (reservationId == clientsAttended1!.reservation_id) {
            print('if (reservationId == clientsAttended1!.reservation_id) {');
            clientsAttended1 = null;
          }
        }
        if (clientsAttended2 != null) {
          //si es 2 es que ya termino de atender al cliente2
          if (reservationId == clientsAttended2!.reservation_id) {
            print('if (reservationId == clientsAttended2!.reservation_id) {');
            clientsAttended2 = null;
          }
        }
      }
      update();

      filterShowCardTimer();
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
