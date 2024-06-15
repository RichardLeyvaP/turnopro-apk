// ignore_for_file: file_names, depend_on_referenced_packages
//import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/Utility/textTruncate.dart';
import 'package:turnopro_apk/Utility/utils.dart';
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
  final CoexistenceController coexCont = Get.find<CoexistenceController>();
  final double valuePadding = 12;

  /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */
  final IconnsBack = Icons.arrow_back;
  final IconnsP = MdiIcons.accountGroup;
  String title = 'Clientes Atendidos';
  String subTitle = 'Detalle';
  final colorCont = Colors.white;
  double panddCont = 8;
  double borderCont = 12;
  final colorIcon = Color(0xFF4470F3);
  /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */

  @override
  Widget build(BuildContext context) {
    //functions utiles
    //devolver long de un text
    int getTextLength(String text) {
      return text.length;
    }

//calcular cuantas lineas ocupa el texto
    int calculateTextLines(String text, double maxWidth, TextStyle style) {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 5,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(maxWidth: maxWidth);

      // Calculate the number of lines
      int lineCount = textPainter.computeLineMetrics().length;

      return lineCount;
    }

    //functions utiles

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
                  _.chargeSave == 'Tecnico'
                      ? Expanded(
                          flex:
                              heightFlexBody, // 85% del espacio disponible para esta parte
                          child: _.estadist1Length > 0
                              ? ListView.builder(
                                  padding: EdgeInsets
                                      .zero, // Elimina cualquier padding del ListView
                                  itemCount: _.estadist1Length,
                                  itemBuilder: (context, index) {
                                    return Padding(
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
                                                  0.15),
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
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                CircleAvatar(
                                                                              backgroundColor: Colors.white,
                                                                              radius: 20,
                                                                              child: ClipOval(
                                                                                child: Image.network(
                                                                                  '${Env.apiEndpoint}/images/${_.estadist1[index].client_image}',
                                                                                  fit: BoxFit.cover, // Ajusta la imagen para cubrir completamente el área
                                                                                  width: 50, // Ancho deseado de la imagen dentro del círculo
                                                                                  height: 50,
                                                                                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
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
                                                                                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
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
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              TruncatedText(
                                                                                text: _.estadist1[index].clientName.toString(),
                                                                                maxLength: 17,
                                                                                styleText: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700),
                                                                              ),
                                                                              Text(
                                                                                _.estadist1[index].date.toString(),
                                                                                maxLines: 2, // Limita el texto a 2 líneas
                                                                                overflow: TextOverflow.ellipsis, // Agrega los tres puntos suspensivos
                                                                                style: const TextStyle(fontSize: 10, color: Color.fromARGB(148, 0, 0, 0), fontWeight: FontWeight.w700),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const Padding(
                                                                        padding:
                                                                            EdgeInsets.all(8.0),
                                                                        child: Text(
                                                                            'PAGADO',
                                                                            style: TextStyle(
                                                                                fontSize: 16,
                                                                                color: Color(0xFF19CF9E),
                                                                                fontWeight: FontWeight.w700)),
                                                                      )
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
                                                                      const Text(
                                                                          'Monto Total',
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              color: Color.fromARGB(255, 0, 0, 0),
                                                                              fontWeight: FontWeight.w700)),
                                                                      Text(
                                                                        formatNumber(_
                                                                            .estadist1[index]
                                                                            .amountTotal
                                                                            .toString()),

                                                                        maxLines:
                                                                            2, // Limita el texto a 2 líneas

                                                                        overflow:
                                                                            TextOverflow.ellipsis, // Agrega los tres puntos suspensivos
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
                                    );
                                  })
                              : const Center(
                                  //*AQUI ESTA EL CODIGO DE CUANDO NO HAY Convivencias
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('No hay Clientes Atendidos'),
                                      ],
                                    ),
                                  ],
                                )))
                      : Expanded(
                          flex: heightFlexBody +
                              2, // 85% del espacio disponible para esta parte
                          child: _.estadist1Length > 0
                              ? ListView.builder(
                                  padding: EdgeInsets
                                      .zero, // Elimina cualquier padding del ListView
                                  itemCount: _.estadist1Length,
                                  itemBuilder: (context, index) {
                                    String servRea = _
                                        .estadist1[index].servicesRealizated
                                        .toString();
                                    int textLines = calculateTextLines(
                                        servRea,
                                        (MediaQuery.of(context).size.width *
                                            0.72),
                                        const TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(148, 0, 0, 0),
                                            fontWeight: FontWeight.w700));
                                    print('textLines:$textLines');

                                    return Padding(
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
                                                  (0.514 +
                                                      (0.03 *
                                                          textLines))), //aqui por cada linea que tenga le aumento 0.03 de tamaño
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
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                CircleAvatar(
                                                                              radius: 20,
                                                                              backgroundColor: Colors.white, //fondo de la imagen
                                                                              child: ClipOval(
                                                                                child: Image.network(
                                                                                  '${Env.apiEndpoint}/images/${_.estadist1[index].client_image}',
                                                                                  fit: BoxFit.cover, // Ajusta la imagen para cubrir completamente el área
                                                                                  width: 50, // Ancho deseado de la imagen dentro del círculo
                                                                                  height: 50,
                                                                                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
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
                                                                                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
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
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              TruncatedText(
                                                                                text: _.estadist1[index].clientName.toString(),
                                                                                maxLength: 17,
                                                                                styleText: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700),
                                                                              ),
                                                                              Text(
                                                                                _.estadist1[index].date.toString(),
                                                                                maxLines: 2, // Limita el texto a 2 líneas
                                                                                overflow: TextOverflow.ellipsis, // Agrega los tres puntos suspensivos
                                                                                style: const TextStyle(fontSize: 10, color: Color.fromARGB(148, 0, 0, 0), fontWeight: FontWeight.w700),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child: Text(
                                                                            _.estadist1[index].pay == 0
                                                                                ? 'PENDIENTE'
                                                                                : 'PAGADO',
                                                                            style: TextStyle(
                                                                                fontSize: 16,
                                                                                color: _.estadist1[index].pay == 0 ? Color(0xFFFDAE2A) : Color(0xFF19CF9E),
                                                                                fontWeight: FontWeight.w700)),
                                                                      )
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
                                                                          'Elección'),
                                                                      Text(
                                                                        _.estadist1[index]
                                                                            .choice
                                                                            .toString(),
                                                                        maxLines:
                                                                            2, // Limita el texto a 2 líneas
                                                                        overflow:
                                                                            TextOverflow.ellipsis, // Agrega los tres puntos suspensivos
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
                                                                          'Cantidad de Servicios'),
                                                                      Text(
                                                                        formatNumber(_
                                                                            .estadist1[index]
                                                                            .Services
                                                                            .toString()),
                                                                        maxLines:
                                                                            2, // Limita el texto a 2 líneas
                                                                        overflow:
                                                                            TextOverflow.ellipsis, // Agrega los tres puntos suspensivos
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
                                                                          'Servicios especiales'),
                                                                      Text(
                                                                        formatNumber(_
                                                                            .estadist1[index]
                                                                            .serviceSpecial
                                                                            .toString()),
                                                                        maxLines:
                                                                            2, // Limita el texto a 2 líneas
                                                                        overflow:
                                                                            TextOverflow.ellipsis, // Agrega los tres puntos suspensivos
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
                                                                          'Servicios regulares'),
                                                                      Text(
                                                                        formatNumber(_
                                                                            .estadist1[index]
                                                                            .serviceRegular
                                                                            .toString()),
                                                                        maxLines:
                                                                            2, // Limita el texto a 2 líneas
                                                                        overflow:
                                                                            TextOverflow.ellipsis, // Agrega los tres puntos suspensivos
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
                                                                        servRea,
                                                                        maxLines:
                                                                            5, // Limita el texto a 2 líneas
                                                                        overflow:
                                                                            TextOverflow.ellipsis, // Agrega los tres puntos suspensivos
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
                                                                          'Tiempo de servicio'),
                                                                      Text(
                                                                        _.estadist1[index]
                                                                            .time
                                                                            .toString(),
                                                                        maxLines:
                                                                            2, // Limita el texto a 2 líneas
                                                                        overflow:
                                                                            TextOverflow.ellipsis, // Agrega los tres puntos suspensivos
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
                                                                          'Cantidad de productos'),
                                                                      Text(
                                                                        formatNumber(_
                                                                            .estadist1[index]
                                                                            .Products
                                                                            .toString()),
                                                                        maxLines:
                                                                            2, // Limita el texto a 2 líneas
                                                                        overflow:
                                                                            TextOverflow.ellipsis, // Agrega los tres puntos suspensivos
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
                                                                            .SpecialAmount
                                                                            .toString(),
                                                                        maxLines:
                                                                            2, // Limita el texto a 2 líneas
                                                                        overflow:
                                                                            TextOverflow.ellipsis, // Agrega los tres puntos suspensivos
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
                                                                          'Total en servicios'),
                                                                      Text(
                                                                        _.estadist1[index]
                                                                            .totalServices
                                                                            .toString(),

                                                                        maxLines:
                                                                            2, // Limita el texto a 2 líneas
                                                                        overflow:
                                                                            TextOverflow.ellipsis, // Agrega los tres puntos suspensivos
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
                                                                          'Propina'),
                                                                      Text(
                                                                        _.estadist1[index]
                                                                            .tips
                                                                            .toString(),
                                                                        maxLines:
                                                                            2, // Limita el texto a 2 líneas
                                                                        overflow:
                                                                            TextOverflow.ellipsis, // Agrega los tres puntos suspensivos
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
                                                                          'Propina 80%'),
                                                                      Text(
                                                                        _.estadist1[index]
                                                                            .tips80
                                                                            .toString(),

                                                                        maxLines:
                                                                            2, // Limita el texto a 2 líneas
                                                                        overflow:
                                                                            TextOverflow.ellipsis, // Agrega los tres puntos suspensivos
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
                                                                          'Retención'),
                                                                      Text(
                                                                        _.estadist1[index]
                                                                            .totalRetention
                                                                            .toString(),
                                                                        maxLines:
                                                                            2, // Limita el texto a 2 líneas
                                                                        overflow:
                                                                            TextOverflow.ellipsis, // Agrega los tres puntos suspensivos
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
                                                                  /*   Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      const Text(
                                                                        'Monto Generado',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        formatNumber(_
                                                                            .estadist1[index]
                                                                            .amountGenerate
                                                                            .toString()),
                                                                        maxLines:
                                                                            2, // Limita el texto a 2 líneas
                                                                        overflow:
                                                                            TextOverflow.ellipsis, // Agrega los tres puntos suspensivos
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
                                                                  ),*/
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      const Text(
                                                                        'Monto Líquido',
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
                                                                        _.estadist1[index]
                                                                            .winPay
                                                                            .toString(),
                                                                        maxLines:
                                                                            2, // Limita el texto a 2 líneas
                                                                        overflow:
                                                                            TextOverflow.ellipsis, // Agrega los tres puntos suspensivos
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
                                                                      // Text(
                                                                      //   formatNumber(_
                                                                      //       .estadist1[index]
                                                                      //       .winPay
                                                                      //       .toString()),
                                                                      //   maxLines:
                                                                      //       2, // Limita el texto a 2 líneas
                                                                      //   overflow:
                                                                      //       TextOverflow.ellipsis, // Agrega los tres puntos suspensivos
                                                                      //   style: const TextStyle(
                                                                      //       fontSize:
                                                                      //           16,
                                                                      //       color: Color.fromARGB(
                                                                      //           220,
                                                                      //           0,
                                                                      //           0,
                                                                      //           0),
                                                                      //       fontWeight:
                                                                      //           FontWeight.w700),
                                                                      // ),
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
                                    );
                                  })
                              : const Center(
                                  //*AQUI ESTA EL CODIGO DE CUANDO NO HAY Convivencias
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
