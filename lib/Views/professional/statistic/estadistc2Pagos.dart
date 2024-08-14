//ESTE ES EL ULTIMOS QUE FALLABA
//
// ignore_for_file: file_names, depend_on_referenced_packages
//import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/Utility/utils.dart';
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
  final PagesConfigController pagesConfigCont = Get.find<PagesConfigController>();
  final CoexistenceController coexCont = Get.find<CoexistenceController>();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (coexCont.retriesResult == true) {
        Get.snackbar(
          'Alerta',
          'Hubo problema al conectar con el servidor, por favor intentarlo nuevamente',
          duration: const Duration(milliseconds: 2500),
        );
      }
    });
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
                    flex: loginCont.chargeUserLoggedIn == 'Tecnico' ? 6 : 4,
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
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
                          child: Container(
                            height: (MediaQuery.of(context).size.height * 0.08),
                            width: (MediaQuery.of(context).size.width * 1),
                            child: GetBuilder<ClientsScheduledController>(builder: (controllerClient) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: (MediaQuery.of(context).size.height * 0.085),
                                    width: MediaQuery.of(context).size.width * 0.485,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFDAE2A), //todo
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          const Text('Pendiente a Cobrar',
                                              style: TextStyle(
                                                  fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700)),
                                          Text('  ${formatNumber(_.estadistPagosFijo['pendiente'].toString())}  ',
                                              style: const TextStyle(
                                                  fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: (MediaQuery.of(context).size.height * 0.085),
                                    width: MediaQuery.of(context).size.width * 0.485,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF19CF9E), //todo
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          const Text('Cobrado',
                                              style: TextStyle(
                                                  fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700)),
                                          Text('  ${formatNumber(_.estadistPagosFijo['pagado'].toString())}  ',
                                              style: const TextStyle(
                                                  fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700)),
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
                  /* 
                Aqui estaba la estadistica de detalles del barbero que el cliente mando a aquitar
                 if (loginCont.chargeUserLoggedIn == 'Barbero' ||
                      loginCont.chargeUserLoggedIn ==
                          'Barbero y Encargado') ...[
                    
                    Expanded(
                      flex: 14,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Row(
                            children: [
                              Container(
                                height:
                                    (MediaQuery.of(context).size.height * 0.4),
                                width: (MediaQuery.of(context).size.width * 1),
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 6,
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
                                                              color: const Color(
                                                                  0xFFFDAE2A),
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            const Text(
                                                              'Detalles',

                                                              overflow: TextOverflow
                                                                  .ellipsis, // Agrega los tres puntos suspensivos
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Color(
                                                                      0xFFFDAE2A),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          ],
                                                        ),
                                                        const Text(
                                                          '',
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 2,
                                                    ),
                                                    Container(
                                                      height: 1,
                                                      width: 1000,
                                                      color:
                                                          const Color.fromARGB(
                                                              155,
                                                              182,
                                                              184,
                                                              182),
                                                    ),
                                                    const SizedBox(
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
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Text(
                                                            _.estadistPagosFijo[
                                                                    'clientAtended']
                                                                .toString(),
                                                            maxLines:
                                                                2, // Limita el texto a 2 líneas
                                                            overflow: TextOverflow
                                                                .ellipsis, // Agrega los tres puntos suspensivos
                                                            style: const TextStyle(
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
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Text(
                                                            formatNumber(_
                                                                .estadistPagosFijo[
                                                                    'propina80']
                                                                .toString()),
                                                            maxLines:
                                                                2, // Limita el texto a 2 líneas
                                                            overflow: TextOverflow
                                                                .ellipsis, // Agrega los tres puntos suspensivos
                                                            style: const TextStyle(
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
                                                              fontSize: 16,
                                                              color: Color
                                                                  .fromARGB(148,
                                                                      0, 0, 0),
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
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Text(
                                                          formatNumber(_
                                                              .estadistPagosFijo[
                                                                  'productCant']
                                                              .toString()),
                                                          maxLines:
                                                              2, // Limita el texto a 2 líneas
                                                          overflow: TextOverflow
                                                              .ellipsis, // Agrega los tres puntos suspensivos
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              color: Color
                                                                  .fromARGB(148,
                                                                      0, 0, 0),
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
                                                          'Retención',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Text(
                                                          formatNumber(_
                                                              .estadistPagosFijo[
                                                                  'retention']
                                                              .toString()),
                                                          maxLines:
                                                              2, // Limita el texto a 2 líneas
                                                          overflow: TextOverflow
                                                              .ellipsis, // Agrega los tres puntos suspensivos
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              color: Color
                                                                  .fromARGB(148,
                                                                      0, 0, 0),
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
                                                          'Metas de Convivencias',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Text(
                                                          formatNumber(_
                                                              .estadistPagosFijo[
                                                                  'metaAmount']
                                                              .toString()),
                                                          maxLines:
                                                              2, // Limita el texto a 2 líneas
                                                          overflow: TextOverflow
                                                              .ellipsis, // Agrega los tres puntos suspensivos
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              color: Color
                                                                  .fromARGB(148,
                                                                      0, 0, 0),
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
                                                          'Metas de Servicios',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Text(
                                                          formatNumber(_
                                                              .estadistPagosFijo[
                                                                  'servAmount']
                                                              .toString()),
                                                          maxLines:
                                                              2, // Limita el texto a 2 líneas
                                                          overflow: TextOverflow
                                                              .ellipsis, // Agrega los tres puntos suspensivos
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              color: Color
                                                                  .fromARGB(148,
                                                                      0, 0, 0),
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
                                                          'Metas de Productos',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Text(
                                                          formatNumber(_
                                                              .estadistPagosFijo[
                                                                  'productAmount']
                                                              .toString()),
                                                          maxLines:
                                                              2, // Limita el texto a 2 líneas
                                                          overflow: TextOverflow
                                                              .ellipsis, // Agrega los tres puntos suspensivos
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              color: Color
                                                                  .fromARGB(148,
                                                                      0, 0, 0),
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
                                                          'Monto Generado',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Text(
                                                          formatNumber(_
                                                              .estadistPagosFijo[
                                                                  'amountGenerate']
                                                              .toString()),

                                                          maxLines:
                                                              2, // Limita el texto a 2 líneas
                                                          overflow: TextOverflow
                                                              .ellipsis, // Agrega los tres puntos suspensivos
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              color: Color
                                                                  .fromARGB(148,
                                                                      0, 0, 0),
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
                                                          'Monto Ganado',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Text(
                                                          formatNumber(_
                                                              .estadistPagosFijo[
                                                                  'winnerAmount']
                                                              .toString()),
                                                          maxLines:
                                                              2, // Limita el texto a 2 líneas
                                                          overflow: TextOverflow
                                                              .ellipsis, // Agrega los tres puntos suspensivos
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              color: Color
                                                                  .fromARGB(148,
                                                                      0, 0, 0),
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
                                                          'Monto Líquido',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Color
                                                                  .fromARGB(220,
                                                                      0, 0, 0),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                        Text(
                                                          formatNumber(_
                                                              .estadistPagosFijo[
                                                                  'winnerRetention']
                                                              .toString()),
                                                          maxLines:
                                                              2, // Limita el texto a 2 líneas
                                                          overflow: TextOverflow
                                                              .ellipsis, // Agrega los tres puntos suspensivos
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              color: Color
                                                                  .fromARGB(220,
                                                                      0, 0, 0),
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
                 
                  ],
                  //detalles solo del barbero
*/
                  //pocos detalles solo del tecnico
                  if (loginCont.chargeUserLoggedIn == 'Tecnico') ...[
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Row(
                            children: [
                              Container(
                                height: (MediaQuery.of(context).size.height * 0.11),
                                width: (MediaQuery.of(context).size.width * 1),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.7),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(-5, 5), // Ajusta los valores para personalizar la sombra
                                    ),
                                  ],
                                  borderRadius: const BorderRadius.all(Radius.circular(borderRadiusValue)),
                                ),
                                child: GetBuilder<ClientsScheduledController>(builder: (controllerClient) {
                                  return ListTile(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(12)),
                                      ),
                                      title: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width * 0.9,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 6,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Icon(
                                                              MdiIcons.accountDetails,
                                                              color: const Color(0xFFFDAE2A),
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            const Text(
                                                              'Detalles',

                                                              overflow: TextOverflow
                                                                  .ellipsis, // Agrega los tres puntos suspensivos
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Color(0xFFFDAE2A),
                                                                  fontWeight: FontWeight.w700),
                                                            ),
                                                          ],
                                                        ),
                                                        const Text(
                                                          '',
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 2,
                                                    ),
                                                    Container(
                                                      height: 1,
                                                      width: 1000,
                                                      color: const Color.fromARGB(155, 182, 184, 182),
                                                    ),
                                                    const SizedBox(
                                                      height: 6,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        const Text(
                                                          'Clientes atendidos',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Text(_.estadistPagosFijo['clientAtended'].toString(),
                                                            maxLines: 2, // Limita el texto a 2 líneas
                                                            overflow: TextOverflow
                                                                .ellipsis, // Agrega los tres puntos suspensivos
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                color: Color.fromARGB(148, 0, 0, 0),
                                                                fontWeight: FontWeight.w700)),
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
                  ],
                  //pagos
                  Expanded(
                    flex: loginCont.chargeUserLoggedIn == 'Barbero' ||
                            loginCont.chargeUserLoggedIn == 'Barbero y Encargado'
                        ? 18
                        : 22, // 85% del espacio disponible para esta parte
                    child: _.estadistPagosLength > 0
                        ? ListView.builder(
                            padding: EdgeInsets.zero, // Elimina cualquier padding del ListView
                            itemCount: _.estadistPagosLength,
                            itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.only(
                                    top: 4,
                                    left: 10,
                                    right: 10,
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: (MediaQuery.of(context).size.height * 0.13),
                                          width: (MediaQuery.of(context).size.width * 1),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.3),
                                                spreadRadius: 1,
                                                blurRadius: 3,
                                                offset: const Offset(
                                                    0, 5), // Ajusta los valores para personalizar la sombra
                                              ),
                                            ],
                                            borderRadius: const BorderRadius.all(Radius.circular(borderRadiusValue)),
                                          ),
                                          child: GetBuilder<ClientsScheduledController>(builder: (controllerClient) {
                                            return ListTile(
                                                shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                                ),
                                                title: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width * 0.9,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              const SizedBox(
                                                                height: 12,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Icon(
                                                                    MdiIcons.calendar,
                                                                    color: const Color(0xFFFDAE2A),
                                                                  ),
                                                                  Text(
                                                                    _.estadistPagos[index].date.toString(),
                                                                    maxLines: 2, // Limita el texto a 2 líneas
                                                                    overflow: TextOverflow
                                                                        .ellipsis, // Agrega los tres puntos suspensivos
                                                                    style: const TextStyle(
                                                                        fontSize: 18,
                                                                        color: Color(0xFFFDAE2A),
                                                                        fontWeight: FontWeight.w700),
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                height: 2,
                                                                width: 1000,
                                                                color: const Color.fromARGB(155, 182, 184, 182),
                                                              ),
                                                              const SizedBox(
                                                                height: 6,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  const Text('Tipo de Pago'),
                                                                  Text(
                                                                    _.estadistPagos[index].type.toString(),
                                                                    maxLines: 2, // Limita el texto a 2 líneas
                                                                    overflow: TextOverflow
                                                                        .ellipsis, // Agrega los tres puntos suspensivos
                                                                    style: const TextStyle(
                                                                        fontSize: 16,
                                                                        color: Color.fromARGB(148, 0, 0, 0),
                                                                        fontWeight: FontWeight.w700),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  const Text(
                                                                    'Cantidad',
                                                                    style: TextStyle(
                                                                        fontSize: 16,
                                                                        color: Color.fromARGB(220, 0, 0, 0),
                                                                        fontWeight: FontWeight.w700),
                                                                  ),
                                                                  Text(
                                                                    formatNumber(
                                                                        _.estadistPagos[index].amount.toString()),
                                                                    maxLines: 2, // Limita el texto a 2 líneas
                                                                    overflow: TextOverflow
                                                                        .ellipsis, // Agrega los tres puntos suspensivos
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
