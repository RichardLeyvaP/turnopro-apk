// ignore_for_file: file_names, depend_on_referenced_packages
//import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/coexistence.controller.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/Views/common/topPage.dart';

//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CoexistencePageTecnhical extends StatefulWidget {
  const CoexistencePageTecnhical({super.key});

  @override
  State<CoexistencePageTecnhical> createState() =>
      _CoexistencePageTecnhicalState();
}

class _CoexistencePageTecnhicalState extends State<CoexistencePageTecnhical> {
  final PagesConfigController pagesConfigCont =
      Get.find<PagesConfigController>();
  final double valuePadding = 12;

  /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */
  final IconnsBack = Icons.arrow_back;
  final IconnsP = MdiIcons.starOutline;

  String title = 'Convivencia';
  String subTitle = 'Cumplimiento de reglas';
  final colorCont = Colors.white;
  double panddCont = 8;
  double borderCont = 12;
  final colorIcon = Color(0xFFFDAE2A);
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
                      isPagesConfig: true,
                      IconnsP: IconnsP,
                      title: title,
                      subTitle: subTitle,
                      colorIcon: colorIcon,
                      buttonRight: false,
                    ),
                  ),
                  Expanded(
                      flex:
                          heightFlexBody, // 85% del espacio disponible para esta parte
                      child: _.coexistenceListLength > 0
                          ? ListView.builder(
                              padding: EdgeInsets
                                  .zero, // Elimina cualquier padding del ListView
                              itemCount: _.coexistenceListLength,
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
                                                0.11),
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
                                                      controllerClient.noncomplianceProfessional[_
                                                                  .coexistence[
                                                                      index]
                                                                  .type] ==
                                                              3
                                                          ? Icon(
                                                              MdiIcons
                                                                  .checkboxBlankOutline,
                                                              color: const Color(
                                                                  0xFFFDAE2A),
                                                              size: 45,
                                                            )
                                                          : controllerClient.noncomplianceProfessional[_
                                                                      .coexistence[
                                                                          index]
                                                                      .type] ==
                                                                  0
                                                              ? Icon(
                                                                  MdiIcons
                                                                      .minusBox,
                                                                  color: const Color(
                                                                      0xFFFF6750),
                                                                  size: 45,
                                                                )
                                                              : Icon(
                                                                  MdiIcons
                                                                      .starBox,
                                                                  color: const Color(
                                                                      0xFF4470F3),
                                                                  size: 45,
                                                                ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.77,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Text(
                                                                  _
                                                                      .coexistence[
                                                                          index]
                                                                      .name
                                                                      .toString(),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  _
                                                                      .coexistence[
                                                                          index]
                                                                      .description
                                                                      .toString(),
                                                                  maxLines:
                                                                      2, // Limita el texto a 2 líneas
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis, // Agrega los tres puntos suspensivos
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Color
                                                                          .fromARGB(
                                                                              148,
                                                                              0,
                                                                              0,
                                                                              0)),
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
                                    Text('No hay Convivencias'),
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
