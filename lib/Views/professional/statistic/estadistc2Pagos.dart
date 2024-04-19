// ignore_for_file: file_names, depend_on_referenced_packages
//import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/Views/common/topPage.dart';
import 'package:turnopro_apk/env.dart';

//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Estadistc2Pagos extends StatefulWidget {
  const Estadistc2Pagos({super.key});

  @override
  State<Estadistc2Pagos> createState() => _Estadistc2PagosState();
}

class _Estadistc2PagosState extends State<Estadistc2Pagos> {
  final PagesConfigController pagesConfigCont =
      Get.find<PagesConfigController>();
  final double valuePadding = 12;

  /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */
  final IconnsBack = Icons.arrow_back;
  final IconnsP = MdiIcons.currencyUsd;
  String title = 'Pagos Realizados';
  String subTitle = 'Mis pagos';
  final colorCont = Colors.white;
  double panddCont = 8;
  double borderCont = 12;
  final colorIcon = Color(0xFF4470F3);
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
                    child: _.estadistPagosLength > 0
                        ? ListView.builder(
                            padding: EdgeInsets
                                .zero, // Elimina cualquier padding del ListView
                            itemCount: _.estadistPagosLength,
                            itemBuilder: (context, index) => Padding(
                                  padding: EdgeInsets.only(
                                    top: 10,
                                    left: 10,
                                    right: 10,
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: (MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.145),
                                          width: (MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                spreadRadius: 1,
                                                blurRadius: 3,
                                                offset: const Offset(0,
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
                                                          Radius.circular(12)),
                                                ),
                                                title: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
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
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Icon(
                                                                    MdiIcons
                                                                        .calendar,
                                                                    color: Color(
                                                                        0xFFFDAE2A),
                                                                  ),
                                                                  Text(
                                                                    _
                                                                        .estadistPagos[
                                                                            index]
                                                                        .date
                                                                        .toString(),
                                                                    maxLines:
                                                                        2, // Limita el texto a 2 líneas
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis, // Agrega los tres puntos suspensivos
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
                                                                      'Tipo de Pago'),
                                                                  Text(
                                                                    _
                                                                        .estadistPagos[
                                                                            index]
                                                                        .type
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
                                                                  const Text(
                                                                    'Cantidad',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Color.fromARGB(
                                                                            220,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                  Text(
                                                                    _
                                                                        .estadistPagos[
                                                                            index]
                                                                        .amount
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
                                                                            220,
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
                                  Text('No hay Pagos Realizados'),
                                ],
                              ),
                            ],
                          )),
                  ),
                ],
              );
      }),
    );
  }
}
