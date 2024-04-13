// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers, depend_on_referenced_packages

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:turnopro_apk/Controllers/clientsCoordinatorController.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Controllers/coexistence.controller.dart';
//import 'package:lottie/lottie.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/notification.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configResp.controller.dart';
import 'package:turnopro_apk/Controllers/shoppingCart.controller.dart';

class HomeResponsibleBodyPages extends StatefulWidget {
  const HomeResponsibleBodyPages({super.key});

  @override
  State<HomeResponsibleBodyPages> createState() =>
      _HomeResponsibleBodyPagesState();
}

class _HomeResponsibleBodyPagesState extends State<HomeResponsibleBodyPages>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final ShoppingCartController controllerShoppingCart =
      Get.find<ShoppingCartController>();
  final LoginController controllerLogin = Get.find<LoginController>();
  final ClientsCoordinatorController clientCorControl =
      Get.find<ClientsCoordinatorController>();
  final ClientsScheduledController clientsScheduleCont =
      Get.find<ClientsScheduledController>();
  final CoexistenceController coexistCont = Get.find<CoexistenceController>();

  final PagesConfigResponController pagesConfigReC =
      Get.find<PagesConfigResponController>();
  NotificationController notiController = Get.find<NotificationController>();
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Asegúrate de cancelar el temporizador al eliminar el widget
    _timer?.cancel();
    super.dispose();
  }

  Timer? _timer;

  void iniciarLlamadaCada10Segundos() {
    // Cancela cualquier temporizador existente para evitar duplicaciones
    _timer?.cancel();
    int cont = -1;
    // Establece un temporizador que llama a la función cada 20 segundos
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) async {
      cont += 1;
      print('Aqui entro solo la primera vez 111');
      print('Aqui entro solo la primera vez 111-cont:$cont');
      if (cont == 0) {
        print('Aqui entro solo la primera vez (cont == 0)');

        if (controllerLogin.branchIdLoggedIn != null &&
            controllerLogin.idProfessionalLoggedIn != null) {
          notiController.fetchNotificationList(controllerLogin.branchIdLoggedIn,
              controllerLogin.idProfessionalLoggedIn, 'Encargado');
          await controllerShoppingCart
              .loadOrderDeleteCar(controllerLogin.branchIdLoggedIn!);
          controllerShoppingCart.setLoading(false);
          clientCorControl
              .fetchClientsScheduledBranch(controllerLogin.branchIdLoggedIn);
          await clientCorControl
              .fetchClientsRechazBranch(controllerLogin.branchIdLoggedIn);
        }
      }
      if (cont == 4 || cont == 10 || cont == 20) {
        if (cont == 20) {
          print('Aqui entro solo ACTUALIZAR el contador a 1');
          cont = 1;
        }
        //estoy entrando cada 8 segundos
        print('Aqui entro solo ACTUALIZAR');
        if (controllerLogin.branchIdLoggedIn != null &&
            controllerLogin.idProfessionalLoggedIn != null) {
          notiController.fetchNotificationList(controllerLogin.branchIdLoggedIn,
              controllerLogin.idProfessionalLoggedIn, 'Encargado');
          await controllerShoppingCart
              .loadOrderDeleteCar(controllerLogin.branchIdLoggedIn!);
          controllerShoppingCart.setLoading(false);
          clientCorControl
              .fetchClientsScheduledBranch(controllerLogin.branchIdLoggedIn);
          await clientCorControl
              .fetchClientsRechazBranch(controllerLogin.branchIdLoggedIn);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    iniciarLlamadaCada10Segundos();
//ESTRUCTURA DE LOS CARTS
    final twoPi = 3.14 * 2;

    return Column(
      children: [
        Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: const Color(0xFF4470F3), //CARAGANDO COLOR HEXADECIMAL,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /*todo texto arriba */ const Padding(
                      padding: EdgeInsets.only(left: 8, top: 8),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Últimas Notificaciones',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          )),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    /*todo cart1 servicios*/ Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8, top: 4, right: 8, bottom: 6),
                          child: FadeIn(
                            duration: const Duration(seconds: 2),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GetBuilder<ShoppingCartController>(
                                    builder: (contShopp) {
                                  if (controllerShoppingCart.isLoading ==
                                      true) {
                                    return const Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 45,
                                        ),
                                        CircularProgressIndicator(
                                          color: Color(0xFFFDAE2A),
                                        ),
                                        Text(
                                          'Cargando lista de solicitudes...',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        )
                                      ],
                                    ));
                                  } else {
                                    return showRequestsDelete(
                                        context,
                                        contShopp,
                                        controllerLogin,
                                        clientCorControl);
                                  }
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
        Expanded(
            flex: 14, // 85% del espacio disponible para esta parte
            child: SingleChildScrollView(
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
                                color: const Color.fromARGB(255, 43, 44, 49),
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
                                onTap: () async {
                                  Get.dialog(
                                    const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFFFDAE2A),
                                      ),
                                    ),
                                    barrierDismissible: false,
                                  ); //Get.back();
                                  await clientCorControl
                                      .fetchClientsScheduledBranch(
                                          controllerLogin.branchIdLoggedIn);

                                  pagesConfigReC.onTabTapped(1);
                                  Get.back();
                                  print('cargando valores 2');
                                },
                                child: cartsHome(
                                    context,
                                    const Color(0xFF19CF9E),
                                    'Clientes',
                                    'Clientes del día',
                                    Icons.notifications),
                              ),
                              InkWell(
                                onTap: () {
                                  pagesConfigReC.onTabTapped(2);
                                  /* Get.toNamed(
                                    '/NotificationsPageNew',
                                  );*/
                                },
                                child: cartsHome(
                                    context,
                                    const Color(0xFF4470F3),
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
                                  Get.dialog(
                                    const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFFFDAE2A),
                                      ),
                                    ),
                                    barrierDismissible: false,
                                  ); //Get.back();
                                  pagesConfigReC.onTabTapped(3);
                                  Get.back();
                                  /* Get.toNamed(
                                    '/StatisticPageRespon',
                                  );*/
                                  // Get.snackbar(
                                  //   'Mensaje',
                                  //   'Aqui van las Estadísticas',
                                  //   duration:
                                  //       const Duration(milliseconds: 1500),
                                  //   showProgressIndicator: true,
                                  //   progressIndicatorBackgroundColor:
                                  //       const Color(0xFF4470F3),
                                  //   progressIndicatorValueColor:
                                  //       const AlwaysStoppedAnimation(
                                  //           Color(0xFFFDAE2A)),
                                  //   overlayBlur: 3,
                                  // );
                                },
                                child: cartsHome(
                                    context,
                                    const Color(0xFFFF6750),
                                    'Estadísticas',
                                    'Revisa Tus Ingresos',
                                    Icons.bar_chart),
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
                                  await coexistCont.fetchBranchProfessionals();
                                  pagesConfigReC.onTabTapped(4);
                                  Get.back();
                                  /*Get.toNamed(
                                    '/coexistencePageResponsible',
                                  );*/
                                },
                                child: cartsHome(
                                    context,
                                    const Color(0xFFFDAE2A),
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
  }

  Container cartsHome(BuildContext context, Color colorVariable,
      String titleCart, String descriptionTitleCart, iconCart) {
    return Container(
      width: (MediaQuery.of(context).size.width * 0.46), //Tamaño de los Cards
      height: (MediaQuery.of(context).size.height * 0.20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
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
                backgroundColor: const Color.fromARGB(
                    255, 231, 233, 233), // Color de fondo del CircleAvatar
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
                        color: const Color(0xFFFF6750),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                      ),
                      child: IconButton(
                        onPressed: () async {
                          if (controllerLogin.codigoQrValid() == true) {
                            //rechazar la eliminacion
                            controllerShoppingCart.setLoading(true);
                            //aqui mandar a poner en 0 de nuevo en la cola al cliente

                            bool result = await clientCorControl
                                .acceptOrRejectClientCoord(
                                    controllerclient
                                        .clientsScheduledListBranchClient[i]
                                        .reservation_id,
                                    0);
                            //aqui mandar notificacion
                            print('return resul: IconButton $result');
                            if (result == true) {
                              notiController.storeNotification(
                                  'Solicitud de Eliminacion Rechazada',
                                  controllerLogin.branchIdLoggedIn,
                                  controllerclient
                                      .clientsScheduledListBranchClient[i]
                                      .professional_id,
                                  '!Atención..El cliente ${controllerclient.clientsScheduledListBranchClient[i].client_name} no fue rechazado.');
                            }
                            if (controllerLogin.branchIdLoggedIn != null) {
                              await controllerclient.fetchClientsRechazBranch(
                                  controllerLogin.branchIdLoggedIn!);
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
                    Container(
                      height: (MediaQuery.of(context).size.height * 0.120),
                      width: (MediaQuery.of(context).size.width * 0.8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30, top: 10),
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
                                              .client_name,
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
                    Container(
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
                          if (controllerLogin.codigoQrValid() == true) {
                            controllerShoppingCart.setLoading(true);

                            bool result = await clientsScheduleCont
                                .deleteReservationClientCoor(
                                    controllerclient
                                        .clientsScheduledListBranchClient[i]
                                        .reservation_id,
                                    'Fue rechazado por ${controllerclient.clientsScheduledListBranchClient[i].professional_name}');
                            //aqui mandar notificacion
                            print('return resul: IconButton $result');
                            if (result == true) {
                              String typeDelete =
                                  'Aceptada Eliminación de Cliente';

                              notiController.storeNotification(
                                  typeDelete,
                                  controllerLogin.branchIdLoggedIn,
                                  controllerclient
                                      .clientsScheduledListBranchClient[i]
                                      .professional_id,
                                  'El cliente ${controllerclient.clientsScheduledListBranchClient[i].client_name} fue eliminado de su cola');
                            }
                            if (controllerLogin.branchIdLoggedIn != null) {
                              await controllerclient.fetchClientsRechazBranch(
                                  controllerLogin.branchIdLoggedIn!);
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
    //
    //
    //
    //
    //
    //
//todo aqui le muestra las solicitudes de eliminacion de Servicios y Productos
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
                        color: const Color(0xFFFF6750),
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
                          color: const Color(0xFF19CF9E),
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
                              String typeDelete =
                                  'Aceptada Eliminación de Servicio';
                              String serviceProduct = 'Servicio';
                              String? nameServiceProduct =
                                  contShopp.orderDeleteCar[i].nameService;
                              if (contShopp.orderDeleteCar[i].nameService ==
                                  '') {
                                typeDelete = 'Aceptada Eliminación de Producto';
                                serviceProduct = 'Producto';
                                nameServiceProduct =
                                    contShopp.orderDeleteCar[i].nameProduct;
                              }

                              if (typeDelete ==
                                  'Aceptada Eliminación de Servicio') {
                                notiController.storeNotification2(
                                    typeDelete,
                                    controllerLogin.branchIdLoggedIn,
                                    contShopp.orderDeleteCar[i].profesional_id,
                                    '$serviceProduct "$nameServiceProduct" del cliente ${contShopp.orderDeleteCar[i].nameClient} fue eliminado con tiempo de ${contShopp.orderDeleteCar[i].duration_service} min.${contShopp.orderDeleteCar[i].reservation_id}');
                              } else {
                                notiController.storeNotification(
                                    typeDelete,
                                    controllerLogin.branchIdLoggedIn,
                                    contShopp.orderDeleteCar[i].profesional_id,
                                    'El $serviceProduct "$nameServiceProduct" del cliente ${contShopp.orderDeleteCar[i].nameClient} fue eliminado satisfactoriamente.');
                              }
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
    //todo aqui le muestra las solicitudes de eliminacion de Servicios y Productos
    //
    //
    //
    //

    //
    if ((contShopp.orderDeleteCar.isEmpty) &&
        (controllerclient.clientsScheduledListBranchClient.isEmpty)) {
      widgets.add(const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 70),
          child: Text(
            'No hay solicitudes a eliminar.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ));
    }

    return Column(
      children: widgets,
    );
  }

/*
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
                        color: const Color(0xFFFDAE2A),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                      ),
                      child: IconButton(
                        onPressed: () async {
                          /*
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
*/

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
                                      Color(0xFFFDAE2A)),
                              overlayBlur: 3,
                            );
                          }

                          //   'Rechazada la solicitud',
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
                              String typeDelete =
                                  'Aceptada Eliminación de Servicio';
                              String serviceProduct = 'Servicio';
                              String? nameServiceProduct =
                                  contShopp.orderDeleteCar[i].nameService;
                              if (contShopp.orderDeleteCar[i].nameService ==
                                  '') {
                                typeDelete = 'Aceptada Eliminación de Producto';
                                serviceProduct = 'Producto';
                                nameServiceProduct =
                                    contShopp.orderDeleteCar[i].nameProduct;
                              }

                              if (typeDelete ==
                                  'Aceptada Eliminación de Servicio') {
                                notiController.storeNotification2(
                                    typeDelete,
                                    controllerLogin.branchIdLoggedIn,
                                    contShopp.orderDeleteCar[i].profesional_id,
                                    '$serviceProduct "$nameServiceProduct" del cliente ${contShopp.orderDeleteCar[i].nameClient} fue eliminado con tiempo de ${contShopp.orderDeleteCar[i].duration_service} min.${contShopp.orderDeleteCar[i].reservation_id}');
                              } else {
                                notiController.storeNotification(
                                    typeDelete,
                                    controllerLogin.branchIdLoggedIn,
                                    contShopp.orderDeleteCar[i].profesional_id,
                                    'El $serviceProduct "$nameServiceProduct" del cliente ${contShopp.orderDeleteCar[i].nameClient} fue eliminado satisfactoriamente.');
                              }
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
                                      Color(0xFFFDAE2A)),
                              overlayBlur: 3,
                            );
                          }
                          /*
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
                            if (contShopp.orderDeleteCar[i].nameService == '') {
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
                          */

                          //   'Solicitud Eliminada',
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
        child: Text(
          'No hay solicitudes a eliminar.',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ));
    }

    return Column(
      children: widgets,
    );
  }
*/
}
