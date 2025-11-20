// ignore_for_file: file_names, depend_on_referenced_packages
//import 'package:animate_do/animate_do.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/notification.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Controllers/shoppingCart.controller.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Utility/utils.dart';
import 'package:turnopro_apk/Views/common/topPage.dart';
import 'package:turnopro_apk/env.dart';
import 'package:http/http.dart' as http;

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  final double valuePadding = 12;

  final String imageDirection = 'assets/images/image_perfil.jpg';

  final ShoppingCartController controllerShoppingCart =
      Get.find<ShoppingCartController>();

  final PagesConfigController pagesConfigC = Get.find<PagesConfigController>();

  final ClientsScheduledController clientsController =
      Get.find<ClientsScheduledController>();

  final LoginController controllerLogin = Get.find<LoginController>();

  final ShoppingCartController shoppingCar = Get.find<ShoppingCartController>();

  NotificationController notiController = Get.find<NotificationController>();

  /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */
  final IconnsBack = Icons.arrow_back;

  final IconnsP = MdiIcons.shoppingOutline;

  String title = 'Carro de Compra';

  String subTitle = 'Carro de Compra';

  final colorCont = Colors.white;

  double panddCont = 8;

  double borderCont = 12;

  final colorIcon = Color(0xFF19CF9E);

  /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */

  @override
  Widget build(BuildContext context) {
    /* WidgetsBinding.instance.addPostFrameCallback((_) async {
      ejecutarCadaQuinceSegundos();
    });*/
    final double heightScreen = MediaQuery.of(context).size.height;
    int heightFlexBody = 18;
    if (heightScreen <= 534.0) {
      heightFlexBody = 14;
    }
    //DECLARACION DE VARIABLES
    const double borderRadiusValue = 12;

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 231, 232, 234),
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: topPage(
                panddCont: panddCont,
                colorCont: colorCont,
                borderCont: borderCont,
                IconnsBack: IconnsBack,
                pagesConfigC: pagesConfigC,
                isPagesConfig: true,
                IconnsP: IconnsP,
                title: title,
                subTitle: subTitle,
                colorIcon: colorIcon,
                totalCC: controllerShoppingCart.totalPrice.toStringAsFixed(0),
                buttonRight: false,
              ),
            ),
            Expanded(
              flex: heightFlexBody,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(-5,
                            5), // Ajusta los valores para personalizar la sombra
                      ),
                    ],
                    borderRadius: const BorderRadius.all(
                        Radius.circular(borderRadiusValue)),
                  ),
                  child: Column(
                    children: [
                      controllerShoppingCart.serviceListLength > 0
                          ? Text(
                              'Servicios Solicitados',
                              style: TextStyle(
                                  fontSize:
                                      (MediaQuery.of(context).size.height *
                                          0.02),
                                  fontWeight: FontWeight.w900),
                            )
                          : const Text(''),
                      controllerShoppingCart.serviceListLength > 0
                          ? Expanded(
                              flex:
                                  heightFlexBody, // 85% del espacio disponible para esta parte
                              child: ListView.builder(
                                  padding: EdgeInsets
                                      .zero, // Elimina cualquier padding del ListView
                                  itemCount:
                                      controllerShoppingCart.serviceListLength,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          (MediaQuery.of(context).size.height *
                                              0.013),
                                          (MediaQuery.of(context).size.height *
                                              0.006),
                                          (MediaQuery.of(context).size.height *
                                              0.013),
                                          (MediaQuery.of(context).size.height *
                                              0.006)),
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Row(
                                          children: [
                                            Container(
                                              height: (MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.08),
                                              width: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.7),
                                                    spreadRadius: 1,
                                                    blurRadius: 5,
                                                    offset: const Offset(-5,
                                                        5), // Ajusta los valores para personalizar la sombra
                                                  ),
                                                ],
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(
                                                            borderRadiusValue)),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 7),
                                                child: ListTile(
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  12)),
                                                    ),
                                                    title: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width:
                                                                  50, // Diameter of the CircleAvatar
                                                              height:
                                                                  50, // Diameter of the CircleAvatar
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .grey, // Border color
                                                                  width:
                                                                      1.0, // Border width
                                                                ),
                                                              ),
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 28,
                                                                backgroundColor:
                                                                    Colors
                                                                        .white, //fondo de la imagen
                                                                child: ClipOval(
                                                                  child: Image
                                                                      .network(
                                                                    '${dotenv.env['API_ENDPOINT']}/images/${controllerShoppingCart.selectserviceCart[index].image_service}',
                                                                    fit: BoxFit
                                                                        .cover, // Ajusta la imagen para cubrir completamente el área
                                                                    width:
                                                                        50, // Ancho deseado de la imagen dentro del círculo
                                                                    height: 50,
                                                                    loadingBuilder: (BuildContext
                                                                            context,
                                                                        Widget
                                                                            child,
                                                                        ImageChunkEvent?
                                                                            loadingProgress) {
                                                                      if (loadingProgress ==
                                                                          null) {
                                                                        // Si la imagen se carga correctamente, mostramos la imagen
                                                                        return child;
                                                                      } else {
                                                                        // Si la imagen aún se está cargando, mostramos un indicador de progreso
                                                                        return const CircularProgressIndicator(
                                                                          color:
                                                                              Color(0xFFFDAE2A),
                                                                        );
                                                                      }
                                                                    },
                                                                    errorBuilder: (BuildContext
                                                                            context,
                                                                        Object
                                                                            error,
                                                                        StackTrace?
                                                                            stackTrace) {
                                                                      // Si la imagen no se puede cargar y estamos en modo de depuración, mostramos una imagen por defecto
                                                                      if (kDebugMode) {
                                                                        return CircleAvatar(
                                                                          radius:
                                                                              30,
                                                                          backgroundColor:
                                                                              Colors.transparent, // Fondo transparente para que el borde sea visible
                                                                          child:
                                                                              ClipOval(
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/service-default.png',
                                                                              fit: BoxFit.cover, // Ajusta la imagen para cubrir completamente el área
                                                                              width: 50, // Ancho deseado de la imagen dentro del círculo
                                                                              height: 50, // Alto deseado de la imagen dentro del círculo
                                                                            ),
                                                                          ),
                                                                        );
                                                                      } else {
                                                                        // Si no estamos en modo de depuración, mostramos un texto de error
                                                                        return CircleAvatar(
                                                                          radius:
                                                                              30,
                                                                          backgroundColor:
                                                                              Colors.transparent, // Fondo transparente para que el borde sea visible
                                                                          child:
                                                                              ClipOval(
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/service-default.png',
                                                                              fit: BoxFit.cover, // Ajusta la imagen para cubrir completamente el área
                                                                              width: 50, // Ancho deseado de la imagen dentro del círculo
                                                                              height: 50, // Alto deseado de la imagen dentro del círculo
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            //

                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  controllerShoppingCart
                                                                      .selectserviceCart[
                                                                          index]
                                                                      .nameService
                                                                      .toString(),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  formatNumber(controllerShoppingCart
                                                                      .selectserviceCart[
                                                                          index]
                                                                      .price_service
                                                                      .toString()),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Color
                                                                          .fromARGB(
                                                                              148,
                                                                              0,
                                                                              0,
                                                                              0)),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            GetBuilder<
                                                                    ShoppingCartController>(
                                                                builder: (_) {
                                                              return InkWell(
                                                                onTap:
                                                                    () async {
                                                                  if (controllerLogin
                                                                          .codigoQrValid() ==
                                                                      true) {
                                                                    //aqui voy controlando que no pueda elimira tds los servicios
                                                                    //todo aqui controlar que no pueda mandara eliminar tds los servicios
                                                                    /*  if ((controllerShoppingCart.serviceListLengthCant +
                                                                            1) ==
                                                                        controllerShoppingCart
                                                                            .serviceListLength) {
                                                                      Get.snackbar(
                                                                        'Mensaje',
                                                                        'Todos los servicios no pueden ser eliminados',
                                                                        duration:
                                                                            const Duration(milliseconds: 2500),
                                                                        backgroundColor: const Color.fromARGB(
                                                                            118,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                        showProgressIndicator:
                                                                            true,
                                                                        progressIndicatorBackgroundColor: const Color.fromARGB(
                                                                            255,
                                                                            203,
                                                                            205,
                                                                            209),
                                                                        progressIndicatorValueColor:
                                                                            const AlwaysStoppedAnimation(Color(0xFFF18254)),
                                                                        overlayBlur:
                                                                            3,
                                                                      );
                                                                    } else {*/
                                                                    //aqui voy controlando que no pueda elimira tds los servicios
                                                                    controllerShoppingCart
                                                                        .setServiceSelectCant(
                                                                            1);

                                                                    int result = await controllerShoppingCart.requestDelete(
                                                                        controllerShoppingCart
                                                                            .selectserviceCart[index]
                                                                            .id,
                                                                        1);
                                                                    //todo aquiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
                                                                    if (result ==
                                                                        1) {
                                                                      // ver que reloj es?
                                                                      // if (clientsController
                                                                      //         .modifyTimeSpecific ==
                                                                      //     0) {
                                                                      //   controllerLogin
                                                                      //       .setCallDeleteService1(false);
                                                                      // }
                                                                      // if (clientsController
                                                                      //         .modifyTimeSpecific ==
                                                                      //     1) {
                                                                      //   controllerLogin
                                                                      //       .setCallDeleteService2(false);
                                                                      // }
                                                                      // if (clientsController
                                                                      //         .modifyTimeSpecific ==
                                                                      //     2) {
                                                                      //   controllerLogin
                                                                      //       .setCallDeleteService3(false);
                                                                      // }
                                                                      // if (clientsController
                                                                      //         .modifyTimeSpecific ==
                                                                      //     3) {
                                                                      //   controllerLogin
                                                                      //       .setCallDeleteService4(false);
                                                                      // }

                                                                      notiController.storeNotification(
                                                                          'Solicitud de servicio a eliminar',
                                                                          controllerLogin
                                                                              .branchIdLoggedIn,
                                                                          controllerLogin
                                                                              .idProfessionalLoggedIn,
                                                                          'EL servicio "${controllerShoppingCart.selectserviceCart[index].nameService}" fue enviado a eliminar',
                                                                          'orden${controllerShoppingCart.selectserviceCart[index].id}',
                                                                          'Ambos'); //esto es para quele llegue a coordinador y encargado
                                                                    }
                                                                    // }
                                                                  } else if (controllerLogin
                                                                          .usserPermissionQr ==
                                                                      2) {
                                                                    Get.snackbar(
                                                                      'Mensaje',
                                                                      'Debe de esperar la respuesta a su solicitud',
                                                                      duration: const Duration(
                                                                          milliseconds:
                                                                              2500),
                                                                      backgroundColor: const Color
                                                                              .fromARGB(
                                                                          118,
                                                                          255,
                                                                          255,
                                                                          255),
                                                                      showProgressIndicator:
                                                                          true,
                                                                      progressIndicatorBackgroundColor: const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          203,
                                                                          205,
                                                                          209),
                                                                      progressIndicatorValueColor:
                                                                          const AlwaysStoppedAnimation(
                                                                              Color(0xFFFDAE2A)),
                                                                      overlayBlur:
                                                                          3,
                                                                    );
                                                                  } else {
                                                                    Get.snackbar(
                                                                      'Mensaje',
                                                                      'Debe de escanear el código Qr de entrada',
                                                                      duration: const Duration(
                                                                          milliseconds:
                                                                              2500),
                                                                      backgroundColor: const Color
                                                                              .fromARGB(
                                                                          118,
                                                                          255,
                                                                          255,
                                                                          255),
                                                                      showProgressIndicator:
                                                                          true,
                                                                      progressIndicatorBackgroundColor: const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          203,
                                                                          205,
                                                                          209),
                                                                      progressIndicatorValueColor:
                                                                          const AlwaysStoppedAnimation(
                                                                              Color(0xFFF18254)),
                                                                      overlayBlur:
                                                                          3,
                                                                    );
                                                                  }
                                                                },
                                                                child: _.requestDeleteOrder.contains(controllerShoppingCart
                                                                            .selectserviceCart[
                                                                                index]
                                                                            .id) ||
                                                                        (_.idServiceCart.contains(controllerShoppingCart.selectserviceCart[index].nameService) &&
                                                                            controllerShoppingCart.selectserviceCart[index].request_delete ==
                                                                                1)
                                                                    ? const Icon(
                                                                        Icons
                                                                            .delete,
                                                                        size:
                                                                            35,
                                                                        color: Color.fromARGB(
                                                                            105,
                                                                            139,
                                                                            137,
                                                                            136),
                                                                      )
                                                                    : const Icon(
                                                                        Icons
                                                                            .delete,
                                                                        size:
                                                                            35,
                                                                        color: Color(
                                                                            0xFFFDAE2A),
                                                                      ),
                                                              );
                                                            }),
                                                          ],
                                                        )
                                                      ],
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          : const Text(''),
                      controllerShoppingCart.productListLength > 0
                          ? Text(
                              'Productos Solicitados',
                              style: TextStyle(
                                  fontSize:
                                      (MediaQuery.of(context).size.height *
                                          0.02),
                                  fontWeight: FontWeight.w900),
                            )
                          : const Text(''),
                      controllerShoppingCart.productListLength > 0
                          ? Expanded(
                              flex:
                                  heightFlexBody, // 85% del espacio disponible para esta parte

                              child: ListView.builder(
                                  //todo builder
                                  padding: EdgeInsets
                                      .zero, // Elimina cualquier padding del ListView
                                  itemCount:
                                      controllerShoppingCart.productListLength,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          (MediaQuery.of(context).size.height *
                                              0.013),
                                          (MediaQuery.of(context).size.height *
                                              0.006),
                                          (MediaQuery.of(context).size.height *
                                              0.013),
                                          (MediaQuery.of(context).size.height *
                                              0.006)),
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Row(
                                          children: [
                                            Container(
                                              height: (MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.08),
                                              width: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.7),
                                                    spreadRadius: 1,
                                                    blurRadius: 5,
                                                    offset: const Offset(-5,
                                                        5), // Ajusta los valores para personalizar la sombra
                                                  ),
                                                ],
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(
                                                            borderRadiusValue)),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 7),
                                                child: ListTile(
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  12)),
                                                    ),
                                                    title: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width:
                                                                  50, // Diameter of the CircleAvatar
                                                              height:
                                                                  50, // Diameter of the CircleAvatar
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .grey, // Border color
                                                                  width:
                                                                      1.0, // Border width
                                                                ),
                                                              ),
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 28,
                                                                backgroundColor:
                                                                    Colors
                                                                        .white, //fondo de la imagen
                                                                child: ClipOval(
                                                                  child: Image
                                                                      .network(
                                                                    '${dotenv.env['API_ENDPOINT']}/images/${controllerShoppingCart.selectproduct[index].image_product}',
                                                                    fit: BoxFit
                                                                        .cover, // Ajusta la imagen para cubrir completamente el área
                                                                    width:
                                                                        50, // Ancho deseado de la imagen dentro del círculo
                                                                    height: 50,
                                                                    loadingBuilder: (BuildContext
                                                                            context,
                                                                        Widget
                                                                            child,
                                                                        ImageChunkEvent?
                                                                            loadingProgress) {
                                                                      if (loadingProgress ==
                                                                          null) {
                                                                        // Si la imagen se carga correctamente, mostramos la imagen
                                                                        return child;
                                                                      } else {
                                                                        // Si la imagen aún se está cargando, mostramos un indicador de progreso
                                                                        return const CircularProgressIndicator(
                                                                          color:
                                                                              Color(0xFFFDAE2A),
                                                                        );
                                                                      }
                                                                    },
                                                                    errorBuilder: (BuildContext
                                                                            context,
                                                                        Object
                                                                            error,
                                                                        StackTrace?
                                                                            stackTrace) {
                                                                      // Si la imagen no se puede cargar y estamos en modo de depuración, mostramos una imagen por defecto
                                                                      if (kDebugMode) {
                                                                        return CircleAvatar(
                                                                          radius:
                                                                              30,
                                                                          backgroundColor:
                                                                              Colors.transparent, // Fondo transparente para que el borde sea visible
                                                                          child:
                                                                              ClipOval(
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/product-default.png',
                                                                              fit: BoxFit.cover, // Ajusta la imagen para cubrir completamente el área
                                                                              width: 50, // Ancho deseado de la imagen dentro del círculo
                                                                              height: 50, // Alto deseado de la imagen dentro del círculo
                                                                            ),
                                                                          ),
                                                                        );
                                                                      } else {
                                                                        // Si no estamos en modo de depuración, mostramos un texto de error
                                                                        return CircleAvatar(
                                                                          radius:
                                                                              30,
                                                                          backgroundColor:
                                                                              Colors.transparent, // Fondo transparente para que el borde sea visible
                                                                          child:
                                                                              ClipOval(
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/product-default.png',
                                                                              fit: BoxFit.cover, // Ajusta la imagen para cubrir completamente el área
                                                                              width: 50, // Ancho deseado de la imagen dentro del círculo
                                                                              height: 50, // Alto deseado de la imagen dentro del círculo
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                            //

                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  controllerShoppingCart
                                                                      .selectproduct[
                                                                          index]
                                                                      .name
                                                                      .toString(),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  formatNumber(controllerShoppingCart
                                                                      .selectproduct[
                                                                          index]
                                                                      .sale_price
                                                                      .toString()),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Color
                                                                          .fromARGB(
                                                                              148,
                                                                              0,
                                                                              0,
                                                                              0)),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        GetBuilder<
                                                                ShoppingCartController>(
                                                            builder: (_) {
                                                          return InkWell(
                                                            onTap: () {
                                                              if (controllerLogin
                                                                      .codigoQrValid() ==
                                                                  true) {
                                                                notiController.storeNotification(
                                                                    'Solicitud de producto a eliminar',
                                                                    controllerLogin
                                                                        .branchIdLoggedIn,
                                                                    controllerLogin
                                                                        .idProfessionalLoggedIn,
                                                                    'EL producto "${controllerShoppingCart.selectproduct[index].name}" fue enviado a eliminar',
                                                                    'orden${controllerShoppingCart.selectproduct[index].id}',
                                                                    'Ambos'); //esto es para quele llegue a coordinador y encargado
                                                                controllerShoppingCart
                                                                    .requestDelete(
                                                                        controllerShoppingCart
                                                                            .selectproduct[index]
                                                                            .id,
                                                                        1);
                                                              } else if (controllerLogin
                                                                      .usserPermissionQr ==
                                                                  2) {
                                                                Get.snackbar(
                                                                  'Mensaje',
                                                                  'Debe de esperar la respuesta a su solicitud',
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          2500),
                                                                  backgroundColor:
                                                                      const Color
                                                                              .fromARGB(
                                                                          118,
                                                                          255,
                                                                          255,
                                                                          255),
                                                                  showProgressIndicator:
                                                                      true,
                                                                  progressIndicatorBackgroundColor:
                                                                      const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          203,
                                                                          205,
                                                                          209),
                                                                  progressIndicatorValueColor:
                                                                      const AlwaysStoppedAnimation(
                                                                          Color(
                                                                              0xFFFDAE2A)),
                                                                  overlayBlur:
                                                                      3,
                                                                );
                                                              } else {
                                                                Get.snackbar(
                                                                  'Mensaje',
                                                                  'Debe de escanear el código Qr de entrada',
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          2500),
                                                                  backgroundColor:
                                                                      const Color
                                                                              .fromARGB(
                                                                          118,
                                                                          255,
                                                                          255,
                                                                          255),
                                                                  showProgressIndicator:
                                                                      true,
                                                                  progressIndicatorBackgroundColor:
                                                                      const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          203,
                                                                          205,
                                                                          209),
                                                                  progressIndicatorValueColor:
                                                                      const AlwaysStoppedAnimation(
                                                                          Color(
                                                                              0xFFFDAE2A)),
                                                                  overlayBlur:
                                                                      3,
                                                                );
                                                              }
                                                            },
                                                            child: (_.requestDeleteOrder.contains(controllerShoppingCart
                                                                        .selectproduct[
                                                                            index]
                                                                        .id)) ||
                                                                    (controllerShoppingCart
                                                                            .selectproduct[index]
                                                                            .request_delete ==
                                                                        1)
                                                                ? const Icon(
                                                                    Icons
                                                                        .delete,
                                                                    size: 35,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            105,
                                                                            139,
                                                                            137,
                                                                            136),
                                                                  )
                                                                : const Icon(
                                                                    Icons
                                                                        .delete,
                                                                    size: 35,
                                                                    color: Color(
                                                                        0xFFFDAE2A),
                                                                  ),
                                                          );
                                                        })
                                                      ],
                                                    )),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          : const Text(''),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
