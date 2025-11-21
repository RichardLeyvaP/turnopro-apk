//ESTE ES EL ULTIMOS QUE FALLABA
//
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
  final LoginController loginCont = Get.find<LoginController>();
  final PagesConfigController pagesConfigCont =
      Get.find<PagesConfigController>();
  final double valuePadding = 12;

  /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */
  final IconnsBack = Icons.arrow_back;
  final IconnsP = MdiIcons.currencyUsd;
  String title = 'Pagos Realizados 4';
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
                    flex: 5,
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
                  //pendientes y por cobrar
                  Expanded(
                    flex: 3,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            child: Container(
                              height:
                                  (MediaQuery.of(context).size.height * 0.08),
                              width: (MediaQuery.of(context).size.width * 1),
                              child: GetBuilder<ClientsScheduledController>(
                                  builder: (controllerClient) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height:
                                          (MediaQuery.of(context).size.height *
                                              0.085),
                                      width: MediaQuery.of(context).size.width *
                                          0.485,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFDAE2A),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text('PENDIENTE POR COBRAR',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            Text(
                                                '  ${_.estadistPagosFijo['pendiente'].toString()}  ',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height:
                                          (MediaQuery.of(context).size.height *
                                              0.085),
                                      width: MediaQuery.of(context).size.width *
                                          0.485,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF19CF9E),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text('GANANCIA TOTAL',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            Text(
                                                '  ${_.estadistPagosFijo['pagado'].toString()}  ',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (loginCont.chargeUserLoggedIn == 'Barbero' ||
                      loginCont.chargeUserLoggedIn ==
                          'Barbero y Encargado') ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Expanded(
                        flex: 9,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Row(
                              children: [
                                Container(
                                  height: (MediaQuery.of(context).size.height *
                                      0.4),
                                  width:
                                      (MediaQuery.of(context).size.width * 1),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.7),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(-5,
                                            5), // Ajusta los valores para personalizar la sombra
                                      ),
                                    ],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(borderRadiusValue)),
                                  ),
                                  child: GetBuilder<ClientsScheduledController>(
                                      builder: (controllerClient) {
                                    return ListTile(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        title: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
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
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Icon(
                                                                MdiIcons
                                                                    .accountDetails,
                                                                color: Color(
                                                                    0xFFFDAE2A),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                'DETALLES',
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
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            '',
                                                            maxLines:
                                                                2, // Limita el texto a 2 líneas
                                                            overflow: TextOverflow
                                                                .ellipsis, // Agrega los tres puntos suspensivos
                                                            style: const TextStyle(
                                                                fontSize: 18,
                                                                color: Color(
                                                                    0xFFFDAE2A),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 2,
                                                      ),
                                                      Container(
                                                        height: 1,
                                                        width: 1000,
                                                        color: const Color
                                                                .fromARGB(
                                                            155, 182, 184, 182),
                                                      ),
                                                      SizedBox(
                                                        height: 6,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'Clientes atendidos',
                                                            style: TextStyle(
                                                              height: 1.2,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          Text(
                                                              _.estadistPagosFijo['clientAtended']
                                                                  .toString(),
                                                              maxLines:
                                                                  2, // Limita el texto a 2 líneas
                                                              overflow: TextOverflow
                                                                  .ellipsis, // Agrega los tres puntos suspensivos
                                                              style: const TextStyle(
                                                                  height: 1.2,
                                                                  fontSize: 16,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          148,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700)),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'Propina 80%',
                                                            style: TextStyle(
                                                              height: 1.2,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          Text(
                                                              _.estadistPagosFijo['propina80']
                                                                  .toString(),
                                                              maxLines:
                                                                  2, // Limita el texto a 2 líneas
                                                              overflow: TextOverflow
                                                                  .ellipsis, // Agrega los tres puntos suspensivos
                                                              style: const TextStyle(
                                                                  height: 1.2,
                                                                  fontSize: 16,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          148,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700)),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'Cantidad de servicios',
                                                            style: TextStyle(
                                                              height: 1.2,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          Text(
                                                            _.estadistPagosFijo[
                                                                    'servCant']
                                                                .toString(),
                                                            maxLines:
                                                                2, // Limita el texto a 2 líneas
                                                            overflow: TextOverflow
                                                                .ellipsis, // Agrega los tres puntos suspensivos
                                                            style: const TextStyle(
                                                                height: 1.2,
                                                                fontSize: 16,
                                                                color: Color
                                                                    .fromARGB(
                                                                        148,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'Ganancia en productos',
                                                            style: TextStyle(
                                                              height: 1.2,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          Text(
                                                            _.estadistPagosFijo[
                                                                    'productCant']
                                                                .toString(),
                                                            maxLines:
                                                                2, // Limita el texto a 2 líneas
                                                            overflow: TextOverflow
                                                                .ellipsis, // Agrega los tres puntos suspensivos
                                                            style: const TextStyle(
                                                                height: 1.2,
                                                                fontSize: 16,
                                                                color: Color
                                                                    .fromARGB(
                                                                        148,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Retención',
                                                            style: TextStyle(
                                                              height: 1.2,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          Text(
                                                            _.estadistPagosFijo[
                                                                    'retention']
                                                                .toString(),
                                                            maxLines:
                                                                2, // Limita el texto a 2 líneas
                                                            overflow: TextOverflow
                                                                .ellipsis, // Agrega los tres puntos suspensivos
                                                            style: const TextStyle(
                                                                height: 1.2,
                                                                fontSize: 16,
                                                                color: Color
                                                                    .fromARGB(
                                                                        148,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Ganancia Líquida',
                                                            style: TextStyle(
                                                              height: 1.2,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          Text(
                                                            _.estadistPagosFijo[
                                                                    'winnerRetention']
                                                                .toString(),
                                                            maxLines:
                                                                2, // Limita el texto a 2 líneas
                                                            overflow: TextOverflow
                                                                .ellipsis, // Agrega los tres puntos suspensivos
                                                            style: const TextStyle(
                                                                height: 1.2,
                                                                fontSize: 16,
                                                                color: Color
                                                                    .fromARGB(
                                                                        148,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'Cantidad de Meta',
                                                            style: TextStyle(
                                                              height: 1.2,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          Text(
                                                            _.estadistPagosFijo[
                                                                    'metaCant']
                                                                .toString(),
                                                            maxLines:
                                                                2, // Limita el texto a 2 líneas
                                                            overflow: TextOverflow
                                                                .ellipsis, // Agrega los tres puntos suspensivos
                                                            style: TextStyle(
                                                              height: 1.2,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'Pago de Meta',
                                                            style: TextStyle(
                                                              height: 1.2,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          Text(
                                                            _.estadistPagosFijo[
                                                                    'metaAmount']
                                                                .toString(),
                                                            maxLines:
                                                                2, // Limita el texto a 2 líneas
                                                            overflow: TextOverflow
                                                                .ellipsis, // Agrega los tres puntos suspensivos
                                                            style: TextStyle(
                                                              height: 1.2,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'Bonos de Servicios',
                                                            style: TextStyle(
                                                              height: 1.2,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          Text(
                                                            _.estadistPagosFijo[
                                                                    'servAmount']
                                                                .toString(),
                                                            maxLines:
                                                                2, // Limita el texto a 2 líneas
                                                            overflow: TextOverflow
                                                                .ellipsis, // Agrega los tres puntos suspensivos
                                                            style: TextStyle(
                                                              height: 1.2,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'Bonos de Productos',
                                                            style: TextStyle(
                                                              height: 1.2,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          Text(
                                                            _.estadistPagosFijo[
                                                                    'productAmount']
                                                                .toString(),
                                                            maxLines:
                                                                2, // Limita el texto a 2 líneas
                                                            overflow: TextOverflow
                                                                .ellipsis, // Agrega los tres puntos suspensivos
                                                            style: TextStyle(
                                                              height: 1.2,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'Monto Generado',
                                                            style: TextStyle(
                                                              height: 1.2,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          Text(
                                                            _.estadistPagosFijo[
                                                                    'amountGenerate']
                                                                .toString(),

                                                            maxLines:
                                                                2, // Limita el texto a 2 líneas
                                                            overflow: TextOverflow
                                                                .ellipsis, // Agrega los tres puntos suspensivos
                                                            style: TextStyle(
                                                              height: 1.2,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'Monto Ganado',
                                                            style: TextStyle(
                                                                height: 1.2,
                                                                fontSize: 16,
                                                                color: Color
                                                                    .fromARGB(
                                                                        220,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          Text(
                                                            _.estadistPagosFijo[
                                                                    'winnerAmount']
                                                                .toString(),
                                                            maxLines:
                                                                2, // Limita el texto a 2 líneas
                                                            overflow: TextOverflow
                                                                .ellipsis, // Agrega los tres puntos suspensivos
                                                            style: const TextStyle(
                                                                height: 1.2,
                                                                fontSize: 16,
                                                                color: Color
                                                                    .fromARGB(
                                                                        220,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
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
                      ),
                    ),
                  ],
                  //detalles solo del barbero
                  //pagos
                  Expanded(
                    flex: loginCont.chargeUserLoggedIn == 'Barbero' ||
                            loginCont.chargeUserLoggedIn ==
                                'Barbero y Encargado'
                        ? 13
                        : 22, // 85% del espacio disponible para esta parte
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
                                              0.13),
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
