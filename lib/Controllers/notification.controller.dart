// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:soundpool/soundpool.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Models/clientsScheduled_model.dart';
import 'package:turnopro_apk/Models/notification_model.dart';
import 'package:turnopro_apk/get_connect/repository/notification.repository.dart';
import 'package:turnopro_apk/services/localNotification.dart';

import 'login.controller.dart';

class NotificationController extends GetxController {
  //LLAMANDO AL CONTROLADOR
  NotificationController() {
    // initializeNotifications();
  }
//DECLARACION DE VARIABLES
  NotificationRepository repository = NotificationRepository();
  final LoginController controllerLogin = Get.find<LoginController>();
  final ClientsScheduledController controllerclient =
      Get.find<ClientsScheduledController>();
  int notificationListLength = 0;
  int notificationListLengthEncarg = 0;
  int notificationListNewLength = 0;
  int notificationListNewLengthEncarg = 0;
  int notificationListBack = 0;
  int notificationListBackEncarg = 0;
  List<NotificationModel> notification = []; // Lista de Notificaciones
  List<NotificationModel> notificationEncarg = []; // Lista de Notificaciones
  List<NotificationModel> notificationListNew = []; // Lista de Notificaciones
  List<int> notificationListNewSounded = []; // Lista de Notificaciones
  List<NotificationModel> notificationListNewEncarg =
      []; // Lista de Notificaciones
  List<NotificationModel> selectNotification = [];
  bool isLoading = true;
  List<String> created_atTime = [];
  int outAcept = 0;

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 2), () {
      isLoading = false;
      update();
    });
  }

  getList() {
    return notification;
  }

  void updateOutAcept(int value) {
    outAcept = value;
    update();
  }

  Future<bool> storeNotification2(
      //todo1
      tittle,
      branchId,
      professionalId,
      description,
      type) async {
    //AQUI LLAMAR AL REPOSITORIO PARA DAR INCUMPLIMIENTO
    bool result = await repository.storeNotification2(
        tittle, branchId, professionalId, description, type);
    if (result) {
      print('CORRECTO inserto una nueva notificacion ');
    }
    return result;
  }

  Future<bool> storeNotification(
      //todo1
      tittle,
      branchId,
      professionalId,
      description,
      type) async {
    //AQUI LLAMAR AL REPOSITORIO PARA DAR INCUMPLIMIENTO
    bool result = await repository.storeNotification(
        tittle, branchId, professionalId, description, type);
    if (result) {
      print('CORRECTO inserto una nueva notificacion ');
    }
    return result;
  }

  /* Future<void> reproducirSound() async {
    Soundpool pool = Soundpool(streamType: StreamType.notification);
    print('reproduciendo el sonido-1');
    int soundId = await rootBundle
        .load("assets/sound/livechat-129007.mp3")
        .then((ByteData soundData) {
      print('reproduciendo el sonido-3');
      return pool.load(soundData);
    });
    int streamId = await pool.play(soundId);
    print('reproduciendo el sonido-2');
  }*/

  updateNotificationListBack(int value) {
    notificationListBack = value;
    update();
  }

  updateNotificationListBackEncarg(int value) {
    notificationListBackEncarg = value;
    update();
  }

  getSelectNotification(index) {
    (selectNotification.contains(notification[index]))
        ? selectNotification.remove(notification[index])
        : selectNotification.add(notification[index]);
    update();
  }

  //todo/****AQUI LO DE LAS NOTIFICACIONES LOCALES****/
/*  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void scheduleNotification(String title, String descripcion) async {
    final Uuid uuid = Uuid(); // Crea una instancia de Uuid
    final String channelId = uuid.v4(); // Genera un channelId único
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channelId, // ID del canal
      'Nombre del Canal', // Nombre del Canal
      channelDescription:
          'Descripción del Canal', // Descripción del Canal (argumento nombrado)
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      sound: RawResourceAndroidNotificationSound('livechat129007'),
      // ^ Utiliza el nombre del archivo de sonido sin la extensión
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      descripcion,
      platformChannelSpecifics,
    );
  }*/
  //todo/****AQUI LO DE LAS NOTIFICACIONES LOCALES****/

  Future<void> professionalBranchNotifQueque(
      idBranch, idProfe, type, msj) async {
    print('entrando aqui para mandar notificacion al-234');
    bool noUpdate = false;
    final ClientsScheduledController clientCon =
        Get.find<ClientsScheduledController>();
    List<ClientsScheduledModel> clientsAux = [];
    print('qwerc SII mandar ->NOTIFICACIONES-$msj');
    print('12345llamada timer estoy en CAntidad de Notificaciones-$type');
    print(
        'llamada timer ...tipo:$type......idSucursal:$idBranch......iProf:$idProfe');
    try {
      Map<String, dynamic> resultList = await repository
          .professionalBranchNotifQueque(idBranch, idProfe, type);
      bool siHayEliminarService = false;

      if (resultList.containsKey('Erroor') && resultList['Erroor'] == true) {
        print(
            'mandar alguna variable para la vista deciendo que hay problemas al conectarse con el servidor, el error fue en Future<void> fetchNotificationList');
      } else if (resultList.containsKey('notificationList') &&
          resultList.containsKey('notificationListNew')) {
        notification =
            resultList['notificationList']; //busca aqui las notificaciones

        notificationListLength = notification.length;

        notificationListNew = resultList['notificationListNew'];
        notificationListNewLength = notificationListNew.length;
        List<NotificationModel> notificationListNewAux1 = [];
        notificationListNew.forEach((element) async {
          if (element.state == 0 || element.state == 3) {
            if (!notificationListNewSounded.contains(element.id)) {
              notificationListNewSounded.add(element.id);
              // localNotificationsSimplifies(element.tittle, element.description);

              notificationListNewAux1.add(element);
            }
          }

          //SI HAY QUE ELIMINAR TIEMPO DEL RELOJ
          if (element.state == 3 &&
              element.tittle == 'Aceptada Eliminación de Servicio') {
            print('modificar time de mm 1 estoy aqui en el forEach');
            String textoCompleto = element.description;
            // String descripcion =
            //     textoCompleto.split('.')[0]; // Obtener la descripción
            // Obtener el segundo número (999)
            String numeroOcultoString = textoCompleto
                .split('.')[1]
                .trim(); // Obtener la parte después del punto y eliminar espacios en blanco
            int idReservation =
                int.parse(numeroOcultoString); // Convertir a entero
            controllerclient.watchModifyTimeRest(idReservation,
                textoCompleto); //aqui le mando el tiempo tambien y los voy sumando si el id coincidiera
            updateNotifications2(idBranch, idProfe,
                element.id); //aqui es para no repetir esto y lo pongo en 0

            //NOTIFICAR UQ HAY CAMBIOS EN LOS RELOJES
            //DESCONTAR EL TIEMPO AL RELOJ
            //MANDAR AL METODO DE SABER CUANTOS MINUTOS HAY QUE DESCONTAR
            siHayEliminarService = true;
          }
          //esto es para saber que valor darle al qr si aceptan o rechazan la colación
          if (element.state == 3 &&
              element.tittle ==
                  'Aceptada su solicitud de Colación') //pongo a null el qr
          {
            updateNotifications2(idBranch, idProfe, element.id);
            controllerLogin.setCodigoQrValid(null);
          }
          if (element.state == 3 &&
              element.tittle ==
                  'Solicitud de Eliminación Rechazada') //pongo a null el qr
          {
            updateNotifications2(idBranch, idProfe, element.id);
            controllerLogin.setCodigoQrValid(1);
          }
          if (element.state == 3 &&
              element.tittle ==
                  'Aceptada Eliminación de Cliente') //pongo a null el qr
          {
            updateNotifications2(idBranch, idProfe, element.id);
            controllerLogin.setCodigoQrValid(1);
          }
          if (element.state == 3 &&
              element.tittle ==
                  'Rechazada su solicitud de Colación') //pongo a 1 el qr
          {
            updateNotifications2(idBranch, idProfe, element.id);
            controllerLogin.setCodigoQrValid(1);
          }
          if (element.state == 3 &&
              element.tittle ==
                  'Rechazada su solicitud de Salida') //pongo a 1 el qr
          {
            updateNotifications2(idBranch, idProfe, element.id);
            controllerLogin.setCodigoQrValid(1);
          }
          if (element.state == 3 &&
              element.tittle ==
                  'Aceptada su solicitud de Salida') //pongo a 1 el qr
          {
            print('cargando aqui-16 para sacar del puesto y la apk-1');

            updateOutAcept(element.id);
          }
        });

//aqui veo y voy mandando las notificaciones locales
        for (final result1 in notificationListNewAux1) {
          // Llama a la función localNotificationsSimplifies después del retraso
          localNotificationsSimplifies(result1.tittle, result1.description);
          print('aqui llamando las notificaciones nuevas1');
          print(
              'aqui llamando las notificaciones nuevas1:result1.tittle : ${result1.tittle}');
          await Future.delayed(const Duration(seconds: 2)); // Espera 2 segundos
        }

        if (siHayEliminarService ==
            true) //entro solo si entro al if de 'Aceptada Eliminación de Servicio'
        {
          controllerclient.setActiveModifyTimeRest(true);
        }
        print(
            'cargando aqui-16 para sacar del puesto y la apk-1Salir=$outAcept');
        if (outAcept !=
            0) //entro solo si entro al if de 'Aceptada Eliminación de Servicio'
        {
          Get.snackbar(
            'Mensaje',
            'Cerrando aplicación.',
            duration: const Duration(milliseconds: 2500),
            backgroundColor: const Color.fromARGB(118, 255, 255, 255),
            showProgressIndicator: true,
            progressIndicatorBackgroundColor:
                const Color.fromARGB(255, 203, 205, 209),
            progressIndicatorValueColor:
                const AlwaysStoppedAnimation(Color(0xFFFDAE2A)),
            overlayBlur: 3,
          );
          Get.dialog(
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFDAE2A),
              ),
            ),
            barrierDismissible: false,
          ); //Get.back();
          await updateNotifications2(idBranch, idProfe, outAcept);
          await controllerLogin.exitPostworking("Barbero");
          controllerLogin.exit(controllerLogin.tokenUserLoggedIn);
          updateOutAcept(0);
          Get.back();
          print('cargando aqui-16 para sacar del puesto y la apk-2');
        }
//fin de trabajo de notificaciones
//aqui empiza la asignacion de la cola

        clientCon.correctConnection = true;
        //aqui estoy guardando la cola del dia de hoy del profesional
        List<ClientsScheduledModel>? clientsScheduledListAUX = [];
        List<ClientsScheduledModel>? clientsScheduledListAUX2 = [];

        clientsScheduledListAUX = (resultList['clientList'] ?? []).cast<
            ClientsScheduledModel>(); //aqui estoy guardando la cola del dia de hoy del profesional
        clientsScheduledListAUX2 =
            (resultList['clientListSig'] ?? []).cast<ClientsScheduledModel>();
        if (clientsScheduledListAUX != null &&
            clientsScheduledListAUX2 != null) {
          clientCon.clientsScheduledList = clientsScheduledListAUX;

          clientCon.clientsScheduledListLength =
              clientCon.clientsScheduledList.length;
          print(
              'llamada timer Cantidad de Clientes-3 :${clientCon.clientsScheduledListLength}');
          clientsAux = clientsScheduledListAUX2;
          clientCon.clientsScheduledListLengthTail = clientsAux.length;
          print(
              'llamando a buscar clientes - BIEN4-clientsScheduledList.length:${clientCon.clientsScheduledList.length}');

          //
          //  if (closeIesperado == true) //es que cerró inesperadamente
          {
            if (resultList.containsKey('attendingClient')) {
              List<Map>? attendingClientList = resultList['attendingClient'];
              //aqui es donde tiene que entrar solamente si se loguea
              if (controllerLogin.isLoggingIn == true) {
                print(
                    'EL TIEMPO clientes asistiendo -- if (controllerLogin.isLoggingIn == ${controllerLogin.isLoggingIn}) { entre poque vine del login ');

                clientCon.logicaInesperada(attendingClientList);
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
          clientCon.clientsScheduledNext = resultList['nextClient'];
          int clientNewAux = 0;
//aqui verifico si entra un cliente nuevo
          //************************************* */
          if (clientCon.clientsScheduledListId.isNotEmpty) {
            clientNewAux = clientCon.clientsScheduledListId.length;
          }

          clientCon.clientsScheduledList.forEach((element) async {
            if (!clientCon.clientsScheduledListId
                .contains(element.reservation_id)) {
              clientCon.clientsScheduledListId.add(element.reservation_id!);
            }
          });

          if (clientNewAux != 0) {
            if (clientCon.clientsScheduledListId.length > clientNewAux) {
              clientCon.setclientNew(
                  clientCon.clientsScheduledListId.length - clientNewAux);
            }
          }

          if (clientCon.clientNew > 0) {
            String s = '';
            if (clientCon.clientNew > 1) {
              s = 's';
            }

            //mando notificacion al barbero
            storeNotification(
                'Nuevo cliente en cola',
                controllerLogin.branchIdLoggedIn,
                controllerLogin.idProfessionalLoggedIn,
                'Tienes ${clientCon.clientNew} cliente$s nuevo$s en cola',
                'Barbero');

            clientCon.setclientNew(0);
            //************************************* */
          }

          clientCon.quantityClientAttended =
              resultList['quantityClientAttended'];
          clientCon.varClientsWaiting = resultList['varclientswaiting'];
          if (clientCon.quantityClientAttended == 0) {
            clientCon.clientsAttended = 'nobody';
          }

          if (clientCon.clientsScheduledNext != null) {
            int idCar = clientCon.clientsScheduledNext!.car_id!;
            await clientCon.searchForCustomerServices(idCar);
            await clientCon.filterShowNext();
            //  setValueClock(true);
          } else {
            print('if (clientsScheduledNext != null) ESTOY DANDO null');
            //  setValueClock(false);
          }
        }
//aqui empiza la asignacion de la cola
      } else if (resultList.containsKey('notificationListEncarg') &&
          resultList.containsKey('notificationListNewEncarg')) {
        print('ENTRO A BUSCAR NOTIFICACIONES - cont: estoy en el controlador');
        notificationEncarg = resultList['notificationListEncarg'];

        notificationListLengthEncarg = notificationEncarg.length;

        notificationListNewEncarg = resultList['notificationListNewEncarg'];
        notificationListNewLengthEncarg = notificationListNewEncarg.length;
        print(
            'ENTRO A BUSCAR NOTIFICACIONES - cont: estoy en el controlador - notificationListNewLengthEncarg:${notificationEncarg.length}');

        notificationListNewEncarg.forEach((element) async {
          if (element.state == 3 &&
              element.tittle == 'Aceptada Eliminación de Servicio') {
            print('modificar time de mm 1 estoy aqui en el forEach');
            String textoCompleto = element.description;
            // String descripcion =
            //     textoCompleto.split('.')[0]; // Obtener la descripción
            // Obtener el segundo número (999)
            String numeroOcultoString = textoCompleto
                .split('.')[1]
                .trim(); // Obtener la parte después del punto y eliminar espacios en blanco
            int idReservation =
                int.parse(numeroOcultoString); // Convertir a entero
            controllerclient.watchModifyTimeRest(idReservation,
                textoCompleto); //aqui le mando el tiempo tambien y los voy sumando si el id coincidiera
            updateNotifications2(idBranch, idProfe,
                element.id); //aqui es para no repetir esto y lo pongo en 0

            //NOTIFICAR UQ HAY CAMBIOS EN LOS RELOJES
            //DESCONTAR EL TIEMPO AL RELOJ
            //MANDAR AL METODO DE SABER CUANTOS MINUTOS HAY QUE DESCONTAR
            siHayEliminarService = true;
          }
        });
        if (siHayEliminarService ==
            true) //entro solo si entro al if de 'Aceptada Eliminación de Servicio'
        {
          controllerclient.setActiveModifyTimeRest(true);
        }
      }
    } catch (e) {
      // Manejo de errores
      noUpdate = true;
      print('Error al obtener la lista de notificaciones:este: $e');
    } finally {
      print(
          'Obtener la lista de notificaciones: noUpdate == Timer10segun $noUpdate');
      if (noUpdate == false) {
        update();
      }
      controllerLogin.setIsLoadingFor(false);
    }
  }

  //
  //
  //
  //
//todo/****AQUI LO DE LAS NOTIFICACIONES LOCALES****/
//tecnicooooooo
  Future<void> fetchNotificationList(idBranch, idProfe, type, msj) async {
    print('qwerc SII mandar ->NOTIFICACIONES-$msj');
    print('12345llamada timer estoy en CAntidad de Notificaciones-$type');
    print(
        'llamada timer ...tipo:$type......idSucursal:$idBranch......iProf:$idProfe');
    try {
      Map<String, dynamic> result =
          await repository.getNotificationList(idBranch, idProfe, type);
      bool siHayEliminarService = false;

      if (result.containsKey('Erroor') && result['Erroor'] == true) {
        print(
            'mandar alguna variable para la vista deciendo que hay problemas al conectarse con el servidor, el error fue en Future<void> fetchNotificationList');
      } else if (result.containsKey('notificationList') &&
          result.containsKey('notificationListNew')) {
        notification = result['notificationList'];

        print(
            'llamada timer estoy en CAntidad de Notificaciones fetchNotificationList :${notification.length}');

        notificationListLength = notification.length;

        notificationListNew = result['notificationListNew'];
        notificationListNewLength = notificationListNew.length;
        List<NotificationModel> notificationListNewAux =
            []; // Lista de Notificaciones
        for (final element in notificationListNew) {
          if (element.state == 0 || element.state == 3) {
            if (!notificationListNewSounded.contains(element.id)) {
              notificationListNewSounded.add(element.id);

              notificationListNewAux.add(element);
              //localNotificationsSimplifies(element.tittle, element.description);
            }
          }

          //esto es para saber que valor darle al qr si aceptan o rechazan la colación
          if (element.state == 3 &&
              element.tittle ==
                  'Aceptada su solicitud de Colación') //pongo a null el qr
          {
            updateNotifications2(idBranch, idProfe, element.id);
            controllerLogin.setCodigoQrValid(null);
          }
          if (element.state == 3 &&
              element.tittle ==
                  'Rechazada su solicitud de Colación') //pongo a 1 el qr
          {
            updateNotifications2(idBranch, idProfe, element.id);
            controllerLogin.setCodigoQrValid(1);
          }
          if (element.state == 3 &&
              element.tittle ==
                  'Rechazada su solicitud de Salida') //pongo a 1 el qr
          {
            updateNotifications2(idBranch, idProfe, element.id);
            controllerLogin.setCodigoQrValid(1);
          }
          if (element.state == 3 &&
              element.tittle ==
                  'Aceptada su solicitud de Salida') //pongo a 1 el qr
          {
            print('cargando aqui-16 para sacar del puesto y la apk-1');

            updateOutAcept(element.id);
          }
          if (element.state == 3 &&
              element.tittle ==
                  'Solicitud de Eliminación Rechazada') //pongo a null el qr
          {
            updateNotifications2(idBranch, idProfe, element.id);
            controllerLogin.setCodigoQrValid(1);
          }
          if (element.state == 3 &&
              element.tittle ==
                  'Aceptada Eliminación de Cliente') //pongo a null el qr
          {
            updateNotifications2(idBranch, idProfe, element.id);
            controllerLogin.setCodigoQrValid(1);
          }
        }

//aqui veo y voy mandando las notificaciones locales
        for (final result in notificationListNewAux) {
          // Llama a la función localNotificationsSimplifies después del retraso
          localNotificationsSimplifies(result.tittle, result.description);
          print('aqui llamando las notificaciones nuevas');
          await Future.delayed(const Duration(seconds: 2)); // Espera 2 segundos
        }

        if (outAcept !=
            0) //entro solo si entro al if de 'Aceptada Eliminación de Servicio'
        {
          Get.snackbar(
            'Mensaje',
            'Cerrando aplicación.',
            duration: const Duration(milliseconds: 2500),
            backgroundColor: const Color.fromARGB(118, 255, 255, 255),
            showProgressIndicator: true,
            progressIndicatorBackgroundColor:
                const Color.fromARGB(255, 203, 205, 209),
            progressIndicatorValueColor:
                const AlwaysStoppedAnimation(Color(0xFFFDAE2A)),
            overlayBlur: 3,
          );
          Get.dialog(
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFDAE2A),
              ),
            ),
            barrierDismissible: false,
          ); //Get.back();
          await updateNotifications2(idBranch, idProfe, outAcept);
          await controllerLogin.exitPostworking("Tecnico");
          controllerLogin.exit(controllerLogin.tokenUserLoggedIn);
          updateOutAcept(0);
          Get.back();
          print('cargando aqui-16 para sacar del puesto y la apk-2');
        }

        update();
      } else if (result.containsKey('notificationListEncarg') &&
          result.containsKey('notificationListNewEncarg')) {
        print('ENTRO A BUSCAR NOTIFICACIONES - cont: estoy en el controlador');
        notificationEncarg = result['notificationListEncarg'];

        notificationListLengthEncarg = notificationEncarg.length;

        notificationListNewEncarg = result['notificationListNewEncarg'];
        notificationListNewLengthEncarg = notificationListNewEncarg.length;
        print(
            'ENTRO A BUSCAR NOTIFICACIONES - cont: estoy en el controlador - notificationListNewLengthEncarg:${notificationEncarg.length}');

        notificationListNewEncarg.forEach((element) async {
          if (element.state == 3 &&
              element.tittle == 'Aceptada Eliminación de Servicio') {
            print('modificar time de mm 1 estoy aqui en el forEach');
            String textoCompleto = element.description;
            // String descripcion =
            //     textoCompleto.split('.')[0]; // Obtener la descripción
            // Obtener el segundo número (999)
            String numeroOcultoString = textoCompleto
                .split('.')[1]
                .trim(); // Obtener la parte después del punto y eliminar espacios en blanco
            int idReservation =
                int.parse(numeroOcultoString); // Convertir a entero
            controllerclient.watchModifyTimeRest(idReservation,
                textoCompleto); //aqui le mando el tiempo tambien y los voy sumando si el id coincidiera
            updateNotifications2(idBranch, idProfe,
                element.id); //aqui es para no repetir esto y lo pongo en 0

            //NOTIFICAR UQ HAY CAMBIOS EN LOS RELOJES
            //DESCONTAR EL TIEMPO AL RELOJ
            //MANDAR AL METODO DE SABER CUANTOS MINUTOS HAY QUE DESCONTAR
            siHayEliminarService = true;
          }
        });
        if (siHayEliminarService ==
            true) //entro solo si entro al if de 'Aceptada Eliminación de Servicio'
        {
          controllerclient.setActiveModifyTimeRest(true);
        }

        update();
      }
      controllerLogin.setIsLoadingFor(false);
    } catch (e) {
      controllerLogin.setIsLoadingFor(false);
      // Manejo de errores
      print('Error al obtener la lista de notificaciones:aqui: $e');
    }
  }

  Future<void> updateNotifications(idBranch, idProf, type) async {
    try {
      int result = await repository.updateNotifications(idBranch, idProf, type);
      if (result == 1) {
        print('Las notificaciones fueron vistas');
      } else {
        print('No modifico las notificaciones como vistas');
      }
    } catch (e) {
      print('error de notification:$e');
    }
  }

  Future<void> updateNotifications2(idBranch, idProf, id) async {
    try {
      int result = await repository.updateNotifications2(idBranch, idProf, id);
      if (result == 1) {
        print('Las notificaciones fueron cambiada a 3 estas de id:$id');
      } else {
        print('Las notificaciones fueron cambiada a 3 NOOOOOOOOOOOOO');
      }
    } catch (e) {
      print('error de notification:$e');
    }
  }
}
