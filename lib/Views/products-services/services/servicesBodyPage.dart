// ignore_for_file: file_names, unused_local_variable, dead_code

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Controllers/service.controller.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/shoppingCart.controller.dart';
import 'package:turnopro_apk/Utility/utils.dart';
import 'package:turnopro_apk/Views/professional/clientsScheduled/modalHelperClientSchedule.dart';
import 'package:turnopro_apk/env.dart';
//import 'package:turnopro_apk/Routes/index.dart';

class ServicesBodyPage extends StatefulWidget {
  const ServicesBodyPage({super.key});

  @override
  State<ServicesBodyPage> createState() => _ServicesBodyPageState();
}

class _ServicesBodyPageState extends State<ServicesBodyPage> {
  final double valuePadding = 12;

  final ShoppingCartController controllerShoppingCart =
      Get.find<ShoppingCartController>();
  final PagesConfigController pagesConfigC = Get.find<PagesConfigController>();

  final LoginController controllerLogin = Get.find<LoginController>();
  final ClientsScheduledController clientsController =
      Get.find<ClientsScheduledController>();

  //bool visibleButonEliminar = false;
  @override
  Widget build(BuildContext context) {
    final double heightScreen = MediaQuery.of(context).size.height;
    int heightFlexBody = 24;
    if (heightScreen <= 534.0) {
      heightFlexBody = 14;
    }

    //DECLARACION DE VARIABLES
    const double borderRadiusValue = 12;

    return GetBuilder<ServiceController>(builder: (_) {
      print('object-long service:${_.serviceListLength}');
      // print('object-long service-services:${_.services[0].name}');
      return _.isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Color(0xFFFDAE2A),
            ))
          : _.serviceListLength > 0
              ? Padding(
                  padding: const EdgeInsets.only(right: 14, left: 14),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 24,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                flex:
                                    heightFlexBody, // 85% del espacio disponible para esta parte
                                child: ListView.builder(
                                    shrinkWrap:
                                        true, // Ajustar al tamaño de su contenido
                                    itemCount: _.serviceListLength,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            (MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01),
                                            (MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.0006),
                                            (MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01),
                                            (MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.006)),
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Row(
                                            children: [
                                              Container(
                                                height: (MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.1),
                                                width: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1),
                                                decoration: ((_.selectService
                                                                .contains(_.services[
                                                                    index])) ||
                                                            (controllerShoppingCart
                                                                .idServiceCart
                                                                .contains(_
                                                                    .services[
                                                                        index]
                                                                    .name))) ||
                                                        (_.selectServiceNew.contains(_.services[index]) ||
                                                            _.services[index]
                                                                    .cliente ==
                                                                true)
                                                    ? const BoxDecoration(
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(borderRadiusValue)),
                                                        gradient: LinearGradient(
                                                          colors: [
                                                            Colors.white,
                                                            Color(0xFFFDAE2A),
                                                          ],
                                                          stops: [0.0, 0.8],
                                                          begin:
                                                              FractionalOffset
                                                                  .centerRight,
                                                          end: FractionalOffset
                                                              .centerLeft,
                                                        ))
                                                    : const BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255, 231, 232, 234),
                                                        borderRadius: BorderRadius
                                                            .all(Radius.circular(
                                                                borderRadiusValue)),
                                                      ),
                                                child: ListTile(
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                  ),
                                                  onTap: () async {
                                                    if (controllerLogin
                                                                .codigoQrValid() ==
                                                            true ||
                                                        (loginController
                                                                .usserPermissionQr ==
                                                            2)) {
                                                      if (!_.selectService
                                                              .contains(
                                                                  _.services[
                                                                      index]) &&
                                                          !(controllerShoppingCart
                                                              .idServiceCart
                                                              .contains(_
                                                                  .services[
                                                                      index]
                                                                  .name)) &&
                                                          _.services[index]
                                                                  .cliente ==
                                                              false) {
                                                        print(
                                                            'aquoi seleccionandolo');
                                                        _.getSelectServiceNew(
                                                            _.services[index]);

                                                        //MENSAJE DE CONFIRMACION SI DESEA REALMENTE AGREGAR UN SERVICIO
                                                      }
                                                    } else {
                                                      Get.snackbar(
                                                        'Mensaje',
                                                        'Debe de escanear el código Qr de entrada',
                                                        duration:
                                                            const Duration(
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
                                                        overlayBlur: 3,
                                                      );
                                                    }
                                                  },
                                                  title: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 6),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                CircleAvatar(
                                                                  radius: 20,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white, //fondo de la imagen
                                                                  child:
                                                                      ClipOval(
                                                                    child: Image
                                                                        .network(
                                                                      '${Env.apiEndpoint}/images/${_.services[index].image_service}',
                                                                      fit: BoxFit
                                                                          .cover, // Ajusta la imagen para cubrir completamente el área
                                                                      width:
                                                                          50, // Ancho deseado de la imagen dentro del círculo
                                                                      height:
                                                                          50,

                                                                      loadingBuilder: (BuildContext context,
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
                                                                      errorBuilder: (BuildContext context,
                                                                          Object
                                                                              error,
                                                                          StackTrace?
                                                                              stackTrace) {
                                                                        // Si la imagen no se puede cargar y estamos en modo de depuración, mostramos una imagen por defecto
                                                                        if (kDebugMode) {
                                                                          return CircleAvatar(
                                                                            radius:
                                                                                20,
                                                                            backgroundColor:
                                                                                Colors.transparent, // Fondo transparente para que el borde sea visible
                                                                            child:
                                                                                ClipOval(
                                                                              child: Image.asset(
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
                                                                                20,
                                                                            backgroundColor:
                                                                                Colors.transparent, // Fondo transparente para que el borde sea visible
                                                                            child:
                                                                                ClipOval(
                                                                              child: Image.asset(
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

                                                                //

                                                                SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          _.services[index]
                                                                              .name
                                                                              .toString(),
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color:
                                                                                const Color(0xFF2B3141),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          _.services[index]
                                                                              .type_service
                                                                              .toString(),
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              color: const Color(0xFF2B3141)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            Text(
                                                              formatNumber(_
                                                                  .services[
                                                                      index]
                                                                  .price_service
                                                                  .toString()),
                                                              style: TextStyle(
                                                                  fontSize: (MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.03),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  color: const Color(
                                                                      0xFF2B3141)),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 3,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            LayoutBuilder(
                                                              builder: (context,
                                                                  constraints) {
                                                                return Container(
                                                                  height: (MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.008),
                                                                  width: constraints
                                                                      .maxWidth,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            231,
                                                                            232,
                                                                            234),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(borderRadiusValue)),
                                                                  ),
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                          width:
                                                                              constraints.maxWidth * (_.services[index].duration_service / controllerLogin.serviceTime), //TODO AQUI CALCULA PARA QUE PINTE EL CONTAINER-RESPECTO-TIEMPO
                                                                          decoration: const BoxDecoration(
                                                                              borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue)),
                                                                              gradient: LinearGradient(
                                                                                colors: [
                                                                                  Colors.white,
                                                                                  Color(0xFFFDAE2A),
                                                                                ],
                                                                                stops: [
                                                                                  0.0,
                                                                                  0.8
                                                                                ],
                                                                                begin: FractionalOffset.centerLeft,
                                                                                end: FractionalOffset.centerRight,
                                                                              ))),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            SizedBox(
                                                              height: 3,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Icon(
                                                                    Icons.timer,
                                                                    color: Color(
                                                                        0xFFFDAE2A),
                                                                    size: (MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.016)),
                                                                Text(
                                                                  '${_.services[index].duration_service} Minutos',
                                                                  style: const TextStyle(
                                                                      height:
                                                                          1.0,
                                                                      fontSize:
                                                                          10,
                                                                      color: Color(
                                                                          0xFFFDAE2A),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                              //todo este era el que decia abajo total a pagar*/
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: SizedBox(
                            width: 2000,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GetBuilder<ShoppingCartController>(
                                    builder: (shpCont) {
                                  return ElevatedButton(
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                        const EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 8.0),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        _.selectServiceNew.isNotEmpty
                                            ? const Color(0xFF4470F3)
                                            : const Color.fromARGB(
                                                118, 255, 255, 255),
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Radio de los bordes
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      String s = '';
                                      if (_.selectServiceNew.isNotEmpty) {
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
                                                  Text('Agregando servicios...',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ],
                                              ),
                                            ),
                                          ),
                                          barrierDismissible: false,
                                        ); //Get.back();
                                        int resp = await shpCont
                                            .updateShoppingCartValueSerNew(
                                                _.selectServiceNew);
                                        Get.back(); //quito el cargando
                                        if (resp >= 1) {
                                          //reiniciar los relojes

                                          if (resp > 1) {
                                            s = 's';
                                          }
                                          Get.snackbar(
                                            'Mensaje',
                                            'Servicio$s agregado$s correctamente',
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
                                                    Color(0xFFFDAE2A)),
                                            overlayBlur: 3,
                                          );
                                        } else if (resp < 0 &&
                                            resp != -990099) {
                                          controllerLogin.showConnectionError();
                                          Get.snackbar(
                                            'Mensaje',
                                            'Problemas de conexión,inténtelo nuevamente agregar servicios',
                                            //  'Conexión lenta al agregarse (${resp * -1}) servicios',
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
                                                    Color(0xFFFDAE2A)),
                                            overlayBlur: 3,
                                          );
                                          //aqui mando al home ya que hubo problemas al insertar
                                          loginController.inTheClock(false);
                                          pagesConfigC.back();
                                        } else if (resp == -990099) {
                                          controllerLogin.showConnectionError();
                                          Get.snackbar(
                                            '!Alerta',
                                            'Problema al agregar los servicios,inténtelo de nuevo',
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
                                                    Color(0xFFFDAE2A)),
                                            overlayBlur: 3,
                                          );
                                          //aqui mando al home ya que hubo problemas al insertar
                                          loginController.inTheClock(false);
                                          pagesConfigC.back();
                                        }

                                        _.clearSelectServiceNew();
                                      } else {
                                        Get.snackbar(
                                          'Mensaje',
                                          'No hay servicios seleccionados',
                                          duration: const Duration(
                                              milliseconds: 2500),
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
                                    child: const Text(
                                      '     CONFIRMAR     ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ))
                    ],
                  ),
                )
              : const Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No hay servicios'),
                      ],
                    ),
                  ],
                ));
    });
  }
}
