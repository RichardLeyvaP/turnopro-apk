import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsCoordinatorController.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Controllers/coexistence.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/notification.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Controllers/shoppingCart.controller.dart';
import 'package:turnopro_apk/env.dart';
import 'package:intl/intl.dart';

class HomeCoordinatorBody extends StatefulWidget {
  const HomeCoordinatorBody({super.key});

  @override
  State<HomeCoordinatorBody> createState() => _HomeCoordinatorBodyState();
}

class _HomeCoordinatorBodyState extends State<HomeCoordinatorBody>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final ClientsCoordinatorController clientsScheduledController =
      Get.find<ClientsCoordinatorController>();

  final PagesConfigController pagesConfigC = Get.find<PagesConfigController>();

  final LoginController loginController = Get.find<LoginController>();
  final ClientsScheduledController clientsScheduleCont =
      Get.find<ClientsScheduledController>();

  final CoexistenceController coexistenceController =
      Get.put(CoexistenceController());
  NotificationController notiController = Get.find<NotificationController>();
  final ShoppingCartController controllerShoppingCart =
      Get.find<ShoppingCartController>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    if (loginController.idProfessionalLoggedIn != null &&
        loginController.branchIdLoggedIn != null &&
        loginController.usserPermissionQr != null) {
      callFirts();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //
      if (loginController.idProfessionalLoggedIn != null &&
          loginController.branchIdLoggedIn != null &&
          loginController.usserPermissionQr != null) {
        callTimerCoord();
      } else {
        clientsScheduledController.setLoading(false);
        controllerShoppingCart.setLoading(false);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timerCoord?.cancel();
    super.dispose();
  }

  callFirts() async {
    print('cargando aqui-1');
    //SOLO ESTRA UNA SOLA VEZ AL INICIO
    await clientsScheduledController
        .clientsAttendBranch(loginController.branchIdLoggedIn);
    await controllerShoppingCart
        .loadOrderDeleteCar(loginController.branchIdLoggedIn!);

    await notiController.fetchNotificationList(
        loginController.branchIdLoggedIn,
        loginController.idProfessionalLoggedIn,
        'Coordinador',
        'callFirts',
        loginController.tokenUserLoggedIn);

    await clientsScheduledController
        .fetchClientsScheduledBranch(loginController.branchIdLoggedIn);
    await clientsScheduledController
        .fetchClientsRechazBranch(loginController.branchIdLoggedIn);
    clientsScheduledController.setLoading(false);
    await clientsScheduledController.ColacionRequestBranch(
        loginController.branchIdLoggedIn);
    await clientsScheduledController
        .outRequestBranch(loginController.branchIdLoggedIn);
    controllerShoppingCart.setLoading(false);
  }

  Timer? _timerCoord;
  callTimerCoord() {
    print('cargando aqui-2');
    // Cancela cualquier temporizador existente para evitar duplicaciones

    // Establece un temporizador que llama a la función cada 20 segundos
    _timerCoord =
        Timer.periodic(const Duration(seconds: 13), (Timer timer) async {
      print('hola entrando en 10 min;');
      if (loginController.makeCallC == true) {
        print('hola entrando en 10 min-makeCallC == true');
        if (loginController.branchIdLoggedIn != null &&
            loginController.chargeUserLoggedIn == "Coordinador" &&
            loginController.usserPermissionQr != null) {
          // actualizo la cola
          notiController.fetchNotificationList(
              loginController.branchIdLoggedIn,
              loginController.idProfessionalLoggedIn,
              'Coordinador',
              'callTimerCoord',
              loginController.tokenUserLoggedIn);

          await clientsScheduledController
              .fetchClientsScheduledBranch(loginController.branchIdLoggedIn);
          await clientsScheduledController
              .fetchClientsRechazBranch(loginController.branchIdLoggedIn);
          clientsScheduledController.setLoading(false);
          if (loginController.branchIdLoggedIn != null) {
            await controllerShoppingCart
                .loadOrderDeleteCar(loginController.branchIdLoggedIn);
          }
          await clientsScheduledController.ColacionRequestBranch(
              loginController.branchIdLoggedIn);
          await clientsScheduledController
              .outRequestBranch(loginController.branchIdLoggedIn);
          controllerShoppingCart.setLoading(false);
        }
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  //
  @override
  Widget build(BuildContext context) {
    //AQUI REVISO SI HAY ALGUNO POR ACTIVAR LO ACTIVO

    super.build(context);
    return GetBuilder<ClientsCoordinatorController>(
        builder: (controllerclient) {
      return PageView(
          controller: pagesConfigC.pageController2,
          scrollDirection: Axis.horizontal,
          physics: pagesConfigC.isPageViewEnabled
              ? BouncingScrollPhysics() // Habilitar desplazamiento
              : NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            // Almacena el índice de la página actual cuando cambia.

            setState(() {
              pagesConfigC.currentPageIndex = index;
              print(
                  'mostrando aqui el valor de index ESTOY EN HOMEcOORDINATORbODY : $index');
              print(
                  'mostrando aqui el valor de pagesConfigC.pages31Index ESTOY EN HOMEcOORDINATORbODY wewewe : ${pagesConfigC.pages31Index}');
            });
          },
          children: [
            Column(
              //Cart anaranjado grande inicial que tiene el cronometro
              children: [
                Expanded(
                  flex: 11,
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          color: Colors.white,
                          border: Border.all(
                              width: 2,
                              color: Color.fromARGB(110, 175, 175, 175)),
                        ),
                        child: controllerclient.isLoading
                            ? const Center(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: Color(0xFFFDAE2A),
                                  ),
                                  Text(
                                    'Cargando ...',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  )
                                ],
                              ))
                            : Stack(
                                children: [
                                  Positioned.fill(
                                    child: TabBarView(
                                      controller: _tabController,
                                      children: [
                                        // Contenido de las pestañas

                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 36,
                                              left: 8,
                                              right: 8,
                                              bottom: 6),
                                          child: FadeIn(
                                            duration:
                                                const Duration(seconds: 2),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GetBuilder<
                                                          ShoppingCartController>(
                                                      builder: (contShopp) {
                                                    if (controllerShoppingCart
                                                            .isLoading ==
                                                        true) {
                                                      return const Center(
                                                          child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            height: 45,
                                                          ),
                                                          CircularProgressIndicator(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    241,
                                                                    130,
                                                                    84),
                                                          ),
                                                          Text(
                                                            'Cargando lista de solicitudes...',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12),
                                                          )
                                                        ],
                                                      ));
                                                    } else {
                                                      return Column(
                                                        children: [
                                                          showRequestsDelete(
                                                              context,
                                                              contShopp,
                                                              loginController,
                                                              controllerclient),
                                                        ],
                                                      );
                                                    }
                                                  }),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        controllerclient
                                                    .clientsScheduledListBranchLength >
                                                0
                                            ?

                                            //AQUI ESTA LA LISTA DE COLAS
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 36,
                                                    left: 12,
                                                    right: 12,
                                                    bottom: 12),
                                                child: ListView.builder(
                                                  itemCount: controllerclient
                                                      .clientsScheduledListBranchLength,
                                                  itemBuilder: (context,
                                                          index) =>
                                                      cardClientTails(
                                                          controllerclient,
                                                          context,
                                                          index,
                                                          pagesConfigC
                                                              .pageController2,
                                                          pagesConfigC),
                                                ),
                                              )
                                            : const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'No hay clientes en cola',
                                                      // style: TextStyle(
                                                      //     color: Color.fromARGB(
                                                      //         255, 63, 63, 63)
                                                      //         ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 0, // Posición arriba
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      height: 32,
                                      color: Colors.transparent,
                                      child: PreferredSize(
                                        preferredSize: Size.fromHeight(36),
                                        child: DefaultTabController(
                                          length: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 6, right: 6, top: 6),
                                            child: TabBar(
                                              controller: _tabController,
                                              onTap: (index) {
                                                print(
                                                    'SI ESTOY LLEGANDO AL OnTap');
                                                _tabController.animateTo(index);
                                              },
                                              labelColor: Colors
                                                  .white, // Color del texto
                                              unselectedLabelColor: Colors
                                                  .grey, // Color del texto cuando no está seleccionado

                                              indicator: BoxDecoration(
                                                color: Color(
                                                    0xFF4470F3), // Color de fondo cuando está seleccionado
                                                borderRadius: BorderRadius.circular(
                                                    8), // Bordes redondeados, si lo deseas
                                              ),
                                              tabs: const [
                                                Tab(
                                                  text: 'Solicitudes',
                                                ),
                                                Tab(
                                                  text: '    Cola    ',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                  ),
                ),
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
                                      color:
                                          const Color.fromARGB(255, 43, 44, 49),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    cartsHome(
                                        context,
                                        12,
                                        const Color(0xFF19CF9E),
                                        const Color.fromARGB(
                                            255, 231, 233, 233),
                                        'Atendiéndose',
                                        'Clientes Atendiéndose',
                                        Icons.person),
                                    cartsHome(
                                        context,
                                        12,
                                        const Color(0xFFFF6750),
                                        Color.fromARGB(255, 231, 233, 233),
                                        'Colación',
                                        'Colación',
                                        Icons.person_pin_rounded),
                                  ],
                                ),
                                SizedBox(
                                  height: (MediaQuery.of(context).size.height *
                                      0.01),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    cartsHome(
                                        context,
                                        12,
                                        const Color(0xFF4470F3),
                                        Color.fromARGB(255, 231, 233, 233),
                                        'Estadísticas',
                                        'Revisa Tus Ingresos',
                                        Icons.bar_chart),
                                    cartsHome(
                                        context,
                                        12,
                                        const Color(0xFFFDAE2A),
                                        Color.fromARGB(255, 231, 233, 233),
                                        'Convivencia',
                                        'Cumplimiento de Reglas',
                                        Icons.star),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
              ],
            ),
            //AQUI MUESTRO LA OTRA NAVEGACION
            pagesConfigC.pages31[0],
            pagesConfigC.pages31[1],
            pagesConfigC.pages31[2],
            pagesConfigC.pages31[3],
            pagesConfigC.pages31[4],
            pagesConfigC.pages31[5],
          ]);
    });
    //todoooooooooooooooooooooooooooooooooooooooooo
  }

//
//
//
//
  cardClientTails(
      ClientsCoordinatorController controllerclient,
      BuildContext context,
      index,
      PageController pageController2,
      PagesConfigController pagesConfigC) {
    return FadeIn(
      duration: Duration(seconds: 2),
      child: FittedBox(
          fit: BoxFit.contain,
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      border: Border.all(
                          width: 2,
                          color: controllerclient
                                      .clientsScheduledListBranch[index]
                                      .from_home ==
                                  1
                              ? const Color(0xFFFDAE2A)
                              : controllerclient
                                          .clientsScheduledListBranch[index]
                                          .select_professional ==
                                      1
                                  ? const Color(0xFF19CF9E)
                                  : const Color(0xFF4470F3))),
                  //AQUI CONTROLO SI HAY ALGUIEN EN COLA
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white, //fondo de la imagen
                          child: ClipOval(
                            child: Image.network(
                              '${Env.apiEndpoint}/images/${controllerclient.clientsScheduledListBranch[index].client_image}',
                              fit: BoxFit
                                  .cover, // Ajusta la imagen para cubrir completamente el área
                              width:
                                  50, // Ancho deseado de la imagen dentro del círculo
                              height: 50,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  // Si la imagen se carga correctamente, mostramos la imagen
                                  return child;
                                } else {
                                  // Si la imagen aún se está cargando, mostramos un indicador de progreso
                                  return const CircularProgressIndicator(
                                    color: Color(0xFFFDAE2A),
                                  );
                                }
                              },
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                // Si la imagen no se puede cargar y estamos en modo de depuración, mostramos una imagen por defecto
                                if (kDebugMode) {
                                  return CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors
                                        .transparent, // Fondo transparente para que el borde sea visible
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/images/default_profile.jpg',
                                        fit: BoxFit
                                            .cover, // Ajusta la imagen para cubrir completamente el área
                                        width:
                                            50, // Ancho deseado de la imagen dentro del círculo
                                        height:
                                            50, // Alto deseado de la imagen dentro del círculo
                                      ),
                                    ),
                                  );
                                } else {
                                  // Si no estamos en modo de depuración, mostramos un texto de error
                                  return CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors
                                        .transparent, // Fondo transparente para que el borde sea visible
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/images/default_profile.jpg',
                                        fit: BoxFit
                                            .cover, // Ajusta la imagen para cubrir completamente el área
                                        width:
                                            50, // Ancho deseado de la imagen dentro del círculo
                                        height:
                                            50, // Alto deseado de la imagen dentro del círculo
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        //
                      ),
                      Container(
                        height: (MediaQuery.of(context).size.height * 0.115),
                        width: (MediaQuery.of(context).size.width * 0.8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0, top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    //CLIENTE
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        color: const Color.fromARGB(
                                            255, 43, 44, 49),
                                        size: 22,
                                      ),
                                      Text(
                                        controllerclient
                                            .clientsScheduledListBranch[index]
                                            .client_name!,
                                        softWrap: true,
                                        style: const TextStyle(
                                            height: 1.0,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    //HORARIO
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Icon(
                                        MdiIcons.clockOutline,
                                        color: const Color.fromARGB(
                                            255, 43, 44, 49),
                                        size: 22,
                                      ),
                                      Text(
                                        '${controllerclient.clientsScheduledListBranch[index].start_time} - ${controllerclient.clientsScheduledListBranch[index].final_hour}',
                                        softWrap: true,
                                        style: const TextStyle(
                                            height: 1.0,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    //PROFESIONAL
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Icon(
                                        MdiIcons.accountTie,
                                        color: const Color.fromARGB(
                                            255, 43, 44, 49),
                                        size: 22,
                                      ),
                                      Text(
                                        controllerclient
                                            .clientsScheduledListBranch[index]
                                            .professional_name!,
                                        softWrap: true,
                                        style: const TextStyle(
                                            height: 1.0,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 4, bottom: 4, right: 6.0),
                        child: Container(
                          height: (MediaQuery.of(context).size.height * 0.115),
                          width: (MediaQuery.of(context).size.width * 0.20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white, // Color blanco para el borde
                              width:
                                  1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                            ),
                          ),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: const Color(
                                    0xFF19CF9E), // Color de fondo en verde
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      12.0), // Ajusta el radio según tus necesidades
                                ),
                              ),
                              onPressed: () async {
                                if (loginController.codigoQrValid() == true) {
                                  Get.dialog(
                                    const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFFFDAE2A),
                                      ),
                                    ),
                                    barrierDismissible: false,
                                  ); //Get.back();
                                  int idClient = controllerclient
                                      .clientsScheduledListBranch[index]
                                      .client_id!;
                                  int idReserv = controllerclient
                                      .clientsScheduledListBranch[index]
                                      .reservation_id!;
                                  int idBranch =
                                      loginController.branchIdLoggedIn!;
                                  // aqui llamar a la db y pedir todos los datos del cliente
                                  /*   clientsScheduledController
                                          .saveIdProfessional(controllerclient
                                              .clientsScheduledListBranch[index]
                                              .professional_id!);*/
                                  controllerclient.setActualNameCORD(
                                      controllerclient
                                          .clientsScheduledListBranch[index]
                                          .professional_name);

                                  await controllerclient
                                      .getClientHistory(
                                          idClient, idBranch, idReserv)
                                      .then((_) async {
                                    if (controllerclient.correctConnection ==
                                        true) {
                                      Get.back();
                                      pageController2.nextPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.ease,
                                      );
                                    } else {
                                      Get.back();
                                      Get.snackbar(
                                        'Error',
                                        'Problemas al conectarse al servidor.',
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
                                  });
                                  // pagesConfigC.updateSelectedIndex();
                                  // await pagesConfigC.showAppBar(false);
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
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Icon(
                                        MdiIcons.eye,
                                        color: Colors.white,
                                        size: (MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.05),
                                      ),
                                      const Text(
                                        'VER MÁS',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      )
                    ],
                  )),
              const SizedBox(
                height: 12,
              )
            ],
          )),
    );
  }

//

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
      height: (MediaQuery.of(context).size.height *
          0.192), //todo cambiadoNuevoValores
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
          if (titleCart == 'Atendiéndose') {
            await pagesConfigC.updateColacionNotification(0);
            Get.dialog(
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFDAE2A),
                ),
              ),
              barrierDismissible: false,
            ); //Get.back();
            await clientsScheduledController
                .clientsAttendBranch(loginController.branchIdLoggedIn);
            pagesConfigC.onTabTapped(1);
            Get.back();
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
            await coexistenceController.fetchBranchProfessionals();
            pagesConfigC.onTabTapped(4); //index = 4 -> /CoexistencePage
            Get.back();
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
            pagesConfigC.onTabTapped(3); //index = 3 -> /StatisticPage
            Get.back();
          }
          if (titleCart == 'Colación') {
            await pagesConfigC.updateColacionNotification(1);
            Get.dialog(
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFDAE2A),
                ),
              ),
              barrierDismissible: false,
            ); //Get.back();
            await clientsScheduledController.ClientsColacionBranch(
                loginController.branchIdLoggedIn);
            pagesConfigC.onTabTapped(1); //index = 2 -> /NotificationsPageProf
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

  Column showRequestsDelete(
      context,
      ShoppingCartController contShopp,
      LoginController controllerLogin,
      ClientsCoordinatorController controllerclient) {
    List<Widget> widgets = [];
    String titulo = "";
    bool service = false;
    /* if (fin > 2) {
    fin = 2;
  }*/

    //todo aqui le muestra las solicitudes de Salida
    for (int i = 0; i < controllerclient.pOutRequestLength; i++) {
      titulo = 'Solicitando Salida';

      widgets.add(
        FittedBox(
          fit: BoxFit.contain,
          child: Column(
            children: [
              Container(
                height: (MediaQuery.of(context).size.height * 0.126),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 6, top: 6, bottom: 6),
                      child: Container(
                        height: (MediaQuery.of(context).size.height * 0.120),
                        width: (MediaQuery.of(context).size.width * 0.20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white, // Color blanco para el borde
                            width:
                                1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                          ),
                          color: const Color(0xFFFF6750),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            //  if (controllerLogin.codigoQrValid() == true) {
                            if (controllerLogin.usserPermissionQr == 1 ||
                                controllerLogin.usserPermissionQr == 2) {
                              loginController.setMakeCallC(
                                  false); //se pone a false para que el timer no haga llamadas
                              controllerShoppingCart.setLoading(true);
                              int idProf = controllerclient
                                  .pOutRequestBranch[i].professional_id!;
                              String charge =
                                  controllerclient.pOutRequestBranch[i].charge!;
                              if (charge == 'Barbero y Encargado') {
                                charge = 'Barbero';
                              }

                              int result =
                                  await controllerLogin.ColacionProfessional(
                                      idProf, charge, 1);
                              //aqui mandar notificacion
                              if (result == 1) {
                                //codigo 200
                                String typeDelete =
                                    'Rechazada su solicitud de Salida';

                                notiController.storeNotification2(
                                    typeDelete,
                                    controllerLogin.branchIdLoggedIn,
                                    idProf,
                                    'Su solicitud de Salida fue rechazada',
                                    charge);
                              } else {
                                Get.snackbar(
                                  'Alerta',
                                  'Inténtelo nuevamente,problemas de conexión',
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
                              if (controllerLogin.branchIdLoggedIn != null) {
                                //loginController.setMakeCallC(true);//se pone a true dentro de la funcion cuando finaliza
                                await controllerclient.outRequestBranch(
                                    controllerLogin.branchIdLoggedIn);
                                controllerShoppingCart.setLoading(false);
                              }
                              loginController.setMakeCallC(
                                  true); //por si no entrara al metodo,que avilite las llamadas del timer
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
                                        Color(0xFFFDAE2A)),
                                overlayBlur: 3,
                              );
                            }
                          },
                          icon: Icon(
                            MdiIcons.thumbDownOutline,
                            color: Colors.white,
                            size: (MediaQuery.of(context).size.height * 0.04),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: (MediaQuery.of(context).size.height * 0.120),
                      width: (MediaQuery.of(context).size.width * 0.8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' $titulo',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AutofillHints.familyName,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 0, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Icon(
                                        MdiIcons.accountTie,
                                      ),
                                      Text(
                                        controllerclient.pOutRequestBranch[i]
                                            .professional_name!,
                                        style: TextStyle(
                                          fontSize: (MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.018),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                      controllerclient
                                          .pOutRequestBranch[i].start_time!,
                                      style: TextStyle(
                                          fontSize: (MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.018),
                                          fontWeight: FontWeight.w800,
                                          height: 1)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 6, top: 6, bottom: 6),
                      child: Container(
                        height: (MediaQuery.of(context).size.height * 0.120),
                        width: (MediaQuery.of(context).size.width * 0.20),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white, // Color blanco para el borde
                              width:
                                  1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                            ),
                            color: const Color(0xFF19CF9E),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12))),
                        child: IconButton(
                          onPressed: () async {
                            if (controllerLogin.usserPermissionQr == 1 ||
                                controllerLogin.usserPermissionQr == 2) {
                              loginController.setMakeCallC(
                                  false); //desavilite las llamadas del timer
                              controllerShoppingCart.setLoading(true);
                              int idProf = controllerclient
                                  .pOutRequestBranch[i].professional_id!;
                              String charge =
                                  controllerclient.pOutRequestBranch[i].charge!;
                              if (charge == 'Barbero y Encargado') {
                                charge = 'Barbero';
                              }

                              int result =
                                  await controllerLogin.ColacionProfessional(
                                      idProf, charge, 0);
                              //aqui mandar notificacion
                              if (result == 1) {
                                //poner a 4 para que le cierre la session el Qr
                                // controllerLogin.setCodigoQrValid(null);
                                //viendo a la hora que se le aceptó
                                var now = DateTime.now(); //hora actual
                                //sumo 1 hora
                                var formatter = DateFormat('hh:mm');
                                String formattedTime = formatter.format(now);

                                //codigo 200
                                String typeDelete =
                                    'Aceptada su solicitud de Salida';

                                notiController.storeNotification2(
                                    typeDelete,
                                    controllerLogin.branchIdLoggedIn,
                                    idProf,
                                    'Aceptada su solicitud de Salida, ($formattedTime).',
                                    charge);
                              } else {
                                Get.snackbar(
                                  'Alerta',
                                  'Inténtelo nuevamente,problemas de conexión',
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
                              if (controllerLogin.branchIdLoggedIn != null) {
                                // loginController.setMakeCallC(
                                //   true); //avilite las llamadas del timer
                                await controllerclient.outRequestBranch(
                                    controllerLogin.branchIdLoggedIn);
                                controllerShoppingCart.setLoading(false);
                              }
                              loginController.setMakeCallC(
                                  true); //avilite las llamadas del timer
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
                                        Color(0xFFFDAE2A)),
                                overlayBlur: 3,
                              );
                            }
                          },
                          icon: Icon(
                            MdiIcons.thumbUpOutline,
                            color: Colors.white,
                            size: (MediaQuery.of(context).size.height * 0.04),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              )
            ],
          ),
        ),
      );
    }
    //
    //
    //todo aqui le muestra las solicitudes de Salida
    //
    //

    //
    //todo aqui le muestra las solicitudes de Colación
    for (int i = 0; i < controllerclient.clientsColacionRequestLength; i++) {
      titulo = 'Solicitando Colación';

      widgets.add(
        FittedBox(
          fit: BoxFit.contain,
          child: Column(
            children: [
              Container(
                height: (MediaQuery.of(context).size.height * 0.126),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 6, top: 6, bottom: 6),
                      child: Container(
                        height: (MediaQuery.of(context).size.height * 0.120),
                        width: (MediaQuery.of(context).size.width * 0.20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white, // Color blanco para el borde
                            width:
                                1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                          ),
                          color: const Color(0xFFFF6750),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            //  if (controllerLogin.codigoQrValid() == true) {
                            if (controllerLogin.usserPermissionQr == 1 ||
                                controllerLogin.usserPermissionQr == 2) {
                              loginController.setMakeCallC(
                                  false); //de-avilite las llamadas del timer
                              controllerShoppingCart.setLoading(true);
                              int idProf = controllerclient
                                  .clientsColacionRequestBranch[i]
                                  .professional_id!;
                              String charge = controllerclient
                                  .clientsColacionRequestBranch[i].charge!;
                              if (charge == 'Barbero y Encargado') {
                                charge = 'Barbero';
                              }
                              print('este es el cargo : $charge');

                              int result =
                                  await controllerLogin.ColacionProfessional(
                                      idProf, charge, 1);
                              //aqui mandar notificacion
                              if (result == 1) {
                                //codigo 200
                                String typeDelete =
                                    'Rechazada su solicitud de Colación';

                                notiController.storeNotification2(
                                    typeDelete,
                                    controllerLogin.branchIdLoggedIn,
                                    idProf,
                                    'Su solicitud de Colación fue rechazada',
                                    charge);
                              } else {
                                Get.snackbar(
                                  'Alerta',
                                  'Inténtelo nuevamente,problemas de conexión',
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
                              if (controllerLogin.branchIdLoggedIn != null) {
                                // loginController.setMakeCallC(
                                //   true); //avilite las llamadas del timer
                                await clientsScheduledController
                                    .ColacionRequestBranch(
                                        controllerLogin.branchIdLoggedIn);
                                controllerShoppingCart.setLoading(false);
                              }
                              loginController.setMakeCallC(
                                  true); //avilite las llamadas del timer
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
                                        Color(0xFFFDAE2A)),
                                overlayBlur: 3,
                              );
                            }
                          },
                          icon: Icon(
                            MdiIcons.thumbDownOutline,
                            color: Colors.white,
                            size: (MediaQuery.of(context).size.height * 0.04),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: (MediaQuery.of(context).size.height * 0.120),
                      width: (MediaQuery.of(context).size.width * 0.8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' $titulo',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AutofillHints.familyName,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 0, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Icon(
                                        MdiIcons.accountTie,
                                      ),
                                      Text(
                                        controllerclient
                                            .clientsColacionRequestBranch[i]
                                            .professional_name!,
                                        style: TextStyle(
                                          fontSize: (MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.018),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                      controllerclient
                                          .clientsColacionRequestBranch[i]
                                          .start_time!,
                                      style: TextStyle(
                                          fontSize: (MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.018),
                                          fontWeight: FontWeight.w800,
                                          height: 1)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 6, top: 6, bottom: 6),
                      child: Container(
                        height: (MediaQuery.of(context).size.height * 0.120),
                        width: (MediaQuery.of(context).size.width * 0.20),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white, // Color blanco para el borde
                              width:
                                  1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                            ),
                            color: const Color(0xFF19CF9E),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12))),
                        child: IconButton(
                          onPressed: () async {
                            if (controllerLogin.usserPermissionQr == 1 ||
                                controllerLogin.usserPermissionQr == 2) {
                              loginController.setMakeCallC(
                                  false); //avilite las llamadas del timer
                              controllerShoppingCart.setLoading(true);
                              int idProf = controllerclient
                                  .clientsColacionRequestBranch[i]
                                  .professional_id!;
                              String charge = controllerclient
                                  .clientsColacionRequestBranch[i].charge!;
                              if (charge == 'Barbero y Encargado') {
                                charge = 'Barbero';
                              }

                              int result =
                                  await controllerLogin.ColacionProfessional(
                                      idProf, charge, 2);
                              //aqui mandar notificacion
                              if (result == 1) {
                                //poner a null el Qr
                                // controllerLogin.setCodigoQrValid(null);
                                //viendo a la hora que se le aceptó
                                var now = DateTime.now(); //hora actual
                                var oneHourLater =
                                    now.add(Duration(hours: 1)); //sumo 1 hora
                                var formatter = DateFormat('hh:mm');
                                String formattedTime = formatter.format(now);
                                String formattedTime2 =
                                    formatter.format(oneHourLater);
                                //codigo 200
                                String typeDelete =
                                    'Aceptada su solicitud de Colación';

                                notiController.storeNotification2(
                                    typeDelete,
                                    controllerLogin.branchIdLoggedIn,
                                    idProf,
                                    'Aceptada su solicitud de Colación, de ($formattedTime a $formattedTime2)',
                                    charge);
                              } else {
                                Get.snackbar(
                                  'Alerta',
                                  'Inténtelo nuevamente,problemas de conexión',
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
                              if (controllerLogin.branchIdLoggedIn != null) {
                                await clientsScheduledController
                                    .ColacionRequestBranch(
                                        controllerLogin.branchIdLoggedIn);
                                controllerShoppingCart.setLoading(false);
                              }
                              loginController.setMakeCallC(
                                  true); //avilite las llamadas del timer
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
                                        Color(0xFFFDAE2A)),
                                overlayBlur: 3,
                              );
                            }
                          },
                          icon: Icon(
                            MdiIcons.thumbUpOutline,
                            color: Colors.white,
                            size: (MediaQuery.of(context).size.height * 0.04),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              )
            ],
          ),
        ),
      );
    }
    //
    //todo aqui le muestra las solicitudes de Colación
    //

    //todo aqui le muestra a los clientes solicitados como rechazados
    for (int i = 0;
        i < controllerclient.clientsScheduledListBranchClientLength;
        i++) {
      titulo = 'Rechazando Cliente';

      widgets.add(
        FittedBox(
          fit: BoxFit.contain,
          child: Column(
            children: [
              Container(
                height: (MediaQuery.of(context).size.height * 0.126),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 6, top: 6, bottom: 6),
                      child: Container(
                        height: (MediaQuery.of(context).size.height * 0.126),
                        width: (MediaQuery.of(context).size.width * 0.20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white, // Color blanco para el borde
                            width:
                                1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                          ),
                          color: const Color(0xFFFF6750),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            if (controllerLogin.usserPermissionQr == 1 ||
                                controllerLogin.usserPermissionQr == 2) {
                              loginController.setMakeCallC(
                                  false); //de-avilite las llamadas del timer
                              //rechazar la Eliminación
                              controllerShoppingCart.setLoading(true);
                              print('rechazando la solicitud');
                              //aqui mandar a poner en 0 de nuevo en la cola al cliente
                              bool result = false;
                              String charge = controllerclient
                                  .clientsScheduledListBranchClient[i].charge!;
                              print('rechazando la solicitud - charge:$charge');
                              if (charge == 'Barbero y Encargado') {
                                charge = 'Barbero';
                              }
                              if (charge == 'Barbero') {
                                result = await clientsScheduledController
                                    .acceptOrRejectClientCoord(
                                        controllerclient
                                            .clientsScheduledListBranchClient[i]
                                            .reservation_id,
                                        0);
                              } else if (charge == 'Tecnico') {
                                result = await clientsScheduledController
                                    .acceptOrRejectClientCoord(
                                        controllerclient
                                            .clientsScheduledListBranchClient[i]
                                            .reservation_id,
                                        4);
                              }

                              //aqui mandar notificacion
                              print('return resul: IconButton $result');
                              if (result == true) {
                                if (charge == 'Barbero') {
                                  notiController.storeNotification2(
                                      'Solicitud de Eliminación Rechazada',
                                      controllerLogin.branchIdLoggedIn,
                                      controllerclient
                                          .clientsScheduledListBranchClient[i]
                                          .professional_id,
                                      '!Atención..El cliente ${controllerclient.clientsScheduledListBranchClient[i].client_name} no fue rechazado.',
                                      'Barbero');
                                } else if (charge == 'Tecnico') {
                                  notiController.storeNotification2(
                                      'Solicitud de Eliminación Rechazada',
                                      controllerLogin.branchIdLoggedIn,
                                      controllerclient
                                          .clientsScheduledListBranchClient[i]
                                          .professional_id,
                                      '!Atención..El cliente ${controllerclient.clientsScheduledListBranchClient[i].client_name} no fue rechazado.',
                                      'Tecnico');
                                }
                                if (controllerLogin.branchIdLoggedIn != null) {
                                  // loginController.setMakeCallC(true); //avilite las llamadas del timer
                                  await controllerclient
                                      .fetchClientsRechazBranch(
                                          controllerLogin.branchIdLoggedIn!);
                                  await contShopp.loadOrderDeleteCar(
                                      controllerLogin.branchIdLoggedIn!);
                                  controllerShoppingCart.setLoading(false);
                                }
                                loginController.setMakeCallC(true);
                              } else {
                                Get.snackbar(
                                  'Mensaje',
                                  'Intentelo nuevamente',
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
                                controllerShoppingCart.setLoading(false);
                              }
                              loginController.setMakeCallC(
                                  true); //avilite las llamadas del timer
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
                                        Color(0xFFFDAE2A)),
                                overlayBlur: 3,
                              );
                            }
                          },
                          icon: Icon(
                            MdiIcons.thumbDownOutline,
                            color: Colors.white,
                            size: (MediaQuery.of(context).size.height * 0.04),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: (MediaQuery.of(context).size.height * 0.120),
                      width: (MediaQuery.of(context).size.width * 0.8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ' $titulo',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        height: 1),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 0, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.person,
                                          color: Color.fromARGB(180, 0, 0, 0),
                                        ),
                                        Text(
                                          controllerclient
                                              .clientsScheduledListBranchClient[
                                                  i]
                                              .client_name!,
                                          style: TextStyle(
                                              fontSize: (MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.018),
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Text(
                                        controllerclient
                                            .clientsScheduledListBranchClient[i]
                                            .time
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: (MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.018),
                                            fontWeight: FontWeight.w800)),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    MdiIcons.accountTie,
                                  ),
                                  Text(
                                    controllerclient
                                        .clientsScheduledListBranchClient[i]
                                        .professional_name
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: (MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.018),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 6, top: 6, bottom: 6),
                      child: Container(
                        height: (MediaQuery.of(context).size.height * 0.126),
                        width: (MediaQuery.of(context).size.width * 0.20),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white, // Color blanco para el borde
                              width:
                                  1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                            ),
                            color: const Color(0xFF19CF9E),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12))),
                        child: IconButton(
                          onPressed: () async {
                            if (controllerLogin.usserPermissionQr == 1 ||
                                controllerLogin.usserPermissionQr == 2) {
                              loginController.setMakeCallC(
                                  false); //de-avilite las llamadas del timer
                              controllerShoppingCart.setLoading(true);
                              String charge = controllerclient
                                  .clientsScheduledListBranchClient[i].charge!;
                              bool result = false;
                              String typeDelete = '';
                              if (charge == 'Barbero y Encargado') {
                                charge = 'Barbero';
                              }
                              if (charge == 'Barbero') {
                                result = await clientsScheduleCont
                                    .deleteReservationClientCoor(
                                        controllerclient
                                            .clientsScheduledListBranchClient[i]
                                            .reservation_id,
                                        'Fue rechazado por ${controllerclient.clientsScheduledListBranchClient[i].professional_name}');
                                typeDelete = 'Aceptada Eliminación de Cliente';
                              } else if (charge == 'Tecnico') {
                                result = await clientsScheduledController
                                    .acceptOrRejectClientCoord(
                                        controllerclient
                                            .clientsScheduledListBranchClient[i]
                                            .reservation_id,
                                        11);

                                typeDelete = 'Aceptada Eliminación de Cliente';
                              }

                              //aqui mandar notificacion
                              print('return resul: IconButton $result');
                              if (result == true) {
                                if (charge == 'Barbero') {
                                  notiController.storeNotification(
                                      typeDelete,
                                      controllerLogin.branchIdLoggedIn,
                                      controllerclient
                                          .clientsScheduledListBranchClient[i]
                                          .professional_id,
                                      'El cliente ${controllerclient.clientsScheduledListBranchClient[i].client_name} fue eliminado de su cola',
                                      'Barbero');
                                } else if (charge == 'Tecnico') {
                                  //enviar mensaje al barbero que el cliente esta regresando porque fue rechazado

                                  notiController.storeNotification(
                                      'Cliente rechazado por el Técnico',
                                      controllerLogin.branchIdLoggedIn,
                                      controllerclient
                                          .clientsScheduledListBranchClient[i]
                                          .idBarber,
                                      'El cliente ${controllerclient.clientsScheduledListBranchClient[i].client_name} fue rechazado por el Técnico ${controllerclient.clientsScheduledListBranchClient[i].professional_name}',
                                      'Barbero');
                                  //enviar notificacion al propio tecnico que fue aceptada
                                  notiController.storeNotification(
                                      typeDelete,
                                      controllerLogin.branchIdLoggedIn,
                                      controllerclient
                                          .clientsScheduledListBranchClient[i]
                                          .professional_id,
                                      'El cliente ${controllerclient.clientsScheduledListBranchClient[i].client_name} fue eliminado de su cola',
                                      'Tecnico');
                                }
                              }
                              if (controllerLogin.branchIdLoggedIn != null) {
                                //  loginController.setMakeCallC(true); //de-avilite las llamadas del timer
                                await controllerclient.fetchClientsRechazBranch(
                                    controllerLogin.branchIdLoggedIn!);
                                await contShopp.loadOrderDeleteCar(
                                    controllerLogin.branchIdLoggedIn!);
                                controllerShoppingCart.setLoading(false);
                              }
                              loginController.setMakeCallC(
                                  true); //avilite las llamadas del timer
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
                                        Color(0xFFFDAE2A)),
                                overlayBlur: 3,
                              );
                            }
                          },
                          icon: Icon(
                            MdiIcons.thumbUpOutline,
                            color: Colors.white,
                            size: (MediaQuery.of(context).size.height * 0.04),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              )
            ],
          ),
        ),
      );
    }
    //
    //
    //todo aqui le muestra a los clientes solicitados como rechazados
//todo aqui le muestra las solicitudes de Eliminación de Servicios y Productos
    for (int i = 0; i < contShopp.orderDeleteCar.length; i++) {
      if (contShopp.orderDeleteCar[i].nameService == '') {
        titulo = 'Eliminación de Producto';
        service = false;
      } else {
        titulo = 'Eliminación de Servicio';
        service = true;
      }
      widgets.add(
        FittedBox(
          fit: BoxFit.contain,
          child: Column(
            children: [
              Container(
                height: (MediaQuery.of(context).size.height * 0.126),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 6, top: 6, bottom: 6),
                      child: Container(
                        height: (MediaQuery.of(context).size.height * 0.126),
                        width: (MediaQuery.of(context).size.width * 0.20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6750),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color(
                                0xFFFF6750), // Color de fondo en verde
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12.0), // Ajusta el radio según tus necesidades
                            ),
                            // Ajusta el radio según tus necesidades
                          ),
                          onPressed: () async {
                            if (controllerLogin.usserPermissionQr == 1 ||
                                controllerLogin.usserPermissionQr == 2) {
                              //rechazar la Eliminación
                              loginController.setMakeCallC(
                                  false); //de-avilite las llamadas del timer
                              controllerShoppingCart.setLoading(true);
                              int result = await contShopp.requestDelete(
                                  contShopp.orderDeleteCar[i].id, 0);
                              //aqui mandar notificacion
                              if (result == 1) {
                                String serviceProduct = 'Servicio';
                                String? nameServiceProduct =
                                    contShopp.orderDeleteCar[i].nameService;
                                if (contShopp.orderDeleteCar[i].nameService ==
                                    null) {
                                  serviceProduct = 'Producto';
                                  nameServiceProduct =
                                      contShopp.orderDeleteCar[i].nameProduct;
                                }

                                notiController.storeNotification(
                                    'Solicitud de Eliminación Rechazada',
                                    controllerLogin.branchIdLoggedIn,
                                    contShopp.orderDeleteCar[i].profesional_id,
                                    '!Atención..El $serviceProduct "$nameServiceProduct" de el cliente ${contShopp.orderDeleteCar[i].nameClient} no fue aprobado para su eliminación.',
                                    'Barbero');
                              }
                              if (controllerLogin.branchIdLoggedIn != null) {
                                await contShopp.loadOrderDeleteCar(
                                    controllerLogin.branchIdLoggedIn!);
                                controllerShoppingCart.setLoading(false);
                              }
                              loginController.setMakeCallC(
                                  true); //avilite las llamadas del timer
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
                    ),
                    Container(
                      height: (MediaQuery.of(context).size.height * 0.120),
                      width: (MediaQuery.of(context).size.width * 0.8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, left: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' $titulo',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      height: 1),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 5, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        MdiIcons.formatListBulleted,
                                      ),
                                      Text(
                                        service
                                            ? '${contShopp.orderDeleteCar[i].nameService}'
                                            : '${contShopp.orderDeleteCar[i].nameProduct}',
                                        style: TextStyle(
                                            fontSize: (MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.018),
                                            fontWeight: FontWeight.w500,
                                            height: 1),
                                      ),
                                    ],
                                  ),
                                  Text(
                                      contShopp.orderDeleteCar[i].hora
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: (MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.018),
                                          fontWeight: FontWeight.w800,
                                          height: 1)),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(
                                  MdiIcons.accountTie,
                                ),
                                Text(
                                  contShopp.orderDeleteCar[i].nameProfesional
                                      .toString(),
                                  style: TextStyle(
                                      fontSize:
                                          (MediaQuery.of(context).size.height *
                                              0.018),
                                      fontWeight: FontWeight.w500,
                                      height: 1),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: Color.fromARGB(180, 0, 0, 0),
                                ),
                                Text(
                                  contShopp.orderDeleteCar[i].nameClient,
                                  style: TextStyle(
                                      fontSize:
                                          (MediaQuery.of(context).size.height *
                                              0.018),
                                      fontWeight: FontWeight.w500,
                                      height: 1),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 6, top: 6, bottom: 6),
                      child: Container(
                        height: (MediaQuery.of(context).size.height * 0.126),
                        width: (MediaQuery.of(context).size.width * 0.20),
                        decoration: BoxDecoration(
                            color: const Color(0xFF19CF9E),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12))),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color(
                                0xFF19CF9E), // Color de fondo en verde
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12.0), // Ajusta el radio según tus necesidades
                            ),
                          ),
                          onPressed: () async {
                            if (controllerLogin.usserPermissionQr == 1 ||
                                controllerLogin.usserPermissionQr == 2) {
                              if (contShopp.buttonPress == false) {
                                contShopp.setButtonPress(true);
                                loginController.setMakeCallC(
                                    false); //avilite las llamadas del timer
                                controllerShoppingCart.setLoading(true);
                                int result = await contShopp.orderDelete(
                                    contShopp.orderDeleteCar[i].id);
                                //aqui mandar notificacion
                                print('return resul: IconButton $result');
                                print(
                                    'return resul: orderDeleteCar[i].id ${contShopp.orderDeleteCar[i].id}');
                                if (result == 1) {
                                  String typeDelete =
                                      'Aceptada Eliminación de Servicio';
                                  String serviceProduct = 'Servicio';
                                  String? nameServiceProduct =
                                      contShopp.orderDeleteCar[i].nameService;
                                  if (contShopp.orderDeleteCar[i].nameService ==
                                      '') {
                                    typeDelete =
                                        'Aceptada Eliminación de Producto';
                                    serviceProduct = 'Producto';
                                    nameServiceProduct =
                                        contShopp.orderDeleteCar[i].nameProduct;
                                  }

                                  if (typeDelete ==
                                      'Aceptada Eliminación de Servicio') {
                                    notiController.storeNotification2(
                                        typeDelete,
                                        controllerLogin.branchIdLoggedIn,
                                        contShopp
                                            .orderDeleteCar[i].profesional_id,
                                        '$serviceProduct "$nameServiceProduct" del cliente ${contShopp.orderDeleteCar[i].nameClient} fue eliminado con tiempo de ${contShopp.orderDeleteCar[i].duration_service} min.${contShopp.orderDeleteCar[i].reservation_id}',
                                        'Barbero');
                                  } else {
                                    notiController.storeNotification(
                                        typeDelete,
                                        controllerLogin.branchIdLoggedIn,
                                        contShopp
                                            .orderDeleteCar[i].profesional_id,
                                        'El $serviceProduct "$nameServiceProduct" del cliente ${contShopp.orderDeleteCar[i].nameClient} fue eliminado satisfactoriamente.',
                                        'Barbero');
                                  }
                                }
                                if (controllerLogin.branchIdLoggedIn != null) {
                                  // loginController.setMakeCallC(
                                  // true); //avilite las llamadas del timer
                                  await contShopp.loadOrderDeleteCar(
                                      controllerLogin.branchIdLoggedIn!);
                                  controllerShoppingCart.setLoading(false);
                                  contShopp.setButtonPress(false);
                                }
                              }
                              controllerShoppingCart.setLoading(false);
                              contShopp.setButtonPress(false);
                              loginController.setMakeCallC(
                                  true); //avilite las llamadas del timer
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
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              )
            ],
          ),
        ),
      );
    }
    //
    //todo aqui le muestra las solicitudes de Eliminación de Servicios y Productos
    //

    //
    if ((contShopp.orderDeleteCar.isEmpty) &&
        (controllerclient.clientsScheduledListBranchClient.isEmpty) &&
        (controllerclient.clientsScheduledListBranchClient.isEmpty) &&
        (controllerclient.pOutRequestBranch.isEmpty)) {
      widgets.add(const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 80),
          child: Text(
            'No hay solicitudes a eliminar.',
            // style: TextStyle(color: Color.fromARGB(255, 63, 63, 63)),
          ),
        ),
      ));
    }

    return Column(
      children: widgets,
    );
  }
}
