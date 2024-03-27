import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Models/clientsScheduled_model.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/Views/coordinator/coexistencePageCoordinator.dart';

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final ClientsScheduledController clientsScheduledController =
      Get.find<ClientsScheduledController>();

  final PagesConfigController pagesConfigC = Get.find<PagesConfigController>();

  final LoginController loginController = Get.find<LoginController>();

  final CoexistenceController coexistenceController =
      Get.put(CoexistenceController());
  NotificationController notiController = Get.find<NotificationController>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    //AQUI ME DEVUELVE A Q CLIENTE LE SIGUE Y ACUAL MOSTRAR EN LA COLA
    clientsScheduledController.filterShowNext();
    //clientsScheduledController.filterShowCardTimer();//todo ahora comente a ver que pasa

    //INICIALIZANDO CONTROLES DE LOS RELOJES
    clientsScheduledController.animationControllerInitial = AnimationController(
      vsync: this,
      duration: Duration(seconds: clientsScheduledController.totalTimeInitial),
    );
    //clientsScheduledController.animationControllerInitial!.forward();
    clientsScheduledController.animationControllerInitial!.forward();
// Inicia la animación
    clientsScheduledController.animationControllerInitial!
        .addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (clientsScheduledController.noncomplianceProfessional['Tiempo'] !=
                0 &&
            loginController.usserPermissionQr == 1 &&
            clientsScheduledController.clientsScheduledListLength > 0) {
          print(
              'inserto correctamente ********** .noncomplianceProfessional[]');
          //CADA VEZ QUE ENTRE AQUI INCULPLIO CON EL TIEMPO DE LLAMAR AL CLIENTE ANTES DE 3MIN
          String type = 'Tiempo';
          int branchId = loginController.branchIdLoggedIn!;
          int professionalId = loginController.idProfessionalLoggedIn!;
          int estado = 0; //es que incumplió
          clientsScheduledController.changeNoncomplianceP(
              type, branchId, professionalId, estado);
          //aqui llamar e insertar en las notificacione sque incumplio esta convivencia
          notiController.storeNotification(
              'Incumplimiento de convivencia',
              branchId,
              professionalId,
              'Tu tiempo de espera de 3 minutos para seleccionar al nuevo cliente en cola se ha agotado');
        }

        // La animación ha llegado al final, reiniciar
        clientsScheduledController.animationControllerInitial!.reset();
        clientsScheduledController.animationControllerInitial!.forward();
      } else {
        print(
            'inserto correctamente NO ENTRO ********** .noncomplianceProfessional[]');
      }
    });

    clientsScheduledController.animationController1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
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
//
//
//

//

//
//
//
//
//
  }

  @override
  void dispose() {
    clientsScheduledController.animationControllerInitial!.dispose();
    clientsScheduledController.animationController1!.dispose();
    clientsScheduledController.animationController2!.dispose();
    clientsScheduledController.animationController3!.dispose();
    clientsScheduledController.animationController4!.dispose();
    super.dispose();
  }

  void verifyingClockTime(
      ClientsScheduledController clientsScheduledController, int endingTime) {
    try {
      //este es para el reloj 1
      if (clientsScheduledController.clientsAttended1 != null) {
        if (clientsScheduledController.animationController1 != null &&
            clientsScheduledController.animationController1!.isAnimating) {
          print('object-1');
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
                double progress =
                    clientsScheduledController.animationController1!.value;
                int totalTimeInSeconds = clientsScheduledController
                    .timeClientsAttended1!; // Duración total del AnimationController en segundos
                int elapsedTimeInSeconds =
                    (progress * totalTimeInSeconds).round();
                int remainingTimeInSeconds =
                    totalTimeInSeconds - elapsedTimeInSeconds;
                int standbyTimeSeconds = endingTime * 60;
                // Verificar si faltan menos de 180 segundos (3 minutos) para terminar

                if (remainingTimeInSeconds <= standbyTimeSeconds) {
                  // Realizar alguna acción
                  print(
                      'object-Enviar mensaje que el tiempo de servicio esta por culminar, que solo le faltan 3 minutos');

                  int professionalId = loginController.idProfessionalLoggedIn!;
                  int branchId = loginController.branchIdLoggedIn!;

                  if ((idClient ==
                      clientsScheduledController.clientsAttended1?.client_id)) {
                    notiController.storeNotification(
                        '!Alerta',
                        branchId,
                        professionalId,
                        'El tiempo de servicio del cliente $nameClient se agotará en los próximos $endingTime minutos');
                    //llamo al metodo que me dice que para este cliente ya se envio una notificacion al barbero
                    clientsScheduledController.setNotificationClients1(1,
                        clientsScheduledController.clientsAttended1!.client_id);
                  }
                }
              }
            }
          }
        } else {
          print('object-2');
        }
      } else {
        clientsScheduledController.animationController1!.stop();
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
            //analizo si para este clientes ya se envio el mensaje para no repetirselo
            if (clientsScheduledController.notificationClients2 == null ||
                (clientsScheduledController.notificationClients2 != idClient &&
                    clientsScheduledController.notificationClients2 != null)) {
              if (clientsScheduledController.animationController2 != null) {
                double progress =
                    clientsScheduledController.animationController2!.value;
                int totalTimeInSeconds = clientsScheduledController
                    .timeClientsAttended2!; // Duración total del AnimationController en segundos
                int elapsedTimeInSeconds =
                    (progress * totalTimeInSeconds).round();
                int remainingTimeInSeconds =
                    totalTimeInSeconds - elapsedTimeInSeconds;
                int standbyTimeSeconds = endingTime * 60;
                // Verificar si faltan menos de 180 segundos (3 minutos) para terminar

                if (remainingTimeInSeconds <= standbyTimeSeconds) {
                  // Realizar alguna acción
                  print(
                      'object-Enviar mensaje que el tiempo de servicio esta por culminar, que solo le faltan 3 minutos');

                  int professionalId = loginController.idProfessionalLoggedIn!;
                  int branchId = loginController.branchIdLoggedIn!;

                  if ((idClient ==
                      clientsScheduledController.clientsAttended2?.client_id)) {
                    notiController.storeNotification(
                        '!Alerta',
                        branchId,
                        professionalId,
                        'El tiempo de servicio del cliente $nameClient se agotará en los próximos $endingTime minutos');
                    //llamo al metodo que me dice que para este cliente ya se envio una notificacion al barbero
                    clientsScheduledController.setNotificationClients1(2,
                        clientsScheduledController.clientsAttended2!.client_id);
                  }
                }
              }
            }
          }
        } else {
          print('object-2 reloj 2');
        }
      } else {
        clientsScheduledController.animationController2!.stop();
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
                double progress =
                    clientsScheduledController.animationController3!.value;
                int totalTimeInSeconds = clientsScheduledController
                    .timeClientsAttended3!; // Duración total del AnimationController en segundos
                int elapsedTimeInSeconds =
                    (progress * totalTimeInSeconds).round();
                int remainingTimeInSeconds =
                    totalTimeInSeconds - elapsedTimeInSeconds;
                int standbyTimeSeconds = endingTime * 60;
                // Verificar si faltan menos de 180 segundos (3 minutos) para terminar

                if (remainingTimeInSeconds <= standbyTimeSeconds) {
                  // Realizar alguna acción
                  print(
                      'object-Enviar mensaje que el tiempo de servicio esta por culminar, que solo le faltan 3 minutos');

                  int professionalId = loginController.idProfessionalLoggedIn!;
                  int branchId = loginController.branchIdLoggedIn!;

                  if ((idClient ==
                      clientsScheduledController.clientsAttended3?.client_id)) {
                    notiController.storeNotification(
                        '!Alerta',
                        branchId,
                        professionalId,
                        'El tiempo de servicio del cliente $nameClient se agotará en los próximos $endingTime minutos');
                    //llamo al metodo que me dice que para este cliente ya se envio una notificacion al barbero
                    clientsScheduledController.setNotificationClients1(3,
                        clientsScheduledController.clientsAttended3!.client_id);
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
                double progress =
                    clientsScheduledController.animationController4!.value;
                int totalTimeInSeconds = clientsScheduledController
                    .timeClientsAttended4!; // Duración total del AnimationController en segundos
                int elapsedTimeInSeconds =
                    (progress * totalTimeInSeconds).round();
                int remainingTimeInSeconds =
                    totalTimeInSeconds - elapsedTimeInSeconds;
                int standbyTimeSeconds = endingTime * 60;
                // Verificar si faltan menos de 180 segundos (3 minutos) para terminar

                if (remainingTimeInSeconds <= standbyTimeSeconds) {
                  // Realizar alguna acción
                  print(
                      'object-Enviar mensaje que el tiempo de servicio esta por culminar, que solo le faltan 3 minutos');

                  int professionalId = loginController.idProfessionalLoggedIn!;
                  int branchId = loginController.branchIdLoggedIn!;

                  if ((idClient ==
                      clientsScheduledController.clientsAttended4?.client_id)) {
                    notiController.storeNotification(
                        '!Alerta',
                        branchId,
                        professionalId,
                        'El tiempo de servicio del cliente $nameClient se agotará en los próximos $endingTime minutos');
                    //llamo al metodo que me dice que para este cliente ya se envio una notificacion al barbero
                    clientsScheduledController.setNotificationClients1(4,
                        clientsScheduledController.clientsAttended4!.client_id);
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
        print('object-2-2 reloj 4');
      }
      //
      //
    } catch (e) {
      print('object-4 dio error en :$e');
    }
  }

  Timer? _timer;

  iniciarLlamadaCada10Segundos() {
    // Cancela cualquier temporizador existente para evitar duplicaciones
    _timer?.cancel();
    int cont = 2;
    int endingtime = 1;
    // Establece un temporizador que llama a la función cada 20 segundos
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) async {
      if (loginController.idProfessionalLoggedIn != null &&
          loginController.branchIdLoggedIn != null &&
          loginController.chargeUserLoggedIn == "Barbero") {
        print('.........estoy entrando cada : $cont segundos........');
        //Este metodo es para verificar si hay relojes activos
        //Si hubiera activos ver y mandar una notificacion si el tiempo se estuviera acabando
        //en este caso son 3 minutos que esta definido en el controlador
        if (endingtime == 30) //verificar en 30 segundos
        {
          //aqui verifico si se esta acabando algun servico para mandar una notificacion
          verifyingClockTime(clientsScheduledController,
              clientsScheduledController.endingTime);
          endingtime = 1;
        }
        endingtime++;

        cont += 2;
        if ((clientsScheduledController.varClientsWaiting == true) &&
            (loginController.usserPermissionQr == 1)) {
          print('esteeeeee se cumplio que puede atender ..aqui entrandoya');
          if (clientsScheduledController
                  .animationControllerInitial!.isAnimating &&
              clientsScheduledController.cantClientWait !=
                  clientsScheduledController.clientsScheduledListLength) {
            // La animación está activa (en progreso)
            print(
                'varClientsWaiting es contClientsWaiting La animación está activa');
            if (clientsScheduledController.contClientsWaiting == 10) {
              print('esteeeeee varClientsWaiting Mande la notificacion ya');
              //aqui llamar e insertar en las notificaciones
              notiController.storeNotification(
                  'Clientes en cola',
                  loginController.branchIdLoggedIn,
                  loginController.idProfessionalLoggedIn,
                  'Recuerda que tienes clientes en cola.¡No los mantengas esperando por mucho tiempo!');
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
              clientsScheduledController.setContClientsWaiting(-91119); //sumo 1
            }
          } else {
            clientsScheduledController
                .setContClientsWaiting(-90009); //inicializo nuevamente a 0
            // La animación está detenida
            print(
                'varClientsWaiting es contClientsWaiting La animación está detenida');
          }
          print(
              'varClientsWaiting es contClientsWaiting = ${clientsScheduledController.contClientsWaiting}');
        } else {
          clientsScheduledController
              .setContClientsWaiting(-90009); //inicializo nuevamente a 0
          print('varClientsWaiting es false');
        }

        //
        //
        //
        //
        // actualizo la cola
        if (cont == 4 ||
            cont == 10 ||
            cont == 20 ||
            cont == 30 ||
            cont == 40 ||
            cont == 60 ||
            cont == 70 ||
            cont == 80) {
          //AQUI INSERTO EN LA DB SI HUBIERAS RELOJES ACTIVOS
          // await clientsScheduledController.upadateVariablesValueTimersSPlano();

          print('ENTRO A BUSCAR NOTIFICACIONES');
          print('ENTRO A BUSCAR NOTIFICACIONES - cont: $cont');
          notiController.fetchNotificationList(loginController.branchIdLoggedIn,
              loginController.idProfessionalLoggedIn);
        }
        if (cont == 6 || cont == 40) {
          notiController.fetchNotificationList(loginController.branchIdLoggedIn,
              loginController.idProfessionalLoggedIn);

          clientsScheduledController.fetchClientsScheduled(
              loginController.idProfessionalLoggedIn,
              loginController.branchIdLoggedIn);
          print('con contador en 8 llamo la funcion1 222');
        }
        if (cont == 4 || cont == 40 || cont == 80) {
          await clientsScheduledController.upadateVariablesValueTimers();
          print(
              'clientes asistiendo  inserto cada cierto tiempo en la db los nuevos valores del timer-2 upadateVariablesValueTimers()->$cont');
        }
        if (cont == 20 || cont == 40 || cont == 60 || cont == 80) {
          print(
              'con contador en 8 llamo la funcion1 con contador en 10 entro para activar reloges si fuera necesario');
          for (var i = 0;
              i < clientsScheduledController.clientsScheduledList.length;
              i++) {
            int clock = 0;
            if (clientsScheduledController.clientsScheduledList[i].attended ==
                11) {
              int reservationId = clientsScheduledController
                  .clientsScheduledList[i].reservation_id;
              clock = await clientsScheduledController
                  .getValueClockDb(reservationId);
              if (clock == 1) {
                print('activando el Clock - 1');
                clientsScheduledController.animationController1!.forward();
                clientsScheduledController.acceptOrRejectClient(
                    reservationId, 111);
                clientsScheduledController.pauseResumeClock((clock - 1), -99);
              }
              if (clock == 2) {
                print('activando el Clock - 2');
                clientsScheduledController.animationController2!.forward();
                clientsScheduledController.acceptOrRejectClient(
                    reservationId, 111);
                clientsScheduledController.pauseResumeClock((clock - 1), -99);
              }
              if (clock == 3) {
                print('activando el Clock - 3');
                clientsScheduledController.animationController3!.forward();
                clientsScheduledController.acceptOrRejectClient(
                    reservationId, 111);
                clientsScheduledController.pauseResumeClock((clock - 1), -99);
              }
              if (clock == 4) {
                print('activando el Clock - 4');
                clientsScheduledController.animationController4!.forward();
                clientsScheduledController.acceptOrRejectClient(
                    reservationId, 111);
                clientsScheduledController.pauseResumeClock((clock - 1), -99);
              }
            } //fin del if
          }
          if (cont == 80) {
            print('vuelvo a poner en 2 a cont');
            cont = 2;
          }
        }
        //fin del for
      }
    });
  }

  //
  @override
  Widget build(BuildContext context) {
    //AQUI REVISO SI HAY ALGUNO POR ACTIVAR LO ACTIVO
    iniciarLlamadaCada10Segundos();

    super.build(context);
    return GetBuilder<ClientsScheduledController>(builder: (controllerclient) {
      //CREANDO LISTAS PARA UTILIZARLO EN EL FOR
      List<ClientsScheduledModel?> clientsList = [
        controllerclient.clientsAttended1,
        controllerclient.clientsAttended2,
        controllerclient.clientsAttended3,
        controllerclient.clientsAttended4,
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
        print('La aplicación se activeClock() {--');
        for (var i = 0; i < clientsScheduledController.item.length; i++) {
          if (clientsScheduledController.item[i] == 0) {
            animationCont[0]!.duration =
                Duration(seconds: animationCont[0]!.duration!.inSeconds);
            animationCont[0]!.forward();
            print(
                'La aplicación se activeClock() {-- ${animationCont[0]!.duration!.inSeconds}');
          } else if (clientsScheduledController.item[i] == 1) {
            animationCont[1]!.duration =
                Duration(seconds: animationCont[1]!.duration!.inSeconds);
            animationCont[1]!.forward();
            print(
                'La aplicación se activeClock() {-- ${animationCont[1]!.duration!.inSeconds}');
          } else if (clientsScheduledController.item[i] == 2) {
            animationCont[2]!.duration =
                Duration(seconds: animationCont[2]!.duration!.inSeconds);
            animationCont[2]!.forward();
            print(
                'La aplicación se activeClock() {-- ${animationCont[2]!.duration!.inSeconds}');
          } else if (clientsScheduledController.item[i] == 3) {
            animationCont[3]!.duration =
                Duration(seconds: animationCont[3]!.duration!.inSeconds);
            animationCont[3]!.forward();
            print(
                'La aplicación se activeClock() {-- ${animationCont[3]!.duration!.inSeconds}');
          }
        }
      }

      activeClockLogin() {
        print('La aplicación se activeClock() {--');
        for (var i = 0; i < clientsScheduledController.item.length; i++) {
          if (clientsScheduledController.item[i] == 0) {
            animationCont[0]!.duration =
                Duration(seconds: controllerclient.timeClientsAttended1!);
            animationCont[0]!.forward();
            print(
                'La aplicación se activeClock() {-- ${controllerclient.timeClientsAttended1!}');
          } else if (clientsScheduledController.item[i] == 1) {
            animationCont[1]!.duration =
                Duration(seconds: controllerclient.timeClientsAttended2!);
            animationCont[1]!.forward();
            print(
                'La aplicación se activeClock() {-- ${controllerclient.timeClientsAttended2!}');
          } else if (clientsScheduledController.item[i] == 2) {
            animationCont[2]!.duration =
                Duration(seconds: controllerclient.timeClientsAttended3!);
            animationCont[2]!.forward();
            print(
                'La aplicación se activeClock() {-- ${controllerclient.timeClientsAttended3!}');
          } else if (clientsScheduledController.item[i] == 3) {
            animationCont[3]!.duration =
                Duration(seconds: controllerclient.timeClientsAttended4!);
            animationCont[3]!.forward();
            print(
                'La aplicación se activeClock() {-- ${controllerclient.timeClientsAttended4!}');
          }
        }
      }

      /*   if (loginController.segundoPlano == 3) {
        print(
            '..segundoPlano siii activando los relojes animationCont[0]!.duration : ${animationCont[0]!.duration}');
        print('..segundoPlano siii activando los relojes');
        animationCont[0]!.duration =
            Duration(seconds: controllerclient.timeClientsAttended1!);
      }*/

      if (loginController.isLoggingInCharge == true) {
        //solo va a entar si viene del login
        print('Hubo un cierre inesperado y se estan activando los relojes');
        activeClockLogin();
      }
      if (controllerclient.closeIesperado == true &&
          loginController.isLoggingInCharge == false) {
        print('Hubo un cierre inesperado y se estan activando los relojes');
        activeClock();
      }
      if (controllerclient.activeModifyTime == true) {
        print('EL TIEMPO ACTUAL DEL RELOJ estoy entrando aqui');
        //aqui verifico qsi hay que agregarle el tiempo algun reloj
        print(
            'activeModifyTime SOY = ${controllerclient.activeModifyTime} Y MANDE ESTE TIEMPO ${controllerclient.modifyTime[controllerclient.modifyTimeSpecific]}');
        int i = controllerclient.modifyTimeSpecific;
        int value =
            controllerclient.modifyTime[controllerclient.modifyTimeSpecific];
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

        Duration duracionSendAct = Duration(
          minutes: tiempoRestante.truncate() + value,
        );

// Aumenta la duración actual en 30 segundos
        Duration nuevaDuracion = duracionSendAct;

        animationCont[i]!.duration = nuevaDuracion;
        print('EL TIEMPO ACTUAL DEL RELOJ duracionSend YA:$duracionSendAct');

        animationCont[i]!.reset();
        animationCont[i]!.forward();
        print('EL TIEMPO ACTUAL DEL RELOJ RESETEADO YA');

        //preguntar que no venga del login
      }

      //AQUI ESCUCHANDO PARA SABER SI TENGO QUE DETENER O REAUNUDAR LOS TIMER
      if (controllerclient.clockchanges == true) {
        //
        for (var i = 0; i < controllerclient.pausResumeClock.length; i++) {
          int? value = controllerclient.pausResumeClock[i];
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

      if (controllerclient.clientsScheduledNext != null) {
        String fullName = controllerclient.clientsScheduledNext!.client_name;
        //todo1                // Dividir el nombre completo por espacios
        List<String> partsName =
            fullName.split(" "); // Tomar los primeros dos nombres (si existen)
        firstName = partsName.isNotEmpty ? partsName[0] : "";
        // String secondName = partsName.length > 1 ? partsName[1] : "";
      }

      //clientsScheduledController.animationControllerInitial!.forward();

      // print('clientes asistiendo Antes de addPostFrameCallback');
      //todo IMPORTANTE ESTA FUNCION SE EJECUTA DESPUES QUE SE CREA EL WIDGET
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        //aqui solo debe entrar cuando o se agregan servicios o cuando se eliminan

        if (loginController.segundoPlano == 3) {
          print('..segundoPlano siii APAGANDO LLAMADA');
          loginController.getSegundoPlano(1);
        }
        if (controllerclient.activeModifyTime == true) {
          await clientsScheduledController.upadateVariablesValueTimers();
          print(
              'esteeeeee clientes asistiendo  inserto cada cierto tiempo en la db los nuevos valores y puso a FALSE a activeModifyTime');
          controllerclient.setActiveModifyTime(false);
        }
        print(
            'valor de variable controllerclient.segundoPlano = ${loginController.segundoPlano}');

        if (loginController.ejecutadoEvent == false) {
          // Se ejecutará después de que se haya construido el widget
          //define que tipo de saludo dar dependiendo de la hora

          if (controllerclient.closeIesperado == true) {
            print('-*-*-*-**>>>> si fui un sierre inesperado');
            if (clientsScheduledController.item.isNotEmpty) {
              loginController.setCodigoQrValid(1);
            } else {
              loginController.setCodigoQrValid(null);
            }
          } else {
            print('-*-*-*-**>>>> NOOO fui un sierre inesperado');
          }
          if (loginController.isLoggingInCharge == true) {
            loginController.setLoggingInCharge(false);
          }

          controllerclient.setCloseIesperado(false);
          controllerclient.clockChanges(false);
          loginController.ejecutado_(true);
          controllerclient.modifingTimeClose();
        }
        controllerclient.setCloseIesperadoLogin(false);

        // print(
        //     'clientes asistiendo ENTRE A DESTRUIR LAS VARIABLES DEL TIEMPO ASIGNADO activeModifyTime SOY = ${controllerclient.activeModifyTime}');
      });
      // print('clientes asistiendo Después de addPostFrameCallback');
      return Column(
        //Cart anaranjado grande inicial que tiene el cronometro
        children: [
          Expanded(
              flex: loginController.androidInfoDisplay! >=
                      6.6 //propiedades de telefone
                  ? 12
                  : 13,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: Color(0xFFF18254),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      /*todo texto arriba */ Padding(
                        padding: const EdgeInsets.only(left: 8, top: 5),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            controllerclient.item.isEmpty
                                ? 'Cliente en espera'
                                : 'Atendiendo ${controllerclient.item.length} cliente(s)',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                      ),

                      /*CRONOMETRO*/ Padding(
                        padding: const EdgeInsets.all(8.0),
                        //todo AQUI LA LOGICA AL MOSTRAR LOS TIMER
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                      UniqueKey(),
                                      clientsList[clientsScheduledController
                                              .item[i]]!
                                          .client_name,
                                      controllerclient,
                                      animationCont[
                                          clientsScheduledController.item[i]]!,
                                    ),
                                  ],
                                ]
                                //SI NO ESTA ATENDIENDOA NADIE Y HAY GENTE EN LA COLA ESPERANDO CARGA EL TIMER INICIAL
                                else if (controllerclient
                                        .clientsScheduledNext !=
                                    null) ...[
                                  //AQUI VERIFICO SI YA ESCANEO EL CODIGO QR
                                  if (loginController.codigoQrValid() == true &&
                                      clientsScheduledController
                                          .item.isEmpty) ...[
                                    cardTimer(
                                      UniqueKey(),
                                      'Esperando',
                                      controllerclient,
                                      clientsScheduledController
                                          .animationControllerInitial!,
                                    ),
                                  ] else ...[
                                    const Center(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                          ),
                                          Text(
                                            'Debe de escanear el código Qr ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            'para atender clientes',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    )
                                  ]
                                ] else ...[
                                  const SizedBox(
                                    height: 50,
                                  ),
                                ]
                              ]),
                        ),
                        //FIN CLIENTES QUE ESTAN EN COLA
                      ),
                      //todo CLIENTES QUE ESTAN EN COLA

                      controllerclient.boolFilterShowNext
                          ? cardClientTails(controllerclient, context,
                              firstName, animationCont)
                          :

                          //si hubiera algien en cola
                          clientsScheduledController
                                      .clientsScheduledListLength >
                                  0
                              ? const Column(
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      'Cliente atendiéndose.',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      'Esperando para mostrar el siguiente',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )
                              : const Text('No hay clientes en cola',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: Colors.white)),
                      //FIN CLIENTES QUE ESTAN EN COLA
                    ],
                  ),
                ),
              )),
          Expanded(
              flex: 15, // 85% del espacio disponible para esta parte
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 1),
                child: Container(
                  color: const Color.fromARGB(255, 231, 232, 234),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Dashboard',
                            style: TextStyle(
                                color: Color.fromARGB(255, 43, 44, 49),
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                          controllerLogin.setIsLoading == true
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Color.fromARGB(255, 241, 130, 84),
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
                              GestureDetector(
                                onTap: () {
                                  pagesConfigC
                                      .onTabTapped(1); //index = 1 -> /Clients
                                },
                                child: cartsHome(
                                    context,
                                    12,
                                    const Color(0xFF2B3141),
                                    const Color.fromARGB(255, 231, 233, 233),
                                    'Agenda',
                                    'Clientes Agendados',
                                    Icons.perm_contact_calendar),
                              ),
                              InkWell(
                                onTap: () async {
                                  await notiController.fetchNotificationList(
                                      1, 11);
                                  pagesConfigC.onTabTapped(
                                      2); //index = 2 -> /NotificationsPageProf
                                },
                                child: cartsHome(
                                    context,
                                    12,
                                    const Color.fromARGB(255, 81, 93, 117),
                                    Color.fromARGB(255, 231, 233, 233),
                                    'Notificaciones',
                                    'Tus Notificaciones',
                                    Icons.notifications),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: (MediaQuery.of(context).size.height * 0.01),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  pagesConfigC.onTabTapped(
                                      3); //index = 3 -> /StatisticPage
                                },
                                child: cartsHome(
                                    context,
                                    12,
                                    const Color.fromARGB(255, 177, 174, 174),
                                    Color.fromARGB(255, 231, 233, 233),
                                    'Estadísticas',
                                    'Revisa Tus Ingresos',
                                    Icons.bar_chart),
                              ),
                              InkWell(
                                onTap: () async {
                                  controllerLogin.setIsLoadingFor(true);
                                  await coexistenceController
                                      .fetchCoexistenceList();
                                  pagesConfigC.onTabTapped(
                                      4); //index = 4 -> /CoexistencePage
                                },
                                child: cartsHome(
                                    context,
                                    12,
                                    const Color(0xFFF18254),
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
              )),
        ],
      );
    });
    //todoooooooooooooooooooooooooooooooooooooooooo
  }

  Padding cardClientTails(
      ClientsScheduledController controllerclient,
      BuildContext context,
      String firstName,
      List<AnimationController?> animationCont) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 6),
      child: FittedBox(
        fit: BoxFit.contain,
        child: controllerclient.clientsScheduledNext != null
            ? Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
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
                        color: const Color(0xFFF18254),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                      ),
                      child: IconButton(
                        onPressed: () {
                          if (loginController.codigoQrValid() == true) {
                            int resulButton = 0;
                            resulButton = loginController.handleButtonClick(
                                controllerclient
                                    .clientsScheduledNext!.reservation_id);
                            if (resulButton == 1) {
                              controllerclient.acceptOrRejectClient(
                                  controllerclient
                                      .clientsScheduledNext!.reservation_id,
                                  3);
                            }
                          } else {
                            Get.snackbar(
                              'Mensaje',
                              'Debe de escanear el código Qr de entrada',
                              duration: const Duration(milliseconds: 2500),
                              backgroundColor:
                                  const Color.fromARGB(118, 255, 255, 255),
                              showProgressIndicator: true,
                              progressIndicatorBackgroundColor:
                                  const Color.fromARGB(255, 203, 205, 209),
                              progressIndicatorValueColor:
                                  const AlwaysStoppedAnimation(
                                      Color(0xFFF18254)),
                              overlayBlur: 3,
                            );
                          }
                        },
                        icon: Icon(
                          MdiIcons.thumbDown,
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
                        padding: const EdgeInsets.only(left: 30, top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: const Color.fromARGB(255, 43, 44, 49),
                                  size: 22,
                                ),
                                Text(
                                  firstName,
                                  softWrap: true,
                                  style: const TextStyle(
                                      height: 1.0,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: controllerclient
                                            .serviceCustomerSelected.length >
                                        2
                                    ? 2
                                    : controllerclient
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
                                            const Icon(
                                              Icons.api_sharp,
                                              size: 12,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              controllerclient
                                                  .serviceCustomerSelected[
                                                      index]
                                                  .name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.timer,
                                    color: const Color.fromARGB(180, 0, 0, 0),
                                    size: (MediaQuery.of(context).size.height *
                                        0.018)),
                                Text(
                                    //AQUI ETSA EL TIEMPO TOTAL DEL SERVICIO
                                    (controllerclient
                                        .clientsScheduledNext!.total_time),
                                    style: const TextStyle(
                                      height: 1.2,
                                      fontSize: 16,
                                      color: Color.fromARGB(180, 0, 0, 0),
                                    )),
                              ],
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
                            color: Colors.white, // Color blanco para el borde
                            width:
                                1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                          ),
                          color: const Color.fromARGB(255, 43, 44, 49),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12))),
                      child: IconButton(
                        onPressed: () async {
                          //AQUI VEO SI YA ESCANEO EL CODIGO QR Y ESTA EN EL LOCAL
                          if (loginController.codigoQrValid() == true) {
                            int resulButton = 0;
                            resulButton = loginController.handleButtonClick(
                                controllerclient
                                    .clientsScheduledNext!.reservation_id);
                            if (resulButton == 1) {
                              //aqui manda aceptar, es decir atender este cliente
                              clientsScheduledController.clientsWaiting(false);
                              // detengo el timer de 2 minutos
                              clientsScheduledController
                                  .animationControllerInitial!
                                  .stop();
                              clientsScheduledController
                                  .animationControllerInitial!
                                  .reset();
                              // detengo todos los timers que deben detenerse
                              for (int j = 0;
                                  j < controllerclient.itemDel.length;
                                  j++) {
                                animationCont[controllerclient.itemDel[j]]!
                                    .stop();
                                animationCont[controllerclient.itemDel[j]]!
                                    .reset();
                              }
                              await controllerclient.newClientAttended(
                                  controllerclient.clientsScheduledNext!,
                                  controllerclient.availability);

                              //
                              //
                              //
                              //HACE LAS VERIFICACIONES NECESARIAS PARA ACTIVAR LOS RELOJES QUE NECESITEN SER ACTIVADOS
                              if (controllerclient.busyClock == 0) {
                                animationCont[0]!.duration = Duration(
                                    seconds:
                                        controllerclient.timeClientsAttended1!);
                                animationCont[0]!.forward();
                              } else if (controllerclient.busyClock == 1) {
                                animationCont[1]!.duration = Duration(
                                    seconds:
                                        controllerclient.timeClientsAttended2!);
                                animationCont[1]!.forward();
                              } else if (controllerclient.busyClock == 2) {
                                animationCont[2]!.duration = Duration(
                                    seconds:
                                        controllerclient.timeClientsAttended3!);
                                animationCont[2]!.forward();
                              } else if (controllerclient.busyClock == 3) {
                                animationCont[3]!.duration = Duration(
                                    seconds:
                                        controllerclient.timeClientsAttended4!);
                                animationCont[3]!.forward();
                              }

                              //el valor 1 es que es que le va atender y por ende va ser el que esta atendiendo
                              await controllerclient.acceptOrRejectClient(
                                  controllerclient
                                      .clientsScheduledNext!.reservation_id,
                                  1);
                            }
                          } else {
                            Get.snackbar(
                              'Mensaje',
                              'Debe de escanear el código Qr de entrada',
                              duration: const Duration(milliseconds: 2500),
                              backgroundColor:
                                  const Color.fromARGB(118, 255, 255, 255),
                              showProgressIndicator: true,
                              progressIndicatorBackgroundColor:
                                  const Color.fromARGB(255, 203, 205, 209),
                              progressIndicatorValueColor:
                                  const AlwaysStoppedAnimation(
                                      Color(0xFFF18254)),
                              overlayBlur: 3,
                            );
                          }
                        },
                        icon: Icon(
                          MdiIcons.thumbUp,
                          color: Colors.white,
                          size: (MediaQuery.of(context).size.height * 0.04),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: GetBuilder<LoginController>(builder: (controllerLogin) {
                  return const Row(
                    children: [
                      Text('No hay clientes en cola',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: Colors.white)),
                    ],
                  );
                }),
              ),
      ),
    );
  }

  //todo9
  Padding cardTimer(
    Key uniqueKey,
    String name,
    ClientsScheduledController controllerclient,
    AnimationController _animationController,
  ) {
    String segundos = "";
    Color colorInicial = Colors.white;
    Color colorInicialCirculo = const Color(0xFFF18254);
    double fontSizeText = (MediaQuery.of(context).size.width * 0.030);
    // Dividir el nombre completo por espacios

    List<String> partsName =
        name.split(" "); // Tomar los primeros dos nombres (si existen)
    String firstName = partsName.isNotEmpty ? partsName[0] : "";
    // String secondName = partsName.length > 1 ? partsName[1] : "";

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Center(
        child: AnimatedBuilder(
          key: uniqueKey,
          animation: _animationController,
          builder: (context, child) {
            final value = _animationController.value;
            final remainingSeconds = (_animationController.duration!.inSeconds -
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
              width: controllerclient.sizeClock,
              height: controllerclient.sizeClock,
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
                              colors: [Colors.white, Colors.grey.withAlpha(55)])
                          .createShader(rect);
                    },
                    child: Container(
                      width: controllerclient.sizeClock,
                      height: controllerclient.sizeClock,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image:
                                  Image.asset("assets/images/radial_scale.png")
                                      .image)),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: (controllerclient.sizeClock) - 40,
                      height: (controllerclient.sizeClock) - 40,
                      decoration: BoxDecoration(
                          color: colorInicialCirculo, shape: BoxShape.circle),
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
                                    fontSize:
                                        (MediaQuery.of(context).size.width *
                                            0.04), //todo2
                                    fontFamily:
                                        GoogleFonts.orbitron().fontFamily,
                                    color: colorInicial,
                                    fontWeight: FontWeight.w900),
                              ),
                              Text(
                                "$segundos$seconds",
                                style: TextStyle(
                                    fontSize:
                                        (MediaQuery.of(context).size.width *
                                            0.04),
                                    color: colorInicial,
                                    fontFamily:
                                        GoogleFonts.orbitron().fontFamily,
                                    fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              firstName,
                              style: TextStyle(
                                  fontSize: fontSizeText,
                                  color: colorInicial,
                                  fontWeight: FontWeight.w900),
                            ),
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
              : (MediaQuery.of(context).size.height * 0.180),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue)),
        color: colorVariable,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 20, // Tamaño del CircleAvatar
                backgroundColor: colorBottom, // Color de fondo del CircleAvatar
                child: Icon(
                  iconCart, // Icono que deseas mostrar
                  size: 30, // Tamaño del icono
                  color:
                      const Color.fromARGB(255, 26, 50, 82), // Color del icono
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
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  descriptionTitleCart,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
