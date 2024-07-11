import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsCoordinatorController.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Models/clientsScheduled_model.dart';
import 'package:turnopro_apk/Models/professional_model.dart';

import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/Views/coordinator/coexistencePageCoordinator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:turnopro_apk/Views/coordinator/services/localStorage.dart';

//import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:turnopro_apk/services/background_task_service.dart';
/*
import 'package:turnopro_apk/Models/notification_model.dart';
import 'package:turnopro_apk/env.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert'; // Importa el paquete 'dart:convert' para trabajar con JSON*/

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final ClientsScheduledController clientsScheduledController =
      Get.find<ClientsScheduledController>();
  final ClientsCoordinatorController clientCord =
      Get.find<ClientsCoordinatorController>();

  final PagesConfigController pagesConfigC = Get.find<PagesConfigController>();

  final LoginController loginController = Get.find<LoginController>();

  final CoexistenceController coexistenceController =
      Get.put(CoexistenceController());
  NotificationController notiController = Get.find<NotificationController>();
  ServiceController serviceControll = Get.find<ServiceController>();
  ShoppingCartController chopCont = Get.find<ShoppingCartController>();
  CoexistenceController coexCont = Get.find<CoexistenceController>();
  final ProductController controllerProduct = Get.put(ProductController());

  @override
  bool get wantKeepAlive => true;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isMounted = true;
/*
  WebSocketChannel channel = IOWebSocketChannel.connect(
      'wss://api2.simplifies.cl/api/notification-professional?branch_id=15&professional_id=76');*/

  Future<void> saveData() async {
    int valueClock = getTimeRemaining();
    await LocalStorage.prefs.setInt('valueClockIni', valueClock);
    int hAs = obtenerHoraActualEnSegundos();
    LocalStorage.prefs.setInt('valueHoraAnt', hAs);

    print('--este es el value del clok... ->Value guardado:$valueClock');
  }

  int getTimeRemaining() {
    if (clientsScheduledController.animationControllerInitial != null) {
      return (clientsScheduledController.totalTimeInitial -
              (clientsScheduledController.animationControllerInitial!.value *
                  clientsScheduledController.totalTimeInitial))
          .round();
    } else {
      return 180;
    }
  }

  int obtenerHoraActualEnSegundos() {
    DateTime ahora = DateTime.now();
    int segundos = ahora.hour * 3600 + ahora.minute * 60 + ahora.second;
    return segundos;
  }

  reasigClient(int reservationId, int clientId) async {
    print('se hacompletado los 3 min-ESTOY EN reasigClient');
    int idProfDisp = await professionalDisp(reservationId);
    if (idProfDisp != 0) {
      // entonces reasignoP
      Get.dialog(
        const Center(
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: Color(0xFFFDAE2A),
                ),
                SizedBox(height: 16),
                Text('Reasignando cliente...',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      ); //Get.back();
      bool result = await clientCord.reasignedClient(reservationId, clientId,
          idProfDisp, loginController.tokenUserLoggedIn);
      if (result == true) {
        await clientsScheduledController.fetchClientsScheduledNew(
            loginController.idProfessionalLoggedIn,
            loginController.branchIdLoggedIn,
            'Home-reasignedClient',
            loginController.tokenUserLoggedIn);
        Get.back();
        loginController.setCodigoQrValidAnt(1);
      } else {
        loginController.setCodigoQrValidAnt(1);
        Get.back();
      }
    } else //No hay barberos disponibles
    {
      //aqui mandar el cliente a verificar si es aleatori y cambiar el valor
      //y poner valor aleatore = 3 diciendo que puede ser llamado por alguien aunque este de primero
      loginController.setCodigoQrValidAnt(1);
      Get.back();
      Get.snackbar(
        'Alerta',
        'No hay barberos disponibles',
        duration: const Duration(milliseconds: 2500),
        backgroundColor: const Color.fromARGB(118, 255, 255, 255),
        showProgressIndicator: true,
        progressIndicatorBackgroundColor:
            const Color.fromARGB(255, 203, 205, 209),
        progressIndicatorValueColor:
            const AlwaysStoppedAnimation(Color(0xFFFF6750)),
        overlayBlur: 3,
      );
    }
  }

  Future<int> professionalDisp(int idReserv) async {
    //que sea diferente al barbero actual
    int idBarberAct = loginController.idProfessionalLoggedIn!;
    List<ProfessionalModel> profDisp;
    profDisp = await clientsScheduledController.getFirstProfessional(
        loginController.branchIdLoggedIn,
        idReserv,
        idBarberAct,
        loginController.tokenUserLoggedIn);
    if (profDisp.isNotEmpty) {
      print('hay profesional libre para reasignar');
      return profDisp[0].id;
    } else {
      print('No hay profesional libre para reasignar');
      return 0;
    }
  }

  reiniciateClock() {
    print('verificando si esta activo:Aqui reiniciateClock()');
    LocalStorage.prefs.setBool('convivenciaIncumplida', true);
    LocalStorage.prefs.setInt('valueClockIni', 180);
    clientsScheduledController.setTotalTimeInitial(180);
    LocalStorage.prefs.setBool('valueClockActiv', false);

    // Reiniciar la animación
    // Reiniciar y avanzar la animación existente
    clientsScheduledController.animationControllerInitial!
      ..duration = Duration(seconds: 180)
      ..reset()
      ..forward();

    // clientsScheduledController.animationControllerInitial!.reset();
    // clientsScheduledController.animationControllerInitial!.forward();
  }

  restartStopClock() {
    print(
        'verificando si esta activo:Aqui estoy párando el reloj reiniciateClock()');
    LocalStorage.prefs.setBool('convivenciaIncumplida', true);
    LocalStorage.prefs.setInt('valueClockIni', 180);
    clientsScheduledController.setTotalTimeInitial(180);
    LocalStorage.prefs.setBool('valueClockActiv', false);

    // Reiniciar la animación
    // Reiniciar y avanzar la animación existente
    clientsScheduledController.animationControllerInitial!
      ..duration = Duration(seconds: 180)
      ..reset()
      ..stop();

    // clientsScheduledController.animationControllerInitial!.reset();
    // clientsScheduledController.animationControllerInitial!.forward();
  }

  //BackgroundTaskService backgroundTaskService = BackgroundTaskService();
  @override
  void initState() {
    super.initState();

    print('fff12 antes del channel.stream');

    print('cargando aqui-3');
    // initializeNotifications();
    //AQUI ME DEVUELVE A Q CLIENTE LE SIGUE Y ACUAL MOSTRAR EN LA COLA
    clientsScheduledController.filterShowNext();

//todo fin codigoanterior
    clientsScheduledController.animationControllerInitial = AnimationController(
      vsync: this,
      duration: Duration(seconds: clientsScheduledController.totalTimeInitial),
    );

    // Agregar listener solo una vez
    clientsScheduledController.animationControllerInitial!
        .addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print('Se ha completado los 3-La animación se ha completado-SIIIII');

        String type = 'Tiempo';
        int estado = 0; //es que incumplió
        //CADA VEZ QUE ENTRE AQUI INCULPLIO CON EL TIEMPO DE LLAMAR AL CLIENTE ANTES DE 3MIN
        if (loginController.branchIdLoggedIn != null &&
            loginController.idProfessionalLoggedIn != null) {
          //acabaron los 3 minutos de espera
          clientsScheduledController.changeNoncomplianceP2(
              type,
              loginController.branchIdLoggedIn!,
              loginController.idProfessionalLoggedIn!,
              estado);
        }

        // Aquí llamamos a BackgroundTaskService para registrar la tarea de una sola vez
        /*  if (loginController.branchIdLoggedIn != null &&
            loginController.idProfessionalLoggedIn != null) {
          // Acabaron los 3 minutos de espera
          backgroundTaskService.registerOneOffTask(
            type,
            loginController.branchIdLoggedIn!,
            loginController.idProfessionalLoggedIn!,
            estado,
          );
        }*/

        //AQUI SI HAY QUE REASIGNAR SE REASIGNA
        if (clientsScheduledController.clientsScheduledNext != null) {
          print('se hacompletado los 3 min-HAY CLIENTE POR ATENDER');
          int reservationId =
              clientsScheduledController.clientsScheduledNext!.reservation_id!;
          int clientId =
              clientsScheduledController.clientsScheduledNext!.client_id!;
          reasigClient(reservationId, clientId);
        }

        // reasigClient(int reservationId, int clientId);
        if (loginController.chargeUserLoggedIn != "Barbero y Encargado") {
          if (clientsScheduledController.noncomplianceProfessional['Tiempo'] !=
                  0 &&
              loginController.usserPermissionQr == 1 &&
              clientsScheduledController.clientsScheSalon > 0) {
            print('--este es el value del clok-FINALIZANDO*****22');
            print(
                'inserto correctamente ********** .noncomplianceProfessional[]');

            clientsScheduledController.changeNoncomplianceP(
                type,
                loginController.branchIdLoggedIn!,
                loginController.idProfessionalLoggedIn!,
                estado);
            //aqui llamar e insertar en las notificacione sque incumplio esta convivencia
            notiController.storeNotification(
                'Incumplimiento de convivencia',
                loginController.branchIdLoggedIn!,
                loginController.idProfessionalLoggedIn!,
                'Tu tiempo de espera de 3 minutos para seleccionar al nuevo cliente en cola se ha agotado',
                'Barbero');
//todo notificate
            // reiniciateClock();
            // LocalStorage.prefs.setInt('valueClockIni', 180);
            // clientsScheduledController.setTotalTimeInitial(180);
            // LocalStorage.prefs.setBool('valueClockActiv', false);
            // La animación ha llegado al final, reiniciar

            // clientsScheduledController.animationControllerInitial!.reset();
            // clientsScheduledController.animationControllerInitial!.forward();
          }
        } //FIN DEL IF DE BARBERO ENCARGADO
        reiniciateClock();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print('Se ha completado los 3-Renderizado de la pagina');

      _timer3 = Timer.periodic(Duration(seconds: 3), (timer) async {
        print('Se ha completado los 3 minutos-Timer-Chequeando');
        if (clientsScheduledController.animationControllerInitial != null &&
            clientsScheduledController
                .animationControllerInitial!.isAnimating) {
          // Aquí puedes realizar alguna acción periódica si es necesario
          print('Se ha completado los 3 minutos-esta activo el reloj');
        }
      });
      clientsScheduledController.animationControllerInitial!.forward();

      if (loginController.isLoggingInCharge == true) {
        print('cargando aqui-15');
        await loginController.setLoggingInCharge(false, 'buildComponent-1114');
      }
    });
//todo inicio codigo-nuevo
    // clientsScheduledController.animationControllerInitial = AnimationController(
    //   vsync: this,
    //   duration: Duration(seconds: clientsScheduledController.totalTimeInitial),
    // );
    // A este cargo no se le cambia la regla de convivencia del tiempo

//todo fin codigo-nuevo

    clientsScheduledController.animationController1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 50),
    );
    clientsScheduledController.animationController2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    clientsScheduledController.animationController3 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    clientsScheduledController.animationController4 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
//

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      clientsScheduledController.setBoolControlVision(true);
      llamadasTimer1();

      // print(
    });
  }

  @override
  void dispose() {
    clientsScheduledController.animationControllerInitial!.dispose();

    clientsScheduledController.animationController1!.dispose();
    clientsScheduledController.animationController2!.dispose();
    clientsScheduledController.animationController3!.dispose();
    clientsScheduledController.animationController4!.dispose();
    // channel.sink.close();
    _isMounted = false;
    _timer1?.cancel();
    _timer2?.cancel();
    _timer3?.cancel();

    super.dispose();
  }

  void verifyingClockTimeActive() {
    print('cargando aqui-9');
    if (clientsScheduledController.clientsAttended1 == null &&
        clientsScheduledController.clientsAttended2 == null &&
        clientsScheduledController.clientsAttended3 == null &&
        clientsScheduledController.clientsAttended4 == null &&
        loginController.usserPermissionQr == 1 &&
        clientsScheduledController.clientsScheSalon > 0 &&
        clientsScheduledController.animationControllerInitial != null) {
      //SI TODOS LOS RELOS ESTAN DETENIDOS Y TIENE EL QR LEIDO Y HAY ALGIEN EN COLA QUE REINICIE EL RELOJ DE 3 MIN DE ESPERA
      //REINICIO Y ACTIVO EL RELOJ DE ESPERA
      print('estoy reiniciando el reloj inicial');
      bool isAnimating =
          clientsScheduledController.animationControllerInitial!.isAnimating;
      if (!isAnimating &&
          clientsScheduledController.animationControllerInitial != null &&
          _isMounted) {
        print('estoy reiniciando el reloj inicial--NO ESTABA ANIMADO');

        clientsScheduledController.animationControllerInitial!.reset();
        clientsScheduledController.animationControllerInitial!.forward();
        LocalStorage.prefs.setBool('valueClockActiv', true);
        int hAs = obtenerHoraActualEnSegundos();
        LocalStorage.prefs.setInt('valueHoraAnt', hAs);
      }
    } else {
      if (clientsScheduledController.animationControllerInitial != null &&
          clientsScheduledController.animationControllerInitial!.isAnimating) {
        clientsScheduledController.animationControllerInitial!.stop();
        LocalStorage.prefs.setBool('valueClockActiv', false);
        LocalStorage.prefs.setInt('valueClockIni', 180);
      }
    }
  }

  //optener la hora actual
  String getCurrentTime() {
    // Obtener la hora actual
    DateTime now = DateTime.now();

    // Formatear la hora
    String formattedTime = DateFormat('HH:mm:ss').format(now);

    return formattedTime;
  }

  //comparar 2 horas si h1>h2 devuelve true
  bool isTime1GreaterThanTime2(String h1, String h2) {
    DateFormat format = DateFormat('HH:mm:ss');

    // Convertir las cadenas a objetos DateTime
    DateTime time1 = format.parse(h1);
    DateTime time2 = format.parse(h2);

    // Comparar los tiempos
    return time1.isAfter(time2);
  }

  void verifyingClockTime(
      ClientsScheduledController clientsScheduledController, int endingTime) {
    String teleClient = '';
    if (clientsScheduledController.clientsScheduledNext != null) {
      teleClient =
          clientsScheduledController.clientsScheduledNext!.telefone_client!;
      print(
          'cargando aqui-8-EL TIEMPO ACTUAL DEL RELOJ duracionSend YA sera:TELEFONO:$teleClient');
    } else {
      print('cargando aqui-8-TELEFONO-NULO:$teleClient');
    }
    print('cargando aqui-8');
    try {
      //este es para el reloj 1
      if (clientsScheduledController.clientsAttended1 != null) {
        if (clientsScheduledController.animationController1 != null &&
            clientsScheduledController.animationController1!.isAnimating) {
          //   print('estoy entrando pa saber que relojes->para mandar notifiacion');
          int? idClient =
              clientsScheduledController.clientsAttended1?.client_id;
          String? nameClient =
              clientsScheduledController.clientsAttended1?.client_name;
          if (idClient != null && nameClient != null) {
            //analizo si para este clientes ya se envio el mensaje para no repetirselo
            if (clientsScheduledController.notificationClients1 == null ||
                (clientsScheduledController.notificationClients1 != idClient &&
                    clientsScheduledController.notificationClients1 != null)) {
              if (clientsScheduledController.animationController1 != null) {
                // Obtener la hora actual
                String currentTime = getCurrentTime();
                print('La hora actual es: $currentTime');
                int tiempoMin = loginController.secondsToMinutes(
                    clientsScheduledController.timeClientsAttended1!);
                print(
                    'Mandar notificacionq ue el tiempo acabó-***ENTRANDO***-');
                // String hrAcaba3min = loginController.getUpdateTime(tiempoMin);
                String hrAcaba3min = '';

                if (LocalStorage.prefs.getString('varSistemHr3min1') != null) {
                  hrAcaba3min =
                      LocalStorage.prefs.getString('varSistemHr3min1')!;
                  if (hrAcaba3min == 'FIN') //el tiempo acabo
                  {
                    Get.snackbar(
                      'Mensaje',
                      'Ya el tiempo de servicio acabó',
                      duration: const Duration(milliseconds: 2500),
                      backgroundColor: const Color.fromARGB(118, 255, 255, 255),
                      showProgressIndicator: true,
                      progressIndicatorBackgroundColor:
                          const Color.fromARGB(255, 203, 205, 209),
                      progressIndicatorValueColor:
                          const AlwaysStoppedAnimation(Color(0xFFFDAE2A)),
                      overlayBlur: 3,
                    );
                    print('Mandar notificacionq ue el tiempo acabó');
                    // LocalStorage.prefs.setString('varSistemHr3min1', '0');
                  }

                  // String hrAvisar =
                  //     LocalStorage.prefs.getString('varSistemHr3min1')!;
                  // print(
                  //     'Mandar notificacionq ue el tiempo Aun esta por cumplirse, td bien-1:$currentTime > $hrAcaba3min');
                  // print(
                  //     'Mandar notificacionq ue el tiempo Aun esta por cumplirse, td bien:tiempo de reloj-1:$tiempoMin');
                  // verifico aqui si el tiempo con la hora actual
                  else if (isTime1GreaterThanTime2(currentTime, hrAcaba3min) ||
                      hrAcaba3min == 'MENOR') {
                    int professionalId =
                        loginController.idProfessionalLoggedIn!;
                    int branchId = loginController.branchIdLoggedIn!;
                    notiController.storeNotification(
                        '!Alerta',
                        branchId,
                        professionalId,
                        'El tiempo de servicio del cliente $nameClient se agotará en los próximos $endingTime minutos',
                        'Barbero');

                    //llamo al metodo que me dice que para este cliente ya se envio una notificacion al barbero
                    String teleClient = '';
                    if (clientsScheduledController.clientsScheduledNext !=
                        null) {
                      teleClient = clientsScheduledController
                          .clientsScheduledNext!.telefone_client!;
                      print(
                          'cargando aqui-8-Actualizando la variable-TELEFONO:$teleClient');
                    }
                    clientsScheduledController.setNotificationClients1(
                        1, //esto indica que es el reloj 1
                        clientsScheduledController.clientsAttended1!.client_id!,
                        teleClient);
                    print(
                        'EL TIEMPO ACTUAL DEL RELOJ duracionSend YA sera:TELEFONO:$teleClient');
                    //todo notificate
                    // scheduleNotification('!Alerta',
                    //     'El tiempo de servicio del cliente $nameClient se agotará');
                  } else {
                    print(
                        'Mandar notificacionq ue el tiempo -***hrActua:-(1):$currentTime y acaba a :$hrAcaba3min***-');
                  }
                } else {
                  print(
                      'Mandar notificacionq ue el tiempo acabó-***ENTRANDO-pero es null***-');
                }
              }
            }
          }
        } else {
          print('object-2');
        }
      } else {
        clientsScheduledController.animationController1!.stop();
        clientsScheduledController.clearNotificationClients1(1);
        print('object-2-2 reloj 1');
      }
//este es para el reloj 2
      if (clientsScheduledController.clientsAttended2 != null) {
        if (clientsScheduledController.animationController2 != null &&
            clientsScheduledController.animationController2!.isAnimating) {
          print('object-1 reloj 2');
          int? idClient =
              clientsScheduledController.clientsAttended2?.client_id;
          String? nameClient =
              clientsScheduledController.clientsAttended2?.client_name;
          if (idClient != null && nameClient != null) {
            if (clientsScheduledController.notificationClients2 == null ||
                (clientsScheduledController.notificationClients2 != idClient &&
                    clientsScheduledController.notificationClients2 != null)) {
              if (clientsScheduledController.animationController2 != null) {
                // Obtener la hora actual
                String currentTime = getCurrentTime();
                print('La hora actual es: $currentTime');
                int tiempoMin = loginController.secondsToMinutes(
                    clientsScheduledController.timeClientsAttended2!);

                // String hrAcaba3min = loginController.getUpdateTime(tiempoMin);
                String hrAcaba3min = '';

                if (LocalStorage.prefs.getString('varSistemHr3min2') != null) {
                  hrAcaba3min =
                      LocalStorage.prefs.getString('varSistemHr3min2')!;
                  if (hrAcaba3min == 'FIN') //el tiempo acabo
                  {
                    print('Mandar notificacionq ue el tiempo acabó');
                  } else if (hrAcaba3min == 'MENOR') {
                    print(
                        'Mandar notificacionq ue el tiempo YA ES MENOR DE LOS 3 MINUTOS');
                  }

                  print(
                      'Mandar notificacionq ue el tiempo Aun esta por cumplirse, td bien-2:$currentTime > $hrAcaba3min');
                  print(
                      'Mandar notificacionq ue el tiempo Aun esta por cumplirse, td bien:tiempo de reloj-2:$tiempoMin');
                  // verifico aqui si el tiempo con la hora actual
                  if (isTime1GreaterThanTime2(currentTime, hrAcaba3min)) {
                    int professionalId =
                        loginController.idProfessionalLoggedIn!;
                    int branchId = loginController.branchIdLoggedIn!;
                    notiController.storeNotification(
                        '!Alerta',
                        branchId,
                        professionalId,
                        'El tiempo de servicio del cliente $nameClient se agotará en los próximos $endingTime minutos',
                        'Barbero');

                    if ((idClient ==
                        clientsScheduledController
                            .clientsAttended2?.client_id)) {
                      //llamo al metodo que me dice que para este cliente ya se envio una notificacion al barbero
                      String teleClient = '';
                      if (clientsScheduledController.clientsScheduledNext !=
                          null) {
                        teleClient = clientsScheduledController
                            .clientsScheduledNext!.telefone_client!;
                      }
                      clientsScheduledController.setNotificationClients1(
                          2, //esto indica que es el reloj 2
                          clientsScheduledController
                              .clientsAttended2!.client_id!,
                          teleClient);
                      //todo notificate
                      // scheduleNotification('!Alerta',
                      //     'El tiempo de servicio del cliente $nameClient se agotará');
                    }
                  }
                }
              }
            }
          }
        } else {
          print('object-2 reloj 2**');
        }
      } else {
        clientsScheduledController.animationController2!.stop();
        clientsScheduledController.clearNotificationClients1(2);
        print('object-2-2 reloj 2');
      }
      //este es para el reloj 3
      if (clientsScheduledController.clientsAttended3 != null) {
        if (clientsScheduledController.animationController3 != null &&
            clientsScheduledController.animationController3!.isAnimating) {
          print('object-1 reloj 3');
          int? idClient =
              clientsScheduledController.clientsAttended3?.client_id;
          String? nameClient =
              clientsScheduledController.clientsAttended3?.client_name;
          if (idClient != null && nameClient != null) {
            //analizo si para este clientes ya se envio el mensaje para no repetirselo
            if (clientsScheduledController.notificationClients3 == null ||
                (clientsScheduledController.notificationClients3 != idClient &&
                    clientsScheduledController.notificationClients3 != null)) {
              if (clientsScheduledController.animationController3 != null) {
                // Obtener la hora actual
                String currentTime = getCurrentTime();
                print('La hora actual es: $currentTime');
                int tiempoMin = loginController.secondsToMinutes(
                    clientsScheduledController.timeClientsAttended3!);

                // String hrAcaba3min = loginController.getUpdateTime(tiempoMin);
                String hrAcaba3min = '';

                if (LocalStorage.prefs.getString('varSistemHr3min3') != null) {
                  hrAcaba3min =
                      LocalStorage.prefs.getString('varSistemHr3min3')!;
                  if (hrAcaba3min == 'FIN') //el tiempo acabo
                  {
                    print('Mandar notificacionq ue el tiempo acabó');
                  } else if (hrAcaba3min == 'MENOR') {
                    print(
                        'Mandar notificacionq ue el tiempo YA ES MENOR DE LOS 3 MINUTOS');
                  }

                  print(
                      'Mandar notificacionq ue el tiempo Aun esta por cumplirse, td bien-3:$currentTime > $hrAcaba3min');
                  print(
                      'Mandar notificacionq ue el tiempo Aun esta por cumplirse, td bien:tiempo de reloj-3:$tiempoMin');
                  // verifico aqui si el tiempo con la hora actual
                  if (isTime1GreaterThanTime2(currentTime, hrAcaba3min)) {
                    int professionalId =
                        loginController.idProfessionalLoggedIn!;
                    int branchId = loginController.branchIdLoggedIn!;
                    notiController.storeNotification(
                        '!Alerta',
                        branchId,
                        professionalId,
                        'El tiempo de servicio del cliente $nameClient se agotará en los próximos $endingTime minutos',
                        'Barbero');

                    if ((idClient ==
                        clientsScheduledController
                            .clientsAttended3?.client_id)) {
                      //llamo al metodo que me dice que para este cliente ya se envio una notificacion al barbero
                      String teleClient = '';
                      if (clientsScheduledController.clientsScheduledNext !=
                          null) {
                        teleClient = clientsScheduledController
                            .clientsScheduledNext!.telefone_client!;
                      }
                      clientsScheduledController.setNotificationClients1(
                          3, //esto indica que es el reloj 2
                          clientsScheduledController
                              .clientsAttended3!.client_id!,
                          teleClient);
                      //todo notificate
                      // scheduleNotification('!Alerta',
                      //     'El tiempo de servicio del cliente $nameClient se agotará');
                    }
                  }
                }
              }
            }
          }
        } else {
          print('object-2 reloj 3');
        }
      } else {
        clientsScheduledController.animationController3!.stop();
        clientsScheduledController.clearNotificationClients1(3);
        print('object-2-2 reloj 3');
      }

      //este es para el reloj 4
      if (clientsScheduledController.clientsAttended4 != null) {
        if (clientsScheduledController.animationController4 != null &&
            clientsScheduledController.animationController4!.isAnimating) {
          print('object-1 reloj 4');
          int? idClient =
              clientsScheduledController.clientsAttended4?.client_id;
          String? nameClient =
              clientsScheduledController.clientsAttended4?.client_name;
          if (idClient != null && nameClient != null) {
            //analizo si para este clientes ya se envio el mensaje para no repetirselo
            if (clientsScheduledController.notificationClients4 == null ||
                (clientsScheduledController.notificationClients4 != idClient &&
                    clientsScheduledController.notificationClients4 != null)) {
              if (clientsScheduledController.animationController4 != null) {
                // Obtener la hora actual
                String currentTime = getCurrentTime();
                print('La hora actual es: 4: $currentTime');
                int tiempoMin = loginController.secondsToMinutes(
                    clientsScheduledController.timeClientsAttended4!);

                // String hrAcaba3min = loginController.getUpdateTime(tiempoMin);
                String hrAcaba3min = '';

                if (LocalStorage.prefs.getString('varSistemHr3min4') != null) {
                  hrAcaba3min =
                      LocalStorage.prefs.getString('varSistemHr3min4')!;
                  if (hrAcaba3min == 'FIN') //el tiempo acabo
                  {
                    print('Mandar notificacionq ue el tiempo acabó');
                  } else if (hrAcaba3min == 'MENOR') {
                    print(
                        'Mandar notificacionq ue el tiempo YA ES MENOR DE LOS 3 MINUTOS');
                  }

                  print(
                      'Mandar notificacionq ue el tiempo Aun esta por cumplirse, td bien-4:$currentTime > $hrAcaba3min');
                  print(
                      'Mandar notificacionq ue el tiempo Aun esta por cumplirse, td bien:tiempo de reloj-4:$tiempoMin');
                  // verifico aqui si el tiempo con la hora actual
                  if (isTime1GreaterThanTime2(currentTime, hrAcaba3min)) {
                    int professionalId =
                        loginController.idProfessionalLoggedIn!;
                    int branchId = loginController.branchIdLoggedIn!;
                    notiController.storeNotification(
                        '!Alerta',
                        branchId,
                        professionalId,
                        'El tiempo de servicio del cliente $nameClient se agotará en los próximos $endingTime minutos',
                        'Barbero');

                    if ((idClient ==
                        clientsScheduledController
                            .clientsAttended4?.client_id)) {
                      //llamo al metodo que me dice que para este cliente ya se envio una notificacion al barbero
                      String teleClient = '';
                      if (clientsScheduledController.clientsScheduledNext !=
                          null) {
                        teleClient = clientsScheduledController
                            .clientsScheduledNext!.telefone_client!;
                      }
                      clientsScheduledController.setNotificationClients1(
                          4, //esto indica que es el reloj 1
                          clientsScheduledController
                              .clientsAttended4!.client_id!,
                          teleClient);
                      //todo notificate
                      // scheduleNotification('!Alerta',
                      //     'El tiempo de servicio del cliente $nameClient se agotará');
                    }
                  }
                }
              }
            }
          }
        } else {
          print('object-2 reloj 4');
        }
      } else {
        clientsScheduledController.animationController4!.stop();
        clientsScheduledController.clearNotificationClients1(4);
        print('object-2-2 reloj 4');
      }
      //
      //
    } catch (e) {
      print('object-4 dio error en :$e');
    }
  }

  Timer? _timer1;
  Timer? _timer2;
  Timer? _timer3;
  int initialValue = 10;

  llamadasTimer1() {
    _timer1 = //notificaciones
        Timer.periodic(const Duration(seconds: 10), (Timer timer) async {
      saveData();
      getTimeRemaining();
      print(
          'llamada timer en 10 segundos obtenerHoraActualEnSegundos: getTimeRemaining():${getTimeRemaining()} ');
      if (loginController.makeCall == true) {
        print('Error al obtener la lista de notificaciones:este:TIMER-TIMER');
        print(
            'Error al obtener la lista de notificaciones:este:clientsScheduledController.boolFilterShowNext:${clientsScheduledController.boolFilterShowNext}');
        print('llamada timer en 10 segundos obtenerHoraActualEnSegundos:');
        if (loginController.usserPermissionQr != null &&
            loginController.idProfessionalLoggedIn != null &&
            loginController.branchIdLoggedIn != null &&
            (loginController.chargeUserLoggedIn == "Barbero" ||
                (loginController.chargeUserLoggedIn ==
                    "Barbero y Encargado"))) {
          clientsScheduledController.filterShowNext();
          String teleClient = '';
          if (clientsScheduledController.clientsScheduledNext != null) {
            teleClient = clientsScheduledController
                .clientsScheduledNext!.telefone_client!;
            print(
                'EL telefono del que le sigue en la cola es:TELEFONO:$teleClient');
          }
          //pregunto si no tinee a nadie en cola
          //voy a ver si hay alguno para reasignarlo
          print(
              'Cliente reasignado correctamente ->ANTES DEL IF clientsScheduledListLengthTail:${clientsScheduledController.clientsScheduledListLength})');
          print(
              'Cliente reasignado correctamente ->ANTES DEL IF clientsScheduledController.item.isEmpty:${clientsScheduledController.item.isEmpty})');

          //await Future.delayed(Duration(seconds: 1));
          //Buscar notificaciones
          //variables
          int idBranch = loginController.branchIdLoggedIn!;
          int idProfe = loginController.idProfessionalLoggedIn!;
          String type = 'Barbero';
          String msj = 'llamadasTimer1';

          await notiController.professionalBranchNotifQueque(
              idBranch, idProfe, type, msj, loginController.tokenUserLoggedIn);
          print(
              'viendo si hay clientes esperando realmente::${clientsScheduledController.clientsScheSalon})');
          print(
              'viendo si hay clientes esperando realmente::errorHome:${clientsScheduledController.errorHome})');

          /*esta era para llamar a un aleatorio si no tenia nadie en cola.ya eso lo hace la api
           if (clientsScheduledController.clientsScheSalon == 0 &&
              clientsScheduledController.errorHome != -99) {
            restartStopClock();
            print(
                'Error al obtener la lista de notificaciones:este: estoy entrando a madar a reasignar aqui :${clientsScheduledController.clientsScheduledListLength}');
            print(
                'Cliente reasignado correctamente -> entre a buscar clientes para mi que estoy vacio');
            int decisionResult = await clientCord.reasignedClientTottem(
                loginController.branchIdLoggedIn,
                loginController.idProfessionalLoggedIn);
            if (decisionResult == 1) {
              reiniciateClock();
            }
          }*/
          if (loginController.chargeUserLoggedIn == "Barbero y Encargado") {
            await notiController.fetchNotificationList(
                loginController.branchIdLoggedIn,
                loginController.idProfessionalLoggedIn,
                'Encargado',
                'Cart home',
                loginController.tokenUserLoggedIn);
          }

          //lo que llamaba el timer 2
          print('llamada timer 2 - 11segundos');
          if (loginController.idProfessionalLoggedIn != null &&
              loginController.branchIdLoggedIn != null &&
              (loginController.chargeUserLoggedIn == "Barbero" ||
                  (loginController.chargeUserLoggedIn ==
                      "Barbero y Encargado"))) {
            //guardar datos de los relojes en la db
            await clientsScheduledController.upadateVariablesValueTimers();
            //aqui en este actualiza los tiempos de los relojes

            print(
                'activando el Clock - 1 lenght - clientsScheduledList:${clientsScheduledController.clientsScheduledList.length}');
            for (var i = 0;
                i < clientsScheduledController.clientsScheduledList.length;
                i++) {
              int clock = 0;
              if (clientsScheduledController.clientsScheduledList[i].attended ==
                  11) {
                int reservationId = clientsScheduledController
                    .clientsScheduledList[i].reservation_id!;
                clock = await clientsScheduledController
                    .getValueClockDb(reservationId);
                if (clock == 1) {
                  print('activando el Clock - 1');
                  clientsScheduledController.animationController1!.forward();
                  clientsScheduledController.acceptOrRejectClient(
                      reservationId, 111, loginController.tokenUserLoggedIn);
                  clientsScheduledController.pauseResumeClock((clock - 1), -99);
                }
                if (clock == 2) {
                  print('activando el Clock - 2');
                  clientsScheduledController.animationController2!.forward();
                  clientsScheduledController.acceptOrRejectClient(
                      reservationId, 111, loginController.tokenUserLoggedIn);
                  clientsScheduledController.pauseResumeClock((clock - 1), -99);
                }
                if (clock == 3) {
                  print('activando el Clock - 3');
                  clientsScheduledController.animationController3!.forward();
                  clientsScheduledController.acceptOrRejectClient(
                      reservationId, 111, loginController.tokenUserLoggedIn);
                  clientsScheduledController.pauseResumeClock((clock - 1), -99);
                }
                if (clock == 4) {
                  print('activando el Clock - 4');
                  clientsScheduledController.animationController4!.forward();
                  clientsScheduledController.acceptOrRejectClient(
                      reservationId, 111, loginController.tokenUserLoggedIn);
                  clientsScheduledController.pauseResumeClock((clock - 1), -99);
                }
              } //fin del if
            }
          }
          //lo que llamaba el timer 2

          //ESTO ES LO QUE LLAMABA EL TIMER
          if (loginController.idProfessionalLoggedIn != null &&
              loginController.branchIdLoggedIn != null &&
              (loginController.chargeUserLoggedIn == "Barbero" ||
                  (loginController.chargeUserLoggedIn ==
                      "Barbero y Encargado"))) {
            //en este caso son 3 minutos que esta definido en el controlador
            //aqui verifico si se esta acabando algun servico para mandar una notificacion
            //  await Future.delayed(Duration(seconds: 1));
            verifyingClockTime(clientsScheduledController,
                clientsScheduledController.endingTime);
          }
          //ESTO ES LO QUE LLAMABA EL TIMER

          //ESTO ES LO QUE LLAMABA EL TIMER 3
          if (loginController.idProfessionalLoggedIn != null &&
              loginController.branchIdLoggedIn != null &&
              (loginController.chargeUserLoggedIn == "Barbero" ||
                  (loginController.chargeUserLoggedIn ==
                      "Barbero y Encargado"))) {
            //en este caso son 3 minutos que esta definido en el controlador
            //aqui verifico si se esta acabando algun servico para mandar una notificacion
            //
            // await Future.delayed(Duration(seconds: 2));

            if ((clientsScheduledController.varClientsWaiting == true) &&
                (loginController.usserPermissionQr == 1)) {
              print('esteeeeee se cumplio que puede atender ..aqui entrandoya');
              if (clientsScheduledController
                      .animationControllerInitial!.isAnimating &&
                  clientsScheduledController.cantClientWait !=
                      clientsScheduledController.clientsScheduledListLength) {
                // La animación está activa (en progreso)
                if (clientsScheduledController.contClientsWaiting == 10) {
                  print('esteeeeee varClientsWaiting Mande la notificacion ya');
                  //aqui llamar e insertar en las notificaciones
                  notiController.storeNotification(
                      'Clientes en cola',
                      loginController.branchIdLoggedIn,
                      loginController.idProfessionalLoggedIn,
                      'Recuerda que tienes clientes en cola.¡No los mantengas esperando por mucho tiempo!',
                      'Barbero');
                  //todo notificate
                  // scheduleNotification(
                  //     '!Alerta', 'Recuerda que tienes clientes en cola');
                  //para controlar que con este cliente solo le avise una vez
                  clientsScheduledController.setContClientsWaiting(20);
                  clientsScheduledController.setcantClientWait(
                      clientsScheduledController.clientsScheduledListLength);
                }
                if (clientsScheduledController.contClientsWaiting == 10) {
                  print(
                      'entando en 10 segundos aqui para insertar el tiempo si hubiera reloj activo');
                } else if (clientsScheduledController.contClientsWaiting ==
                    100) //si llega a 100 mando que sea 20 de nuevo para q no pase de los valores del entero y tener un control mejor de el
                {
                  clientsScheduledController.setContClientsWaiting(20);
                } else {
                  clientsScheduledController
                      .setContClientsWaiting(-91119); //sumo 1
                }
              } else {
                clientsScheduledController
                    .setContClientsWaiting(-90009); //inicializo nuevamente a 0
                // La animación está detenida
              }
            } else {
              clientsScheduledController
                  .setContClientsWaiting(-90009); //inicializo nuevamente a 0
            }
            //
          }
          //ESTO ES LO QUE LLAMABA EL TIMER 3
        } else if (loginController.usserPermissionQr == null) {
          //poner a false el cargando
          clientsScheduledController.setBoolControlVision(false);
        }
      }
    });
  }

  // //
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    final dateAct = formatter.format(now);
    //AQUI REVISO SI HAY ALGUNO POR ACTIVAR LO ACTIVO

    super.build(context);

    _timer2 = Timer.periodic(Duration(seconds: 5), (timer) async {
      print(
          'Esto se ejecuta 2 segundos después de renderizar el cuadro--nuevo');

      if (getTimeRemaining() < 3) {
        // aaqui cancelar hasta que vea si rasigna o no
        loginController.setCodigoQrValidAnt(0); //10 es en espera
      }
      if (loginController.idProfessionalLoggedIn != null &&
          loginController.branchIdLoggedIn != null &&
          (loginController.chargeUserLoggedIn == "Barbero" ||
              (loginController.chargeUserLoggedIn == "Barbero y Encargado"))) {
        verifyingClockTimeActive();
      }
      if (loginController.segundoPlano == 3) {
        print('cargando aqui-11');
        print('..segundoPlano siii APAGANDO LLAMADA');
        loginController.getSegundoPlano(1);
      }
      //todo este no va hacer falta si lo implemento en ShopingCart.controller
      if (clientsScheduledController.activeModifyTime == true) {
        print('cargando aqui-12');
        //AQUI GARANTIZO QUE AUMENTE EL VALOR DEL RELOJ UNA SOLA VEZ Y QUE INSERTE EN LA DB 1 SOLA VEZ
        clientsScheduledController.setActiveModifyTime(false);
      }
      if (clientsScheduledController.activeModifyTimeRest == true) {
        print('cargando aqui-13');
        //AQUI GARANTIZO QUE disminuya EL VALOR DEL RELOJ UNA SOLA VEZ Y QUE INSERTE EN LA DB 1 SOLA VEZ
        clientsScheduledController.setActiveModifyTimeRest(false);
        clientsScheduledController.clearModifyTimeSpecificRest();
      }

      if (loginController.ejecutadoEvent == false) {
        print('cargando aqui-14');
        // Se ejecutará después de que se haya construido el widget
        //define que tipo de saludo dar dependiendo de la hora

        if (clientsScheduledController.closeIesperado == true) {
          print('-*-*-*-**>>>> si fui un sierre inesperado');
          if (clientsScheduledController.item.isNotEmpty) {
            loginController.setCodigoQrValid(1);
          } else if (loginController.usserPermissionQr == -99 &&
              loginController.usserPermissionQr == 0) {
            loginController.setCodigoQrValid(null);
            print('id de mi puesto de trabajo 1 no esta en ningun puesto:null');
          }
        } else {
          print('-*-*-*-**>>>> NOOO fui un sierre inesperado');
        }
        if (loginController.isLoggingInCharge == true) {
          await loginController.setLoggingInCharge(
              false, 'buildComponent-1103');
        }

        clientsScheduledController.setCloseIesperado(false);
        clientsScheduledController.clockChanges(false);
        loginController.ejecutado_(true);
        clientsScheduledController.modifingTimeClose();
      }
      clientsScheduledController.setCloseIesperadoLogin(false);

      clientsScheduledController.setCloseIesperado(false);
    });

    return GetBuilder<ClientsScheduledController>(
        builder: (clientsScheduledController) {
      //CREANDO LISTAS PARA UTILIZARLO EN EL FOR
      List<ClientsScheduledModel?> clientsList = [
        clientsScheduledController.clientsAttended1,
        clientsScheduledController.clientsAttended2,
        clientsScheduledController.clientsAttended3,
        clientsScheduledController.clientsAttended4,
        // Agrega más listas según sea necesario
      ]; //CREANDO LISTAS PARA UTILIZARLO EN EL FOR
      List<AnimationController?> animationCont = [
        clientsScheduledController.animationController1,
        clientsScheduledController.animationController2,
        clientsScheduledController.animationController3,
        clientsScheduledController.animationController4,
        // Agrega más listas según sea necesario
      ];

      activeClock() {
        print('La aplicación se activeClock() {--111');
        for (var i = 0; i < clientsScheduledController.item.length; i++) {
          if (clientsScheduledController.item[i] == 0) {
            animationCont[0]!.duration =
                Duration(seconds: animationCont[0]!.duration!.inSeconds);
            //ver si esta con el tecnico ponerlo parado sin descontar
            animationCont[0]!.forward();
            //verificar si esta con el tecnico y detenerlo
            if (clientsScheduledController.clientsAttended1!.attended == 4 ||
                clientsScheduledController.clientsAttended1!.attended == 5 ||
                clientsScheduledController.clientsAttended1!.attended == 33) {
              animationCont[0]!.stop();
            }

            print(
                'La aplicación se activeClock() {--1 ${animationCont[0]!.duration!.inSeconds}');
          } else if (clientsScheduledController.item[i] == 1) {
            animationCont[1]!.duration =
                Duration(seconds: animationCont[1]!.duration!.inSeconds);
            animationCont[1]!.forward();
            //verificar si esta con el tecnico y detenerlo
            if (clientsScheduledController.clientsAttended2!.attended == 4 ||
                clientsScheduledController.clientsAttended2!.attended == 5 ||
                clientsScheduledController.clientsAttended2!.attended == 33) {
              animationCont[1]!.stop();
            }
            print(
                'La aplicación se activeClock() {--2 ${animationCont[1]!.duration!.inSeconds}');
          } else if (clientsScheduledController.item[i] == 2) {
            animationCont[2]!.duration =
                Duration(seconds: animationCont[2]!.duration!.inSeconds);
            animationCont[2]!.forward();
            //verificar si esta con el tecnico y detenerlo
            if (clientsScheduledController.clientsAttended3!.attended == 4 ||
                clientsScheduledController.clientsAttended3!.attended == 5 ||
                clientsScheduledController.clientsAttended3!.attended == 33) {
              animationCont[2]!.stop();
            }
            print(
                'La aplicación se activeClock() {--3 ${animationCont[2]!.duration!.inSeconds}');
          } else if (clientsScheduledController.item[i] == 3) {
            animationCont[3]!.duration =
                Duration(seconds: animationCont[3]!.duration!.inSeconds);
            animationCont[3]!.forward();
            //verificar si esta con el tecnico y detenerlo
            if (clientsScheduledController.clientsAttended4!.attended == 4 ||
                clientsScheduledController.clientsAttended4!.attended == 5 ||
                clientsScheduledController.clientsAttended4!.attended == 33) {
              animationCont[3]!.stop();
            }
            print(
                'La aplicación se activeClock() {--4 ${animationCont[3]!.duration!.inSeconds}');
          }
        }
      }

      activeClockLogin() {
        print('La aplicación se activeClock() {--9');
        for (var i = 0; i < clientsScheduledController.item.length; i++) {
          if (clientsScheduledController.item[i] == 0) {
            print(
                'relojes activos: 1-clientsScheduledController.item[$i]:${clientsScheduledController.item[i]}');
            print(
                'relojes activos: 1-:${clientsScheduledController.clientsAttended1!.attended}');
            print(
                'relojes activos: 1-clientsScheduledController.timeClientsAttended1!${clientsScheduledController.timeClientsAttended1!}');
            animationCont[0]!.duration = Duration(
                seconds: clientsScheduledController.timeClientsAttended1!);
            animationCont[0]!.forward();
            //verificar si esta con el tecnico y detenerlo
            if (clientsScheduledController.clientsAttended1!.attended == 4 ||
                clientsScheduledController.clientsAttended1!.attended == 5 ||
                clientsScheduledController.clientsAttended1!.attended == 33) {
              animationCont[0]!.stop();
            }

            print(
                'La aplicación se activeClock() {--8 ${clientsScheduledController.timeClientsAttended1!}');
          } else if (clientsScheduledController.item[i] == 1) {
            print(
                'relojes activos: 2-${clientsScheduledController.clientsAttended2!.attended}');
            animationCont[1]!.duration = Duration(
                seconds: clientsScheduledController.timeClientsAttended2!);
            animationCont[1]!.forward();
            //verificar si esta con el tecnico y detenerlo

            if (clientsScheduledController.clientsAttended2!.attended == 4 ||
                clientsScheduledController.clientsAttended2!.attended == 5 ||
                clientsScheduledController.clientsAttended2!.attended == 33) {
              animationCont[1]!.stop();
            }
            print(
                'La aplicación se activeClock() {--7 ${clientsScheduledController.timeClientsAttended2!}');
          } else if (clientsScheduledController.item[i] == 2) {
            print(
                'relojes activos: 3-${clientsScheduledController.clientsAttended3!.attended}');
            animationCont[2]!.duration = Duration(
                seconds: clientsScheduledController.timeClientsAttended3!);
            animationCont[2]!.forward();
            if (clientsScheduledController.clientsAttended3!.attended == 4 ||
                clientsScheduledController.clientsAttended3!.attended == 5 ||
                clientsScheduledController.clientsAttended3!.attended == 33) {
              animationCont[2]!.stop();
            }
            print(
                'La aplicación se activeClock() {--6 ${clientsScheduledController.timeClientsAttended3!}');
          } else if (clientsScheduledController.item[i] == 3) {
            print(
                'relojes activos: 4-${clientsScheduledController.clientsAttended4!.attended}');
            animationCont[3]!.duration = Duration(
                seconds: clientsScheduledController.timeClientsAttended4!);
            animationCont[3]!.forward();
            if (clientsScheduledController.clientsAttended4!.attended == 4 ||
                clientsScheduledController.clientsAttended4!.attended == 5 ||
                clientsScheduledController.clientsAttended4!.attended == 33) {
              animationCont[3]!.stop();
            }
            print(
                'La aplicación se activeClock() {--5 ${clientsScheduledController.timeClientsAttended4!}');
          }
        }
        //llamar aqui y poner en false
      }

      /*   if (loginController.segundoPlano == 3) {
        print(
            '..segundoPlano siii activando los relojes animationCont[0]!.duration : ${animationCont[0]!.duration}');
        print('..segundoPlano siii activando los relojes');
        animationCont[0]!.duration =
            Duration(seconds: clientsScheduledController.timeClientsAttended1!);
      }*/

      if (loginController.isLoggingInCharge == true) {
        //solo va a entar si viene del login
        print(
            'Hubo un cierre inesperado y se estan activando los relojessiiiiii');

        activeClockLogin();
      }
      if (clientsScheduledController.closeIesperado == true &&
          loginController.isLoggingInCharge == false) {
        print(
            'Hubo un cierre inesperado y se estan activando los relojesDDDDDDDDDDDDDDDDDDDDD');
        activeClock();
      }

      if (clientsScheduledController.activeModifyTime == true) {
        //SI activeModifyTime =  TRUE SUMO TIEMPO
        print(
            'tiempo a sumar =  2 EL TIEMPO ACTUAL DEL RELOJ estoy entrando aqui');
        //aqui verifico qsi hay que agregarle el tiempo algun reloj
        print(
            'activeModifyTime SOY = ${clientsScheduledController.activeModifyTime} Y MANDE ESTE TIEMPO ${clientsScheduledController.modifyTime[clientsScheduledController.modifyTimeSpecific]}');
        int i = clientsScheduledController.modifyTimeSpecific;
        int value = clientsScheduledController
            .modifyTime[clientsScheduledController.modifyTimeSpecific];
        // Obtén la duración total del AnimationController
        Duration? duracionTotal = animationCont[i]!.duration;

// Obtén el tiempo transcurrido hasta ahora en minutos
        double tiempoTranscurrido =
            animationCont[i]!.value * duracionTotal!.inMinutes;

// Calcula el tiempo restante en minutos
        double tiempoRestante = duracionTotal.inMinutes - tiempoTranscurrido;

        print(
            'EL TIEMPO ACTUAL DEL RELOJ Tiempo duracionTotal: $duracionTotal');
        print(
            'EL TIEMPO ACTUAL DEL RELOJ Tiempo tiempoTranscurrido: ${tiempoTranscurrido.truncate()}');
        print('EL TIEMPO ACTUAL DEL RELOJ Tiempo restante: $tiempoRestante');

        int valueMin = tiempoRestante.truncate() + value;
        Duration nuevaDuracion = Duration(
          minutes: valueMin,
        );

        animationCont[i]!.duration = nuevaDuracion;
        print(
            'EL TIEMPO ACTUAL DEL RELOJ duracionSend YA sera valueMinuto :$valueMin');
        //aqui actualizar la variable
        //aqui es cuando agregan algun servicio
        //todo aqui poner el metodo
        loginController.getUpdateTime(valueMin, (i + 1),
            'build-homePage-i=${i + 1}'); //porque i comienza en 0

        animationCont[i]!.reset();
        animationCont[i]!.forward();
        print('EL TIEMPO ACTUAL DEL RELOJ RESETEADO YA');

        //preguntar que no venga del login
      }

      if (clientsScheduledController.activeModifyTimeRest == true) {
        if (clientsScheduledController.modifyTimeSpecificRest != -99) //reloj 1
        {
          print(
              'modificar time de mm 1 estoy aqui en el (clientsScheduledController.modifyTimeSpecificRest != -99)');
          int i = clientsScheduledController.modifyTimeSpecificRest;
          int value = clientsScheduledController.modifyTimeSpecificRestTIME;
          // Obtén la duración total del AnimationController
          Duration? duracionTotal = animationCont[i]!.duration;
          print('modificar time de mm i = $i');
          print('modificar time de mm value = $value');
// Obtén el tiempo transcurrido hasta ahora en minutos
          double tiempoTranscurrido =
              animationCont[i]!.value * duracionTotal!.inMinutes;

// Calcula el tiempo restante en minutos
          double tiempoRestante = duracionTotal.inMinutes - tiempoTranscurrido;
          int valueMin = tiempoRestante.truncate() - value;
          if (valueMin <= 0) {
            valueMin = 1;
          }
          Duration nuevaDuracion = Duration(
            minutes: valueMin,
          );

          animationCont[i]!.duration = nuevaDuracion;
          print('EL TIEMPO ACTUAL DEL RELOJ duracionSend YA:$nuevaDuracion');
          //aqui actualizar la variable
          //aqui es cuando eliminan algun servicio
          //todo aqui poner el metodo
          loginController.getUpdateTime(
              valueMin, 1, 'build-homePage-1'); //debe ser el reloj 1
          animationCont[i]!.reset();
          animationCont[i]!.forward();
          print('EL TIEMPO ACTUAL DEL RELOJ RESETEADO YA');
        }

        if (clientsScheduledController.modifyTimeSpecificRest1 != -99) //reloj 2
        {
          print(
              'modificar time de mm 1 estoy aqui en el (clientsScheduledController.modifyTimeSpecificRest1 != -99)');
          int i = clientsScheduledController.modifyTimeSpecificRest1;
          int value = clientsScheduledController.modifyTimeSpecificRestTIME1;
          // Obtén la duración total del AnimationController
          Duration? duracionTotal = animationCont[i]!.duration;

// Obtén el tiempo transcurrido hasta ahora en minutos
          double tiempoTranscurrido =
              animationCont[i]!.value * duracionTotal!.inMinutes;

// Calcula el tiempo restante en minutos
          double tiempoRestante = duracionTotal.inMinutes - tiempoTranscurrido;
          int valueMin = tiempoRestante.truncate() - value;
          if (valueMin <= 0) {
            valueMin = 1;
          }
          Duration nuevaDuracion = Duration(
            minutes: valueMin,
          );

          animationCont[i]!.duration = nuevaDuracion;
          print('EL TIEMPO ACTUAL DEL RELOJ duracionSend YA:$nuevaDuracion');
          //aqui actualizar la variable
          //aqui es cuando eliminan algun servicio
          //todo aqui poner el metodo
          loginController.getUpdateTime(
              valueMin, 2, 'build-homePage-1'); //debe ser el reloj 2
          animationCont[i]!.reset();
          animationCont[i]!.forward();
          print('EL TIEMPO ACTUAL DEL RELOJ RESETEADO YA');
        }
        if (clientsScheduledController.modifyTimeSpecificRest2 != -99) //reloj 3
        {
          print(
              'modificar time de mm 1 estoy aqui en el (clientsScheduledController.modifyTimeSpecificRest2 != -99)');
          int i = clientsScheduledController.modifyTimeSpecificRest2;
          int value = clientsScheduledController.modifyTimeSpecificRestTIME2;
          // Obtén la duración total del AnimationController
          Duration? duracionTotal = animationCont[i]!.duration;

// Obtén el tiempo transcurrido hasta ahora en minutos
          double tiempoTranscurrido =
              animationCont[i]!.value * duracionTotal!.inMinutes;

// Calcula el tiempo restante en minutos
          double tiempoRestante = duracionTotal.inMinutes - tiempoTranscurrido;
          int valueMin = tiempoRestante.truncate() - value;
          if (valueMin <= 0) {
            valueMin = 1;
          }
          Duration nuevaDuracion = Duration(
            minutes: valueMin,
          );

          animationCont[i]!.duration = nuevaDuracion;
          print('EL TIEMPO ACTUAL DEL RELOJ duracionSend YA:$nuevaDuracion');
//aqui actualizar la variable
          //aqui es cuando eliminan algun servicio
          //todo aqui poner el metodo
          loginController.getUpdateTime(
              valueMin, 3, 'build-homePage-3'); //debe ser el reloj 3
          animationCont[i]!.reset();
          animationCont[i]!.forward();
          print('EL TIEMPO ACTUAL DEL RELOJ RESETEADO YA');
        }

        if (clientsScheduledController.modifyTimeSpecificRest3 != -99) //reloj 4
        {
          print(
              'modificar time de mm 1 estoy aqui en el (clientsScheduledController.modifyTimeSpecificRest3 != -99)');
          int i = clientsScheduledController.modifyTimeSpecificRest3;
          int value = clientsScheduledController.modifyTimeSpecificRestTIME3;
          // Obtén la duración total del AnimationController
          Duration? duracionTotal = animationCont[i]!.duration;

// Obtén el tiempo transcurrido hasta ahora en minutos
          double tiempoTranscurrido =
              animationCont[i]!.value * duracionTotal!.inMinutes;

// Calcula el tiempo restante en minutos
          double tiempoRestante = duracionTotal.inMinutes - tiempoTranscurrido;
          int valueMin = tiempoRestante.truncate() - value;
          if (valueMin <= 0) {
            valueMin = 1;
          }
          Duration nuevaDuracion = Duration(
            minutes: valueMin,
          );

          animationCont[i]!.duration = nuevaDuracion;
          print('EL TIEMPO ACTUAL DEL RELOJ duracionSend YA:$nuevaDuracion');
//aqui actualizar la variable
          //aqui es cuando eliminan algun servicio
          //todo aqui poner el metodo
          loginController.getUpdateTime(
              valueMin, 4, 'build-homePage-4'); //debe ser el reloj 4
          animationCont[i]!.reset();
          animationCont[i]!.forward();
          print('EL TIEMPO ACTUAL DEL RELOJ RESETEADO YA');
        }

        //preguntar que no venga del login
      }

      //AQUI ESCUCHANDO PARA SABER SI TENGO QUE DETENER O REAUNUDAR LOS TIMER
      if (clientsScheduledController.clockchanges == true) {
        //
        for (var i = 0;
            i < clientsScheduledController.pausResumeClock.length;
            i++) {
          int? value = clientsScheduledController.pausResumeClock[i];
          //
          if (value != -99) {
            if (value == 0) //hay que pausarlo
            {
              if (i == 0) {
                clientsScheduledController.animationController1!.stop();
                print('PAUSE EL RELOJ 1');
              }
              if (i == 1) {
                clientsScheduledController.animationController2!.stop();
                print('PAUSE EL RELOJ 2');
              }
              if (i == 2) {
                clientsScheduledController.animationController3!.stop();
                print('PAUSE EL RELOJ 3');
              }
              if (i == 3) {
                clientsScheduledController.animationController4!.stop();
                print('PAUSE EL RELOJ 4');
              }
            }
          }
        } //fin del for
      }

      String firstName = '';
      // //todo AQUI DETENGO LOS TIMER QUE NO ESTAN VISIBLES

      if (clientsScheduledController.clientsScheduledNext != null) {
        String fullName =
            clientsScheduledController.clientsScheduledNext!.client_name!;
        //todo1                // Dividir el nombre completo por espacios
        List<String> partsName =
            fullName.split(" "); // Tomar los primeros dos nombres (si existen)
        firstName = partsName.isNotEmpty ? partsName[0] : "";
        // String secondName = partsName.length > 1 ? partsName[1] : "";
      }

      //clientsScheduledController.animationControllerInitial!.forward();

      // print('clientes asistiendo Antes de addPostFrameCallback');

      // //todo IMPORTANTE ESTA FUNCION SE EJECUTA DESPUES QUE SE CREA EL WIDGET
      // //todo IMPORTANTE ESTA FUNCION SE EJECUTA DESPUES QUE SE CREA EL WIDGET
      // WidgetsBinding.instance.addPostFrameCallback((_) async {
      //   //   print('cargando aqui-10');
      //   // print(
      //   //     'entrando aqui para mandar notificacion al barbero clientsScheduledController.clientNew : ${clientsScheduledController.clientNew}');

      //   //aqui solo debe entrar cuando o se agregan servicios o cuando se eliminan
      //  //     'clientes asistiendo ENTRE A DESTRUIR LAS VARIABLES DEL TIEMPO ASIGNADO activeModifyTime SOY = ${clientsScheduledController.activeModifyTime}');
      // });
      // print('clientes asistiendo Después de addPostFrameCallback');
      return Column(
        //Cart anaranjado grande inicial que tiene el cronometro
        children: [
          Expanded(
              flex: loginController.androidInfoDisplay! >=
                      6.6 //propiedades de telefone
                  ? 12
                  : 13,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: clientsScheduledController.item.isEmpty &&
                            (clientsScheduledController.clientsScheduledNext ==
                                    null ||
                                (clientsScheduledController
                                            .boolFilterShowNext ==
                                        false &&
                                    clientsScheduledController.errorHome !=
                                        -99)) &&
                            loginController.usserPermissionQr == 1
                        ? const SizedBox(
                            height: 45,
                          )
                        : (clientsScheduledController
                                            .clientsScheduledListLength >
                                        0 ||
                                    clientsScheduledController.errorHome ==
                                        -99) &&
                                loginController.usserPermissionQr == 1
                            ? Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  color: Colors.white,
                                  //color: Color(0xFFFDAE2A),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    /*todo texto arriba */ Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, top: 5),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          clientsScheduledController
                                                  .item.isEmpty
                                              ? 'Cliente en espera'
                                              : 'Atendiendo ${clientsScheduledController.item.length} cliente(s)',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color:
                                                Color.fromARGB(255, 82, 81, 81),
                                          ),
                                        ),
                                      ),
                                    ),

                                    /*CRONOMETRO*/ Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      //todo AQUI LA LOGICA AL MOSTRAR LOS TIMER
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              //AQUI MUESTRA LOS TIMER DE LOS CLIENTES QUE ESTE ATENDIENDO
                                              if (clientsScheduledController
                                                  .item.isNotEmpty) ...[
                                                for (int i = 0;
                                                    i <
                                                        clientsScheduledController
                                                            .item.length;
                                                    i++) ...[
                                                  cardTimer(
                                                    clientsList[
                                                            clientsScheduledController
                                                                .item[i]]!
                                                        .reservation_id!,
                                                    i,
                                                    clientsList[
                                                            clientsScheduledController
                                                                .item[i]]!
                                                        .attended!,
                                                    clientsList[
                                                            clientsScheduledController
                                                                .item[i]]!
                                                        .car_id!,
                                                    clientsList[
                                                            clientsScheduledController
                                                                .item[i]]!
                                                        .client_image!,
                                                    UniqueKey(),
                                                    clientsList[
                                                            clientsScheduledController
                                                                .item[i]]!
                                                        .client_name!,
                                                    clientsScheduledController,
                                                    animationCont[
                                                        clientsScheduledController
                                                            .item[i]]!,
                                                  ),
                                                ],
                                              ]
                                              //SI NO ESTA ATENDIENDOA NADIE Y HAY GENTE EN LA COLA ESPERANDO CARGA EL TIMER INICIAL
                                              else if (clientsScheduledController
                                                      .clientsScheduledNext !=
                                                  null) ...[
                                                //AQUI VERIFICO SI YA ESCANEO EL CODIGO QR
                                                if (loginController
                                                            .codigoQrValid() ==
                                                        true &&
                                                    clientsScheduledController
                                                        .item.isEmpty) ...[
                                                  cardTimer2(
                                                    UniqueKey(),
                                                    'Esperando',
                                                    clientsScheduledController,
                                                    clientsScheduledController
                                                        .animationControllerInitial!,
                                                  ),
                                                ] else if (loginController
                                                        .usserPermissionQr ==
                                                    2) ...[
                                                  const Center(
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 35,
                                                        ),
                                                        Text(
                                                          'Debe de esperar la respuesta',
                                                          style: TextStyle(
                                                              // color: Colors.white,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      39,
                                                                      39,
                                                                      39),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        Text(
                                                          'a su solicitud',
                                                          style: TextStyle(
                                                              //color: Colors.white,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      39,
                                                                      39,
                                                                      39),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 45,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ] else ...[
                                                  const Center(
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 35,
                                                        ),
                                                        Text(
                                                          'Debe de escanear el código Qr ',
                                                          style: TextStyle(
                                                              // color: Colors.white,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      39,
                                                                      39,
                                                                      39),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        Text(
                                                          'para atender clientes',
                                                          style: TextStyle(
                                                              //color: Colors.white,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      39,
                                                                      39,
                                                                      39),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 45,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ]
                                              ] else ...[
                                                const SizedBox(
                                                  height: 45,
                                                ),
                                              ]
                                            ]),
                                      ),
                                      //FIN CLIENTES QUE ESTAN EN COLA
                                    ),
                                    //todo CLIENTES QUE ESTAN EN COLA

                                    //FIN CLIENTES QUE ESTAN EN COLA
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: 80,
                              ),
                  ),
                  clientsScheduledController.boolControlVision == true &&
                          loginController.usserPermissionQr == 1
                      ? clientsScheduledController.boolFilterShowNext == true ||
                              clientsScheduledController.errorHome == -99
                          ? cardClientTails(clientsScheduledController, context,
                              firstName, animationCont)
                          :

                          //si hubiera algien en cola
                          (clientsScheduledController
                                      .clientsScheduledListLengthTail >
                                  0)
                              ? const Column(
                                  children: [
                                    Text(
                                      'Cliente atendiéndose',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 82, 81, 81),
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      'Esperando para mostrar el siguiente',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 82, 81, 81),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )
                              : const Text('No hay clientes en cola.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 82, 81, 81),
                                  ))
                      : loginController.usserPermissionQr == 2
                          ? const Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 35,
                                  ),
                                  Text(
                                    'Debe de esperar la respuesta',
                                    style: TextStyle(
                                        // color: Colors.white,
                                        color: Color.fromARGB(255, 39, 39, 39),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'a su solicitud',
                                    style: TextStyle(
                                        //color: Colors.white,
                                        color: Color.fromARGB(255, 39, 39, 39),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 45,
                                  ),
                                ],
                              ),
                            )
                          : loginController.usserPermissionQr == null
                              ? Text('')
                              : const Column(
                                  children: [
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Center(
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Color(0xFFFDAE2A),
                                          strokeWidth: 3,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                ],
              )),
          Expanded(
              flex: 13, // 85% del espacio disponible para esta parte
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 1),
                child: Container(
                  color: const Color.fromARGB(255, 231, 232, 234),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Dashboard',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 82, 81, 81),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            loginController.setIsLoading == true
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFFDAE2A),
                                      strokeWidth: 3,
                                    ),
                                  )
                                : Text(''),
                            Text('                        '),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: (MediaQuery.of(context).size.width *
                                      0.46), //Tamaño de los Cards
                                  height: loginController.androidInfoWidth! >=
                                          867.42 //propiedades de telefone
                                      ? (MediaQuery.of(context).size.height *
                                          0.198)
                                      : (MediaQuery.of(context).size.height *
                                          0.170),
                                  child: cartsHome(
                                      context,
                                      12,
                                      const Color(0xFF19CF9E),
                                      const Color.fromARGB(255, 231, 233, 233),
                                      'Agenda',
                                      'Clientes Agendados',
                                      Icons.perm_contact_calendar),
                                ),
                                InkWell(
                                  onTap: () async {
                                    Get.dialog(
                                      const Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFFFDAE2A),
                                        ),
                                      ),
                                      barrierDismissible: false,
                                    ); //Get.back();
                                    await coexCont.fetchEstadist0();
                                    Get.back();
                                    pagesConfigC.onTabTapped(
                                        3); //index = 3 -> /StatisticPage
                                  },
                                  child: cartsHome(
                                      context,
                                      12,
                                      const Color(0xFF4470F3),
                                      Color.fromARGB(255, 231, 233, 233),
                                      'Estadísticas',
                                      'Revisa Tus Ingresos',
                                      Icons.bar_chart),
                                ),
                              ],
                            ),
                            SizedBox(
                              height:
                                  (MediaQuery.of(context).size.height * 0.01),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () async {},
                                  child: cartsHome(
                                      context,
                                      12,
                                      const Color(0xFFFF6750),
                                      Color.fromARGB(255, 231, 233, 233),
                                      'Notificaciones',
                                      'Tus Notificaciones',
                                      Icons.notifications),
                                ),
                                InkWell(
                                  onTap: () async {},
                                  child: cartsHome(
                                      context,
                                      12,
                                      const Color(0xFFFDAE2A),
                                      Color.fromARGB(255, 231, 233, 233),
                                      'Convivencia',
                                      'Cumplimiento de Reglas',
                                      Icons.star),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ],
      );
    });
    //todoooooooooooooooooooooooooooooooooooooooooo
  }

  cardClientTails(
      ClientsScheduledController clientsScheduledController2,
      BuildContext context,
      String firstName,
      List<AnimationController?> animationCont) {
    return GetBuilder<ClientsScheduledController>(
        builder: (clientsScheduledControllerE) {
      return Padding(
        padding: const EdgeInsets.only(
          left: 8,
          right: 8,
        ),
        child: FittedBox(
            fit: BoxFit.contain,
            child: clientsScheduledControllerE.clientsScheduledNext != null
                ? Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: (MediaQuery.of(context).size.height * 0.115),
                          width: (MediaQuery.of(context).size.width * 0.20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white, // Color blanco para el borde
                              width:
                                  1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                            ),
                            color: Color(0xFFFF6750),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(18)),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color(
                                  0xFFFF6750), // Color de fondo en verde
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16.0), // Ajusta el radio según tus necesidades
                              ),
                            ),
                            onPressed: () async {
                              if (clientsScheduledController.errorHome != -99) {
                                if (loginController.codigoQrValid() == true &&
                                    loginController.usserPermissionQrAntes ==
                                        1) {
                                  clientsScheduledControllerE
                                      .setBoolFilterShowNext(false);
                                  clientsScheduledControllerE
                                      .setBoolControlVision(false);
                                  // int resulButton = 0;
                                  // resulButton = loginController.handleButtonClick(
                                  //     clientsScheduledController
                                  //         .clientsScheduledNext!.reservation_id);
                                  // if (resulButton == 1) {
                                  notiController.storeNotification(
                                      'Solicitud de rechazo',
                                      loginController.branchIdLoggedIn,
                                      loginController.idProfessionalLoggedIn,
                                      'EL profesional "${loginController.nameUserLoggedIn}" está rechazando a "${clientsScheduledControllerE.clientsScheduledNext!.client_name}"',
                                      'Ambos'); //esto es para quele llegue a coordinador y encargado
                                  int rest =
                                      await clientsScheduledControllerE
                                          .acceptOrRejectClient(
                                              clientsScheduledControllerE
                                                  .clientsScheduledNext!
                                                  .reservation_id,
                                              3,
                                              loginController
                                                  .tokenUserLoggedIn);
                                  if (rest == 1) {
                                    LocalStorage.prefs
                                        .setInt('valueClockIni', 180);
                                    clientsScheduledController
                                        .setTotalTimeInitial(180);
                                    LocalStorage.prefs
                                        .setBool('valueClockActiv', false);

                                    clientsScheduledController
                                        .animationControllerInitial!
                                      ..duration = Duration(seconds: 180)
                                      ..reset()
                                      ..stop();
                                    loginController.setCodigoQrValid(2);
                                  } else {
                                    loginController.setCodigoQrValid(1);
                                  }

                                  // clientsScheduledControllerE
                                  //     .setBoolControlVision(true);

                                  //}
                                } else if (loginController.usserPermissionQr ==
                                    2) {
                                  Get.snackbar(
                                    'Mensaje',
                                    'Debe de esperar la respuesta a su solicitud',
                                    duration:
                                        const Duration(milliseconds: 2500),
                                    backgroundColor: const Color.fromARGB(
                                        118, 255, 255, 255),
                                    showProgressIndicator: true,
                                    progressIndicatorBackgroundColor:
                                        const Color.fromARGB(
                                            255, 203, 205, 209),
                                    progressIndicatorValueColor:
                                        const AlwaysStoppedAnimation(
                                            Color(0xFFFDAE2A)),
                                    overlayBlur: 3,
                                  );
                                } else {
                                  Get.snackbar(
                                    'Mensaje',
                                    'Debe de escanear el código Qr de entrada',
                                    duration:
                                        const Duration(milliseconds: 2500),
                                    backgroundColor: const Color.fromARGB(
                                        118, 255, 255, 255),
                                    showProgressIndicator: true,
                                    progressIndicatorBackgroundColor:
                                        const Color.fromARGB(
                                            255, 203, 205, 209),
                                    progressIndicatorValueColor:
                                        const AlwaysStoppedAnimation(
                                            Color(0xFFFDAE2A)),
                                    overlayBlur: 3,
                                  );
                                }
                              } else {
                                //mostrar mensaje de error de conexion
                                loginController.showConnectionError();
                                await Future.delayed(
                                    Duration(milliseconds: 1000));
                                Get.snackbar(
                                  'Mensaje',
                                  'Vuelva a intentarlo, hubo problema de conexión',
                                  duration: const Duration(milliseconds: 2500),
                                  backgroundColor:
                                      const Color.fromARGB(118, 255, 255, 255),
                                  showProgressIndicator: true,
                                  progressIndicatorBackgroundColor:
                                      const Color.fromARGB(255, 203, 205, 209),
                                  progressIndicatorValueColor:
                                      const AlwaysStoppedAnimation(
                                          Color(0xFFFDAE2A)),
                                  overlayBlur: 3,
                                );
                              }
                            },
                            child: Icon(
                              MdiIcons.thumbDownOutline,
                              color: Colors.white,
                              size: (MediaQuery.of(context).size.height * 0.04),
                            ),
                          ),
                        ),
                        Container(
                          height: (MediaQuery.of(context).size.height * 0.115),
                          width: (MediaQuery.of(context).size.width * 0.8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const Icon(
                                          Icons.person,
                                          color: const Color.fromARGB(
                                              255, 43, 44, 49),
                                          size: 22,
                                        ),
                                        Text(
                                          clientCord.truncateText(
                                              firstName, 13),
                                          softWrap: true,
                                          style: const TextStyle(
                                              height: 1.0,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                          //AQUI ETSA EL TIEMPO TOTAL DEL SERVICIO
                                          (clientsScheduledControllerE
                                              .clientsScheduledNext!
                                              .total_time!),
                                          style: const TextStyle(
                                            height: 1.2,
                                            fontSize: 16,
                                            color: Color.fromARGB(180, 0, 0, 0),
                                          )),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: clientsScheduledControllerE
                                                .serviceCustomerSelected
                                                .length >
                                            2
                                        ? 2
                                        : clientsScheduledControllerE
                                            .serviceCustomerSelected.length,
                                    itemBuilder: (context, index) => Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  MdiIcons.menu,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  clientsScheduledControllerE
                                                      .serviceCustomerSelected[
                                                          index]
                                                      .name,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: (MediaQuery.of(context).size.height * 0.115),
                          width: (MediaQuery.of(context).size.width * 0.20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    Colors.white, // Color blanco para el borde
                                width:
                                    1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                              ),
                              color: const Color(0xFF19CF9E),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(18))),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color(
                                  0xFF19CF9E), // Color de fondo en verde
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16.0), // Ajusta el radio según tus necesidades
                              ),
                            ),
                            onPressed: () async {
                              //AQUI VEO SI YA ESCANEO EL CODIGO QR Y ESTA EN EL LOCAL
                              if (clientsScheduledController.errorHome != -99) {
                                if (loginController.codigoQrValid() == true &&
                                    loginController.usserPermissionQrAntes ==
                                        1 &&
                                    clientsScheduledControllerE
                                            .clientsScheduledNext !=
                                        null &&
                                    clientsScheduledControllerE
                                            .clientsScheduledNext!
                                            .reservation_id! >
                                        0) {
                                  loginController.setMakeCall(false);
                                  clientsScheduledControllerE
                                      .setBoolControlVision(false);
                                  clientsScheduledControllerE
                                      .setBoolFilterShowNext(false);
                                  //aqui poner que muestre un cargando

                                  int resulButton = 0;
                                  resulButton =
                                      loginController.handleButtonClick(
                                          clientsScheduledControllerE
                                              .clientsScheduledNext!
                                              .reservation_id!);
                                  if (resulButton == 1) {
                                    //aqui manda aceptar, es decir atender este cliente
                                    //aqui intento hacer que cuando acepte no ce vea el siguiente en la lista
                                    // nunca a no ser que luego lo ponga en true porque tenga services simultaneos

                                    //
                                    clientsScheduledControllerE.clientsWaiting(
                                        false); //este es para saber si hay algun cliente esperando para mandar la notificación
                                    // detengo el timer de 2 minutos

                                    LocalStorage.prefs
                                        .setInt('valueClockIni', 180);
                                    clientsScheduledController
                                        .setTotalTimeInitial(180);
                                    LocalStorage.prefs
                                        .setBool('valueClockActiv', false);

                                    clientsScheduledController
                                        .animationControllerInitial!
                                      ..duration = Duration(seconds: 180)
                                      ..reset()
                                      ..stop();
                                    // detengo todos los timers que deben detenerse
                                    for (int j = 0;
                                        j <
                                            clientsScheduledControllerE
                                                .itemDel.length;
                                        j++) {
                                      animationCont[clientsScheduledControllerE
                                              .itemDel[j]]!
                                          .stop();
                                      animationCont[clientsScheduledControllerE
                                              .itemDel[j]]!
                                          .reset();
                                    }
                                    await clientsScheduledControllerE
                                        .newClientAttended(
                                            clientsScheduledControllerE
                                                .clientsScheduledNext!,
                                            clientsScheduledControllerE
                                                .availability);

                                    //
                                    //
                                    //
                                    //HACE LAS VERIFICACIONES NECESARIAS PARA ACTIVAR LOS RELOJES QUE NECESITEN SER ACTIVADOS
                                    if (clientsScheduledControllerE.busyClock ==
                                        0) {
                                      animationCont[0]!.duration = Duration(
                                          seconds: clientsScheduledControllerE
                                              .timeClientsAttended1!);
                                      animationCont[0]!.forward();
                                    } else if (clientsScheduledControllerE
                                            .busyClock ==
                                        1) {
                                      animationCont[1]!.duration = Duration(
                                          seconds: clientsScheduledControllerE
                                              .timeClientsAttended2!);
                                      animationCont[1]!.forward();
                                    } else if (clientsScheduledControllerE
                                            .busyClock ==
                                        2) {
                                      animationCont[2]!.duration = Duration(
                                          seconds: clientsScheduledControllerE
                                              .timeClientsAttended3!);
                                      animationCont[2]!.forward();
                                    } else if (clientsScheduledControllerE
                                            .busyClock ==
                                        3) {
                                      animationCont[3]!.duration = Duration(
                                          seconds: clientsScheduledControllerE
                                              .timeClientsAttended4!);
                                      animationCont[3]!.forward();
                                    }

                                    //el valor 1 es que es que le va atender y por ende va ser el que esta atendiendo
                                    await clientsScheduledControllerE
                                        .acceptOrRejectClient(
                                            clientsScheduledControllerE
                                                .clientsScheduledNext!
                                                .reservation_id,
                                            1,
                                            loginController.tokenUserLoggedIn);
                                  }
                                  loginController.setMakeCall(true);
                                  // clientsScheduledControllerE
                                  //     .setBoolControlVision(true);
                                } else if (loginController.usserPermissionQr ==
                                    2) {
                                  Get.snackbar(
                                    'Mensaje',
                                    'Debe de esperar la respuesta a su solicitud',
                                    duration:
                                        const Duration(milliseconds: 2500),
                                    backgroundColor: const Color.fromARGB(
                                        118, 255, 255, 255),
                                    showProgressIndicator: true,
                                    progressIndicatorBackgroundColor:
                                        const Color.fromARGB(
                                            255, 203, 205, 209),
                                    progressIndicatorValueColor:
                                        const AlwaysStoppedAnimation(
                                            Color(0xFFFDAE2A)),
                                    overlayBlur: 3,
                                  );
                                } else {
                                  Get.snackbar(
                                    'Mensaje',
                                    'Debe de escanear el código Qr de entrada',
                                    duration:
                                        const Duration(milliseconds: 2500),
                                    backgroundColor: const Color.fromARGB(
                                        118, 255, 255, 255),
                                    showProgressIndicator: true,
                                    progressIndicatorBackgroundColor:
                                        const Color.fromARGB(
                                            255, 203, 205, 209),
                                    progressIndicatorValueColor:
                                        const AlwaysStoppedAnimation(
                                            Color(0xFFFDAE2A)),
                                    overlayBlur: 3,
                                  );
                                }
                              } else {
                                //mostrar mensaje de error de conexion
                                loginController.showConnectionError();
                                await Future.delayed(
                                    Duration(milliseconds: 1000));
                                Get.snackbar(
                                  'Mensaje',
                                  'Vuelva a intentarlo, hubo problema de conexión',
                                  duration: const Duration(milliseconds: 2500),
                                  backgroundColor:
                                      const Color.fromARGB(118, 255, 255, 255),
                                  showProgressIndicator: true,
                                  progressIndicatorBackgroundColor:
                                      const Color.fromARGB(255, 203, 205, 209),
                                  progressIndicatorValueColor:
                                      const AlwaysStoppedAnimation(
                                          Color(0xFFFDAE2A)),
                                  overlayBlur: 3,
                                );
                              }
                            },
                            child: Icon(
                              MdiIcons.thumbUpOutline,
                              color: Colors.white,
                              size: (MediaQuery.of(context).size.height * 0.04),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : (clientsScheduledController.clientsScheSalon == 0) &&
                        clientsScheduledControllerE.clientsScheduledNext == null
                    ? const SizedBox(
                        height: 100,
                        child: Center(
                          child: Text('No hay clientes en cola',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Color.fromARGB(255, 82, 81, 81),
                              )),
                        ),
                      )
                    : loginController.usserPermissionQr == 2
                        ? const Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 35,
                                ),
                                Text(
                                  'Debe de esperar la respuesta',
                                  style: TextStyle(
                                      // color: Colors.white,
                                      color: Color.fromARGB(255, 39, 39, 39),
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  'a su solicitud',
                                  style: TextStyle(
                                      //color: Colors.white,
                                      color: Color.fromARGB(255, 39, 39, 39),
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 45,
                                ),
                              ],
                            ),
                          )
                        : SizedBox(width: 100, height: 100, child: Text(''))),
      );
    });
  }

  //todo9
  cardTimer(
    int idreservation,
    int index,
    int attend,
    int carrId,
    String imag,
    Key uniqueKey,
    String name,
    ClientsScheduledController clientsScheduledController,
    AnimationController _animationController,
  ) {
    if (attend == 4 || attend == 5) //esta con el tecnico
    {
      // aqui parar el reloj
    }
    String segundos = "";
    // Color colorInicial = Colors.white;
    Color colorInicial = Colors.white;
    Color colorInicialCirculo = const Color(0xFFFDAE2A);
    double fontSizeText = (MediaQuery.of(context).size.width * 0.030);
    // Dividir el nombre completo por espacios

    List<String> partsName =
        name.split(" "); // Tomar los primeros dos nombres (si existen)
    String firstName = partsName.isNotEmpty ? partsName[0] : "";
    // String secondName = partsName.length > 1 ? partsName[1] : "";
    int hoursN = 0;
    int minutesN = 0;
    String formattedMinutes = '00';

    return InkWell(
      onTap: () async {
        // Comprobar si la animación está en pausa
        // bool isPaused = _animationController.isAnimating && !_animationController.isCompleted;
        if (clientsScheduledController.errorHome != -99) {
          bool isPaused = _animationController.isAnimating;
          // Comprobar si la animación ha completado su duración
          bool isCompleted = _animationController.isCompleted;
          print('este relojo esta en:$isPaused');

          // if (isPaused == true || isCompleted == true) {
          if (isPaused == true || isCompleted) {
            //aqui llamar un metodo que me diga que attend es, y verificar
            //VA A EJECUTARSE SI NO ESTA CON EL TECNICO
            int resulButton = 0;
            resulButton = loginController.handleButtonClickModal(idreservation);
            if (resulButton == 1) {
              Get.dialog(
                const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFDAE2A),
                  ),
                ),
                barrierDismissible: false,
              );
              //limpio la lista que controla que se de un solo click al seleccionar los servicios
              loginController.inTheClock(true);
              loginController.handleButtonClickServiceClear();
              serviceControll.clearSelectService();
              serviceControll.clearSelectServiceNew();
              chopCont.idServiceCart.clear();
              chopCont.requestDeleteOrder.clear();

              if (isPaused == true || isCompleted == true) {
                //aqui si el reloj esta detenido es que esta con el tecnico
                // aqui selecciono el cliente
                await clientsScheduledController.metodsClients(
                    index, carrId, idreservation, name, imag);
                print('ya páse por aqui-1');
                //todo FIN esto estaba en la pagina del modal al dar en Ver carrito

                //aqui devuelve en category_branch las categorias
                //aqui devuelve en category_products los productos por categorias
                await controllerProduct
                    .metdNewServiceProduct(loginController.branchIdLoggedIn,
                        loginController.idProfessionalLoggedIn, carrId)
                    .then((result1) async {
                  if (result1 == 1) {
                    print('ya páse por aqui-2');
                    loginController.setHandleButtonClickModal();
                    String clientName = name;
                    String urlImage = imag;
                    int reservationId = idreservation;
                    int carId = carrId;
                    //   _mostrarBottomSheet(          context);
                    //  showMyDialog(context);
                    print(
                        'LISTA2 _fetchServiceList Limpiando clientName:$clientName...reservationId:$reservationId....carId:$carId....urlImage:$urlImage');
                    await Future.delayed(const Duration(milliseconds: 500));
                    Get.back();
                    //Get.toNamed('/servicesProductsPage');
                    pagesConfigC.onTabTapped(1); //index = 1 -> /Clients
                  } else {
                    loginController.setHandleButtonClickModal();
                    Get.back();
                  }
                });
              } else {
                loginController.setHandleButtonClickModal();
                Get.back();
              }
            } //cierre del if de comprobacion que no lo llame vairas veces
          } else if (isPaused == false) {
            Get.snackbar(
              'Mensaje',
              'Este cliente está con el técnico, espere que regrese por favor...',
              duration: const Duration(milliseconds: 2500),
              backgroundColor: const Color.fromARGB(118, 255, 255, 255),
              showProgressIndicator: true,
              progressIndicatorBackgroundColor:
                  const Color.fromARGB(255, 203, 205, 209),
              progressIndicatorValueColor:
                  const AlwaysStoppedAnimation(Color(0xFFFDAE2A)),
              overlayBlur: 3,
            );
          }
        } else {
          //mostrar mensaje de error de conexion
          loginController.showConnectionError();
          await Future.delayed(Duration(milliseconds: 1000));
          Get.snackbar(
            'Mensaje',
            'Vuelva a intentarlo, hubo problema de conexión',
            duration: const Duration(milliseconds: 2500),
            backgroundColor: const Color.fromARGB(118, 255, 255, 255),
            showProgressIndicator: true,
            progressIndicatorBackgroundColor:
                const Color.fromARGB(255, 203, 205, 209),
            progressIndicatorValueColor:
                const AlwaysStoppedAnimation(Color(0xFFFDAE2A)),
            overlayBlur: 3,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 6, right: 6),
        child: Column(
          children: [
            Container(
              width: (clientsScheduledController.boolFilterShowNext == false &&
                          clientsScheduledController
                                  .clientsScheduledListLengthTail >
                              0) ||
                      (clientsScheduledController
                              .clientsScheduledListLengthTail ==
                          0)
                  ? 130
                  : 130,
              height: (clientsScheduledController.boolFilterShowNext == false &&
                          clientsScheduledController
                                  .clientsScheduledListLengthTail >
                              0) ||
                      (clientsScheduledController
                              .clientsScheduledListLengthTail ==
                          0)
                  ? 130
                  : 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                // border: Border.all(
                //   color: Color.fromARGB(255, 75, 24, 2),
                // ),
                color: const Color(0xFFFDAE2A),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Center(
                  child: AnimatedBuilder(
                    key: uniqueKey,
                    animation: _animationController,
                    builder: (context, child) {
                      final value = _animationController.value;
                      final remainingSeconds =
                          (_animationController.duration!.inSeconds -
                                  (_animationController.duration!.inSeconds *
                                      value))
                              .ceil();
                      int minutes = remainingSeconds ~/
                          60; // Calcula los minutos restantes
                      int seconds = remainingSeconds %
                          60; // Calcula los segundos restantes

                      if (seconds < 10) {
                        segundos = "0";
                      } else {
                        segundos = "";
                      }

                      if (minutes == 0 && seconds == 0) {
                        firstName = 'Terminó';
                        colorInicial = Colors.red;
                        colorInicialCirculo = Colors.white;
                        fontSizeText = 10;
                      }
                      print('cambioReloj - minutes:$minutes');
                      if (minutes > 59) {
                        // División entera para obtener las horas
                        hoursN = minutes ~/ 60;

                        // Resto de la división para obtener los minutos
                        minutesN = minutes % 60;

                        // Para asegurar que siempre se muestren dos dígitos
                        formattedMinutes = minutesN.toString().padLeft(2, '0');

                        print('cambioReloj - horasN: $hoursN');
                        print('cambioReloj - minutesN: $formattedMinutes');
                      }

                      return SizedBox(
                        width: clientsScheduledController.sizeClock,
                        height: clientsScheduledController.sizeClock,
                        child: Stack(
                          children: [
                            ShaderMask(
                              shaderCallback: (rect) {
                                return SweepGradient(
                                    startAngle: 0.0,
                                    endAngle: 3.14 * 2, //twoPi
                                    stops: [value, value],
                                    // 0.0 , 0.5 , 0.5 , 1.0
                                    center: Alignment.center,
                                    colors: [
                                      Colors.white,
                                      Color.fromARGB(255, 92, 91, 91)
                                          .withAlpha(100)
                                    ]).createShader(rect);
                              },
                              child: Container(
                                width: clientsScheduledController.sizeClock,
                                height: clientsScheduledController.sizeClock,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: Image.asset(
                                                "assets/images/radial_scale.png")
                                            .image)),
                              ),
                            ),
                            Center(
                              child: Container(
                                width:
                                    (clientsScheduledController.sizeClock) - 40,
                                height:
                                    (clientsScheduledController.sizeClock) - 40,
                                decoration: BoxDecoration(
                                    color: colorInicialCirculo,
                                    shape: BoxShape.circle),
                                child: Center(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        minutes > 59
                                            ? minutesN > 9
                                                ? Text(
                                                    '$hoursN:$minutesN:',
                                                    style: TextStyle(
                                                        fontSize:
                                                            (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.038), //todo2
                                                        fontFamily: GoogleFonts
                                                                .orbitron()
                                                            .fontFamily,
                                                        color: colorInicial,
                                                        fontWeight:
                                                            FontWeight.w900),
                                                  )
                                                : Text(
                                                    '$hoursN : $formattedMinutes :',
                                                    style: TextStyle(
                                                        fontSize:
                                                            (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.038), //todo2
                                                        fontFamily: GoogleFonts
                                                                .orbitron()
                                                            .fontFamily,
                                                        color: colorInicial,
                                                        fontWeight:
                                                            FontWeight.w900),
                                                  )
                                            : Text(
                                                '$minutes :',
                                                style: TextStyle(
                                                    fontSize:
                                                        (MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.038), //todo2
                                                    fontFamily:
                                                        GoogleFonts.orbitron()
                                                            .fontFamily,
                                                    color: colorInicial,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                        Text(
                                          "$segundos$seconds",
                                          style: TextStyle(
                                              fontSize: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.038),
                                              color: colorInicial,
                                              fontFamily: GoogleFonts.orbitron()
                                                  .fontFamily,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                firstName,
                style: const TextStyle(
                    fontSize: 18,
                    height: 1.3,
                    color: Color(0xFFFDAE2A),
                    fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //todo9
  cardTimer2(
    Key uniqueKey,
    String name,
    ClientsScheduledController clientsScheduledController,
    AnimationController _animationController,
  ) {
    String segundos = "";
    // Color colorInicial = Colors.white;
    Color colorInicial = Colors.white;
    Color colorInicialCirculo = const Color(0xFFFDAE2A);
    double fontSizeText = (MediaQuery.of(context).size.width * 0.030);
    // Dividir el nombre completo por espacios

    List<String> partsName =
        name.split(" "); // Tomar los primeros dos nombres (si existen)
    String firstName = partsName.isNotEmpty ? partsName[0] : "";
    // String secondName = partsName.length > 1 ? partsName[1] : "";
    LocalStorage.prefs.setBool('valueClockActiv', true);
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6),
      child: Column(
        children: [
          Container(
            width: (clientsScheduledController.boolFilterShowNext == false &&
                        clientsScheduledController
                                .clientsScheduledListLengthTail >
                            0) ||
                    (clientsScheduledController
                            .clientsScheduledListLengthTail ==
                        0)
                ? 130
                : 130,
            height: (clientsScheduledController.boolFilterShowNext == false &&
                        clientsScheduledController
                                .clientsScheduledListLengthTail >
                            0) ||
                    (clientsScheduledController
                            .clientsScheduledListLengthTail ==
                        0)
                ? 130
                : 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              // border: Border.all(
              //   color: Color.fromARGB(255, 75, 24, 2),
              // ),
              color: const Color(0xFFFDAE2A),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Center(
                child: AnimatedBuilder(
                  key: uniqueKey,
                  animation: _animationController,
                  builder: (context, child) {
                    final value = _animationController.value;
                    final remainingSeconds = (_animationController
                                .duration!.inSeconds -
                            (_animationController.duration!.inSeconds * value))
                        .ceil();
                    int minutes =
                        remainingSeconds ~/ 60; // Calcula los minutos restantes
                    int seconds =
                        remainingSeconds % 60; // Calcula los segundos restantes

                    if (seconds < 10) {
                      segundos = "0";
                    } else {
                      segundos = "";
                    }

                    if (minutes == 0 && seconds == 0) {
                      firstName = 'Terminó';
                      colorInicial = Colors.red;
                      colorInicialCirculo = Colors.white;
                      fontSizeText = 10;
                    }

                    return SizedBox(
                      width: clientsScheduledController.sizeClock,
                      height: clientsScheduledController.sizeClock,
                      child: Stack(
                        children: [
                          ShaderMask(
                            shaderCallback: (rect) {
                              return SweepGradient(
                                  startAngle: 0.0,
                                  endAngle: 3.14 * 2, //twoPi
                                  stops: [value, value],
                                  // 0.0 , 0.5 , 0.5 , 1.0
                                  center: Alignment.center,
                                  colors: [
                                    Colors.white,
                                    Color.fromARGB(255, 92, 91, 91)
                                        .withAlpha(100)
                                  ]).createShader(rect);
                            },
                            child: Container(
                              width: clientsScheduledController.sizeClock,
                              height: clientsScheduledController.sizeClock,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: Image.asset(
                                              "assets/images/radial_scale.png")
                                          .image)),
                            ),
                          ),
                          Center(
                            child: Container(
                              width:
                                  (clientsScheduledController.sizeClock) - 40,
                              height:
                                  (clientsScheduledController.sizeClock) - 40,
                              decoration: BoxDecoration(
                                  color: colorInicialCirculo,
                                  shape: BoxShape.circle),
                              child: Center(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '$minutes :',
                                        style: TextStyle(
                                            fontSize: (MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04), //todo2
                                            fontFamily: GoogleFonts.orbitron()
                                                .fontFamily,
                                            color: colorInicial,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      Text(
                                        "$segundos$seconds",
                                        style: TextStyle(
                                            fontSize: (MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04),
                                            color: colorInicial,
                                            fontFamily: GoogleFonts.orbitron()
                                                .fontFamily,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: firstName == 'Esperando'
                  ? Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        '$firstName...',
                        style: const TextStyle(
                            fontSize: 10,
                            height: 1.3,
                            color: Color(0xFFFDAE2A),
                            fontWeight: FontWeight.w900),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        firstName,
                        style: const TextStyle(
                            fontSize: 18,
                            height: 1.3,
                            color: Color(0xFFFDAE2A),
                            fontWeight: FontWeight.w600),
                      ),
                    )),
        ],
      ),
    );
  }

  Container cartsHome(
      BuildContext context,
      double borderRadiusValue,
      Color colorVariable,
      Color colorBottom,
      String titleCart,
      String descriptionTitleCart,
      iconCart) {
    return Container(
      width: (MediaQuery.of(context).size.width * 0.46), //Tamaño de los Cards
      height:
          loginController.androidInfoWidth! >= 867.42 //propiedades de telefone
              ? (MediaQuery.of(context).size.height * 0.198)
              : (MediaQuery.of(context).size.height * 0.170),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue)),
        color: colorVariable,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: colorVariable, // Color de fondo en verde
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                borderRadiusValue), // Ajusta el radio según tus necesidades
          ),
        ),
        onPressed: () async {
          if (titleCart == 'Agenda') {
            Get.dialog(
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFDAE2A),
                ),
              ),
              barrierDismissible: false,
            ); //Get.back();

            //todo optimización de codigo-cambio de ruta (anterior-fetchClientsScheduled)
            if (clientsScheduledController.errorHome == -99) {
              await Future.delayed(const Duration(milliseconds: 2000));
            }
            await clientsScheduledController.fetchClientsScheduledNew(
                loginController.idProfessionalLoggedIn,
                loginController.branchIdLoggedIn,
                'Agenda-Card',
                loginController.tokenUserLoggedIn);

            await Future.delayed(const Duration(milliseconds: 500));
            Get.back();
            pagesConfigC.onTabTapped(1); //index = 4 -> /CoexistencePage
          }
          if (titleCart == 'Convivencia') {
            Get.dialog(
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFDAE2A),
                ),
              ),
              barrierDismissible: false,
            ); //Get.back();
            // controllerLogin.setIsLoadingFor(true);
            await coexistenceController.fetchCoexistenceList();
            await Future.delayed(const Duration(milliseconds: 500));
            Get.back();
            pagesConfigC.onTabTapped(4); //index = 4 -> /CoexistencePage
          }
          if (titleCart == 'Estadísticas') {
            Get.dialog(
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFDAE2A),
                ),
              ),
              barrierDismissible: false,
            ); //Get.back();
            await coexCont.fetchEstadist0();
            await Future.delayed(const Duration(milliseconds: 500));
            Get.back();
            pagesConfigC.onTabTapped(3); //index = 3 -> /StatisticPage
          }
          if (titleCart == 'Notificaciones') {
            Get.dialog(
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFDAE2A),
                ),
              ),
              barrierDismissible: false,
            ); //Get.back();
            String typeEnv = '';

            if (loginController.chargeUserLoggedIn == 'Barbero y Encargado') {
              if (loginController.switchValue == false) //'Barbero'
              {
                typeEnv = 'Barbero';
              } else {
                typeEnv = 'Encargado';
              }
            } else {
              typeEnv = 'Barbero';
            }

            await notiController.fetchNotificationList(
                loginController.branchIdLoggedIn,
                loginController.idProfessionalLoggedIn,
                typeEnv,
                'Cart home',
                loginController.tokenUserLoggedIn);
            await Future.delayed(const Duration(milliseconds: 500));
            pagesConfigC.onTabTapped(2); //index = 2 -> /NotificationsPageProf
            Get.back();
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 20, // Tamaño del CircleAvatar
                  backgroundColor:
                      colorBottom, // Color de fondo del CircleAvatar
                  child: Icon(
                    iconCart, // Icono que deseas mostrar
                    size: 30, // Tamaño del icono
                    color: colorVariable, // Color del icono
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleCart,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 0.4),
                  ),
                  Text(
                    descriptionTitleCart,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        height: 1.5,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
