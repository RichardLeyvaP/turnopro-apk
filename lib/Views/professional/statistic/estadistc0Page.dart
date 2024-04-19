// ignore_for_file: file_names, depend_on_referenced_packages
//import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/env.dart';

//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Estadistc0Page extends StatefulWidget {
  const Estadistc0Page({super.key});

  @override
  State<Estadistc0Page> createState() => _Estadistc0PageState();
}

class _Estadistc0PageState extends State<Estadistc0Page> {
  final PagesConfigController pagesConfigCont =
      Get.find<PagesConfigController>();
  final double valuePadding = 12;

  final String imageDirection = 'assets/images/image_perfil.jpg';

  @override
  Widget build(BuildContext context) {
    final double heightScreen = MediaQuery.of(context).size.height;
    int heightFlexBody = 20;
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
            : _.estadist0Length > 0
                ? Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Expanded(
                            flex:
                                heightFlexBody, // 85% del espacio disponible para esta parte
                            child: ListView.builder(
                                padding: EdgeInsets
                                    .zero, // Elimina cualquier padding del ListView
                                itemCount: _.estadist0Length,
                                itemBuilder: (context, index) => InkWell(
                                      onTap: () async {
                                        print(
                                            'estoy dando en :${_.estadist0[index].data.toString()}');
                                        Get.dialog(
                                          const Center(
                                            child: CircularProgressIndicator(
                                              color: Color(0xFFFDAE2A),
                                            ),
                                          ),
                                          barrierDismissible: false,
                                        ); //Get.back();
                                        await _.fetchEstadist1(
                                            _.estadist0[index].data);
                                        Get.back();
                                        Get.toNamed('/Estadistc1Page');
                                      },
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 10, 10, 0),
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Row(
                                            children: [
                                              Container(
                                                height: (MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.24),
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
                                                    builder:
                                                        (controllerClient) {
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
                                                                      height:
                                                                          12,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Icon(
                                                                          MdiIcons
                                                                              .calendar,
                                                                          color:
                                                                              Color(0xFFFDAE2A),
                                                                        ),
                                                                        Text(
                                                                          _.estadist0[index]
                                                                              .data
                                                                              .toString(),
                                                                          maxLines:
                                                                              2, // Limita el texto a 2 líneas
                                                                          overflow:
                                                                              TextOverflow.ellipsis, // Agrega los tres puntos suspensivos
                                                                          style: const TextStyle(
                                                                              fontSize: 18,
                                                                              color: Color(0xFFFDAE2A),
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 2,
                                                                    ),
                                                                    Container(
                                                                      height: 1,
                                                                      width:
                                                                          1000,
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
                                                                            'Clientes atendidos'),
                                                                        Text(
                                                                          _.estadist0[index]
                                                                              .attendedClient
                                                                              .toString(),
                                                                          maxLines:
                                                                              2, // Limita el texto a 2 líneas
                                                                          overflow:
                                                                              TextOverflow.ellipsis, // Agrega los tres puntos suspensivos
                                                                          style: const TextStyle(
                                                                              fontSize: 16,
                                                                              color: Color.fromARGB(148, 0, 0, 0),
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                            'Clientes aleatorios'),
                                                                        Text(
                                                                          _.estadist0[index]
                                                                              .clientAleator
                                                                              .toString(),
                                                                          maxLines:
                                                                              2, // Limita el texto a 2 líneas
                                                                          overflow:
                                                                              TextOverflow.ellipsis, // Agrega los tres puntos suspensivos
                                                                          style: const TextStyle(
                                                                              fontSize: 16,
                                                                              color: Color.fromARGB(148, 0, 0, 0),
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                            'Servicios'),
                                                                        Text(
                                                                          _.estadist0[index]
                                                                              .services
                                                                              .toString(),
                                                                          maxLines:
                                                                              2, // Limita el texto a 2 líneas
                                                                          overflow:
                                                                              TextOverflow.ellipsis, // Agrega los tres puntos suspensivos
                                                                          style: const TextStyle(
                                                                              fontSize: 16,
                                                                              color: Color.fromARGB(148, 0, 0, 0),
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                            'Total en servicios'),
                                                                        Text(
                                                                          _.estadist0[index]
                                                                              .amountGenerate
                                                                              .toString(),
                                                                          maxLines:
                                                                              2, // Limita el texto a 2 líneas
                                                                          overflow:
                                                                              TextOverflow.ellipsis, // Agrega los tres puntos suspensivos
                                                                          style: const TextStyle(
                                                                              fontSize: 16,
                                                                              color: Color.fromARGB(148, 0, 0, 0),
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        const Text(
                                                                          'Cantidad Generada',
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              color: Color.fromARGB(220, 0, 0, 0),
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                        Text(
                                                                          _.estadist0[index]
                                                                              .totalServices
                                                                              .toString(),
                                                                          maxLines:
                                                                              2, // Limita el texto a 2 líneas
                                                                          overflow:
                                                                              TextOverflow.ellipsis, // Agrega los tres puntos suspensivos
                                                                          style: const TextStyle(
                                                                              fontSize: 16,
                                                                              color: Color.fromARGB(220, 0, 0, 0),
                                                                              fontWeight: FontWeight.w700),
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
                                      ),
                                    )),
                          ),
                          //
                          //
                          //
                          //
                          //
                        ],
                      ),
                    ),
                  )
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
                  ));
      }),
    );
  }
}
