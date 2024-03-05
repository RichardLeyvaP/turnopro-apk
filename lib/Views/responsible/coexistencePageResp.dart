// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Controllers/coexistence.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configResp.controller.dart';
import 'package:turnopro_apk/Models/professional_model.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:turnopro_apk/env.dart';

class CoexistencePageResponsible extends StatefulWidget {
  const CoexistencePageResponsible({super.key});

  @override
  _CoexistencePageResponsibleState createState() =>
      _CoexistencePageResponsibleState();
}

final ClientsScheduledController controllerClient =
    Get.find<ClientsScheduledController>();
final LoginController controllerLogin = Get.find<LoginController>();
final PagesConfigResponController pagesConfigCont =
    Get.find<PagesConfigResponController>();

class _CoexistencePageResponsibleState
    extends State<CoexistencePageResponsible> {
  // Utilizar una función o getter para obtener imageDirection
  String get imageDirection {
    // Si id es null o igual a -99, devuelve la ruta para la foto de perfil incógnito
    return '${Env.apiEndpoint}/images/coordinator/default_profile.jpg';
  }

//
//
//
//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                pagesConfigCont.back();
                // Navigator.pop(context);
              },
            ),
          ],
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Column(
              children: [
                Icon(
                  Icons.stars,
                  size: 50,
                ),
                Text(
                  'Convivencias',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: (MediaQuery.of(context).size.width * 0.14),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: GetBuilder<CoexistenceController>(builder: (controll) {
        List<ProfessionalModel> profesionales = controll.professional;
        return Column(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<ProfessionalModel>(
                        isExpanded: true,
                        hint: const Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: Text(
                                'Selecciona al profesional',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors
                                      .white, // Cambia el color del texto a blanco
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        value: controll.selectedProfessional,
                        onChanged: (ProfessionalModel? newValue) {
                          setState(() {
                            controll.selectedProfessional = newValue;
                            if (newValue != null) {
                              print('${newValue.name}');
                              print('${newValue.id}');
                              int idProfessional = newValue.id;
                              controll.specificCoexistenceList(idProfessional);
                            }
                          });
                        },
                        items: [
                          ...profesionales
                              .map<DropdownMenuItem<ProfessionalModel>>(
                            (ProfessionalModel profesional) {
                              return DropdownMenuItem<ProfessionalModel>(
                                value: profesional,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(imageDirection),
                                      radius:
                                          25, // Ajusta el tamaño del círculo aquí
                                    ),
                                    Text(
                                      '  ${profesional.name} ${profesional.surname}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ].toList(),
                        buttonStyleData: ButtonStyleData(
                          height: 60,
                          width: (MediaQuery.of(context).size.width * 0.95),
                          padding: const EdgeInsets.only(
                              top: 2, left: 14, right: 14, bottom: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.black26,
                            ),
                            color: Color.fromARGB(255, 26, 50, 82),
                          ),
                          elevation: 2,
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_forward_ios_outlined,
                          ),
                          iconSize: 14,
                          iconEnabledColor: Colors.white,
                          iconDisabledColor: Colors.grey,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 340,
                          width: (MediaQuery.of(context).size.width * 0.85),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: const Color.fromARGB(155, 26, 50, 82),
                          ),
                          offset: const Offset(40, 0),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all(6),
                            thumbVisibility: MaterialStateProperty.all(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 50,
                          padding:
                              EdgeInsets.only(left: 14, right: 14, bottom: 5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            controll.selectedProfessional != null
                ? Expanded(
                    flex: 7,
                    child: controll.coexistenceListLength > 0
                        ? ListView.builder(
                            itemCount: controll.coexistenceListLength,
                            itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.fromLTRB(
                                (MediaQuery.of(context).size.height * 0.013),
                                (MediaQuery.of(context).size.height * 0.006),
                                (MediaQuery.of(context).size.height * 0.013),
                                (MediaQuery.of(context).size.height * 0.006),
                              ),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: InkWell(
                                  onTap: () {
                                    {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return GetBuilder<
                                                  ClientsScheduledController>(
                                              builder: (_) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ), //this right here
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(0xFF2B3141),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(8),
                                                        topRight:
                                                            Radius.circular(8),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 12),
                                                          child: Text(
                                                            controll
                                                                .coexistence[
                                                                    index]
                                                                .name
                                                                .toString(),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        ),
                                                        IconButton(
                                                          icon: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.white),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 150,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        //Cart de cumplida

                                                        //Cart de  imcumplida
                                                        InkWell(
                                                          onTap: () {
                                                            controllerClient.changeNoncomplianceP(
                                                                controll
                                                                    .coexistence[
                                                                        index]
                                                                    .type,
                                                                controllerLogin
                                                                    .branchIdLoggedIn,
                                                                controll
                                                                    .selectedProfessional!
                                                                    .id,
                                                                1);
                                                            // Lógica para la opción 2
                                                            Navigator.pop(
                                                                context,
                                                                'Cumplió');
                                                          },
                                                          child: Container(
                                                            height: 40,
                                                            width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.7),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color
                                                                  .fromARGB(
                                                                      82,
                                                                      51,
                                                                      172,
                                                                      27),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              border:
                                                                  Border.all(
                                                                color: Color
                                                                    .fromARGB(
                                                                        210,
                                                                        13,
                                                                        75,
                                                                        26),
                                                                width: 1,
                                                              ),
                                                            ),
                                                            child: const Center(
                                                              child: Text(
                                                                'CUMPLIÓ',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            controllerClient.changeNoncomplianceP(
                                                                controll
                                                                    .coexistence[
                                                                        index]
                                                                    .type,
                                                                controllerLogin
                                                                    .branchIdLoggedIn,
                                                                controll
                                                                    .selectedProfessional!
                                                                    .id,
                                                                0);
                                                            // Lógica para la opción 1
                                                            Navigator.pop(
                                                                context,
                                                                'Incumplio');
                                                          },
                                                          child: Container(
                                                            height: 40,
                                                            width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.7),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color
                                                                      .fromARGB(
                                                                  83,
                                                                  244,
                                                                  67,
                                                                  54),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              border:
                                                                  Border.all(
                                                                color: Color
                                                                    .fromARGB(
                                                                        211,
                                                                        223,
                                                                        18,
                                                                        18),
                                                                width: 1,
                                                              ),
                                                            ),
                                                            child: const Center(
                                                              child: Text(
                                                                'INCUMPLIÓ',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          });
                                        },
                                      );

                                      // Mostrar el modal al hacer clic en el botón
                                      // showDialog(
                                      //   context: context,
                                      //   builder: (BuildContext context) {
                                      //     return AlertDialog(
                                      //       title: Text(
                                      //           controll.coexistence[index].name
                                      //               .toString(),
                                      //           style: const TextStyle(
                                      //             fontSize: 16,
                                      //             fontWeight: FontWeight.w800,
                                      //           )),
                                      //       content: SizedBox(
                                      //         width: 150,
                                      //         height: 150,
                                      //         child: Column(
                                      //           children: [
                                      //             // Opción 1
                                      //             SimpleDialogOption(
                                      //               onPressed: () {
                                      //                 controllerClient
                                      //                     .changeNoncomplianceP(
                                      //                         controll
                                      //                             .coexistence[
                                      //                                 index]
                                      //                             .type,
                                      //                         controllerLogin
                                      //                             .branchIdLoggedIn,
                                      //                         controll
                                      //                             .selectedProfessional!
                                      //                             .id,
                                      //                         0);
                                      //                 // Lógica para la opción 1
                                      //                 Navigator.pop(context,
                                      //                     'Opción 1 seleccionada');
                                      //               },
                                      //               child: Container(
                                      //                 decoration:
                                      //                     const BoxDecoration(
                                      //                   color: Color.fromARGB(
                                      //                       99, 244, 67, 54),
                                      //                   borderRadius:
                                      //                       BorderRadius.all(
                                      //                           Radius.circular(
                                      //                               4)),
                                      //                 ),
                                      //                 child: const Padding(
                                      //                   padding: EdgeInsets.all(
                                      //                       10.0),
                                      //                   child: Row(
                                      //                     mainAxisAlignment:
                                      //                         MainAxisAlignment
                                      //                             .spaceBetween,
                                      //                     children: [
                                      //                       Text('Incumplió'),
                                      //                       Icon(
                                      //                         Icons.star,
                                      //                         size: 30,
                                      //                         color: Colors.red,
                                      //                       ),
                                      //                     ],
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //             // Opción 2
                                      //             SimpleDialogOption(
                                      //               onPressed: () {
                                      //                 controllerClient
                                      //                     .changeNoncomplianceP(
                                      //                         controll
                                      //                             .coexistence[
                                      //                                 index]
                                      //                             .type,
                                      //                         controllerLogin
                                      //                             .branchIdLoggedIn,
                                      //                         controll
                                      //                             .selectedProfessional!
                                      //                             .id,
                                      //                         1);
                                      //                 // Lógica para la opción 2
                                      //                 Navigator.pop(
                                      //                     context, 'Cumplió');
                                      //               },
                                      //               child: Container(
                                      //                 decoration:
                                      //                     const BoxDecoration(
                                      //                   color: Color.fromARGB(
                                      //                       108, 76, 175, 79),
                                      //                   borderRadius:
                                      //                       BorderRadius.all(
                                      //                           Radius.circular(
                                      //                               4)),
                                      //                 ),
                                      //                 child: const Padding(
                                      //                   padding: EdgeInsets.all(
                                      //                       10.0),
                                      //                   child: Row(
                                      //                     mainAxisAlignment:
                                      //                         MainAxisAlignment
                                      //                             .spaceBetween,
                                      //                     children: [
                                      //                       Text('Cumplió'),
                                      //                       Icon(
                                      //                         Icons.star,
                                      //                         size: 30,
                                      //                         color: Color
                                      //                             .fromARGB(
                                      //                                 255,
                                      //                                 10,
                                      //                                 116,
                                      //                                 13),
                                      //                       ),
                                      //                     ],
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //       // Botón de aceptar
                                      //       actions: [
                                      //         Center(
                                      //           child: Container(
                                      //             width: 100,
                                      //             child: ElevatedButton(
                                      //               style: ButtonStyle(
                                      //                 padding:
                                      //                     MaterialStateProperty.all<
                                      //                         EdgeInsetsGeometry>(
                                      //                   const EdgeInsets
                                      //                           .symmetric(
                                      //                       vertical: 4.0,
                                      //                       horizontal: 10.0),
                                      //                 ),
                                      //                 backgroundColor:
                                      //                     MaterialStateProperty
                                      //                         .all<Color>(
                                      //                             Colors.black),
                                      //               ),
                                      //               onPressed: () {
                                      //                 // Lógica para el botón de aceptar
                                      //                 Navigator.pop(
                                      //                     context, 'Cerrar');
                                      //               },
                                      //               child: const Center(
                                      //                 child: Text(
                                      //                   'Cerrar',
                                      //                   style: TextStyle(
                                      //                       color:
                                      //                           Colors.white),
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     );
                                      //   },
                                      // );
                                    }
                                  },
                                  child: GetBuilder<ClientsScheduledController>(
                                      builder: (controllerCient) {
                                    return Row(
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
                                                    .withOpacity(0.7),
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                                offset: const Offset(-5, 5),
                                              ),
                                            ],
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(12),
                                            ),
                                          ),
                                          child: ListTile(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
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
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.77,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            controll
                                                                .coexistence[
                                                                    index]
                                                                .name
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                            ),
                                                          ),
                                                          Text(
                                                            controll
                                                                .coexistence[
                                                                    index]
                                                                .description
                                                                .toString(),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color: Color
                                                                  .fromARGB(148,
                                                                      0, 0, 0),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                controllerCient.noncomplianceProfessional[
                                                            controll
                                                                .coexistence[
                                                                    index]
                                                                .type] ==
                                                        0
                                                    ? const Icon(
                                                        Icons.star,
                                                        color: Colors.red,
                                                        shadows: [
                                                          Shadow(
                                                              offset: Offset(
                                                                  0.5, 0.9))
                                                        ],
                                                        size: 50,
                                                      )
                                                    : controllerCient
                                                                    .noncomplianceProfessional[
                                                                controll
                                                                    .coexistence[
                                                                        index]
                                                                    .type] ==
                                                            1
                                                        ? const Icon(
                                                            Icons.star,
                                                            color:
                                                                Color.fromRGBO(
                                                                    26,
                                                                    177,
                                                                    71,
                                                                    1),
                                                            shadows: [
                                                              Shadow(
                                                                  offset:
                                                                      Offset(
                                                                          0.5,
                                                                          0.9))
                                                            ],
                                                            size: 50,
                                                          )
                                                        : const Icon(
                                                            Icons.star,
                                                            color:
                                                                Color.fromRGBO(
                                                                    145,
                                                                    148,
                                                                    145,
                                                                    1),
                                                            shadows: [
                                                              Shadow(
                                                                  offset:
                                                                      Offset(
                                                                          0.5,
                                                                          0.9))
                                                            ],
                                                            size: 50,
                                                          ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                            'No tiene reglas de convivencia definidas aún',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          )),
                  )
                : Text(' '),
            /*
                 Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controllerLogin.greeting,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              const Icon(
                                Icons.auto_awesome,
                                size: 30,
                                color: Color.fromARGB(255, 236, 181, 14),
                                shadows: [Shadow(offset: Offset(0.3, 0.9))],
                              ),
                            ],
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Por favor ',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.black),
                                ),
                                TextSpan(
                                  text: controllerLogin.nameUserLoggedIn,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Color.fromARGB(255, 18, 41,
                                        71), // Cambia el color según tu preferencia
                                    fontWeight: FontWeight
                                        .bold, // Puedes ajustar otros estilos según tu preferencia
                                  ),
                                ),
                                const TextSpan(
                                  text:
                                      ', seleccione algún profesional y podrá modificar las reglas del mismo.',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
            */
            //AQUI PONER EL SINO HA SELECCIONADO A NADIE
          ],
        );
      }),
    );
  }
}
