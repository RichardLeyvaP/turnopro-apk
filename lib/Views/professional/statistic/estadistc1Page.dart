// ignore_for_file: file_names, depend_on_referenced_packages
//import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Routes/index.dart';
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
      appBar: AppBar(
        // leading: Row(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     IconButton(
        //       icon: const Icon(Icons.arrow_back),
        //       onPressed: () {
        //         pagesConfigCont.back();
        //         // Navigator.pop(context);
        //       },
        //     ),
        //   ],
        // ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Column(
              children: [
                Icon(
                  Icons.person,
                  size: 55,
                ),
                Text(
                  'Clientes Atendidos',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: (MediaQuery.of(context).size.width * 0.14),
            ),
          ],
        ),
        //actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
        elevation: 0, // Quits the shadow
        //shadowColor: Colors.amber, // Removes visual elevation
      ),
      backgroundColor: const Color.fromARGB(255, 231, 232, 234),
      body: GetBuilder<CoexistenceController>(builder: (_) {
        return _.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Color(0xFFFDAE2A),
              ))
            : _.estadist1Length > 0
                ? Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        flex:
                            heightFlexBody, // 85% del espacio disponible para esta parte
                        child: ListView.builder(
                            itemCount: _.estadist1Length,
                            itemBuilder: (context, index) => Padding(
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
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        CircleAvatar(
                                                                      backgroundColor: const Color
                                                                              .fromARGB(
                                                                          120,
                                                                          190,
                                                                          190,
                                                                          189),
                                                                      backgroundImage: NetworkImage(
                                                                          //  '${Env.apiEndpoint}/images/clients/default_profile.jpg'),
                                                                          '${Env.apiEndpoint}/images/${_.estadist1[index].client_image}'),
                                                                      radius:
                                                                          20, // Ajusta el tamaño del círculo aquí
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    _
                                                                        .estadist1[
                                                                            index]
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
                                                                    _
                                                                        .estadist1[
                                                                            index]
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
                                                                    _
                                                                        .estadist1[
                                                                            index]
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
                                                                    _
                                                                        .estadist1[
                                                                            index]
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
                                                                    _
                                                                        .estadist1[
                                                                            index]
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
                                                                    _
                                                                        .estadist1[
                                                                            index]
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
                                                                    _
                                                                        .estadist1[
                                                                            index]
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
                                                                  Text('Fecha'),
                                                                  Text(
                                                                    _
                                                                        .estadist1[
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
                                                                    _
                                                                        .estadist1[
                                                                            index]
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
                                )),
                      ),
                    ],
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
