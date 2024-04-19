// ignore_for_file: file_names, depend_on_referenced_packages
//import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/Views/common/topPage.dart';
import 'package:turnopro_apk/env.dart';

//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Estadistc1Page extends StatefulWidget {
  const Estadistc1Page({super.key});

  @override
  State<Estadistc1Page> createState() => _Estadistc1PageState();
}

class _Estadistc1PageState extends State<Estadistc1Page> {
  final PagesConfigController pagesConfigCont =
      Get.find<PagesConfigController>();
  final double valuePadding = 12;

  /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */
  final IconnsBack = Icons.arrow_back;
  final IconnsP = MdiIcons.bellBadgeOutline;
  String title = 'Clientes Atendidos';
  String subTitle = 'Clientes Atendidos';
  final colorCont = Colors.white;
  double panddCont = 8;
  double borderCont = 12;
  final colorIcon = Color(0xFFFF6750);
  /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */

  @override
  Widget build(BuildContext context) {
    final double heightScreen = MediaQuery.of(context).size.height;
    int heightFlexBody = 18;
    if (heightScreen <= 534.0) {
      heightFlexBody = 14;
    }
    //DECLARACION DE VARIABLES
    const double borderRadiusValue = 12;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 232, 234),
      body: GetBuilder<CoexistenceController>(builder: (_) {
        return _.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Color(0xFFFDAE2A),
              ))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: topPage(
                        panddCont: panddCont,
                        colorCont: colorCont,
                        borderCont: borderCont,
                        IconnsBack: IconnsBack,
                        pagesConfigC: pagesConfigCont,
                        isPagesConfig: false,
                        IconnsP: IconnsP,
                        title: title,
                        subTitle: subTitle,
                        colorIcon: colorIcon,
                        buttonRight: false),
                  ),
                  Expanded(
                      flex:
                          heightFlexBody, // 85% del espacio disponible para esta parte
                      child: _.estadist1Length > 0
                          ? ListView.builder(
                              padding: EdgeInsets
                                  .zero, // Elimina cualquier padding del ListView
                              itemCount: _.estadist1Length,
                              itemBuilder: (context, index) => Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Row(
                                        children: [
                                          Container(
                                            height: (MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.40),
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
                                            child: GetBuilder<
                                                    ClientsScheduledController>(
                                                builder: (controllerClient) {
                                              return ListTile(
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
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.9,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  height: 12,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          CircleAvatar(
                                                                        radius:
                                                                            20,
                                                                        child:
                                                                            ClipOval(
                                                                          child:
                                                                              Image.network(
                                                                            '${Env.apiEndpoint}/images/${_.estadist1[index].client_image}',
                                                                            fit:
                                                                                BoxFit.cover, // Ajusta la imagen para cubrir completamente el área
                                                                            width:
                                                                                50, // Ancho deseado de la imagen dentro del círculo
                                                                            height:
                                                                                50,
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
                                                                            errorBuilder: (BuildContext context,
                                                                                Object error,
                                                                                StackTrace? stackTrace) {
                                                                              // Si la imagen no se puede cargar y estamos en modo de depuración, mostramos una imagen por defecto
                                                                              if (kDebugMode) {
                                                                                return CircleAvatar(
                                                                                  radius: 20,
                                                                                  backgroundColor: Colors.transparent, // Fondo transparente para que el borde sea visible
                                                                                  child: ClipOval(
                                                                                    child: Image.asset(
                                                                                      'assets/images/default_profile.jpg',
                                                                                      fit: BoxFit.cover, // Ajusta la imagen para cubrir completamente el área
                                                                                      width: 50, // Ancho deseado de la imagen dentro del círculo
                                                                                      height: 50, // Alto deseado de la imagen dentro del círculo
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              } else {
                                                                                // Si no estamos en modo de depuración, mostramos un texto de error
                                                                                return CircleAvatar(
                                                                                  radius: 20,
                                                                                  backgroundColor: Colors.transparent, // Fondo transparente para que el borde sea visible
                                                                                  child: ClipOval(
                                                                                    child: Image.asset(
                                                                                      'assets/images/default_profile.jpg',
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
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      _.estadist1[index]
                                                                          .clientName
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          color: Color(
                                                                              0xFFFDAE2A),
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Container(
                                                                  height: 2,
                                                                  width: 1000,
                                                                  color: const Color
                                                                          .fromARGB(
                                                                      155,
                                                                      182,
                                                                      184,
                                                                      182),
                                                                ),
                                                                SizedBox(
                                                                  height: 6,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        'Cantidad Ganada',
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            fontWeight:
                                                                                FontWeight.w700)),
                                                                    Text(
                                                                      _.estadist1[index]
                                                                          .amountWin
                                                                          .toString(),
                                                                      maxLines:
                                                                          2, // Limita el texto a 2 líneas

                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis, // Agrega los tres puntos suspensivos
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        'Monto total'),
                                                                    Text(
                                                                      _.estadist1[index]
                                                                          .amountTotal
                                                                          .toString(),
                                                                      maxLines:
                                                                          2, // Limita el texto a 2 líneas
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis, // Agrega los tres puntos suspensivos
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color: Color.fromARGB(
                                                                              148,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        'Tiempo de Servicio'),
                                                                    Text(
                                                                      _.estadist1[index]
                                                                          .time
                                                                          .toString(),
                                                                      maxLines:
                                                                          2, // Limita el texto a 2 líneas
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis, // Agrega los tres puntos suspensivos
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color: Color.fromARGB(
                                                                              148,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        'Elección'),
                                                                    Text(
                                                                      _.estadist1[index]
                                                                          .choice
                                                                          .toString(),
                                                                      maxLines:
                                                                          2, // Limita el texto a 2 líneas
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis, // Agrega los tres puntos suspensivos
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color: Color.fromARGB(
                                                                              148,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        'Servicios Especiales'),
                                                                    Text(
                                                                      _.estadist1[index]
                                                                          .serviceSpecial
                                                                          .toString(),
                                                                      maxLines:
                                                                          2, // Limita el texto a 2 líneas
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis, // Agrega los tres puntos suspensivos
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color: Color.fromARGB(
                                                                              148,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        'Ganancia Especial'),
                                                                    Text(
                                                                      _.estadist1[index]
                                                                          .specialAmount
                                                                          .toString(),
                                                                      maxLines:
                                                                          2, // Limita el texto a 2 líneas
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis, // Agrega los tres puntos suspensivos
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color: Color.fromARGB(
                                                                              148,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        'Fecha'),
                                                                    Text(
                                                                      _.estadist1[index]
                                                                          .date
                                                                          .toString(),
                                                                      maxLines:
                                                                          2, // Limita el texto a 2 líneas
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis, // Agrega los tres puntos suspensivos
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color: Color.fromARGB(
                                                                              148,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        'Servicios Realizados'),
                                                                    Text(
                                                                      _.estadist1[index]
                                                                          .servicesRealizated
                                                                          .toString(),
                                                                      maxLines:
                                                                          2, // Limita el texto a 2 líneas
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis, // Agrega los tres puntos suspensivos
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color: Color.fromARGB(
                                                                              148,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ));
                                            }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                          : const Center(
                              //*AQUI ESTA EL CODIGO DE CUANDO NO HAY Convivencias
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('No hay Clientes Atendidos'),
                                  ],
                                ),
                              ],
                            ))),
                ],
              );
      }),
    );
  }
}
