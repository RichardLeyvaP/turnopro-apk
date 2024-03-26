// ignore_for_file: depend_on_referenced_packages, unused_element, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Models/clientsScheduled_model.dart';
import 'package:turnopro_apk/Models/professional_model.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/get_connect/repository/clientsScheduled.repository.dart';
import 'package:turnopro_apk/get_connect/repository/user.repository.dart';

class ClientsScheduledController extends GetxController {
  //DECLARACION DE VARIABLES
  ClientsScheduledRepository repository = ClientsScheduledRepository();
  UserRepository repositoryUser = UserRepository();
  final LoginController controllerLogin = Get.find<LoginController>();

  List<ClientsScheduledModel> clientsScheduledList = []; // Lista de clientes
  // Lista de clientes
  List<ClientsScheduledModel> clientsScheduledListTechnical =
      []; // Lista de clientes
  List<ClientsScheduledModel> selectClientsScheduledList = [];
  List<ClientsScheduledModel> selectclientsScheduledListTechnical = [];
  ClientsScheduledModel? clientsScheduledNext; // Cliente en espera
  ClientsScheduledModel? clientsNextTechnical; // Cliente en espera
  ClientsScheduledModel? clientsAttended1; // Cliente en espera
  ClientsScheduledModel? clientsAttendedTechnical,
      clientsAttended2,
      clientsAttended3,
      clientsAttended4; // Cliente en espera
  int? timeClientsAttended1,
      timeClientsAttended2,
      timeClientsAttended3,
      timeClientsAttended4;
  //en estas variables de notificationClients es para no repetir las notificaciones de un mismo cliente
  int? notificationClients1,
      notificationClients2,
      notificationClients3,
      notificationClients4;

  int? timeClientsActAttended1,
      timeClientsActAttended2,
      timeClientsActAttended3,
      timeClientsActAttended4;
  List<int> item = [];
  List<int> itemDel = [];
  bool activeModifyTime = false;
  int modifyTimeSpecific = -99;
  List<int> modifyTime = [
    -1, //este es de _animationController1
    -1, //este es de _animationController2
    -1, //este es de _animationController3
    -1 //este es de _animationController4
  ]; //cuando alguno sea -1 modificar ese tiempo
  int availability = 1;
  int busyClock = -99;
  String clientsAttended = 'nobody';
  String technicalClientsAttended = 'nobody';
  List<ServiceModel> serviceCustomerSelected = [];
  List<ServiceModel> serviceCustomerSelectedForm = [];
  List<ProfessionalModel> professionalDispon = [];
  int professionalDisponLength = 0;

  int clientsScheduledListLength = 0;
  int clientsTechnicalLength = 0;
  int? carIdClientsScheduled;
  int quantityClientAttended = 0;
  int quantityClientAttendedTechnical = 0;
  bool isLoading = true;
  bool correctConnection = true;

  //Variables del reloj
  double sizeClock = 145;
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
  String urlImageTemporary = 'comments/default_profile.jpg';
  bool varClientsWaiting = false;
  int contClientsWaiting = 0;
  int endingTime =
      3; //Tiempo restante de un servicio en minutos,ahi se le manda una notificacion

  Map<int, int> pausResumeClock = {
    0: -99,
    1: -99,
    2: -99,
    3: -99,
  };
  bool clockchanges = false;
  bool closeIesperado = false;
  bool closeIesperadoLogin = false;
  String? imagePath;
  XFile? pickedFile;

  int cantClientWait = 0;

  void setcantClientWait(value) {
    cantClientWait = value;
    update();
  }

  void setImagePath(value) {
    imagePath = value;

    update();
  }

  void setNotificationClients1(int value, int idClient) {
    if (value == 1) {
      notificationClients1 = idClient;
    }
    if (value == 2) {
      notificationClients2 = idClient;
    }
    if (value == 3) {
      notificationClients3 = idClient;
    }
    if (value == 4) {
      notificationClients4 = idClient;
    }
    update();
  }

  void setContClientsWaiting(int value) {
    if (value == -90009) //-999 indica que es para igualar 0
    {
      contClientsWaiting = 0;
    } else if (value == -91119) {
      //esto es sumarle 1;
      contClientsWaiting += 1;
    } else {
      contClientsWaiting = value;
    }
    update();
  }

  void clientsWaiting(value) {
    varClientsWaiting = value;
    update();
  }

  Future<void> loadingValue(bool value) async {
    isLoading = value;
    update();
  }

  void setPickedFile(value) {
    pickedFile = value;
    update();
  }

  void setCloseIesperado(bool value) {
    closeIesperado = value;
    update();
  }

  void setCloseIesperadoLogin(bool value) {
    closeIesperadoLogin = value;
    update();
  }

  //Fin Variables del reloj

  //VARIABLES PARA EL CONTROL DE INCUMPLIMINETOS (convivencia)
  //ESTA VARIABLE HAY QUE LLENARLA DIRECTAMENTE DE LA DB
  Map<String, int> noncomplianceProfessional = {};

  //
  //
  //
  AnimationController? animationControllerInitial;

  AnimationController? animationController1;

  AnimationController? animationController2;

  AnimationController? animationController3;

  AnimationController? animationController4;

  bool verificateValueTimers() {
    bool hasClient1 = clientsAttended1 != null;
    bool hasClient2 = clientsAttended2 != null;
    bool hasClient3 = clientsAttended3 != null;
    bool hasClient4 = clientsAttended4 != null;
    if (hasClient1 || hasClient2 || hasClient3 || hasClient4) {
      return true;
    } else {
      return false;
    }
  }

  final clock1 = {'clock': 1, 'timeClock': 30};
  final clock2 = {'clock': 2, 'timeClock': 120};
  final clock3 = {'clock': 3, 'timeClock': 0};
  final clock4 = {'clock': 4, 'timeClock': 0};

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final newClock1 = {
      'clock': 23,
      'timeClock': 124,
    };
    prefs.setInt('clock1', newClock1['clock']!);
    prefs.setInt('timeClock1', newClock1['timeClock']!);
    final newClock2 = {
      'clock': 36,
      'timeClock': 567,
    };
    prefs.setInt('clock2', newClock2['clock']!);
    prefs.setInt('timeClock2', newClock2['timeClock']!);
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final clock1 = {
      'clock': prefs.getInt('clock1') ?? 0,
      'timeClock': prefs.getInt('timeClock1') ?? 0,
    };
    final clock2 = {
      'clock': prefs.getInt('clock2') ?? 0,
      'timeClock': prefs.getInt('timeClock2') ?? 0,
    };
    // Puedes utilizar los datos recuperados como desees.
    print('Reloj 1: $clock1');
    print('Reloj 2: $clock2');
  }

  upadateVariablesValueTimersSPlano() async {
//saveData();
    bool hasClient1 = clientsAttended1 != null;
    bool hasClient2 = clientsAttended2 != null;
    bool hasClient3 = clientsAttended3 != null;
    bool hasClient4 = clientsAttended4 != null;
    //
    if (hasClient1) {
      await setTimeClock(
          clientsAttended1!.reservation_id, timeClientsActAttended1, 1, 1);
    }
    if (hasClient2) {
      await setTimeClock(
          clientsAttended2!.reservation_id, timeClientsActAttended2, 1, 2);
    }
    if (hasClient3) {
      await setTimeClock(
          clientsAttended3!.reservation_id, timeClientsActAttended3, 1, 3);
    }
    if (hasClient4) {
      await setTimeClock(
          clientsAttended4!.reservation_id, timeClientsActAttended4, 1, 4);
    }
  }

  upadateVariablesValueTimers() async {
    print('entre de nuevo aqui -----');
    // saveData();
    bool hasClient1 = clientsAttended1 != null;
    bool hasClient2 = clientsAttended2 != null;
    bool hasClient3 = clientsAttended3 != null;
    bool hasClient4 = clientsAttended4 != null;
    //
    int remainingTime1,
        remainingTime2,
        remainingTime3,
        remainingTime4,
        reservationId,
        clock,
        detached;
    if (hasClient1) {
      double currentTimeDouble = animationController1!.value *
          animationController1!.duration!.inSeconds.toDouble();
      int totalTimeInSeconds = animationController1!.duration!.inSeconds;
      remainingTime1 = totalTimeInSeconds - currentTimeDouble.toInt();

      // Convertir a minutos
      int remainingMinutes1 = (remainingTime1 / 60).floor(); //MINUTOS RESTANTES
      //int remainingSeconds1 = remainingTime1 % 60; //SEGUNDOS RESTANTES
      timeClientsActAttended1 = remainingMinutes1; //DB - timeClock
      reservationId = clientsAttended1!.reservation_id; //DB - reservation_id
      clock = 1; //DB - clock
      detached = 1; //DB - detached
      //  await set_timeClock(reservation_id,timeClock,detached,clock);
      await setTimeClock(
          reservationId, timeClientsActAttended1, detached, clock);
      print(
          'EL TIEMPO ACTUAL DEL RELOJ 1 ES Tiempo restante: $timeClientsActAttended1 reservation_id : $reservationId -  clock : $clock - detached :$detached');
    }
    if (hasClient2) {
      double currentTimeDouble = animationController2!.value *
          animationController2!.duration!.inSeconds.toDouble();
      int totalTimeInSeconds = animationController2!.duration!.inSeconds;
      remainingTime2 = totalTimeInSeconds - currentTimeDouble.toInt();

      // Convertir a minutos
      int remainingMinutes2 = (remainingTime2 / 60).floor(); //MINUTOS RESTANTES
      //int remainingSeconds1 = remainingTime1 % 60; //SEGUNDOS RESTANTES
      timeClientsActAttended2 = remainingMinutes2; //DB - timeClock
      reservationId = clientsAttended2!.reservation_id; //DB - reservation_id
      clock = 2; //DB - clock
      detached = 1; //DB - detached
      //  await set_timeClock(reservation_id,timeClock,detached,clock);
      await setTimeClock(
          reservationId, timeClientsActAttended2, detached, clock);
      print(
          'EL TIEMPO ACTUAL DEL RELOJ 1 ES Tiempo restante: $timeClientsActAttended2 reservation_id : $reservationId -  clock : $clock - detached :$detached');
    }
    if (hasClient3) {
      double currentTimeDouble = animationController3!.value *
          animationController3!.duration!.inSeconds.toDouble();
      int totalTimeInSeconds = animationController3!.duration!.inSeconds;
      remainingTime3 = totalTimeInSeconds - currentTimeDouble.toInt();

      // Convertir a minutos
      int remainingMinutes3 = (remainingTime3 / 60).floor(); //MINUTOS RESTANTES
      //int remainingSeconds1 = remainingTime1 % 60; //SEGUNDOS RESTANTES
      timeClientsActAttended3 = remainingMinutes3; //DB - timeClock
      reservationId = clientsAttended3!.reservation_id; //DB - reservation_id
      clock = 3; //DB - clock
      detached = 1; //DB - detached
      //  await set_timeClock(reservation_id,timeClock,detached,clock);
      await setTimeClock(
          reservationId, timeClientsActAttended3, detached, clock);
      print(
          'EL TIEMPO ACTUAL DEL RELOJ 1 ES Tiempo restante: $timeClientsActAttended3 reservation_id : $reservationId -  clock : $clock - detached :$detached');
    }
    if (hasClient4) {
      double currentTimeDouble = animationController4!.value *
          animationController4!.duration!.inSeconds.toDouble();
      int totalTimeInSeconds = animationController4!.duration!.inSeconds;
      remainingTime4 = totalTimeInSeconds - currentTimeDouble.toInt();

      // Convertir a minutos
      int remainingMinutes4 = (remainingTime4 / 60).floor(); //MINUTOS RESTANTES
      //int remainingSeconds1 = remainingTime1 % 60; //SEGUNDOS RESTANTES
      timeClientsActAttended4 = remainingMinutes4; //DB - timeClock
      reservationId = clientsAttended4!.reservation_id; //DB - reservation_id
      clock = 4; //DB - clock
      detached = 1; //DB - detached
      //  await set_timeClock(reservation_id,timeClock,detached,clock);
      await setTimeClock(
          reservationId, timeClientsActAttended4, detached, clock);
      print(
          'EL TIEMPO ACTUAL DEL RELOJ 1 ES Tiempo restante: $timeClientsActAttended4 reservation_id : $reservationId -  clock : $clock - detached :$detached');
    } else {
      print('EL TIEMPO ACTUAL DEL RELOJ 1 ES Nulo:$timeClientsActAttended1 ');
    }

    // timeClientsActAttended2 = time2;
    // timeClientsActAttended3 = time3;
    // timeClientsActAttended4 = time4;
    update();
  }

  Future<void> newClientAttended(
      ClientsScheduledModel client, int avail) async {
    //este nuevo cliente se le va a signar un reloj
    if (avail == 1) {
      clientsAttended1 = client;
      timeClientsAttended1 = convertDateSecons(client.total_time);
      busyClock = 0;
    }
    if (avail == 2) {
      clientsAttended2 = client;
      timeClientsAttended2 = convertDateSecons(client.total_time);
      busyClock = 1;
    }
    if (avail == 3) {
      clientsAttended3 = client;
      timeClientsAttended3 = convertDateSecons(client.total_time);
      busyClock = 2;
    }
    if (avail == 4) {
      clientsAttended4 = client;
      timeClientsAttended4 = convertDateSecons(client.total_time);
      busyClock = 3;
    }
    filterShowCardTimer();
    update();
  }

  void filterShowCardTimer() {
    bool hasClient1 = clientsAttended1 != null;
    bool hasClient2 = clientsAttended2 != null;
    bool hasClient3 = clientsAttended3 != null;
    bool hasClient4 = clientsAttended4 != null;

    if (hasClient1 && !hasClient2 && !hasClient3 && !hasClient4) {
      print('client1');
      clientsAttended = 'client1';
      item.clear();
      item.add(0);
      availability = 2; //este esta disponible
      itemDel.clear();
      itemDel.addAll([1, 2, 3]);
    } else if (!hasClient1 && hasClient2 && !hasClient3 && !hasClient4) {
      clientsAttended = 'client2';
      print('client2');
      item.clear();
      item.add(1);
      availability = 1; //este esta disponible
      itemDel.clear();
      itemDel.addAll([0, 2, 3]);
    } else if (hasClient1 && hasClient2 && !hasClient3 && !hasClient4) {
      clientsAttended = 'client1 y client2';
      print('client1 y client2');
      item.clear();
      item.addAll([0, 1]);
      availability = 3; //este esta disponible
      itemDel.clear();
      itemDel.addAll([2, 3]);
    } else if (!hasClient1 && !hasClient2 && hasClient3 && !hasClient4) {
      clientsAttended = 'client3';
      print('client3');
      item.clear();
      item.add(2);
      availability = 1; //este esta disponible
      itemDel.clear();
      itemDel.addAll([0, 1, 3]);
    } else if (!hasClient1 && !hasClient2 && !hasClient3 && hasClient4) {
      clientsAttended = 'client4';
      print('client4');
      item.clear();
      item.add(3);
      availability = 1; //este esta disponible
      itemDel.clear();
      itemDel.addAll([0, 1, 2]);
    } else if (hasClient1 && !hasClient2 && hasClient3 && !hasClient4) {
      clientsAttended = 'client1 y client3';
      print('client1 y client3');
      item.clear();
      item.addAll([0, 2]);
      availability = 2; //este esta disponible
      itemDel.clear();
      itemDel.addAll([1, 3]);
    } else if (hasClient1 && !hasClient2 && !hasClient3 && hasClient4) {
      clientsAttended = 'client1 y client4';
      print('client1 y client4');
      item.clear();
      item.addAll([0, 3]);
      availability = 2; //este esta disponible
      itemDel.clear();
      itemDel.addAll([1, 2]);
    } else if (!hasClient1 && hasClient2 && hasClient3 && !hasClient4) {
      clientsAttended = 'client2 y client3';
      print('client2 y client3');
      item.clear();
      item.addAll([1, 2]);
      availability = 1; //este esta disponible
      itemDel.clear();
      itemDel.addAll([0, 3]);
    } else if (!hasClient1 && hasClient2 && !hasClient3 && hasClient4) {
      clientsAttended = 'client2 y client4';
      print('client2 y client4');
      item.clear();
      item.addAll([1, 3]);
      availability = 1; //este esta disponible
      itemDel.clear();
      itemDel.addAll([0, 2]);
    } else if (!hasClient1 && !hasClient2 && hasClient3 && hasClient4) {
      clientsAttended = 'client3 y client4';
      print('client3 y client4');
      item.clear();
      item.addAll([2, 3]);
      availability = 1; //este esta disponible
      itemDel.clear();
      itemDel.addAll([0, 1]);
    } else if (hasClient1 && hasClient2 && hasClient3 && !hasClient4) {
      clientsAttended = 'client1, client2 y client3';
      print('client1 y client2 y client3');
      item.clear();
      item.addAll([0, 1, 2]);
      availability = 4; //este esta disponible
      itemDel.clear();
      itemDel.add(3);
    } else if (hasClient1 && hasClient2 && !hasClient3 && hasClient4) {
      clientsAttended = 'client1, client2 y client4';
      print('client1 y client2 y client4');
      item.clear();
      item.addAll([0, 1, 3]);
      availability = 3; //este esta disponible
      itemDel.clear();
      itemDel.add(2);
    } else if (!hasClient1 && hasClient2 && hasClient3 && hasClient4) {
      clientsAttended = 'client2, client3 y client4';
      print('client2 y client3 y client4');
      item.clear();
      item.addAll([1, 2, 3]);
      availability = 1; //este esta disponible
      itemDel.clear();
      itemDel.add(0);
    } else if (hasClient1 && !hasClient2 && hasClient3 && hasClient4) {
      clientsAttended = 'client1, client3 y client4';
      print('client1 y client3 y client4');
      item.clear();
      item.addAll([0, 2, 3]);
      availability = 2; //este esta disponible
      itemDel.clear();
      itemDel.add(1);
    } else if (hasClient1 && hasClient2 && hasClient3 && hasClient4) {
      clientsAttended = 'todos los clientes';
      print('todos los clientes');
      item.clear();
      item.addAll([0, 1, 2, 3]);
      availability = -99; //NO tiene disponible
      itemDel.clear();
    } else if (!hasClient1 && !hasClient2 && !hasClient3 && !hasClient4) {
      clientsAttended = 'nobody';
      print('nobody');

      item.clear();
      availability = 1; //este esta disponible
      itemDel.addAll([0, 1, 2, 3]);
    }

    update();
  }

  Future<void> watchModifyTime(reservationId) async {
    if (clientsAttended1 != null) {
      if (reservationId == clientsAttended1!.reservation_id) {
        print('modificar time de 1');
        modifyTimeSpecific = 0;
        modifyTime.addAll([-1]);
      }
    }
    if (clientsAttended2 != null) {
      //si es 2 es que ya termino de atender al cliente2
      if (reservationId == clientsAttended2!.reservation_id) {
        print('modificar time de 2');
        modifyTimeSpecific = 1;
        modifyTime.addAll([-1]);
      }
    }
    if (clientsAttended3 != null) {
      //si es 2 es que ya termino de atender al cliente3
      if (reservationId == clientsAttended3!.reservation_id) {
        print('modificar time de 3');
        modifyTimeSpecific = 2;
        modifyTime.addAll([-1]);
      }
    }
    if (clientsAttended4 != null) {
      //si es 2 es que ya termino de atender al cliente4
      if (reservationId == clientsAttended4!.reservation_id) {
        print('modificar time de 4');
        modifyTimeSpecific = 3;
        modifyTime.addAll([-1]);
      }
    }
    update();
  }

  void modifingTime(time) {
    print(
        '-*-*-*-------------------inicio-------------------------${modifyTime[modifyTimeSpecific]}');
    modifyTime[modifyTimeSpecific] = time;
    print(
        '-*-*-*-------------------deSPUES------------------------${modifyTime[modifyTimeSpecific]}');
    print(
        'clientes asistiendo -*-*-*-------------------deSPUES---------------${modifyTime[modifyTimeSpecific]}');

    //al darle true le estoy diciendo que verifique que en algun timer hay cambio de tiempo
    activeModifyTime = true;
    print(
        'aqui toma valor -void modifingTime(time)- activeModifyTime:$activeModifyTime');
    update();
  }

  bool modifingTimeClose() {
    modifyTime.addAll([-1]);
    activeModifyTime = false;
    update();
    return true;
  }

  void setActiveModifyTime(bool value) {
    activeModifyTime = value;
    print(
        'aqui toma valor -void setActiveModifyTime(bool value)- activeModifyTime:$activeModifyTime');
    update();
  }

  Future getProfessionalState(idBranch) async {
    //todo nuevo
    professionalDispon = await repository.getProfessionalState(idBranch);
    professionalDisponLength = professionalDispon.length;
    update();
  }

  Future<void> acceptClientTechnical(reservationId, attended) async {
    // final LoginController controllerLogin = Get.find<LoginController>();
    quantityClientAttendedTechnical = 1;
    boolFilterShowNextTecnhical = false;
    update();
    bool value = await repository.acceptOrRejectClient(reservationId, attended);
    //si lo que devuelve es true actualizo la cola
    if (value == true) {
      quantityClientAttendedTechnical = 1;
      int? idBranch = controllerLogin.branchIdLoggedIn;
      fetchClientsTechnical(idBranch);
    }
  }

  Future<void> deleteReservationClient(reservationId, cause) async {
    try {
      bool value =
          await repository.deleteReservationClient(reservationId, cause);
      //si lo que devuelve es true actualizo la cola
      if (value == true) {
        print(
            'Cliente eliminado correctamente de la cola deleteReservationClient value = :$value');
      } else {
        print(
            'Cliente NO fue eliminado de la cola deleteReservationClient value = :$value');
      }
    } catch (e) {
      print('deleteReservationClient value e:$e');
    }
  }

  Future<void> storeByReservationId(
      imag, reservationId, commentText, dioClient) async {
    bool value = await repository.storeByReservationId(
        imag, reservationId, commentText, dioClient);
    print('si es - $value - ha o no enviado el comentario');
  }

  void clockChanges(bool value) {
    clockchanges = value;
    update();
  }

  void pauseResumeClock(int clock, int value) {
    //si clock es 0 es que va hacer algo en el reloj 1
    // value = 0 es pausar y value = 1 es reaunudar
    pausResumeClock[clock] = value;
    clockchanges = true;
    update();
  }

  Future<void> acceptOrRejectClient(reservationId, attended) async {
    // final LoginController controllerLogin = Get.find<LoginController>();

    bool value = await repository.acceptOrRejectClient(reservationId, attended);
    //si lo que devuelve es true actualizo la cola
    if (value == true) {
      int? idBranch = controllerLogin.branchIdLoggedIn;
      int? idProfessional = controllerLogin.idProfessionalLoggedIn;
      //aqui actualizo la cola
      await fetchClientsScheduled(idProfessional, idBranch);
      //verificar que reloj es el que hay que QUITAR
      if (attended == 2) {
        //si es 2 es que ya termino de atender al cliente1
        if (clientsAttended1 != null) {
          if (reservationId == clientsAttended1!.reservation_id) {
            //SACO DE MI LISTA A clientsAttended1
            clientsAttended1 = null;

            //AQUI ELIMINO DE LA LISTA AL CLIENTE clientsAttended1
            if (item.contains(0)) {
              item.remove(0);
            }
            pausResumeClock[0] = -99;
            //await sentValueClockDb(reservationId, 0);
            await setTimeClock(reservationId, 0, 0, 0);
          }
        }
        if (clientsAttended2 != null) {
          //si es 2 es que ya termino de atender al cliente2
          if (reservationId == clientsAttended2!.reservation_id) {
            //SACO DE MI LISTA A clientsAttended2
            clientsAttended2 = null;
            pauseResumeClock(1, 0);
            //AQUI ELIMINO DE LA LISTA AL CLIENTE clientsAttended2
            if (item.contains(1)) {
              item.remove(1);
            }
            pausResumeClock[1] = -99;
            // await sentValueClockDb(reservationId, 0);
            await setTimeClock(reservationId, 0, 0, 0);
          }
        }
        if (clientsAttended3 != null) {
          //si es 2 es que ya termino de atender al cliente3
          if (reservationId == clientsAttended3!.reservation_id) {
            //SACO DE MI LISTA A clientsAttended3
            clientsAttended3 = null;
            pauseResumeClock(2, 0);
            //AQUI ELIMINO DE LA LISTA AL CLIENTE clientsAttended3
            if (item.contains(2)) {
              item.remove(2);
            }
            pausResumeClock[2] = -99;
            // await sentValueClockDb(reservationId, 0);
            await setTimeClock(reservationId, 0, 0, 0);
          }
        }
        if (clientsAttended4 != null) {
          //si es 2 es que ya termino de atender al cliente4
          if (reservationId == clientsAttended4!.reservation_id) {
            //SACO DE MI LISTA A clientsAttended4
            clientsAttended4 = null;
            pauseResumeClock(3, 0);
            //AQUI ELIMINO DE LA LISTA AL CLIENTE clientsAttended4
            if (item.contains(3)) {
              item.remove(3);
            }
            pausResumeClock[3] = -99;
            //await sentValueClockDb(reservationId, 0);
            await setTimeClock(reservationId, 0, 0, 0);
          }
        }
      }
      //SI ES ATEENDED = 4 ES PORQUE VA A MANDARLO AL TECNICO
      //AQUI MANDAR A LLAMAR A LA FUNCION set_clock(TIMER), DEPENDIENDO DEL TIMER QUE SEA
      //ESTO LO MODIFICA EN LA BD PARA QUE EL TECNICO TENGA ACCESO A EL
      if (attended == 4) {
        //ES PORQUE ES EL RELOJ 1
        if (clientsAttended1 != null &&
            reservationId == clientsAttended1!.reservation_id) {
          //Pausar reloj 1
          pauseResumeClock(0, 0);
          bool clock = await sentValueClockDb(reservationId, 1);
          print('EL RELOJ MANDO COMO RESPUESTA : $clock');
          print('..............1');
        }
        //ES PORQUE ES EL RELOJ 2
        if (clientsAttended2 != null &&
            reservationId == clientsAttended2!.reservation_id) {
          //Pausar reloj 2
          pauseResumeClock(1, 0);
          print('..............2');
          bool clock = await sentValueClockDb(reservationId, 2);
          print('EL RELOJ MANDO COMO RESPUESTA : $clock');
        }
        //ES PORQUE ES EL RELOJ 3
        if (clientsAttended3 != null &&
            reservationId == clientsAttended3!.reservation_id) {
          //Pausar reloj 3
          pauseResumeClock(2, 0);
          print('..............3');
          bool clock = await sentValueClockDb(reservationId, 3);
          print('EL RELOJ MANDO COMO RESPUESTA : $clock');
        }
        //ES PORQUE ES EL RELOJ 4
        if (clientsAttended4 != null &&
            reservationId == clientsAttended4!.reservation_id) {
          //Pausar reloj 4
          pauseResumeClock(3, 0);
          print('..............4');
          bool clock = await sentValueClockDb(reservationId, 4);
          print('EL RELOJ MANDO COMO RESPUESTA : $clock');
        }
      }
      update();
      //AQUI INSERTO EN LA DB SI HUBIERAS RELOJES ACTIVOS
      await upadateVariablesValueTimers();
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

  Future<void> filterShowNext() async {
    try {
      // final LoginController controllerLogin = Get.find<LoginController>();
      int? idBranch = controllerLogin.branchIdLoggedIn;
      int? idProfessional = controllerLogin.idProfessionalLoggedIn;
      print('mostrando idProfessiona:$idProfessional y IdBranch:$idBranch');

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

  Future<void> setTimeClock(reservationId, timeClock, detached, clock) async {
    try {
      bool result = await repository.setTimeClock(
          reservationId, timeClock, detached, clock);
      if (result) {
        print(
            'EL TIEMPO ACTUAL DEL RELOJ ************** true $reservationId - $timeClock - $detached - $clock');
      } else {
        print('EL TIEMPO ACTUAL DEL RELOJ ************** false');
      }
    } catch (e) {
      print('EL TIEMPO ACTUAL DEL RELOJ set_timeClock:$e');
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

  void returnImageName(String url) async {
    try {
      urlImageTemporary = url;
      print('cambiando image:$url');
      update();
    } catch (e) {
      print(e);
    }
  }

  Future<void> searchForCustomerServices(idCar) async {
    serviceCustomerSelected = await repository.getCustomerServicesList(idCar);
    print('showingServiceClients:$showingServiceClients');
    if (showingServiceClients == false) {
      serviceCustomerSelectedForm = serviceCustomerSelected;
    }
    update();
  }

  Future<bool> changeNoncomplianceP(
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

  getselectCustomer(index, idCar) async {
    print('IdCar:$idCar');
    // await searchForCustomerServices(idCar);
    (selectClientsScheduledList.contains(clientsScheduledList[index]))
        ? selectClientsScheduledList.remove(clientsScheduledList[index])
        : selectClientsScheduledList.add(clientsScheduledList[index]);

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

  cleanselectCustomer() {
    selectClientsScheduledList.clear();
    update();
  }

  cleanselectCustomerTechnical() {
    selectclientsScheduledListTechnical.clear();
    update();
  }

  Future<void> fetchClientsScheduled(idProfessional, idBranch) async {
    try {
      print('con contador en 8 llamo la funcion2');
      Map<String, dynamic> resultList =
          await repository.getClientsScheduledList(idProfessional, idBranch);
      print(resultList);
      //verificando , si entra al if es problemas de coneccion
      if (resultList.containsKey('ConnectionIssues') &&
          resultList['ConnectionIssues'] == true) {
        correctConnection = false;
        print(
            'qwerc NOO mandar alguna variable para la vista deciendo que hay problemas al conectarse con el servidor->${clientsScheduledList.length}');
      } else {
        print('con contador en 8 llamo la funcion3');
        correctConnection = true;
        //aqui estoy guardando la cola del dia de hoy del profesional
        clientsScheduledList =
            (resultList['clientList'] ?? []).cast<ClientsScheduledModel>();
        clientsScheduledListLength = clientsScheduledList.length;
        print(
            'qwerc SII mandar alguna variable para la vista deciendo que hay problemas al conectarse con el servidor->${clientsScheduledList.length}');

        //
        //
        //  if (closeIesperado == true) //es que cerró inesperadamente
        {
          if (resultList.containsKey('attendingClient')) {
            List<Map>? attendingClientList = resultList['attendingClient'];
            //aqui es donde tiene que entrar solamente si se loguea
            if (controllerLogin.isLoggingIn == true) {
              print(
                  'EL TIEMPO clientes asistiendo -- if (controllerLogin.isLoggingIn == ${controllerLogin.isLoggingIn}) { entre poque vine del login ');

              logicaInesperada(attendingClientList);
              controllerLogin.setIsLoggingIn(false);
            } else {
              print(
                  'clientes asistiendo -- if (controllerLogin.isLoggingIn == ${controllerLogin.isLoggingIn})  NOOO ');
            }
          } else {
            // La clave 'attendingClient' no está presente en el mapa
            print(
                '!!!!!!!!!!!!!!!!!!!!La clave "attendingClient" no está presente en el mapa.');
          }
        }

        //aqui guardo al proximo de la cola para mostrarlo en el Home de la apk
        clientsScheduledNext = resultList['nextClient'];
        quantityClientAttended = resultList['quantityClientAttended'];
        varClientsWaiting = resultList['varclientswaiting'];
        if (quantityClientAttended == 0) {
          clientsAttended = 'nobody';
        }

        if (clientsScheduledNext != null) {
          int idCar = clientsScheduledNext!.car_id;
          await searchForCustomerServices(idCar);
          await filterShowNext();
          //  setValueClock(true);
        } else {
          print('if (clientsScheduledNext != null) ESTOY DANDO null');
          //  setValueClock(false);
        }
      }
      update();
    } catch (e) {
      print(
          'Dio error en Future<void> fetchClientsScheduled que se encuentra en el controlador del Login:$e');
    }
  }

  Future<void> logicaInesperada(List<Map>? attendingClientList) async {
    try {
      if (attendingClientList != null && attendingClientList.isNotEmpty) {
        // La lista no es nula y tiene elementos
        // Hacer algo con la lista...
        // print(
        //   'clientes asistiendo!!!!!!!!!!!!!!!!!!!!La lista de clientes asistiendo no está vacía.');
        //print('clientes asistiendo : ${attendingClientList.length}');
        // Obtener la hora actual
        DateTime horaActual = DateTime.now();
        DateTime hora1 = DateTime.parse('2024-02-27 19:34:45');
        int diferenciaSegundos = 0;
        // print('clientes asistiendo horaActual :$horaActual');
        // print('clientes asistiendo hora1 :$hora1');
        // Usando un bucle for-in
        for (var map in attendingClientList) {
          int? id;
          String? updated; // Definir la hora1
          int? clock;
          int? timeClock;
          ClientsScheduledModel? client;

          map.forEach((key, value) {
            // print('clientes asistiendo key :$key');
            // print('clientes asistiendo value :$value');
            // Asignar valores a las variables según la clave
            switch (key) {
              case "reservation_id":
                id = value;
                break;
              case "clock":
                clock = value;
                break;
              case "timeClock":
                timeClock = value;
                break;
              case "client":
                client = value;
                break;
              case "updated_at":
                hora1 = DateTime.parse(value);
                // updated = value;
                break;
              default:
                // Manejar otras claves si es necesario
                break;
            }
          });

          /*   if (hora1 != null) {
            hora1 = DateTime.parse(updated!);
            diferenciaSegundos = horaActual.difference(hora1).inSeconds;
          } else {
            diferenciaSegundos = 0;
          }*/
          // Calcular la diferencia en segundos entre hora1 y la hora actual
          int diferenciaSegundos = horaActual.difference(hora1).inSeconds;

          print('clientes asistiendo clock:$clock');
          print('clientes asistiendo hora1:$hora1');
          print('clientes asistiendo horaActual:$horaActual');
          print(
              'clientes asistiendo hora diferenciaSegundos:$diferenciaSegundos');
          print('clientes asistiendo hora timeClock:$timeClock');
          print(
              'clientes asistiendo hora timeClock:${(timeClock! - diferenciaSegundos)}');
          // Lógica adicional si es necesario con las variables asignadas
          if (clock == 1) {
            print('clientes asistiendo entre a :$clock');
            // Asignar a variables específicas para clock 1
            clientsAttended1 = client;
            timeClientsAttended1 = (timeClock! - diferenciaSegundos) <= 0
                ? 0
                : (timeClock! - diferenciaSegundos); //tiempo en segundos
            //AQUI LLAMAR A LA FUNCION SET_TIMECLOCK Y MODIFICAR TODAS LAS VARIABLES
            //  await set_timeClock(reservation_id,timeClock,detached,clock);
            // await setTimeClock(client!.reservation_id, 0, 0, 1);//todo comente a ver si ya lo hace bien
            // ... otras asignaciones para clock 1
            //  setTimeClock(client!.reservation_id, timeClientsAttended1, 1, 1);
            print(
                'clientes asistiendo hora timeClock***********timeClock*****:$timeClock');
            print(
                'clientes asistiendo hora timeClock*********diferenciaSegundos*******:$diferenciaSegundos');
            print(
                'clientes asistiendo hora timeClock*********timeClientsAttended1*******:$timeClientsAttended1');
          } else if (clock == 2) {
            print('clientes asistiendo entre a :$clock');
            // Asignar a variables específicas para clock 2
            clientsAttended2 = client;
            timeClientsAttended2 = (timeClock! - diferenciaSegundos) <= 0
                ? 0
                : (timeClock! - diferenciaSegundos); //tiempo en segundos
            //AQUI LLAMAR A LA FUNCION SET_TIMECLOCK Y MODIFICAR TODAS LAS VARIABLES
            //  await set_timeClock(reservation_id,timeClock,detached,clock);
            // await setTimeClock(client!.reservation_id, 0, 0, 2);//todo comente a ver si ya lo hace bien
            // ... otras asignaciones para clock 2
            //  setTimeClock(client!.reservation_id, timeClientsAttended2, 1, 2);
            print(
                'clientes asistiendo hora timeClock*******************:$timeClientsAttended2');
          } else if (clock == 3) {
            print('clientes asistiendo entre a :$clock');
            // Asignar a variables específicas para clock 3
            clientsAttended3 = client;
            timeClientsAttended3 = (timeClock! - diferenciaSegundos) <= 0
                ? 0
                : (timeClock! - diferenciaSegundos); //tiempo en segundos
            //AQUI LLAMAR A LA FUNCION SET_TIMECLOCK Y MODIFICAR TODAS LAS VARIABLES
            //  await set_timeClock(reservation_id,timeClock,detached,clock);
            // await setTimeClock(client!.reservation_id, 0, 0, 3);//todo comente a ver si ya lo hace bien

            // ... otras asignaciones para clock 3
            // setTimeClock(client!.reservation_id, timeClientsAttended3, 1, 3);
            print(
                'clientes asistiendo hora timeClock****************:$timeClientsAttended3');
          } else if (clock == 4) {
            print('clientes asistiendo entre a :$clock');
            // Asignar a variables específicas para clock 3
            clientsAttended4 = client;
            timeClientsAttended4 = (timeClock! - diferenciaSegundos) <= 0
                ? 0
                : (timeClock! - diferenciaSegundos); //tiempo en segundos
            //AQUI LLAMAR A LA FUNCION SET_TIMECLOCK Y MODIFICAR TODAS LAS VARIABLES
            //  await set_timeClock(reservation_id,timeClock,detached,clock);
            // await setTimeClock(client!.reservation_id, 0, 0, 4);//todo comente a ver si ya lo hace bien

            // ... otras asignaciones para clock 3
            //  setTimeClock(client!.reservation_id, timeClientsAttended4, 1, 4);
            print(
                'clientes asistiendo hora timeClock*****************:$timeClientsAttended4');
          }
          // Puedes agregar más condiciones según sea necesario para otros valores de clock
        } //cierre for (var map in attendingClientList)
        //VERIFICO QUE RELOJ ESTA OCUPADO Y VEO SI HAY DISPONIBILIDAD
        filterShowCardTimer();
        update();
        //
      } else {
        // La lista es nula o está vacía
        print(
            '!!!!!!!!!!!!!!!!!!!!La lista de clientes asistiendo es nula o está vacía.');
      }
    } catch (e) {
      print('ERROR en Future<void> logicaInesperada:$e');
    }
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

  /* setValueClock(bool value) {
    if (value == true) {
      sizeClock = 145;
    } else {
      sizeClock = 160;
    }
  }*/

//en este le doy el tamaño al reloj dependiendo del tamaño del telefono
  setValueClockDinamic(double value) {
    sizeClock = value;
    update();
  }

  double calcularH(double heightNew) {
    double h2 = heightNew * 0.155;
    print('ESTE ES EL VALOR NUEVO DEL CLOCK heightAntComponet:$heightNew');
    print('ESTE ES EL VALOR NUEVO DEL CLOCK h2:$h2');
    return h2.roundToDouble();
  }

  int convertDateSecons(String tiempo) {
    List<String> partes = tiempo.split(":");
    int horas = int.parse(partes[0]);
    int minutos = int.parse(partes[1]);
    int segundos = int.parse(partes[2]);

    int tiempoEnSegundos = horas * 3600 + minutos * 60 + segundos;
    return tiempoEnSegundos;
  }

//
//
//
//
//
//
//
//
//
  Future<bool> sentValueClockDb(int id, int clock) async {
    //si return = false es que no se inserto en la Db
    return await repository.sentValueClockDb(id, clock);
  }

//
//
//
//
//
  Future<int> getValueClockDb(int id) async {
    try {
      return await repository.getValueClockDb(id);
    } catch (e) {
      print(e);
      return -99;
    }
    //si return = false es que no se inserto en la Db
  }
}
