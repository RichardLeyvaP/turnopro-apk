import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Controllers/coexistence.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Models/clientsScheduled_model.dart';

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  AnimationController? _animationControllerInitial;

  AnimationController? _animationController1;

  AnimationController? _animationController2;

  AnimationController? _animationController3;

  AnimationController? _animationController4;

  final ClientsScheduledController clientsScheduledController =
      Get.find<ClientsScheduledController>();

  final PagesConfigController pagesConfigC = Get.find<PagesConfigController>();

  final LoginController loginController = Get.find<LoginController>();

  final CoexistenceController coexistenceController =
      Get.put(CoexistenceController());

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    //AQUI ME DEVUELVE A Q CLIENTE LE SIGUE Y ACUAL MOSTRAR EN LA COLA
    clientsScheduledController.filterShowNext();
    //clientsScheduledController.filterShowCardTimer();//todo ahora comente a ver que pasa

    //INICIALIZANDO CONTROLES DE LOS RELOJES
    _animationControllerInitial = AnimationController(
      vsync: this,
      duration: Duration(seconds: clientsScheduledController.totalTimeInitial),
    );
    _animationControllerInitial!.forward();

// Inicia la animación
    _animationControllerInitial!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (clientsScheduledController
                .noncomplianceProfessional['initialTime'] !=
            0) {
          //CADA VEZ QUE ENTRE AQUI INCULPLIO CON EL TIEMPO DE LLAMAR AL CLIENTE ANTES DE 3MIN
          String type = 'initialTime';
          int branchId = loginController.branchIdLoggedIn!;
          int professionalId = loginController.idProfessionalLoggedIn!;
          int estado = 0; //es que incumplió
          clientsScheduledController.changeNoncomplianceP(
              type, branchId, professionalId, estado);
        }

        // La animación ha llegado al final, reiniciar
        _animationControllerInitial!.reset();
        _animationControllerInitial!.forward();
      }
    });

    _animationController1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _animationController2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _animationController3 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _animationController4 = AnimationController(
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
    _animationControllerInitial!.dispose();
    _animationController1!.dispose();
    _animationController2!.dispose();
    _animationController3!.dispose();
    _animationController4!.dispose();
    super.dispose();
  }

  Timer? _timer;

  iniciarLlamadaCada10Segundos() {
    // Cancela cualquier temporizador existente para evitar duplicaciones
    _timer?.cancel();

    // Establece un temporizador que llama a la función cada 20 segundos
    _timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) async {
      print('.........estoy entrando cada 5 segundos........');
      // actualizo la cola
      for (var i = 0;
          i < clientsScheduledController.clientsScheduledList.length;
          i++) {
        int clock = 0;
        if (clientsScheduledController.clientsScheduledList[i].attended == 11) {
          int reservationId =
              clientsScheduledController.clientsScheduledList[i].reservation_id;
          clock =
              await clientsScheduledController.getValueClockDb(reservationId);
          if (clock == 1) {
            print('activando el Clock - 1');
            _animationController1!.forward();
            clientsScheduledController.acceptOrRejectClient(reservationId, 111);
            clientsScheduledController.pauseResumeClock((clock - 1), -99);
          }
          if (clock == 2) {
            print('activando el Clock - 2');
            _animationController2!.forward();
            clientsScheduledController.acceptOrRejectClient(reservationId, 111);
            clientsScheduledController.pauseResumeClock((clock - 1), -99);
          }
          if (clock == 3) {
            print('activando el Clock - 3');
            _animationController3!.forward();
            clientsScheduledController.acceptOrRejectClient(reservationId, 111);
            clientsScheduledController.pauseResumeClock((clock - 1), -99);
          }
          if (clock == 4) {
            print('activando el Clock - 4');
            _animationController4!.forward();
            clientsScheduledController.acceptOrRejectClient(reservationId, 111);
            clientsScheduledController.pauseResumeClock((clock - 1), -99);
          }
        } //fin del if
      } //fin del for
    });
  }

  //
  @override
  Widget build(BuildContext context) {
    //AQUI REVISO SI HAY ALGUNO POR ACTIVAR LO ACTIVO
    iniciarLlamadaCada10Segundos();
    super.build(context);
    return GetBuilder<ClientsScheduledController>(builder: (controllerclient) {
      //controllerclient.clientsScheduledList[index].attended ==11

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
                _animationController1!.stop();
                print('PAUSE EL RELOJ 1');
              }
              if (i == 1) {
                _animationController2!.stop();
                print('PAUSE EL RELOJ 2');
              }
              if (i == 2) {
                _animationController3!.stop();
                print('PAUSE EL RELOJ 3');
              }
              if (i == 3) {
                _animationController4!.stop();
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

//CREANDO LISTAS PARA UTILIZARLO EN EL FOR
      List<ClientsScheduledModel?> clientsList = [
        controllerclient.clientsAttended1,
        controllerclient.clientsAttended2,
        controllerclient.clientsAttended3,
        controllerclient.clientsAttended4,
        // Agrega más listas según sea necesario
      ]; //CREANDO LISTAS PARA UTILIZARLO EN EL FOR
      List<AnimationController?> animationCont = [
        _animationController1,
        _animationController2,
        _animationController3,
        _animationController4,
        // Agrega más listas según sea necesario
      ];

      _animationControllerInitial!.forward();

      if (controllerclient.activeModifyTime == true) {
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

        print('Tiempo duracionTotal: $duracionTotal');
        print('Tiempo tiempoTranscurrido: ${tiempoTranscurrido.truncate()}');
        print('Tiempo restante: $tiempoRestante');

        Duration duracionSendAct = Duration(
          minutes: tiempoRestante.truncate() + value,
        );

// Aumenta la duración actual en 30 segundos
        Duration nuevaDuracion = duracionSendAct;

        animationCont[i]!.duration = nuevaDuracion;
        print('duracionSend YA:$duracionSendAct');

        animationCont[i]!.reset();
        animationCont[i]!.forward();
        print('RESETEADO YA');

        //todo IMPORTANTE ESTA FUNCION SE EJECUTA DESPUES QUE SE CREA EL WIDGET
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Se ejecutará después de que se haya construido el widget
          //define que tipo de saludo dar dependiendo de la hora
          controllerclient.clockChanges(false);
          loginController.getGreeting();
          controllerclient.modifingTimeClose();
          print(
              'ENTRE A DESTRUIR LAS VARIABLES DEL TIEMPO ASIGNADO activeModifyTime SOY = ${controllerclient.activeModifyTime}');
        });
      }

      return Column(
        //Cart anaranjado grande inicial que tiene el cronometro
        children: [
          Expanded(
              flex: 11,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: const Color(0xFFF18254),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      /*todo texto arriba */ Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            controllerclient.item.isEmpty
                                ? 'Cliente en espera'
                                : 'Atendiendo ${controllerclient.item.length} clientes',
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
                                  cardTimer(
                                    UniqueKey(),
                                    'Esperando...',
                                    controllerclient,
                                    _animationControllerInitial!,
                                  ),
                                ] else ...[
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.attribution_sharp),
                                      Text('No hay nadie en cola.'),
                                    ],
                                  ),
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
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, top: 8, right: 8, bottom: 6),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    //AQUI CONTROLO SI HAY ALGUIEN EN COLA
                                    child: controllerclient
                                                .clientsScheduledNext !=
                                            null
                                        ? Row(
                                            children: [
                                              Container(
                                                height: (MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.115),
                                                width: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.20),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors
                                                        .white, // Color blanco para el borde
                                                    width:
                                                        1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                                                  ),
                                                  color:
                                                      const Color(0xFFF18254),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(12)),
                                                ),
                                                child: IconButton(
                                                  onPressed: () {
                                                    Get.snackbar(
                                                      'Mensaje',
                                                      'Cancelar',
                                                      duration: const Duration(
                                                          milliseconds: 2000),
                                                    );
                                                    // atender este cliente
                                                    //el valor 3 es que es que lo rechazo, por alguna razon no lo va a tender
                                                    controllerclient
                                                        .acceptOrRejectClient(
                                                            controllerclient
                                                                .clientsScheduledNext!
                                                                .reservation_id,
                                                            3);
                                                  },
                                                  icon: Icon(
                                                    MdiIcons.thumbDown,
                                                    color: Colors.white,
                                                    size:
                                                        (MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.04),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: (MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.115),
                                                width: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8),
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(12)),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 30, top: 8),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          const Icon(
                                                            Icons.person,
                                                            color: Colors.black,
                                                            size: 22,
                                                          ),
                                                          Text(
                                                            firstName,
                                                            softWrap: true,
                                                            style: const TextStyle(
                                                                height: 1.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 20),
                                                          ),
                                                        ],
                                                      ),
                                                      Expanded(
                                                        child: ListView.builder(
                                                          itemCount: controllerclient
                                                                      .serviceCustomerSelected
                                                                      .length >
                                                                  2
                                                              ? 2
                                                              : controllerclient
                                                                  .serviceCustomerSelected
                                                                  .length,
                                                          itemBuilder: (context,
                                                                  index) =>
                                                              Row(
                                                            children: [
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      const Icon(
                                                                        Icons
                                                                            .api_sharp,
                                                                        size:
                                                                            12,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        controllerclient
                                                                            .serviceCustomerSelected[index]
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
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Icon(Icons.timer,
                                                              color: const Color
                                                                      .fromARGB(
                                                                  180, 0, 0, 0),
                                                              size: (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.018)),
                                                          Text(
                                                              //AQUI ETSA EL TIEMPO TOTAL DEL SERVICIO
                                                              (controllerclient
                                                                  .clientsScheduledNext!
                                                                  .total_time),
                                                              style:
                                                                  const TextStyle(
                                                                height: 1.2,
                                                                fontSize: 16,
                                                                color: Color
                                                                    .fromARGB(
                                                                        180,
                                                                        0,
                                                                        0,
                                                                        0),
                                                              )),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: (MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.115),
                                                width: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.20),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors
                                                          .white, // Color blanco para el borde
                                                      width:
                                                          1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                                                    ),
                                                    color: const Color.fromARGB(
                                                        255, 32, 32, 32),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                12))),
                                                child: IconButton(
                                                  onPressed: () async {
                                                    Get.snackbar(
                                                      'Mensaje',
                                                      'Aceptar',
                                                      duration: const Duration(
                                                          milliseconds: 2000),
                                                    );
                                                    //aqui manda aceptar, es decir atender este cliente

                                                    // detengo el timer de 2 minutos
                                                    _animationControllerInitial!
                                                        .stop();
                                                    _animationControllerInitial!
                                                        .reset();
                                                    // detengo todos los timers que deben detenerse
                                                    for (int j = 0;
                                                        j <
                                                            controllerclient
                                                                .itemDel.length;
                                                        j++) {
                                                      animationCont[
                                                              controllerclient
                                                                  .itemDel[j]]!
                                                          .stop();
                                                      animationCont[
                                                              controllerclient
                                                                  .itemDel[j]]!
                                                          .reset();
                                                    }
                                                    await controllerclient
                                                        .newClientAttended(
                                                            controllerclient
                                                                .clientsScheduledNext!,
                                                            controllerclient
                                                                .availability);

                                                    //
                                                    //
                                                    //
                                                    //
                                                    if (controllerclient
                                                            .busyClock ==
                                                        0) {
                                                      animationCont[0]!.duration = Duration(
                                                          seconds: controllerclient
                                                              .convertDateSecons(
                                                                  controllerclient
                                                                      .clientsAttended1!
                                                                      .total_time));
                                                      animationCont[0]!
                                                          .forward();
                                                    } else if (controllerclient
                                                            .busyClock ==
                                                        1) {
                                                      animationCont[1]!.duration = Duration(
                                                          seconds: controllerclient
                                                              .convertDateSecons(
                                                                  controllerclient
                                                                      .clientsAttended2!
                                                                      .total_time));
                                                      animationCont[1]!
                                                          .forward();
                                                    } else if (controllerclient
                                                            .busyClock ==
                                                        2) {
                                                      animationCont[2]!.duration = Duration(
                                                          seconds: controllerclient
                                                              .convertDateSecons(
                                                                  controllerclient
                                                                      .clientsAttended3!
                                                                      .total_time));
                                                      animationCont[2]!
                                                          .forward();
                                                    } else if (controllerclient
                                                            .busyClock ==
                                                        3) {
                                                      animationCont[3]!.duration = Duration(
                                                          seconds: controllerclient
                                                              .convertDateSecons(
                                                                  controllerclient
                                                                      .clientsAttended4!
                                                                      .total_time));
                                                      animationCont[3]!
                                                          .forward();
                                                    }

                                                    //el valor 1 es que es que le va atender y por ende va ser el que esta atendiendo
                                                    controllerclient
                                                        .acceptOrRejectClient(
                                                            controllerclient
                                                                .clientsScheduledNext!
                                                                .reservation_id,
                                                            1);
                                                  },
                                                  icon: Icon(
                                                    MdiIcons.thumbUp,
                                                    color: Colors.white,
                                                    size:
                                                        (MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.04),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GetBuilder<LoginController>(
                                                builder: (controllerLogin) {
                                              return Row(
                                                children: [
                                                  const Text(
                                                      'No hay clientes en cola',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 12)),
                                                  InkWell(
                                                      onTap: () {
                                                        controllerclient
                                                            .fetchClientsScheduled(
                                                                controllerLogin
                                                                    .idProfessionalLoggedIn,
                                                                controllerLogin
                                                                    .branchIdLoggedIn);
                                                      },
                                                      child: const Text(
                                                        '   Actualizar cola',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      )),
                                                ],
                                              );
                                            }),
                                          )),
                              ),
                            )
                          : const Column(
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
                            ),
                      //FIN CLIENTES QUE ESTAN EN COLA
                    ],
                  ),
                ),
              )),
          Expanded(
              flex: 14, // 85% del espacio disponible para esta parte
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 1),
                child: Container(
                  color: const Color.fromARGB(255, 231, 232, 234),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Dashboard',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
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
                                onTap: () {
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
                                    'Estadisticas',
                                    'Revisa Tus Ingresos',
                                    Icons.bar_chart),
                              ),
                              InkWell(
                                onTap: () {
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
    double fontSizeText = (MediaQuery.of(context).size.width * 0.035);
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
                                            0.05), //todo2
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
                                            0.05),
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
      height: (MediaQuery.of(context).size.height * 0.20),
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
