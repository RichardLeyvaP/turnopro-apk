import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsCoordinatorController.dart';
import 'package:turnopro_apk/Controllers/coexistence.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/notification.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Controllers/shoppingCart.controller.dart';
import 'package:turnopro_apk/env.dart';

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
        loginController.branchIdLoggedIn != null) {
      iniciarLlamadaCada10Segundos();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Timer? _timer;
  iniciarLlamadaCada10Segundos() {
    // Cancela cualquier temporizador existente para evitar duplicaciones
    _timer?.cancel();
    int cont = -1;
    // Establece un temporizador que llama a la función cada 20 segundos
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) async {
      print('hola entrando en 10 min;;');
      if (loginController.branchIdLoggedIn != null &&
          loginController.chargeUserLoggedIn == "Cordinador") {
        cont += 1;
        if (cont == 0) {
          //SOLO ESTRA UNA SOLA VEZ AL INICIO
          await clientsScheduledController
              .clientsAttendBranch(loginController.branchIdLoggedIn);
          await controllerShoppingCart
              .loadOrderDeleteCar(loginController.branchIdLoggedIn!);
          controllerShoppingCart.setLoading(false);
        }
        if (cont == 1) {
          print('Aqui entro solo la primera vez (cont == 0)');
          notiController.fetchNotificationList(loginController.branchIdLoggedIn,
              loginController.idProfessionalLoggedIn);

          await clientsScheduledController
              .fetchClientsScheduledBranch(loginController.branchIdLoggedIn);
          clientsScheduledController.setLoading(false);
        }
        if (cont == 10) {
          // actualizo la cola
          notiController.fetchNotificationList(loginController.branchIdLoggedIn,
              loginController.idProfessionalLoggedIn);
          print('con contador en 8 llamo la funcion');
          await clientsScheduledController
              .fetchClientsScheduledBranch(loginController.branchIdLoggedIn);
          clientsScheduledController.setLoading(false);
          await controllerShoppingCart
              .loadOrderDeleteCar(loginController.branchIdLoggedIn!);
          controllerShoppingCart.setLoading(false);
          //fin del for
          cont = 1;
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
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: Color.fromARGB(255, 26, 50, 82),
                      ),
                      child: controllerclient.isLoading
                          ? const Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Color.fromARGB(255, 241, 130, 84),
                                ),
                                Text(
                                  'Cargando ...',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                )
                              ],
                            ))
                          : controllerclient.clientsScheduledListBranchLength >
                                  0
                              ? Stack(
                                  children: [
                                    Positioned.fill(
                                      child: TabBarView(
                                        controller: _tabController,
                                        children: [
                                          // Contenido de las pestañas

                                          SingleChildScrollView(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8,
                                                  top: 4,
                                                  right: 8,
                                                  bottom: 6),
                                              child: FadeIn(
                                                duration:
                                                    const Duration(seconds: 2),
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
                                                              color: Color
                                                                  .fromARGB(
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
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 33),
                                                          child: showRequestsDelete(
                                                              context,
                                                              contShopp,
                                                              loginController),
                                                        );
                                                      }
                                                    }),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

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
                                              itemBuilder: (context, index) =>
                                                  cardClientTails(
                                                      controllerclient,
                                                      context,
                                                      index,
                                                      pagesConfigC
                                                          .pageController2,
                                                      pagesConfigC),
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
                                                  _tabController
                                                      .animateTo(index);
                                                },
                                                labelColor: Color.fromARGB(
                                                    255,
                                                    26,
                                                    50,
                                                    82), // Color del texto
                                                unselectedLabelColor: Colors
                                                    .grey, // Color del texto cuando no está seleccionado

                                                indicator: BoxDecoration(
                                                  color: Colors
                                                      .white, // Color de fondo cuando está seleccionado
                                                  borderRadius:
                                                      BorderRadius.circular(
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
                                )
                              : const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'No hay clientes en cola',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                    ),
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
                                    GestureDetector(
                                      onTap: () async {
                                        await pagesConfigC.showAppBar(false);
                                        await clientsScheduledController
                                            .clientsAttendBranch(loginController
                                                .branchIdLoggedIn);
                                        pagesConfigC.onTabTapped(1);
                                        /* pagesConfigC.goToPage(
                                            4, pagesConfigC.pageController2);*/
                                      },
                                      child: cartsHome(
                                          context,
                                          12,
                                          const Color(0xFF2B3141),
                                          const Color.fromARGB(
                                              255, 231, 233, 233),
                                          'Atendiéndose',
                                          'Clientes Atendiéndose',
                                          Icons.person),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        pagesConfigC.onTabTapped(
                                            2); //index = 2 -> /NotificationsPageProf
                                      },
                                      child: cartsHome(
                                          context,
                                          12,
                                          const Color.fromARGB(
                                              255, 81, 93, 117),
                                          Color.fromARGB(255, 231, 233, 233),
                                          'Notificaciones',
                                          'Tus Notificaciones',
                                          Icons.notifications),
                                    ),
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
                                    InkWell(
                                      onTap: () {
                                        pagesConfigC.onTabTapped(
                                            3); //index = 3 -> /StatisticPage
                                      },
                                      child: cartsHome(
                                          context,
                                          12,
                                          const Color.fromARGB(
                                              255, 177, 174, 174),
                                          Color.fromARGB(255, 231, 233, 233),
                                          'Estadísticas',
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
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  //AQUI CONTROLO SI HAY ALGUIEN EN COLA
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              '${Env.apiEndpoint}/images/${controllerclient.clientsScheduledListBranch[index].client_image}'),
                          radius: 40, // Ajusta el tamaño del círculo aquí
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
                                            .client_name,
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
                      InkWell(
                        onTap: () async {
                          await pagesConfigC.showAppBar(false);
                          pageController2.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 4, bottom: 4, right: 6.0),
                          child: Container(
                            height:
                                (MediaQuery.of(context).size.height * 0.115),
                            width: (MediaQuery.of(context).size.width * 0.20),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors
                                      .white, // Color blanco para el borde
                                  width:
                                      1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                                ),
                                color: const Color.fromARGB(255, 43, 44, 49),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        if (loginController.codigoQrValid() ==
                                            true) {
                                          int idClient = controllerclient
                                              .clientsScheduledListBranch[index]
                                              .client_id;
                                          int idReserv = controllerclient
                                              .clientsScheduledListBranch[index]
                                              .reservation_id;
                                          int idBranch =
                                              loginController.branchIdLoggedIn!;
                                          // aqui llamar a la db y pedir todos los datos del cliente
                                          /*   clientsScheduledController
                                            .saveIdProfessional(controllerclient
                                                .clientsScheduledListBranch[index]
                                                .professional_id!);*/
                                          controllerclient.setActualNameCORD(
                                              controllerclient
                                                  .clientsScheduledListBranch[
                                                      index]
                                                  .professional_name);
                                          await controllerclient
                                              .getClientHistory(
                                                  idClient, idBranch, idReserv);
                                          // pagesConfigC.updateSelectedIndex();
                                          await pagesConfigC.showAppBar(false);
                                          pageController2.nextPage(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.ease,
                                          );
                                        } else {
                                          Get.snackbar(
                                            'Mensaje',
                                            'Debe de escanear el código Qr de entrada',
                                            duration: const Duration(
                                                milliseconds: 2500),
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    118, 255, 255, 255),
                                            showProgressIndicator: true,
                                            progressIndicatorBackgroundColor:
                                                const Color.fromARGB(
                                                    255, 203, 205, 209),
                                            progressIndicatorValueColor:
                                                const AlwaysStoppedAnimation(
                                                    Color(0xFFF18254)),
                                            overlayBlur: 3,
                                          );
                                        }
                                      },
                                      icon: Icon(
                                        MdiIcons.eye,
                                        color: Colors.white,
                                        size: (MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.05),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                                const Text(
                                  'VER MÁS',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
//
//
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

  Column showRequestsDelete(context, ShoppingCartController contShopp,
      LoginController controllerLogin) {
    List<Widget> widgets = [];
    String titulo = "";
    bool service = false;
    /* if (fin > 2) {
    fin = 2;
  }*/

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
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    Container(
                      height: (MediaQuery.of(context).size.height * 0.120),
                      width: (MediaQuery.of(context).size.width * 0.20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white, // Color blanco para el borde
                          width:
                              1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                        ),
                        color: const Color.fromARGB(255, 241, 130, 84),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                      ),
                      child: IconButton(
                        onPressed: () async {
                          if (controllerLogin.codigoQrValid() == true) {
                            //rechazar la eliminacion
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
                                  'Solicitud de Eliminacion Rechazada',
                                  controllerLogin.branchIdLoggedIn,
                                  contShopp.orderDeleteCar[i].profesional_id,
                                  '!Atención..El $serviceProduct "$nameServiceProduct" de el cliente ${contShopp.orderDeleteCar[i].nameClient} no fue aprobado para su eliminación.');
                            }
                            if (controllerLogin.branchIdLoggedIn != null) {
                              await contShopp.loadOrderDeleteCar(
                                  controllerLogin.branchIdLoggedIn!);
                              controllerShoppingCart.setLoading(false);
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
                      height: (MediaQuery.of(context).size.height * 0.120),
                      width: (MediaQuery.of(context).size.width * 0.8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30),
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
                                        fontFamily: AutofillHints.familyName,
                                        fontSize: 22),
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
                                    Text(
                                        service
                                            ? ' ${contShopp.orderDeleteCar[i].nameService}'
                                            : ' ${contShopp.orderDeleteCar[i].nameProduct}',
                                        style: TextStyle(
                                            fontSize: (MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.018),
                                            fontWeight: FontWeight.w500)),
                                    Text(
                                        contShopp.orderDeleteCar[i].hora
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
                                    contShopp.orderDeleteCar[i].nameProfesional
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.person,
                                    color: Color.fromARGB(180, 0, 0, 0),
                                  ),
                                  Text(
                                    contShopp.orderDeleteCar[i].nameClient,
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
                    Container(
                      height: (MediaQuery.of(context).size.height * 0.120),
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
                          if (controllerLogin.codigoQrValid() == true) {
                            controllerShoppingCart.setLoading(true);
                            int result = await contShopp
                                .orderDelete(contShopp.orderDeleteCar[i].id);
                            //aqui mandar notificacion
                            print('return resul: IconButton $result');
                            print(
                                'return resul: orderDeleteCar[i].id ${contShopp.orderDeleteCar[i].id}');
                            if (result == 1) {
                              String serviceProduct = 'servicio';
                              String? nameServiceProduct =
                                  contShopp.orderDeleteCar[i].nameService;
                              if (contShopp.orderDeleteCar[i].nameService ==
                                  '') {
                                serviceProduct = 'producto';
                                nameServiceProduct =
                                    contShopp.orderDeleteCar[i].nameProduct;
                              }
                              print(
                                  'return resul: estoy nameProduct:${contShopp.orderDeleteCar[i].nameProduct} ');
                              print(
                                  'return resul: estoy nameService:${contShopp.orderDeleteCar[i].nameService} ');
                              print('return resul: estoy adentro ');
                              print(
                                  'return resul: branchIdLoggedIn ${controllerLogin.branchIdLoggedIn}');
                              print(
                                  'return resul: profesional_id ${contShopp.orderDeleteCar[i].profesional_id}');

                              notiController.storeNotification(
                                  'Aceptada su Solicitud de Eliminacion ',
                                  controllerLogin.branchIdLoggedIn,
                                  contShopp.orderDeleteCar[i].profesional_id,
                                  'El $serviceProduct "$nameServiceProduct" de el cliente ${contShopp.orderDeleteCar[i].nameClient} fue aprobado y eliminado satisfactoriamente.');
                            }
                            if (controllerLogin.branchIdLoggedIn != null) {
                              await contShopp.loadOrderDeleteCar(
                                  controllerLogin.branchIdLoggedIn!);
                              controllerShoppingCart.setLoading(false);
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
              ),
              const SizedBox(
                height: 12,
              )
            ],
          ),
        ),
      );
    }
    if (contShopp.orderDeleteCar.isEmpty) {
      widgets.add(const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 100),
          child: Text(
            'No hay solicitudes a eliminar.',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ));
    }

    return Column(
      children: widgets,
    );
  }
}
